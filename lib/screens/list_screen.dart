import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/providers/auth_provider.dart';
import 'package:story_app/providers/list_provider.dart';
import 'package:story_app/services/post_upload_notifier.dart';
import 'package:story_app/static/stories_result_state.dart';
import 'package:story_app/widgets/item_story_widget.dart';

class ListScreen extends StatefulWidget {
  final Function() onLogout;
  final Function() onCreateStory;
  final Function(String) onTap;
  const ListScreen({
    super.key,
    required this.onLogout,
    required this.onCreateStory,
    required this.onTap,
  });

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    final provider = context.read<ListProvider>();

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent) {
        if (provider.pageItems != null) {
          provider.getStories();
        }
      }
    });

    Future.microtask(() => provider.getStories());
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        title: Text(
          "Story App",
          style: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              final provider = context.read<AuthProvider>();
              final result = await provider.logout();
              if (result) widget.onLogout();
            },
            icon: context.watch<AuthProvider>().isLoadingLogout
                ? SizedBox(
                    width: 22,
                    height: 22,
                    child: Center(
                        child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    )),
                  )
                : Icon(
                    Icons.logout,
                    color: Colors.white,
                  ),
          )
        ],
      ),
      body: Consumer<ListProvider>(builder: (context, value, child) {
        final state = value.resultState;
        if (state is StoriesLoadingState && value.pageItems == 1) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.pinkAccent,
            ),
          );
        } else if (state is StoriesErrorState) {
          return Center(
            child: const Text("Something went wrong..."),
          );
        } else if (state is StoriesLoadedState) {
          final stories = value.stories;
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: ListView.builder(
              controller: scrollController,
              itemCount: stories.length + (value.pageItems != null ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == stories.length && value.pageItems != null) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Colors.pinkAccent,
                      ),
                    ),
                  );
                }
                final story = stories[index];
                return ItemStoryWidget(
                  story: story,
                  onTap: () => widget.onTap(story.id),
                );
              },
            ),
          );
        } else {
          return const SizedBox();
        }
      }),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.pinkAccent,
        icon: Icon(
          Icons.add,
          color: Colors.white,
        ),
        label: Text('Story',
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Colors.white)),
        onPressed: () async {
          widget.onCreateStory();
          final result =
              await context.read<PostUploadNotifier>().waitForResult();

          if (result) {
            context.read<ListProvider>().getStories();
          }
        },
      ),
    );
  }
}
