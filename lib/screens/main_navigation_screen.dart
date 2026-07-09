import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/bottom_nav.dart';
import 'local_discussion_screen.dart';
import 'local_feed_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({
    super.key,
    required this.city,
    required this.neighborhood,
  });

  final String city;
  final String neighborhood;

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      const LocalFeedScreen(),
      const _PlaceholderTab(
        title: 'Search',
        subtitle: 'Local search stays inside your community.',
      ),
      const _PlaceholderTab(
        title: 'Create',
        subtitle: 'Creator Studio is not part of this visual MVP.',
      ),
      LocalDiscussionScreen(
        locationLabel: '${widget.city} · ${widget.neighborhood}',
        showAppBar: false,
      ),
      _ProfileMenu(
        city: widget.city,
        neighborhood: widget.neighborhood,
        onOpenFeed: () => setState(() => _index = 0),
        onOpenDiscussion: () => setState(() => _index = 3),
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: pages,
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: _index,
        onTap: (value) => setState(() => _index = value),
      ),
    );
  }
}

class _PlaceholderTab extends StatelessWidget {
  const _PlaceholderTab({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Text(title, style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 12),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.mutedText,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileMenu extends StatelessWidget {
  const _ProfileMenu({
    required this.city,
    required this.neighborhood,
    required this.onOpenFeed,
    required this.onOpenDiscussion,
  });

  final String city;
  final String neighborhood;
  final VoidCallback onOpenFeed;
  final VoidCallback onOpenDiscussion;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(28, 28, 28, 40),
        children: [
          Text('Profile', style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 8),
          Text(
            '$neighborhood, $city',
            style: const TextStyle(
              fontFamily: AppTheme.sansFallback,
              fontSize: 15,
              color: AppColors.mutedText,
            ),
          ),
          const SizedBox(height: 28),
          _MenuRow(
            title: 'Feed',
            subtitle: 'Local stories',
            onTap: onOpenFeed,
          ),
          _MenuRow(
            title: 'Events',
            subtitle: 'What’s happening nearby',
            onTap: () {},
          ),
          _MenuRow(
            title: 'Create Story',
            subtitle: 'Share with your community',
            onTap: () {},
          ),
          _MenuRow(
            title: 'Saved',
            subtitle: 'Stories you saved',
            onTap: () {},
          ),
          _MenuRow(
            title: 'Profile',
            subtitle: 'Your account',
            onTap: () {},
          ),
          const SizedBox(height: 12),
          _MenuRow(
            title: 'Discussion',
            subtitle: 'Talk with neighbors',
            onTap: onOpenDiscussion,
          ),
        ],
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  const _MenuRow({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: AppTheme.serifFallback,
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: AppColors.text,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontFamily: AppTheme.sansFallback,
            fontSize: 13,
            color: AppColors.mutedText,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: AppColors.mutedText,
        ),
      ),
    );
  }
}
