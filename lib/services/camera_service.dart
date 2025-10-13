import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraService {
  static List<CameraDescription>? _cameras;
  static bool _initialized = false;

  /// Initialize available cameras
  static Future<void> initialize() async {
    if (_initialized) return;
    
    try {
      final cameras = await availableCameras();
      _cameras = cameras;
      _initialized = true;
      print('CameraService: Found ${_cameras?.length ?? 0} cameras');
    } catch (e) {
      print('CameraService: Error initializing cameras: $e');
      _cameras = <CameraDescription>[];
    }
  }

  /// Get the primary rear camera
  static CameraDescription? get primaryCamera {
    if (_cameras == null || _cameras!.isEmpty) return null;
    
    // Try to find rear camera first
    for (final camera in _cameras!) {
      if (camera.lensDirection == CameraLensDirection.back) {
        return camera;
      }
    }
    
    // Fallback to first available camera
    return _cameras!.first;
  }

  /// Get all available cameras
  static List<CameraDescription> get cameras => _cameras ?? [];

  /// Check and request camera permission
  static Future<bool> checkCameraPermission() async {
    final status = await Permission.camera.status;
    
    if (status.isGranted) {
      return true;
    }
    
    if (status.isDenied) {
      final result = await Permission.camera.request();
      return result.isGranted;
    }
    
    return false;
  }

  /// Show permission denied dialog
  static void showPermissionDeniedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Camera Permission Required'),
        content: const Text(
          'This app needs camera access to scan your fridge contents and generate recipes. '
          'Please grant camera permission in your device settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }
}