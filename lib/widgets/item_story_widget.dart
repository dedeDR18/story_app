import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:story_app/model/story.dart';
import 'package:story_app/static/time_ago.dart';

class ItemStoryWidget extends StatelessWidget {
  final Story story;
  final Function() onTap;

  const ItemStoryWidget({super.key, required this.story, required this.onTap});

  Color getRandomColor() {
    final Random random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //avatar
            Column(
              children: [
                SizedBox(
                  height: 16,
                ),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: getRandomColor()),
                  child: FittedBox(
                    child: Text(
                      story.name[0].toUpperCase(),
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                )
              ],
            ),
            //name and content
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 8, top: 6),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      story.name,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    CachedNetworkImage(
                      imageUrl: story.photoUrl,
                      placeholder: (context, url) =>
                          CircularProgressIndicator(color: Colors.pinkAccent),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      timeAgo(story.createdAt),
                      style: Theme.of(context).textTheme.labelSmall,
                    )
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
