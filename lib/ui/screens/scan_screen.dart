import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import '../../services/ai_recipe_service.dart';
import '../../services/camera_service.dart';
import 'camera_capture_screen.dart';
import 'recipe_detail_screen.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  File? _selectedImage;
  bool _isLoading = false;
  List<String> _detectedIngredients = [];
  List<Map<String, dynamic>> _suggestedRecipes = [];
  String? _analysisError;

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    // Initialize camera service in the background
    try {
      await CameraService.initialize();
    } catch (e) {
      debugPrint('Camera initialization failed: $e');
    }
  }

  Future<void> _captureFromCamera() async {
    try {
      // Check camera permission first
      final hasPermission = await CameraService.checkCameraPermission();
      if (!hasPermission) {
        if (mounted) {
          CameraService.showPermissionDeniedDialog(context);
        }
        return;
      }

      // Navigate to camera capture screen
      final result = await Navigator.of(context).push<dynamic>(
        MaterialPageRoute(
          builder: (context) => const CameraCaptureScreen(),
        ),
      );

      if (result != null && result is File) {
        await _processImage(result);
      } else if (result == 'gallery') {
        await _pickFromGallery();
      }
    } catch (e) {
      setState(() {
        _analysisError = 'Camera error: $e';
      });
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );

      if (result != null) {
        final file = File(result.files.single.path!);
        await _processImage(file);
      }
    } catch (e) {
      setState(() {
        _analysisError = 'Gallery error: $e';
      });
    }
  }

  Future<void> _processImage(File imageFile) async {
    setState(() {
      _selectedImage = imageFile;
      _isLoading = true;
      _detectedIngredients = [];
      _suggestedRecipes = [];
      _analysisError = null;
    });

    try {
      // Analyze image with AI service
      final ingredients = await AIRecipeService.analyzeImage(imageFile);
      
      setState(() {
        _detectedIngredients = ingredients;
      });

      // Generate recipe suggestions
      final recipes = await AIRecipeService.generateRecipes(ingredients);
      
      setState(() {
        // Filter out any null or invalid recipes for safety
        _suggestedRecipes = recipes.where((recipe) => recipe != null && recipe is Map<String, dynamic>).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _analysisError = 'Analysis failed: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Fridge Scanner'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image Display
            if (_selectedImage != null) ...[
              Container(
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    _selectedImage!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _captureFromCamera,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Take Photo'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _pickFromGallery,
                    icon: const Icon(Icons.photo_library),
                    label: const Text('From Gallery'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade300,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Loading State
            if (_isLoading) ...[
              const Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: Colors.green),
                      SizedBox(height: 16),
                      Text(
                        'AI is analyzing your fridge contents...',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'This may take a few moments',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ]
            // Error State
            else if (_analysisError != null) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.error, color: Colors.red, size: 32),
                    const SizedBox(height: 8),
                    Text(
                      _analysisError!,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ]
            // Results
            else if (_detectedIngredients.isNotEmpty) ...[
              const Text(
                'Detected Ingredients:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              
              // Ingredients Grid
              SizedBox(
                height: 120,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: _detectedIngredients.length,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          _detectedIngredients[index],
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Recipe Suggestions
              if (_suggestedRecipes.isNotEmpty) ...[
                const Text(
                  'AI Recipe Suggestions:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    itemCount: _suggestedRecipes.length,
                    itemBuilder: (context, index) {
                      final recipe = _suggestedRecipes[index];
                      
                      // Additional null safety check
                      if (recipe == null || recipe is! Map<String, dynamic>) {
                        return const SizedBox.shrink();
                      }
                      
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.green.shade100,
                            child: Icon(
                              Icons.restaurant_menu,
                              color: Colors.green.shade700,
                            ),
                          ),
                          title: Text(
                            recipe['name']?.toString() ?? recipe['title']?.toString() ?? 'AI Recipe',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(recipe['description']?.toString() ?? recipe['instructions']?.toString() ?? 'AI-generated recipe'),
                              const SizedBox(height: 4),
                              Text(
                                'Cook time: ${recipe['cookTime']?.toString() ?? 'Unknown'} • Difficulty: ${recipe['difficulty']?.toString() ?? 'Unknown'}',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            // Navigate to recipe details
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => RecipeDetailScreen(recipe: recipe),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ]
            // Empty State
            else ...[
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.camera_alt,
                      size: 64,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Scan Your Fridge with AI',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Take a photo of your fridge contents and our AI will suggest recipes you can make!',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}