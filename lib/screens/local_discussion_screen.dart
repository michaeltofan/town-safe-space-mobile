import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class LocalDiscussionScreen extends StatelessWidget {
  const LocalDiscussionScreen({
    super.key,
    this.locationLabel = 'Milano · Brera',
    this.showAppBar = true,
  });

  final String locationLabel;
  final bool showAppBar;

  @override
  Widget build(BuildContext context) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!showAppBar) ...[
          Text(
            'Discussion',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 8),
        ],
        Text(
          locationLabel,
          style: const TextStyle(
            fontFamily: AppTheme.sansFallback,
            fontSize: 14,
            color: AppColors.mutedText,
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Share your perspective with your neighbors.',
          style: TextStyle(
            fontFamily: AppTheme.sansFallback,
            fontSize: 15,
            color: AppColors.mutedText,
          ),
        ),
        const SizedBox(height: 28),
        const _CommentCard(
          name: 'Marco B.',
          body:
              'I support more pedestrian space. It will help local shops and make the area more livable.',
        ),
        const SizedBox(height: 14),
        const _CommentCard(
          name: 'Elena V.',
          body:
              'It’s important to find balance. Deliveries and residents need solutions too.',
        ),
      ],
    );

    return Scaffold(
      appBar: showAppBar
          ? AppBar(
              title: Text(
                'Discussion',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            )
          : null,
      body: SafeArea(
        top: !showAppBar,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(28, showAppBar ? 8 : 24, 28, 16),
                child: content,
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              decoration: BoxDecoration(
                color: AppColors.card,
                border: const Border(
                  top: BorderSide(color: AppColors.border),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 12,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Write your comment…',
                  hintStyle: const TextStyle(
                    fontFamily: AppTheme.sansFallback,
                    color: AppColors.mutedText,
                  ),
                  filled: true,
                  fillColor: AppColors.background,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(999),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(999),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(999),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CommentCard extends StatelessWidget {
  const _CommentCard({required this.name, required this.body});

  final String name;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(
              fontFamily: AppTheme.serifFallback,
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: const TextStyle(
              fontFamily: AppTheme.sansFallback,
              fontSize: 15,
              height: 1.55,
              color: AppColors.text,
            ),
          ),
        ],
      ),
    );
  }
}
