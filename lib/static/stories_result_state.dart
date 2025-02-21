import 'package:story_app/model/story.dart';

sealed class StoriesResultState {}

class StoriesNoneState extends StoriesResultState {}

class StoriesLoadingState extends StoriesResultState {}

class StoriesErrorState extends StoriesResultState {
  final String errorMsg;

  StoriesErrorState(this.errorMsg);
}

class StoriesLoadedState extends StoriesResultState {
  final List<Story> stories;

  StoriesLoadedState(this.stories);
}