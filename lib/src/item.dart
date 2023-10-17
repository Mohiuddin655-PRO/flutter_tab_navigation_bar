part of '../tab_navigation_bar.dart';

class TabNavigationItem {
  final bool useRoot;
  final IconData? icon, activeIcon;

  final Widget? child;
  final Widget Function(BuildContext context, bool selected)? builder;

  const TabNavigationItem({
    this.useRoot = true,
    this.icon,
    this.activeIcon,
    this.child,
    this.builder,
  });

  Widget? _tab(BuildContext context, bool selected) {
    if (builder != null) {
      return builder!(context, selected);
    }
    return child;
  }

  IconData? _icon(bool selected) => selected ? activeIcon ?? icon : icon;
}
