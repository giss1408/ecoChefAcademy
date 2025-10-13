import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../../services/camera_service.dart';

class CameraCaptureScreen extends StatefulWidget {
  const CameraCaptureScreen({super.key});

  @override
  State<CameraCaptureScreen> createState() => _CameraCaptureScreenState();
}

class _CameraCaptureScreenState extends State<CameraCaptureScreen> {
  CameraController? _controller;
  bool _isInitialized = false;
  bool _isCapturing = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      // Check camera permission
      final hasPermission = await CameraService.checkCameraPermission();
      if (!hasPermission) {
        setState(() {
          _error = 'Camera permission denied';
        });
        return;
      }

      // Initialize cameras if not already done
      await CameraService.initialize();
      
      final camera = CameraService.primaryCamera;
      if (camera == null) {
        setState(() {
          _error = 'No camera available';
        });
        return;
      }

      _controller = CameraController(
        camera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _controller!.initialize();
      
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Failed to initialize camera: $e';
      });
    }
  }

  Future<void> _capturePhoto() async {
    if (_controller == null || !_controller!.value.isInitialized || _isCapturing) {
      return;
    }

    setState(() {
      _isCapturing = true;
    });

    try {
      // Create a unique filename
      final directory = await getTemporaryDirectory();
      final imagePath = '${directory.path}/fridge_scan_${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Take the picture
      final XFile picture = await _controller!.takePicture();
      
      // Copy to our desired location
      final File imageFile = File(imagePath);
      await File(picture.path).copy(imagePath);

      // Return the captured image file
      if (mounted) {
        Navigator.of(context).pop(imageFile);
      }
    } catch (e) {
      setState(() {
        _error = 'Failed to capture photo: $e';
      });
    } finally {
      setState(() {
        _isCapturing = false;
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Scan Your Fridge'),
        actions: [
          if (_isInitialized)
            IconButton(
              icon: const Icon(Icons.flip_camera_ios),
              onPressed: () {
                // TODO: Implement camera switching if multiple cameras available
              },
            ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: _isInitialized ? _buildBottomBar() : null,
    );
  }

  Widget _buildBody() {
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, color: Colors.red, size: 64),
            const SizedBox(height: 16),
            Text(
              _error!,
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_error!.contains('permission')) {
                  CameraService.showPermissionDeniedDialog(context);
                } else {
                  Navigator.of(context).pop();
                }
              },
              child: Text(_error!.contains('permission') ? 'Open Settings' : 'Go Back'),
            ),
          ],
        ),
      );
    }

    if (!_isInitialized) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.white),
            SizedBox(height: 16),
            Text(
              'Initializing camera...',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      );
    }

    return Stack(
      children: [
        // Camera preview
        Positioned.fill(
          child: CameraPreview(_controller!),
        ),
        
        // Overlay with instructions
        Positioned(
          top: 20,
          left: 20,
          right: 20,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Column(
              children: [
                Icon(Icons.kitchen, color: Colors.white, size: 32),
                SizedBox(height: 8),
                Text(
                  'Point your camera at your fridge contents',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4),
                Text(
                  'Make sure ingredients are clearly visible',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        
        // Capture overlay
        if (_isCapturing)
          Container(
            color: Colors.black54,
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.white),
                  SizedBox(height: 16),
                  Text(
                    'Capturing photo...',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Gallery button (placeholder)
          IconButton(
            onPressed: () {
              Navigator.of(context).pop('gallery');
            },
            icon: const Icon(Icons.photo_library, color: Colors.white, size: 32),
          ),
          
          // Capture button
          GestureDetector(
            onTap: _isCapturing ? null : _capturePhoto,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4),
                color: _isCapturing ? Colors.grey : Colors.transparent,
              ),
              child: _isCapturing
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.camera_alt, color: Colors.white, size: 32),
            ),
          ),
          
          // Settings button (placeholder)
          IconButton(
            onPressed: () {
              // TODO: Implement camera settings
            },
            icon: const Icon(Icons.settings, color: Colors.white, size: 32),
          ),
        ],
      ),
    );
  }
}