part of '../tab_navigation_bar.dart';

class TabNavigationItem {
  final IconData icon;

  final IconData? activeIcon;

  const TabNavigationItem({
    this.activeIcon,
    required this.icon,
  });
}
