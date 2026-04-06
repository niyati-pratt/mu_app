import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/constants/colors.dart';

class AppShell extends StatelessWidget {
  final Widget child;
  const AppShell({super.key, required this.child});

  int _idx(String loc) {
    if (loc.startsWith('/home'))    return 0;
    if (loc.startsWith('/notices')) return 1;
    if (loc.startsWith('/profile')) return 2;
    return 0;
  }

  @override
  Widget build(BuildContext ctx) {
    final loc = GoRouterState.of(ctx).matchedLocation;
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _idx(loc),
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.primary.withOpacity(0.12),
        onDestinationSelected: (i) {
          switch (i) {
            case 0: ctx.go('/home');
            case 1: ctx.go('/notices');
            case 2: ctx.go('/profile');
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded,
              color: AppColors.primary),
            label: 'Home'),
          NavigationDestination(
            icon: Icon(Icons.campaign_outlined),
            selectedIcon: Icon(Icons.campaign_rounded,
              color: AppColors.primary),
            label: 'Notices'),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded,
              color: AppColors.primary),
            label: 'Profile'),
        ],
      ),
    );
  }
}