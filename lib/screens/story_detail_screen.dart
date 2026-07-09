import 'package:flutter/material.dart';

import '../models/local_story.dart';
import '../theme/app_theme.dart';
import 'local_discussion_screen.dart';

class StoryDetailScreen extends StatelessWidget {
  const StoryDetailScreen({super.key, required this.story});

  final LocalStory story;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                    color: AppColors.text,
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.bookmark_border_rounded),
                    color: AppColors.text,
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.ios_share_rounded),
                    color: AppColors.text,
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(28, 8, 28, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      story.locationLabel,
                      style: const TextStyle(
                        fontFamily: AppTheme.sansFallback,
                        fontSize: 13,
                        letterSpacing: 1.1,
                        fontWeight: FontWeight.w500,
                        color: AppColors.mutedText,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      story.headline,
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(height: 22),
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.softWarm,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.border),
                          ),
                          child: const Icon(
                            Icons.person_outline,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              story.authorName,
                              style: const TextStyle(
                                fontFamily: AppTheme.sansFallback,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AppColors.text,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              story.authorBadge,
                              style: const TextStyle(
                                fontFamily: AppTheme.sansFallback,
                                fontSize: 13,
                                color: AppColors.mutedText,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${story.dateLabel} · ${story.readTime}',
                      style: const TextStyle(
                        fontFamily: AppTheme.sansFallback,
                        fontSize: 13,
                        color: AppColors.mutedText,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: story.gradientColors,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      story.body,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            height: 1.7,
                            fontSize: 17,
                          ),
                    ),
                    const SizedBox(height: 36),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => LocalDiscussionScreen(
                                locationLabel: story.locationLabel,
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          'Join the local discussion',
                          style: TextStyle(
                            fontFamily: AppTheme.serifFallback,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
