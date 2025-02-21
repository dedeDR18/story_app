import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_app/providers/auth_provider.dart';
import 'package:story_app/providers/detail_story_provider.dart';
import 'package:story_app/providers/list_provider.dart';
import 'package:story_app/providers/upload_provider.dart';
import 'package:story_app/routes/route_delegate.dart';
import 'package:story_app/services/api_service.dart';
import 'package:story_app/services/post_upload_notifier.dart';
import 'package:story_app/services/session_manager.dart';
import 'package:story_app/style/theme/story_app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = await SharedPreferences.getInstance();

  runApp(MultiProvider(
    providers: [
      Provider(create: (_) => ApiService()),
      Provider(create: (_) => SessionManager(preferences)),
      ChangeNotifierProvider(
        create: (context) => AuthProvider(
          context.read<ApiService>(),
          context.read<SessionManager>(),
        ),
      ),
      ChangeNotifierProvider(
          create: (context) => ListProvider(
              context.read<ApiService>(), context.read<SessionManager>())),
      ChangeNotifierProvider(
          create: (context) => DetailStoryProvider(
              context.read<ApiService>(), context.read<SessionManager>())),
      ChangeNotifierProvider(
          create: (context) => UploadProvider(
                service: context.read<ApiService>(),
                sessionManager: context.read<SessionManager>(),
              )),
      ChangeNotifierProvider(create: (_) => PostUploadNotifier())
    ],
    child: const StoryApp(),
  ));
}

class StoryApp extends StatefulWidget {
  const StoryApp({super.key});

  @override
  State<StoryApp> createState() => _StoryAppState();
}

class _StoryAppState extends State<StoryApp> {
  late StoryAppRouterDelegate storyAppRouterDelegate;

  @override
  void initState() {
    storyAppRouterDelegate =
        StoryAppRouterDelegate(context.read<SessionManager>());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, provider, child) {
        return MaterialApp(
          title: 'Story App',
          theme: StoryAppTheme.lightTheme,
          home: Router(
            routerDelegate: storyAppRouterDelegate,
            backButtonDispatcher: RootBackButtonDispatcher(),
          ),
        );
      },
    );
  }
}
