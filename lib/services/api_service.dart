import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:story_app/model/detail_story_response.dart';
import 'package:story_app/model/login_response.dart';
import 'package:story_app/model/register_response.dart';
import 'package:story_app/model/stories_response.dart';
import 'package:story_app/model/upload_response.dart';
import 'package:story_app/static/app_constants.dart';

class ApiService {
  Future<RegisterResponse> registerUser(
      String name, String email, String password) async {
    const String url = "${AppConstants.baseUrl}register";
    final uri = Uri.parse(url);
    final response = await http
        .post(uri, body: {'name': name, 'email': email, 'password': password});
    if (response.statusCode == 201) {
      return RegisterResponse.fromJson(jsonDecode(response.body));
    } else {
      final error = RegisterResponse.fromJson(jsonDecode(response.body));
      throw Exception(error.message);
    }
  }

  Future<LoginResponse> login(String email, String password) async {
    const String url = "${AppConstants.baseUrl}login";
    final uri = Uri.parse(url);
    final response =
        await http.post(uri, body: {'email': email, 'password': password});
    if (response.statusCode == 200) {
      return LoginResponse.fromJson(jsonDecode(response.body));
    } else {
      final error = LoginResponse.fromJson(jsonDecode(response.body));
      throw Exception(error.message);
    }
  }

  Future<StoriesResponse> fetchStories(String token, int location, int? pageItems, int sizeItems) async {
    const String url = "${AppConstants.baseUrl}stories";
    final uri = Uri.parse(url).replace(queryParameters: {'page': pageItems.toString(), 'size': sizeItems.toString(), 'location': location.toString()});
    final response =
        await http.get(uri, headers: {'Authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      return StoriesResponse.fromJson(jsonDecode(response.body));
    } else {
      final error = StoriesResponse.fromJson(jsonDecode(response.body));
      throw Exception(error.message);
    }
  }

  Future<DetailStoryResponse> fetchDetail(String idStory, String token) async {
    final String url = "${AppConstants.baseUrl}stories/$idStory";
    final uri = Uri.parse(url);
    try {
      final response =
          await http.get(uri, headers: {'Authorization': 'Bearer $token'});
      if (response.statusCode == 200) {
        return DetailStoryResponse.fromJson(jsonDecode(response.body));
      } else {
        final error = DetailStoryResponse.fromJson(jsonDecode(response.body));
        throw Exception(error.message);
      }
    } catch (e) {
      throw Exception('Failed to fetch detail story');
    }
  }

  Future<UploadResponse> uploadStory(List<int> bytes, String filename,
      String description, double? lat, double? lon, String token) async {
    const String url = "${AppConstants.baseUrl}stories";
    final uri = Uri.parse(url);
    var request = http.MultipartRequest('POST', uri);
    final multiPartFile =
        http.MultipartFile.fromBytes('photo', bytes, filename: filename);
    final Map<String, String> fields = {"description": description};
    if (lat!= null && lon != null) {
      fields['lat'] = lat.toString();
      fields['lon'] = lon.toString();
    }
    final Map<String, String> headers = {
      "Content-type": "multipart/form-data",
      "Authorization": "Bearer $token"
    };
    request.files.add(multiPartFile);
    request.fields.addAll(fields);
    request.headers.addAll(headers);

    final http.StreamedResponse streamedResponse = await request.send();
    final int statusCode = streamedResponse.statusCode;

    final Uint8List responseList = await streamedResponse.stream.toBytes();
    final String responseData = String.fromCharCodes(responseList);

    if (statusCode == 201) {
      final UploadResponse uploadResponse = UploadResponse.fromJson(jsonDecode(responseData));
      return uploadResponse;
    } else {
      throw Exception("Upload file error");
    }
  }
}
