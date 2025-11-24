import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../theme/ink_theme.dart';
import '../theme/medieval_theme.dart';
import 'profile_page.dart';

class VideoIntroPage extends StatefulWidget {
  final String characterId;

  const VideoIntroPage({super.key, required this.characterId});

  @override
  State<VideoIntroPage> createState() => _VideoIntroPageState();
}

class _VideoIntroPageState extends State<VideoIntroPage> {
  late VideoPlayerController _videoController;
  ChewieController? _chewieController;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      _videoController = VideoPlayerController.asset(
        'assets/videos/book_intro.mp4',
      );

      await _videoController.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoController,
        autoPlay: true,
        looping: false,
        showControls: false,
        allowFullScreen: false,
        allowMuting: false,
        aspectRatio: _videoController.value.aspectRatio,
      );

      // Listen for video completion
      _videoController.addListener(() {
        if (_videoController.value.position >=
            _videoController.value.duration) {
          _navigateToProfile();
        }
      });

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
      // Navigate to profile page after 2 seconds if video fails to load
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          _navigateToProfile();
        }
      });
    }
  }

  void _navigateToProfile() {
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const ProfilePage()),
      );
    }
  }

  @override
  void dispose() {
    _videoController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          if (!_isLoading && !_hasError && _chewieController != null)
            Center(child: Chewie(controller: _chewieController!)),
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(color: MedievalColors.gold),
            ),
          if (_hasError)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: InkTheme.paper),
                  const SizedBox(height: 16),
                  Text(
                    'Video not found',
                    style: InkTheme.inkBody.copyWith(color: InkTheme.paper),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Continuing to game...',
                    style: InkTheme.inkBodySmall.copyWith(color: InkTheme.paper.withOpacity(0.7)),
                  ),
                ],
              ),
            ),
          // Skip button overlay
          if (!_isLoading && !_hasError)
            Positioned(
              bottom: 32,
              right: 32,
              child: GestureDetector(
                onTap: _navigateToProfile,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    border: Border.all(color: MedievalColors.gold),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Skip',
                    style: InkTheme.inkLabel.copyWith(color: MedievalColors.gold),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
