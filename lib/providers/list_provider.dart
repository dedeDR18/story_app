import 'package:flutter/material.dart';
import 'package:story_app/model/story.dart';
import 'package:story_app/services/api_service.dart';
import 'package:story_app/services/session_manager.dart';
import 'package:story_app/static/stories_result_state.dart';

class ListProvider extends ChangeNotifier {
  final ApiService _service;
  final SessionManager _sessionManager;

  List<Story> stories = [];

  int? pageItems = 1;
  int sizeItems = 10;

  bool _isLoadingMore = false;

  ListProvider(this._service, this._sessionManager);

  StoriesResultState _resultState = StoriesNoneState();

  StoriesResultState get resultState => _resultState;

  Future<void> getStories([bool fromUploadScreen = false]) async {
    if(fromUploadScreen){
      stories.clear();
      pageItems = 1;
    }

    if (_isLoadingMore) {
      return;
    }
    _isLoadingMore = true;
    notifyListeners();

    try {
      if (pageItems == 1) {
        _resultState = StoriesLoadingState();
        notifyListeners();
      }
      final token = await _sessionManager.getToken();
      final result =
          await _service.fetchStories(token, 0, pageItems!, sizeItems);
      if (result.error) {
        _resultState = StoriesErrorState(result.message);
        notifyListeners();
      } else {
        stories.addAll(result.stories ?? []);
        _resultState = StoriesLoadedState(result.stories ?? []);

        if (result.stories!.length < sizeItems) {
          pageItems = null;
        } else {
          pageItems = pageItems! + 1;
        }

        notifyListeners();
      }
    } catch (e) {
      _resultState = StoriesErrorState(e.toString());
      notifyListeners();
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }
}
