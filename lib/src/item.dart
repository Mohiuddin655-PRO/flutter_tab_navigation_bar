part of '../tab_navigation_bar.dart';

class TabNavigationItem {
  final bool inkWell;
  final Color? rippleColor;
  final Color? pressedColor;

  final Widget? child;
  final Widget Function(BuildContext context, bool selected)? builder;

  const TabNavigationItem({
    this.inkWell = true,
    this.pressedColor,
    this.rippleColor,
    this.child,
    this.builder,
  });

  Widget? _tab(BuildContext context, bool selected, double animation) {
    if (builder != null) {
      return builder!(context, selected);
    }
    return child;
  }
}
