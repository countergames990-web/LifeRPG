import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import '../providers/game_state_provider.dart';
import '../models/story_data.dart';
import '../services/image_compression_service.dart';
import '../theme/rpg_theme.dart';

class StoryPage extends StatefulWidget {
  final String? viewOnlyCharacterId;
  
  const StoryPage({super.key, this.viewOnlyCharacterId});

  @override
  State<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late TextEditingController _char1Controller;
  late TextEditingController _char2Controller;
  final _townPostController = TextEditingController();
  final _additionalPostController = TextEditingController();
  
  String? _selectedTownImage;
  String? _selectedAdditionalImage;

  bool get isViewOnly => widget.viewOnlyCharacterId != null;
  String get viewingCharacterId => widget.viewOnlyCharacterId ?? '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _char1Controller = TextEditingController();
    _char2Controller = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadStoryData();
    });
  }

  void _loadStoryData() {
    final gameState = Provider.of<GameStateProvider>(context, listen: false);
    final story = gameState.storyData;

    if (story != null) {
      _char1Controller.text = story.character1Story;
      _char2Controller.text = story.character2Story;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _char1Controller.dispose();
    _char2Controller.dispose();
    _townPostController.dispose();
    _additionalPostController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(bool isTown) async {
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
                  duration: Duration(seconds: 3),
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
              type: 'story',
            );
            
            setState(() {
              if (isTown) {
                _selectedTownImage = compressedImage;
              } else {
                _selectedAdditionalImage = compressedImage;
              }
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
              if (file.bytes!.length <= 300 * 1024) { // Allow up to 300KB for local dev
                final base64Image = 'data:image/png;base64,${base64Encode(file.bytes!)}';
                setState(() {
                  if (isTown) {
                    _selectedTownImage = base64Image;
                  } else {
                    _selectedAdditionalImage = base64Image;
                  }
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

  Future<void> _postToTown(GameStateProvider gameState) async {
    final text = _townPostController.text.trim();
    if (text.isEmpty && _selectedTownImage == null) return;

    final character = gameState.currentCharacter;
    if (character == null) return;

    final post = StoryPost(
      characterName: character.name,
      characterId: character.id,
      text: text,
      imageUrl: _selectedTownImage,
    );

    await gameState.addTownPost(post);
    
    _townPostController.clear();
    setState(() {
      _selectedTownImage = null;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: MedievalText.body('Posted to Town!', color: RPGTheme.parchment),
          backgroundColor: RPGTheme.mediumWood,
        ),
      );
    }
  }

  Future<void> _postToAdditional(GameStateProvider gameState) async {
    final text = _additionalPostController.text.trim();
    if (text.isEmpty && _selectedAdditionalImage == null) return;

    final character = gameState.currentCharacter;
    if (character == null) return;

    final post = StoryPost(
      characterName: character.name,
      characterId: character.id,
      text: text,
      imageUrl: _selectedAdditionalImage,
    );

    await gameState.addAdditionalPost(post);
    
    _additionalPostController.clear();
    setState(() {
      _selectedAdditionalImage = null;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: MedievalText.body('Posted to Lore!', color: RPGTheme.parchment),
          backgroundColor: RPGTheme.mediumWood,
        ),
      );
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
        child: Column(
          children: [
            _buildHeader(),
            if (!isViewOnly) _buildTabBar(),
            Expanded(
              child: Consumer<GameStateProvider>(
                builder: (context, gameState, child) {
                  if (isViewOnly) {
                    return _buildCharacterStory(gameState);
                  }
                  return TabBarView(
                    controller: _tabController,
                    children: [
                      _buildTownTab(gameState),
                      _buildCharacterTab(gameState, '1'),
                      _buildCharacterTab(gameState, '2'),
                      _buildAdditionalTab(gameState),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: RPGTheme.mediumWood,
        border: Border(
          bottom: BorderSide(color: RPGTheme.ornateGold, width: 2),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              color: RPGTheme.ornateGold,
              onPressed: () => Navigator.pop(context),
            ),
            const SizedBox(width: 8),
            Icon(Icons.auto_stories, color: RPGTheme.ornateGold, size: 28),
            const SizedBox(width: 12),
            MedievalText.title(isViewOnly ? 'View Chronicle' : 'Story Chronicle'),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: RPGTheme.mediumWood,
      child: TabBar(
        controller: _tabController,
        labelColor: RPGTheme.ornateGold,
        unselectedLabelColor: RPGTheme.parchmentDark,
        indicatorColor: RPGTheme.ornateGold,
        tabs: const [
          Tab(icon: Icon(Icons.location_city), text: 'Town'),
          Tab(icon: Icon(Icons.person), text: 'Hero 1'),
          Tab(icon: Icon(Icons.person_outline), text: 'Hero 2'),
          Tab(icon: Icon(Icons.auto_stories), text: 'Lore'),
        ],
      ),
    );
  }

  Widget _buildTownTab(GameStateProvider gameState) {
    final story = gameState.storyData;
    final posts = story?.townPosts ?? [];

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              return _buildPostCard(posts[index]);
            },
          ),
        ),
        _buildPostComposer(
          controller: _townPostController,
          selectedImage: _selectedTownImage,
          onPickImage: () => _pickImage(true),
          onClearImage: () => setState(() => _selectedTownImage = null),
          onPost: () => _postToTown(gameState),
          hint: 'Share town news...',
        ),
      ],
    );
  }

  Widget _buildAdditionalTab(GameStateProvider gameState) {
    final story = gameState.storyData;
    final posts = story?.additionalPosts ?? [];

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              return _buildPostCard(posts[index]);
            },
          ),
        ),
        _buildPostComposer(
          controller: _additionalPostController,
          selectedImage: _selectedAdditionalImage,
          onPickImage: () => _pickImage(false),
          onClearImage: () => setState(() => _selectedAdditionalImage = null),
          onPost: () => _postToAdditional(gameState),
          hint: 'Share additional lore...',
        ),
      ],
    );
  }

  Widget _buildPostCard(StoryPost post) {
    final gameState = Provider.of<GameStateProvider>(context, listen: false);
    final currentCharacter = gameState.currentCharacter;
    final isCurrentUser = currentCharacter?.id == post.characterId;
    
    return Padding(
      padding: EdgeInsets.only(
        bottom: 16,
        left: isCurrentUser ? 0 : 50,
        right: isCurrentUser ? 50 : 0,
      ),
      child: MouseRegion(
        cursor: SystemMouseCursors.basic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isCurrentUser ? RPGTheme.scrollTan : RPGTheme.parchment,
            border: Border.all(
              color: isCurrentUser ? RPGTheme.ornateGold : RPGTheme.mediumWood,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.start : CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: isCurrentUser ? MainAxisAlignment.start : MainAxisAlignment.end,
                  children: [
                    if (isCurrentUser) ...[
                      Icon(Icons.person, color: RPGTheme.ornateGold, size: 20),
                      const SizedBox(width: 8),
                      MedievalText.heading(post.characterName, color: RPGTheme.textBrown),
                      const Spacer(),
                      MedievalText.body(
                        _formatTimestamp(post.timestamp),
                        color: RPGTheme.textBrown,
                      ),
                    ],
                    if (!isCurrentUser) ...[
                      MedievalText.body(
                        _formatTimestamp(post.timestamp),
                        color: RPGTheme.textBrown,
                      ),
                      const Spacer(),
                      MedievalText.heading(post.characterName, color: RPGTheme.textBrown),
                      const SizedBox(width: 8),
                      Icon(Icons.person, color: RPGTheme.ornateGold, size: 20),
                    ],
                  ],
                ),
                if (post.text.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.5),
                      border: Border.all(color: RPGTheme.textBrown.withValues(alpha: 0.3)),
                    ),
                    child: MedievalText.body(post.text, color: RPGTheme.textBrown),
                  ),
                ],
                if (post.imageUrl != null) ...[
                  const SizedBox(height: 12),
                  ClipRect(
                    child: Container(
                      constraints: const BoxConstraints(maxHeight: 300),
                      decoration: BoxDecoration(
                        border: Border.all(color: RPGTheme.ornateGold, width: 2),
                      ),
                      child: Image.network(
                        post.imageUrl!,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => Container(
                          height: 100,
                          color: RPGTheme.parchmentDark,
                          child: const Center(
                            child: Icon(Icons.broken_image, size: 48),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPostComposer({
    required TextEditingController controller,
    required String? selectedImage,
    required VoidCallback onPickImage,
    required VoidCallback onClearImage,
    required VoidCallback onPost,
    required String hint,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: RPGTheme.mediumWood,
        border: Border(
          top: BorderSide(color: RPGTheme.ornateGold, width: 2),
        ),
      ),
      child: Column(
        children: [
          if (selectedImage != null) ...[
            Stack(
              children: [
                Container(
                  constraints: const BoxConstraints(maxHeight: 150),
                  decoration: BoxDecoration(
                    border: Border.all(color: RPGTheme.ornateGold, width: 2),
                  ),
                  child: Image.network(selectedImage, fit: BoxFit.contain),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: onClearImage,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: RPGTheme.scrollTan,
                    border: Border.all(color: RPGTheme.ornateGold, width: 2),
                  ),
                  child: TextField(
                    controller: controller,
                    maxLines: 2,
                    style: const TextStyle(
                      fontFamily: 'Crimson Text',
                      fontSize: 16,
                      color: Color(0xFF3D2817),
                    ),
                    decoration: InputDecoration(
                      hintText: hint,
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: IconButton(
                  icon: const Icon(Icons.image),
                  color: RPGTheme.ornateGold,
                  iconSize: 32,
                  onPressed: onPickImage,
                  style: IconButton.styleFrom(
                    backgroundColor: RPGTheme.darkWood,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: IconButton(
                  icon: const Icon(Icons.send),
                  color: RPGTheme.ornateGold,
                  iconSize: 32,
                  onPressed: onPost,
                  style: IconButton.styleFrom(
                    backgroundColor: RPGTheme.darkWood,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCharacterTab(GameStateProvider gameState, String characterId) {
    final character = characterId == '1' ? gameState.character1 : gameState.character2;
    final controller = characterId == '1' ? _char1Controller : _char2Controller;
    final canEdit = gameState.currentCharacterId == characterId;

    return _buildStoryEditor(
      title: '${character?.name ?? "Character $characterId"}\'s Chronicle',
      controller: controller,
      readOnly: !canEdit,
      onSave: () {
        if (characterId == '1') {
          gameState.updateCharacter1Story(controller.text);
        } else {
          gameState.updateCharacter2Story(controller.text);
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: MedievalText.body('Chronicle saved!', color: RPGTheme.parchment),
            backgroundColor: RPGTheme.mediumWood,
          ),
        );
      },
    );
  }

  Widget _buildCharacterStory(GameStateProvider gameState) {
    final character = viewingCharacterId == '1' ? gameState.character1 : gameState.character2;
    final controller = viewingCharacterId == '1' ? _char1Controller : _char2Controller;

    return _buildStoryEditor(
      title: '${character?.name ?? "Character"}\'s Chronicle',
      controller: controller,
      readOnly: true,
      onSave: () {},
    );
  }

  Widget _buildStoryEditor({
    required String title,
    required TextEditingController controller,
    required bool readOnly,
    required VoidCallback onSave,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: MedievalText.heading(title, color: RPGTheme.parchment),
              ),
              if (readOnly)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: RPGTheme.parchmentDark.withValues(alpha: 0.3),
                    border: Border.all(color: RPGTheme.parchmentDark, width: 2),
                  ),
                  child: MedievalText.body('VIEW ONLY', color: RPGTheme.parchmentDark),
                ),
            ],
          ),
          const SizedBox(height: 8),
          MedievalDivider(),
          const SizedBox(height: 16),
          Expanded(
            child: ScrollContainer(
              child: TextField(
                controller: controller,
                maxLines: null,
                expands: true,
                readOnly: readOnly,
                textAlignVertical: TextAlignVertical.top,
                style: const TextStyle(
                  fontFamily: 'Crimson Text',
                  fontSize: 16,
                  color: Color(0xFF3D2817),
                ),
                decoration: InputDecoration(
                  hintText: readOnly ? '' : 'Write your chronicle...',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (!readOnly)
            OrnateButton(
              text: 'Save Chronicle',
              icon: Icons.save,
              onPressed: onSave,
            ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inDays > 0) {
      return '${diff.inDays}d ago';
    } else if (diff.inHours > 0) {
      return '${diff.inHours}h ago';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
