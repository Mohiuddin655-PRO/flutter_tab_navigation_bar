part of '../tab_navigation_bar.dart';

class _TabNavigationButton extends StatelessWidget {
  final AnimationController controller;
  final TabNavigationItem item;
  final double width;
  final double? height;
  final Color? rippleColor;
  final Color? pressedColor;
  final bool isSelected;
  final VoidCallback? onClick;

  /// Tab properties
  final TabNavigationItemProperty<double> tabCornerRadius;
  final TabNavigationItemProperty<Color?> tabBackground;
  final TabNavigationItemProperty<Color?> tabIconColor;
  final TabNavigationItemProperty<double?> tabIconSize;

  const _TabNavigationButton({
    required this.controller,
    required this.item,
    required this.isSelected,
    required this.width,
    this.height,
    this.onClick,
    this.rippleColor,
    this.pressedColor,
    required this.tabCornerRadius,
    required this.tabBackground,
    required this.tabIconColor,
    required this.tabIconSize,
  });

  @override
  Widget build(BuildContext context) {
    final mChild = item._tab(context, isSelected);
    final mTB = tabBackground;
    final mTCR = tabCornerRadius;
    final mIS = tabIconSize;
    final mIC = tabIconColor;

    Widget mTab;

    if (mChild != null) {
      mTab = GestureDetector(
        onTap: onClick,
        child: AbsorbPointer(child: mChild),
      );
    } else {
      mTab = Material(
        color: mTB.detect(isSelected),
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(mTCR.detect(isSelected)),
        child: InkWell(
          onTap: onClick,
          splashColor: rippleColor,
          highlightColor: pressedColor,
          hoverColor: pressedColor,
          child: Container(
            padding: const EdgeInsets.all(12),
            child: Icon(
              item._icon(isSelected),
              color: mIC.detect(isSelected),
              size: mIS.detect(isSelected),
            ),
          ),
        ),
      );
    }
    return SizedBox(
      width: width,
      height: height,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [mTab],
      ),
    );
  }
}

class TabNavigationItemProperty<T> {
  final T primary;
  final T secondary;

  const TabNavigationItemProperty({
    required this.primary,
    T? secondary,
  }) : secondary = secondary ?? primary;

  bool get isValid => secondary != null;

  T detect(bool isActive) => isActive ? secondary : primary;
}
