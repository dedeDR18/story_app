import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:story_app/model/story.dart';

part 'stories_response.freezed.dart';
part 'stories_response.g.dart';

@freezed
class StoriesResponse with _$StoriesResponse {
  const factory StoriesResponse({
    required bool error,
    required String message,
    @JsonKey(name: "listStory") List<Story>? stories,
  }) = _StoriesResponse;


  factory StoriesResponse.fromJson(Map<String, dynamic> json) => _$StoriesResponseFromJson(json);
}
