part of '../tab_navigation_bar.dart';

class _TabNavigationButton extends StatelessWidget {
  final TabNavigationController controller;
  final TabNavigationItem item;
  final double width;
  final Color? rippleColor;
  final Color? pressedColor;
  final bool isSelected;
  final VoidCallback? onClick;

  /// Tab properties
  final TabNavigationItemProperty<double>? tabCornerRadius;
  final TabNavigationItemProperty<Color?>? tabBackground;

  const _TabNavigationButton({
    required this.controller,
    required this.item,
    required this.isSelected,
    required this.width,
    this.onClick,
    this.rippleColor,
    this.pressedColor,
    this.tabCornerRadius,
    this.tabBackground,
  });

  @override
  Widget build(BuildContext context) {
    final mChild = item._tab(context, isSelected, 1);
    return SizedBox(
      width: width,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Material(
            color: tabBackground?.detect(isSelected) ?? Colors.transparent,
            clipBehavior: Clip.antiAlias,
            borderRadius: tabCornerRadius != null
                ? BorderRadius.circular(tabCornerRadius!.detect(isSelected))
                : null,
            child: item.inkWell
                ? InkWell(
                    onTap: item.inkWell ? onClick : null,
                    splashColor: item.rippleColor ?? rippleColor,
                    highlightColor: item.pressedColor ?? pressedColor,
                    hoverColor: item.pressedColor ?? pressedColor,
                    child: AbsorbPointer(child: mChild),
                  )
                : mChild,
          )
        ],
      ),
    );
  }
}

class TabNavigationItemProperty<T> {
  final T selected;
  final T unselected;

  const TabNavigationItemProperty({
    required this.selected,
    required this.unselected,
  });

  const TabNavigationItemProperty.all(T value)
      : this(selected: value, unselected: value);

  bool get isValid => selected != null;

  T detect(bool isActive) => isActive ? selected : unselected;
}
