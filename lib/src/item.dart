part of '../tab_navigation_bar.dart';

class TabNavigationItem {
  final IconData? icon, activeIcon;
  final TabNavigationItemProperty<Color>? tabIconColor;
  final TabNavigationItemProperty<double>? tabIconSize;

  final TabNavigationItemProperty<double>? tabCornerRadius;
  final TabNavigationItemProperty<Color>? tabBackground;

  final Widget? tab;
  final Widget Function(BuildContext context, bool isSelected)? tabBuilder;

  const TabNavigationItem({
    this.icon,
    this.activeIcon,
    this.tab,
    this.tabBackground,
    this.tabBuilder,
    this.tabCornerRadius,
    this.tabIconColor,
    this.tabIconSize,
  });

  bool get _isValidItem {
    return icon != null ||
        activeIcon != null ||
        tab != null ||
        tabBuilder != null;
  }

  Widget? _tab(BuildContext context, bool selected) {
    return tabBuilder?.call(context, selected) ?? tab;
  }

  IconData? _icon(bool selected) => selected ? activeIcon : icon;
}
