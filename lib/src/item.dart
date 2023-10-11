part of '../tab_navigation_bar.dart';

class TabNavigationItem {
  final IconData? icon;
  final IconData? activeIcon;
  final String label;

  const TabNavigationItem({
    this.icon,
    this.activeIcon,
    this.label = "",
  });

  bool get _isValidItem => icon != null || activeIcon != null;
}
