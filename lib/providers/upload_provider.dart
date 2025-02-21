import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:story_app/model/upload_response.dart';
import 'package:story_app/services/api_service.dart';
import 'package:story_app/services/session_manager.dart';

class UploadProvider extends ChangeNotifier {
  final ApiService service;
  final SessionManager sessionManager;
  bool isUploading = false;
  String message = '';
  UploadResponse? uploadResponse;
  XFile? imageFile;
  String? imagePath;
  LatLng? location;

  UploadProvider({required this.service, required this.sessionManager});

  void setLocation(LatLng? value) {
    location = value;
    notifyListeners();
  }

  void setImageFile(XFile? value) {
    imageFile = value;
    notifyListeners();
  }

  void setImagePath(String? value) {
    imagePath = value;
    notifyListeners();
  }

  Future<void> upload(
      List<int> bytes, String filename, String description, double? lat, double? lon) async {
    try {
      final token = await sessionManager.getToken();
      message = '';
      isUploading = true;
      uploadResponse = null;
      notifyListeners();

      uploadResponse = await service.uploadStory(
        bytes,
        filename,
        description,
        lat,
        lon,
        token
      );
      message = uploadResponse?.message ?? 'success';
      isUploading = false;
      notifyListeners();
    } catch (e) {
      isUploading = false;
      message = e.toString();
      notifyListeners();
    }
  }
}
