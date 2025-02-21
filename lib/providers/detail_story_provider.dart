import 'package:flutter/material.dart';
import 'package:story_app/services/api_service.dart';
import 'package:story_app/services/session_manager.dart';
import 'package:story_app/static/detail_story_result_state.dart';

class DetailStoryProvider extends ChangeNotifier {

  final ApiService _service;
  final SessionManager _sessionManager;

  DetailStoryProvider(this._service, this._sessionManager);

  DetailStoryResultState _resultState = DetailStoryNoneState();

  DetailStoryResultState get resultState => _resultState;

  Future<void> getDetailStory(String idStory) async {
    _resultState = DetailStoryLoadingState();
    notifyListeners();

    try {
      final token = await _sessionManager.getToken();
      final detailStoryResponse = await _service.fetchDetail(idStory, token);
      if (detailStoryResponse.error) {
        _resultState = DetailStoryErrorState(detailStoryResponse.message);
      } else {
        _resultState = DetailStoryLoadedState(detailStoryResponse.detailStory!);
      }
    } catch (e) {
      _resultState = DetailStoryErrorState(e.toString());
    }
    notifyListeners();
  }
}