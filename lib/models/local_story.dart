import 'package:flutter/material.dart';

/// Local editorial story card used by the Substack-style feed.
class LocalStory {
  const LocalStory({
    required this.id,
    required this.locationLabel,
    required this.headline,
    required this.summary,
    required this.authorName,
    required this.authorBadge,
    required this.dateLabel,
    required this.readTime,
    required this.body,
    required this.gradientColors,
  });

  final String id;
  final String locationLabel;
  final String headline;
  final String summary;
  final String authorName;
  final String authorBadge;
  final String dateLabel;
  final String readTime;
  final String body;
  final List<Color> gradientColors;
}
