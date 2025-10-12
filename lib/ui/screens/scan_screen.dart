import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../widgets/ingredient_chip.dart';
import 'recipe_list_screen.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  List<String> _detected = [];
  bool _loading = false;

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );
    if (result == null) return;

    setState(() => _loading = true);

    // -------------------------------------------------
    // In a production app you would send the image to a
    // server‑side TensorFlow‑Lite or a cloud vision API.
    // Here we simulate detection with a fixed list.
    // -------------------------------------------------
    await Future.delayed(const Duration(seconds: 2)); // fake latency
    setState(() {
      _detected = ['tomato', 'egg', 'spinach', 'cheese'];
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan My Fridge')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.upload_file),
              label: const Text('Upload Fridge Photo'),
              onPressed: _pickImage,
            ),
            const SizedBox(height: 24),
            if (_loading) const CircularProgressIndicator(),
            if (_detected.isNotEmpty) ...[
              const Text('Detected ingredients:', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _detected
                    .map((i) => IngredientChip(name: i))
                    .toList(),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.restaurant_menu),
                label: const Text('Find Recipes'),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RecipeListScreen(
                      preselectedIngredients: _detected,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}