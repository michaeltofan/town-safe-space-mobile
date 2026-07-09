import 'package:flutter/material.dart';

import '../models/local_story.dart';
import '../theme/app_theme.dart';

class LocalStoryCard extends StatelessWidget {
  const LocalStoryCard({
    super.key,
    required this.story,
    required this.onTap,
  });

  final LocalStory story;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: story.gradientColors,
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.12),
                    Colors.black.withValues(alpha: 0.58),
                  ],
                ),
              ),
            ),
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(22, 22, 22, 96),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      story.locationLabel,
                      style: AppTheme.sans(
                        fontSize: 12,
                        letterSpacing: 1.1,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      story.headline,
                      style: AppTheme.serif(
                        fontSize: 28,
                        height: 1.2,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      story.summary,
                      style: AppTheme.sans(
                        fontSize: 15,
                        height: 1.5,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.18),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.3),
                            ),
                          ),
                          child: const Icon(
                            Icons.person_outline,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            '${story.authorName} · ${story.authorBadge}',
                            style: AppTheme.sans(
                              fontSize: 12,
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                          ),
                        ),
                        Icon(
                          Icons.bookmark_border_rounded,
                          color: Colors.white.withValues(alpha: 0.85),
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.ios_share_rounded,
                          color: Colors.white.withValues(alpha: 0.85),
                          size: 18,
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.flag_outlined,
                          color: Colors.white.withValues(alpha: 0.85),
                          size: 18,
                        ),
                      ],
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
