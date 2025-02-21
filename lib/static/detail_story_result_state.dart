import 'package:story_app/model/story.dart';

sealed class DetailStoryResultState {}

class DetailStoryNoneState extends DetailStoryResultState {}

class DetailStoryLoadingState extends DetailStoryResultState {}

class DetailStoryErrorState extends DetailStoryResultState {
  final String errorMsg;

  DetailStoryErrorState(this.errorMsg);
}

class DetailStoryLoadedState extends DetailStoryResultState {
  final Story detailStory;

  DetailStoryLoadedState(this.detailStory);
}