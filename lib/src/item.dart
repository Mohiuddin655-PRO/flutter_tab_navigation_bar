part of '../tab_navigation_bar.dart';

class TabNavigationItem {
  final IconData? icon, activeIcon;

  final Widget? child;
  final Widget Function(BuildContext context, bool selected)? builder;

  const TabNavigationItem({
    this.icon,
    this.activeIcon,
    this.child,
    this.builder,
  });

  bool get _isValidItem {
    return icon != null ||
        activeIcon != null ||
        child != null ||
        builder != null;
  }

  Widget? _tab(BuildContext context, bool selected) {
    if (builder != null) {
      return builder!(context, selected);
    }
    return child;
  }

  IconData? _icon(bool selected) => selected ? activeIcon : icon;
}
