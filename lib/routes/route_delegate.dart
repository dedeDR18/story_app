import 'package:flutter/material.dart';
import 'package:story_app/screens/create_story_screen.dart';
import 'package:story_app/screens/detail_story_screen.dart';
import 'package:story_app/screens/list_screen.dart';
import 'package:story_app/screens/login_screen.dart';
import 'package:story_app/screens/register_screen.dart';
import 'package:story_app/screens/splash_screen.dart';
import 'package:story_app/services/session_manager.dart';

class StoryAppRouterDelegate extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final GlobalKey<NavigatorState> _navigatorKey;
  final SessionManager _sessionManager;

  StoryAppRouterDelegate(this._sessionManager)
      : _navigatorKey = GlobalKey<NavigatorState>() {
    _init();
  }

  List<Page> historyStack = [];
  bool? isLoggedIn;
  bool isRegister = false;
  bool isCreatingStory = false;

  void _init() async {
    isLoggedIn = await _sessionManager.isLoggedIn();
    notifyListeners();
  }

  String? selectedStory;

  @override
  Widget build(BuildContext context) {
    if (isLoggedIn == null) {
      historyStack = _splashStack;
    } else if (isLoggedIn == true) {
      historyStack = _loggedInStack;
    } else {
      historyStack = _loggedOutStack;
    }
    return Navigator(
      key: navigatorKey,
      pages: historyStack,
      onPopPage: (route, result) {
        final didPop = route.didPop(result);
        if (!didPop) {
          return false;
        }
        if (isCreatingStory) {
          isCreatingStory = false;
          notifyListeners();
        }

        isRegister = false;
        selectedStory = null;
        notifyListeners();

        return true;
      },
    );
  }

  List<Page> get _splashStack => const [
        MaterialPage(
          key: ValueKey('SplashPage'),
          child: SplashScreen(),
        ),
      ];

  List<Page> get _loggedOutStack => [
        MaterialPage(
          key: ValueKey('LoginPage'),
          child: LoginScreen(
            onLogin: () {
              isLoggedIn = true;
              notifyListeners();
            },
            onRegister: () {
              isRegister = true;
              notifyListeners();
            },
          ),
        ),
        if (isRegister == true)
          MaterialPage(
            key: ValueKey('registerPage'),
            child: RegisterScreen(
              onRegister: () {
                isRegister = false;
                notifyListeners();
              },
              onLogin: () {
                isRegister = false;
                notifyListeners();
              },
            ),
          )
      ];

  List<Page> get _loggedInStack => [
        MaterialPage(
          key: const ValueKey('QuotesListPage'),
          child: ListScreen(
            onTap: (String idStory) {
              selectedStory = idStory;
              notifyListeners();
            },
            onLogout: () {
              isLoggedIn = false;
              notifyListeners();
            },
            onCreateStory: () {
              isCreatingStory = true;
              notifyListeners();
            },
          ),
        ),
        if (isCreatingStory)
          MaterialPage(
            key: const ValueKey('CreateStoryScreen'),
            child: CreateStoryScreen(
              onStoryCreated: () {
                isCreatingStory = false;
                notifyListeners();
              },
            ),
          ),
        if (selectedStory != null)
          MaterialPage(
            key: const ValueKey('DetailStoryScreen'),
            child: DetailStoryScreen(
              idStory: selectedStory!,
              onBack: () {
                selectedStory = null;
                notifyListeners();
              },
            ),
          ),
      ];

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;

  @override
  Future<void> setNewRoutePath(configuration) async {}
}
