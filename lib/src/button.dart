part of '../tab_navigation_bar.dart';

class _TabNavigationButton extends StatelessWidget {
  final double width;
  final double height;
  final Color? rippleColor;
  final Color? pressedColor;
  final bool isSelected;
  final TabNavigationTweenValue<IconData?> tabIcon;
  final VoidCallback? onClick;

  /// Tab properties
  final TabNavigationTweenValue<double> tabCornerRadius;
  final TabNavigationTweenValue<Color?> tabBackground;
  final TabNavigationTweenValue<Color?> tabIconColor;
  final TabNavigationTweenValue<double?> tabIconSize;

  const _TabNavigationButton({
    required this.isSelected,
    required this.width,
    required this.height,
    this.onClick,
    this.rippleColor,
    this.pressedColor,
    required this.tabIcon,
    required this.tabCornerRadius,
    required this.tabBackground,
    required this.tabIconColor,
    required this.tabIconSize,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: tabBackground.detect(isSelected),
      clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.circular(tabCornerRadius.detect(isSelected)),
      child: InkWell(
        onTap: onClick,
        splashColor: rippleColor,
        highlightColor: pressedColor,
        child: SizedBox(
          width: width,
          height: height,
          child: Icon(
            tabIcon.detect(isSelected),
            size: tabIconSize.detect(isSelected),
            color: tabIconColor.detect(isSelected),
          ),
        ),
      ),
    );
  }
}

class TabNavigationTweenValue<T> {
  final T primary;
  final T secondary;

  const TabNavigationTweenValue({
    required this.primary,
    T? secondary,
  }) : secondary = secondary ?? primary;

  T detect(bool isActive) => isActive ? secondary : primary;
}
