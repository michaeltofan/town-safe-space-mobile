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
            style: AppTheme.serif(fontSize: 28, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 6),
        ],
        Text(
          locationLabel.replaceAll(' · ', ' • '),
          style: AppTheme.sans(
            fontSize: 13,
            color: AppColors.mutedText,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Share your perspective with your neighbors.',
          style: AppTheme.sans(
            fontSize: 14,
            color: AppColors.mutedText,
          ),
        ),
        const SizedBox(height: 22),
        const _CommentCard(
          name: 'Marco B.',
          body:
              'I support more pedestrian space. It will help local shops and make the area more livable.',
        ),
        const SizedBox(height: 10),
        const _CommentCard(
          name: 'Elena V.',
          body:
              'It’s important to find balance. Deliveries and residents need solutions too.',
        ),
      ],
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: showAppBar
          ? AppBar(
              title: Text(
                'Discussion',
                style: AppTheme.serif(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            )
          : null,
      body: SafeArea(
        top: !showAppBar,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  AppTheme.screenPadding,
                  showAppBar ? 4 : 18,
                  AppTheme.screenPadding,
                  12,
                ),
                child: content,
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
              decoration: const BoxDecoration(
                color: AppColors.card,
                border: Border(
                  top: BorderSide(color: AppColors.border),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Write your comment…',
                        hintStyle: AppTheme.sans(
                          fontSize: 14,
                          color: AppColors.mutedText,
                        ),
                        filled: true,
                        fillColor: AppColors.background,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
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
                  const SizedBox(width: 8),
                  Container(
                    width: 42,
                    height: 42,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_upward_rounded,
                      color: AppColors.card,
                      size: 18,
                    ),
                  ),
                ],
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.softWarm,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.border),
            ),
            child: const Icon(Icons.person_outline, size: 16, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTheme.serif(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 6),
                Text(
                  body,
                  style: AppTheme.sans(
                    fontSize: 14,
                    height: 1.5,
                    color: AppColors.text,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
