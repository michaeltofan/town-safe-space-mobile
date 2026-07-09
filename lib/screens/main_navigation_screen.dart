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
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
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
            const SizedBox(height: 16),
            Text(
              title,
              style: AppTheme.serif(fontSize: 28, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            Text(
              subtitle,
              style: AppTheme.sans(
                fontSize: 15,
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
  });

  final String city;
  final String neighborhood;
  final VoidCallback onOpenFeed;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
        children: [
          Text(
            'Menu',
            style: AppTheme.serif(fontSize: 30, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 6),
          Text(
            '$neighborhood, $city',
            style: AppTheme.sans(fontSize: 14, color: AppColors.mutedText),
          ),
          const SizedBox(height: 24),
          _MenuRow(
            icon: Icons.auto_stories_outlined,
            title: 'Feed',
            subtitle: 'Local stories',
            onTap: onOpenFeed,
          ),
          _MenuRow(
            icon: Icons.event_outlined,
            title: 'Events',
            subtitle: 'What’s happening nearby',
            onTap: () {},
          ),
          _MenuRow(
            icon: Icons.edit_outlined,
            title: 'Create Story',
            subtitle: 'Share with your community',
            onTap: () {},
          ),
          _MenuRow(
            icon: Icons.bookmark_border_rounded,
            title: 'Saved',
            subtitle: 'Stories you saved',
            onTap: () {},
          ),
          _MenuRow(
            icon: Icons.person_outline,
            title: 'Profile',
            subtitle: 'Your account',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  const _MenuRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.softWarm,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        title: Text(
          title,
          style: AppTheme.serif(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          subtitle,
          style: AppTheme.sans(fontSize: 12, color: AppColors.mutedText),
        ),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: AppColors.mutedText,
        ),
      ),
    );
  }
}
