import 'package:flutter/material.dart';

import '../data/mock_stories.dart';
import '../widgets/local_story_card.dart';
import 'story_detail_screen.dart';

class LocalFeedScreen extends StatelessWidget {
  const LocalFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      scrollDirection: Axis.vertical,
      itemCount: mockStories.length,
      itemBuilder: (context, index) {
        final story = mockStories[index];
        return LocalStoryCard(
          story: story,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => StoryDetailScreen(story: story),
              ),
            );
          },
        );
      },
    );
  }
}
