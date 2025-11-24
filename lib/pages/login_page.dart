import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import '../providers/game_state_provider.dart';
import '../services/image_compression_service.dart';
import '../theme/rpg_theme.dart';
import 'profile_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _nameController = TextEditingController();
  String? _errorMessage;
  String? _selectedCharacterImage;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final gameState = Provider.of<GameStateProvider>(context, listen: false);
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a character name';
      });
      return;
    }

    // Try to login with existing character
    final success = await gameState.loginWithCharacterName(name);

    if (success && mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const ProfilePage()),
      );
    } else {
      setState(() {
        _errorMessage = 'Character "$name" not found. Please create it first.';
      });
    }
  }

  Future<void> _pickCharacterImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        if (file.bytes != null) {
          // Check if image size is acceptable (5MB limit before compression)
          if (!ImageCompressionService.isImageSizeAcceptable(file.bytes!)) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Image too large! Please use an image smaller than 5MB.'),
                  backgroundColor: Colors.red,
                ),
              );
            }
            return;
          }

          // Show loading indicator
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Row(
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    SizedBox(width: 12),
                    Text('Compressing image...'),
                  ],
                ),
                duration: Duration(seconds: 10),
              ),
            );
          }
          
          try {
            // Try to compress image using Netlify function
            final base64Image = 'data:image/png;base64,${base64Encode(file.bytes!)}';
            final compressedImage = await ImageCompressionService.compressImage(
              base64Image,
              type: 'character',
            );
            
            setState(() {
              _selectedCharacterImage = compressedImage;
            });
            
            if (mounted) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('✅ Image compressed successfully!'),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 2),
                ),
              );
            }
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              
              // Check if it's a local development error
              if (e.toString().contains('Netlify function not available')) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('⚠️ Local Development Mode'),
                        const SizedBox(height: 4),
                        Text('Using uncompressed image (${(file.bytes!.length / 1024).toStringAsFixed(0)}KB)'),
                        const SizedBox(height: 4),
                        const Text('To test compression: run "netlify dev"', style: TextStyle(fontSize: 11)),
                      ],
                    ),
                    backgroundColor: Colors.blue,
                    duration: const Duration(seconds: 5),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('⚠️ Compression failed. Using original image.'),
                    backgroundColor: Colors.orange,
                  ),
                );
              }
              
              // Fallback to original image with size check
              if (file.bytes!.length <= 500 * 1024) { // Allow up to 500KB for local dev
                final base64Image = 'data:image/png;base64,${base64Encode(file.bytes!)}';
                setState(() {
                  _selectedCharacterImage = base64Image;
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('❌ Image too large even for local dev. Please resize.'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking image: $e')),
        );
      }
    }
  }

  String _getDefaultImageForType(String type) {
    // Return default icon names based on class
    switch (type) {
      case 'Warrior':
        return 'warrior';
      case 'Mage':
        return 'mage';
      case 'Rogue':
        return 'rogue';
      case 'Healer':
        return 'healer';
      default:
        return 'adventurer';
    }
  }

  Future<void> _createNewCharacter() async {
    final gameState = Provider.of<GameStateProvider>(context, listen: false);
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a character name';
      });
      return;
    }

    // Check if name already exists
    final exists = await gameState.characterNameExists(name);
    if (exists) {
      setState(() {
        _errorMessage = 'Character "$name" already exists. Please login instead.';
      });
      return;
    }

    // Show type selection dialog
    if (mounted) {
      final type = await showDialog<String>(
        context: context,
        builder: (context) => _buildTypeSelectionDialog(),
      );

      if (type != null) {
        // Use selected image or default based on class
        final imageUrl = _selectedCharacterImage ?? _getDefaultImageForType(type);
        await gameState.createNewCharacter(name, type, characterImageUrl: imageUrl);
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const ProfilePage()),
          );
        }
      }
    }
  }

  Widget _buildTypeSelectionDialog() {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        child: ScrollContainer(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MedievalText.title('Choose Your Class'),
              const SizedBox(height: 16),
              MedievalDivider(),
              const SizedBox(height: 24),
              ...['Warrior', 'Mage', 'Rogue', 'Healer'].map((type) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: OrnateButton(
                    text: type,
                    icon: _getTypeIcon(type),
                    onPressed: () => Navigator.pop(context, type),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'Warrior':
        return Icons.shield;
      case 'Mage':
        return Icons.auto_fix_high;
      case 'Rogue':
        return Icons.visibility_off;
      case 'Healer':
        return Icons.favorite;
      default:
        return Icons.person;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RPGTheme.darkWood,
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [
              RPGTheme.mediumWood,
              RPGTheme.darkWood,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 500),
                child: ScrollContainer(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.castle, size: 80, color: RPGTheme.ornateGold),
                      const SizedBox(height: 16),
                      MedievalText.title('Life RPG'),
                      const SizedBox(height: 8),
                      MedievalDivider(),
                      const SizedBox(height: 32),
                      
                      // Character Image Upload
                      GestureDetector(
                        onTap: _pickCharacterImage,
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: RPGTheme.scrollTan,
                              border: Border.all(color: RPGTheme.ornateGold, width: 3),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: _selectedCharacterImage != null
                                ? Image.network(_selectedCharacterImage!, fit: BoxFit.cover)
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add_a_photo, size: 40, color: RPGTheme.ornateGold),
                                      const SizedBox(height: 8),
                                      MedievalText.body(
                                        'Upload Image',
                                        color: RPGTheme.textBrown,
                                      ),
                                      MedievalText.body(
                                        '(Optional)',
                                        color: RPGTheme.parchmentDark,
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Login Form
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: RPGTheme.scrollTan,
                          border: Border.all(color: RPGTheme.ornateGold, width: 2),
                        ),
                        child: TextField(
                          controller: _nameController,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Crimson Text',
                            fontSize: 18,
                            color: Color(0xFF3D2817),
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Enter Character Name',
                            border: InputBorder.none,
                          ),
                          onSubmitted: (_) => _login(),
                        ),
                      ),
                      
                      if (_errorMessage != null) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.2),
                            border: Border.all(color: Colors.red, width: 2),
                          ),
                          child: MedievalText.body(
                            _errorMessage!,
                            color: Colors.red.shade900,
                          ),
                        ),
                      ],
                      
                      const SizedBox(height: 32),
                      
                      // Login Button
                      OrnateButton(
                        text: 'LOGIN',
                        icon: Icons.login,
                        onPressed: _login,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Create Account Button
                      OrnateButton(
                        text: 'CREATE NEW CHARACTER',
                        icon: Icons.person_add,
                        onPressed: _createNewCharacter,
                      ),
                      
                      const SizedBox(height: 32),
                      MedievalText.body(
                        'Enter your character name to login\nor create a new hero',
                        color: RPGTheme.parchmentDark,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
