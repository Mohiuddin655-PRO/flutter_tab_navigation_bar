part of '../tab_navigation_bar.dart';

class TabNavigationItem {
  final IconData? icon;

  final IconData? activeIcon;

  const TabNavigationItem({
    this.icon,
    this.activeIcon,
  });

  bool get _isValidItem => icon != null || activeIcon != null;
}
