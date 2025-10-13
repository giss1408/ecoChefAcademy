import 'package:flutter/material.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final String? thumbnailUrl;
  final int? videoDuration;

  const VideoPlayerWidget({
    required this.videoUrl,
    this.thumbnailUrl,
    this.videoDuration,
    super.key,
  });

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  bool _isPlaying = false;

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          children: [
            // Video thumbnail or placeholder
            if (widget.thumbnailUrl != null && !_isPlaying)
              Image.network(
                widget.thumbnailUrl!,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey[800],
                  child: const Icon(Icons.video_library, size: 64, color: Colors.white),
                ),
              )
            else if (!_isPlaying)
              Container(
                color: Colors.grey[800],
                child: const Icon(Icons.video_library, size: 64, color: Colors.white),
              )
            else
              // Mock video playing state
              Container(
                color: Colors.black,
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.play_arrow, size: 64, color: Colors.white),
                      SizedBox(height: 8),
                      Text(
                        'Playing Video...',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            
            // Dark overlay when not playing
            if (!_isPlaying)
              Container(
                color: Colors.black54,
              ),
            
            // Play button overlay
            Center(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isPlaying = !_isPlaying;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    size: 48,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            
            // Video info overlay
            if (widget.videoDuration != null)
              Positioned(
                bottom: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _formatDuration(widget.videoDuration!),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            
            // Video URL overlay (for development)
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.video_call, size: 16, color: Colors.green),
                    SizedBox(width: 4),
                    Text(
                      'Video Tutorial',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VideoPreviewCard extends StatelessWidget {
  final String? videoUrl;
  final String? thumbnailUrl;
  final int? videoDuration;
  final VoidCallback? onTap;

  const VideoPreviewCard({
    this.videoUrl,
    this.thumbnailUrl,
    this.videoDuration,
    this.onTap,
    super.key,
  });

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    if (videoUrl == null) return const SizedBox.shrink();

    return Card(
      elevation: 3,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Stack(
            children: [
              // Thumbnail background
              if (thumbnailUrl != null)
                Image.network(
                  thumbnailUrl!,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.video_library, size: 48),
                  ),
                )
              else
                Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.video_library, size: 48),
                ),
              
              // Dark overlay
              Container(
                color: Colors.black26,
              ),
              
              // Play button and info
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.play_circle_filled,
                      color: Colors.white,
                      size: 48,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Watch Tutorial',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (videoDuration != null)
                      Text(
                        _formatDuration(videoDuration!),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}