import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageService {
  final ImagePicker _picker = ImagePicker();

  Future<XFile?> pickFromGallery(BuildContext context) async {
    try {
      if (Platform.isIOS) {
        final is14Plus = await _isIOS14OrNewer();

        if (!is14Plus) {
          final ok = await _requestPhotosPermissionLegacy();
          if (!ok) return null;
        }
      }
      final file = await _picker.pickImage(source: ImageSource.gallery);
      return file;
    } catch (_) {
      return null;
    }
  }

  Future<XFile?> pickFromCamera(BuildContext context) async {
    final ok = await _requestCameraPermission();
    if (!ok) return null;
    try {
      final file = await _picker.pickImage(source: ImageSource.camera);
      return file;
    } catch (_) {
      return null;
    }
  }

  Future<XFile?> recoverLostIfAny(BuildContext context) async {
    try {
      final response = await _picker.retrieveLostData();
      if (response.isEmpty) return null;
      if (response.file != null) return response.file;
      return null;
    } catch (_) {
      return null;
    }
  }

  ImageProvider? getImage({
    XFile? file,
    String? photoUrl,
    String? fallbackAsset,
  }) {
    if (file != null) return FileImage(File(file.path));
    if (photoUrl != null && photoUrl.isNotEmpty) return NetworkImage(photoUrl);
    if (fallbackAsset != null) return AssetImage(fallbackAsset);
    return null;
  }

  Future<bool> _isIOS14OrNewer() async {
    try {
      final info = await DeviceInfoPlugin().iosInfo;
      final major = int.tryParse(info.systemVersion.split('.').first) ?? 0;
      return major >= 14;
    } catch (_) {
      return true;
    }
  }

  Future<bool> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    if (status.isGranted) return true;
    if (status.isPermanentlyDenied) {
      await openAppSettings();
    }
    return false;
  }

  Future<bool> _requestPhotosPermissionLegacy() async {
    final status = await Permission.photos.request();
    if (status.isGranted) return true;
    if (status.isPermanentlyDenied) {
      await openAppSettings();
    }
    return false;
  }
}
