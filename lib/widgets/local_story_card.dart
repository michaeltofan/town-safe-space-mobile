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
                    Colors.black.withValues(alpha: 0.15),
                    Colors.black.withValues(alpha: 0.55),
                  ],
                ),
              ),
            ),
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 110),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      story.locationLabel,
                      style: TextStyle(
                        fontFamily: AppTheme.sansFallback,
                        fontSize: 13,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      story.headline,
                      style: const TextStyle(
                        fontFamily: AppTheme.serifFallback,
                        fontSize: 32,
                        height: 1.2,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      story.summary,
                      style: TextStyle(
                        fontFamily: AppTheme.sansFallback,
                        fontSize: 16,
                        height: 1.5,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.35),
                            ),
                          ),
                          child: const Icon(
                            Icons.person_outline,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            '${story.authorName} · ${story.authorBadge}',
                            style: TextStyle(
                              fontFamily: AppTheme.sansFallback,
                              fontSize: 13,
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                          ),
                        ),
                        Icon(
                          Icons.bookmark_border_rounded,
                          color: Colors.white.withValues(alpha: 0.85),
                          size: 22,
                        ),
                        const SizedBox(width: 14),
                        Icon(
                          Icons.ios_share_rounded,
                          color: Colors.white.withValues(alpha: 0.85),
                          size: 20,
                        ),
                        const SizedBox(width: 14),
                        Icon(
                          Icons.flag_outlined,
                          color: Colors.white.withValues(alpha: 0.85),
                          size: 20,
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
