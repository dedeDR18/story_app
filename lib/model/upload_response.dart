
import 'package:freezed_annotation/freezed_annotation.dart';

part 'upload_response.freezed.dart';
part 'upload_response.g.dart';

@freezed
class UploadResponse with _$UploadResponse {
  const factory UploadResponse({
    required bool error,
    required String message,
  }) = _UploadResponse;

  factory UploadResponse.fromJson(Map<String, dynamic> json) => _$UploadResponseFromJson(json);

  // factory UploadResponse.fromJson(String source) {
  //   return UploadResponse.fromMap(jsonDecode(source));
  // }
}