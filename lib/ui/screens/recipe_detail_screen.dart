import 'package:flutter/material.dart';
import '../widgets/video_player_widget.dart';

/// Displays the full details of a single recipe.
class RecipeDetailScreen extends StatefulWidget {
  /// The recipe data comes from the GraphQL query.
  /// Expected keys: title, imageUrl, prepMinutes, ingredients (List), instructions.
  final Map<String, dynamic> recipe;

  const RecipeDetailScreen({
    required this.recipe,
    super.key,
  });

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  bool _showVideo = false;

  @override
  Widget build(BuildContext context) {
    // Defensive defaults – the backend should always send a list,
    // but we guard against a malformed payload.
    final List<dynamic> ingredients = widget.recipe['ingredients'] ?? [];
    final bool hasVideo = widget.recipe['videoUrl'] != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe['title'] ?? 'Recipe'),
        actions: [
          // Video toggle button
          if (hasVideo)
            IconButton(
              tooltip: _showVideo ? 'Show Photo' : 'Watch Video',
              icon: Icon(_showVideo ? Icons.image : Icons.play_circle_filled),
              onPressed: () {
                setState(() {
                  _showVideo = !_showVideo;
                });
              },
            ),
          // OPTIONAL: a quick‑share button (feel free to remove)
          IconButton(
            tooltip: 'Share',
            icon: const Icon(Icons.share),
            onPressed: () {
              // Simple share via the native share sheet (needs `share_plus` package)
              // Share.share('Check out this recipe: ${widget.recipe['title']}');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------- VIDEO OR IMAGE ----------
            if (hasVideo && _showVideo)
              VideoPlayerWidget(
                videoUrl: widget.recipe['videoUrl'],
                thumbnailUrl: widget.recipe['videoThumbnail'],
                videoDuration: widget.recipe['videoDuration'],
              )
            else if (hasVideo && !_showVideo)
              VideoPreviewCard(
                videoUrl: widget.recipe['videoUrl'],
                thumbnailUrl: widget.recipe['videoThumbnail'],
                videoDuration: widget.recipe['videoDuration'],
                onTap: () {
                  setState(() {
                    _showVideo = true;
                  });
                },
              )
            else if (widget.recipe['imageUrl'] != null)
              Image.network(
                widget.recipe['imageUrl'] as String,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.broken_image, size: 200),
              ),
            const SizedBox(height: 12),

            // ---------- PREPARATION TIME ----------
            Row(
              children: [
                Text(
                  "Preparation time: ${widget.recipe['prepMinutes']} min",
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const Spacer(),
                if (hasVideo)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green.withOpacity(0.3)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.videocam, color: Colors.green, size: 16),
                        SizedBox(width: 4),
                        Text(
                          'Video Tutorial',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const Divider(height: 32),

            // ---------- INGREDIENTS ----------
            const Text(
              'Ingredients',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: ingredients
                  .map<Widget>((i) => Chip(label: Text(i.toString())))
                  .toList(),
            ),
            const Divider(height: 32),

            // ---------- INSTRUCTIONS ----------
            Row(
              children: [
                const Text(
                  'Instructions',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                if (hasVideo && !_showVideo)
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _showVideo = true;
                      });
                    },
                    icon: const Icon(Icons.play_circle_filled, size: 18),
                    label: const Text('Watch Tutorial'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.green,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              widget.recipe['instructions'] ?? '',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}