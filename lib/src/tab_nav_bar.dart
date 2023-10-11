part of '../tab_navigation_bar.dart';

typedef OnButtonPressCallback = void Function(int index);

class TabNavigationBar extends StatefulWidget {
  final PageController controller;
  final Color? primaryColor;
  final Color? activeColor;
  final Color? inactiveColor;
  final double? width;
  final Color backgroundColor;
  final OnButtonPressCallback onItemSelected;
  final int selectedIndex;
  final List<TabNavigationItem> items;
  final double? bottomPadding;
  final Duration animationDuration;
  final Widget? indicator;
  final double indicatorWidth;
  final double indicatorHeight;
  final Color? indicatorColor;
  final double indicatorCornerRadius;

  /// Tab properties
  final TabNavigationTweenValue<double>? tabCornerRadius;
  final TabNavigationTweenValue<Color>? tabBackground;
  final TabNavigationTweenValue<Color>? tabIconColor;
  final TabNavigationTweenValue<double>? tabIconSize;

  const TabNavigationBar({
    super.key,
    this.width,
    this.primaryColor,
    this.activeColor,
    this.inactiveColor,
    required this.items,
    required this.selectedIndex,
    required this.onItemSelected,
    this.bottomPadding,
    this.backgroundColor = Colors.white,
    this.animationDuration = const Duration(milliseconds: 500),
    this.indicator,
    this.indicatorWidth = 32,
    this.indicatorHeight = 4,
    this.indicatorColor,
    this.indicatorCornerRadius = 8,
    required this.controller,
    this.tabCornerRadius,
    this.tabBackground,
    this.tabIconColor,
    this.tabIconSize,
  });

  @override
  State<TabNavigationBar> createState() => _TabNavigationBarState();
}

class _TabNavigationBarState extends State<TabNavigationBar>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    )..forward(from: 0.0);
    widget.controller.addListener(_pageListener);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_pageListener);
    _controller.dispose();
    super.dispose();
  }

  void _pageListener() {
    final int selectedIndex = widget.selectedIndex;
    final int index = widget.controller.page?.round() ?? selectedIndex;
    if (selectedIndex != index && !_controller.isAnimating) {
      widget.onItemSelected(index);
      _controller.forward(from: 0.0);
    }
  }

  void _onTap(int index) {
    if (widget.selectedIndex != index) {
      widget.onItemSelected(index);
      _controller.forward(from: 0.0);
      widget.controller.animateToPage(
        index,
        duration: widget.animationDuration,
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary =
        widget.primaryColor ?? Theme.of(context).colorScheme.primary;

    final mAIC = widget.activeColor ?? primary;
    final mIIC = widget.inactiveColor ?? primary.withOpacity(0.5);
    final mIC = widget.indicatorColor ?? primary;

    final int selectedIndex = widget.selectedIndex;
    final Color backgroundColor = widget.backgroundColor;

    final List<TabNavigationItem> items = widget.items;
    final double iconSize = widget.iconSize;
    final double bottomPadding =
        widget.bottomPadding ?? MediaQuery.of(context).padding.bottom;

    return WidgetWrapper(
      wrap: (context, size) {
        var width = size.width / items.length;

        return Container(
          width: widget.width,
          height: 60 + bottomPadding,
          color: backgroundColor,
          child: Stack(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: items.map((item) {
                  final int index = items.indexOf(item);
                  return _TabNavigationButton(
                    tabBackground: widget.tabBackground ??
                        TabNavigationTweenValue(primary: backgroundColor),
                    tabCornerRadius: widget.tabCornerRadius ??
                        const TabNavigationTweenValue(primary: 25),
                    tabIcon: TabNavigationTweenValue(
                      primary: item.icon,
                      secondary: item.activeIcon,
                    ),
                    tabIconColor: widget.tabIconColor ??
                        TabNavigationTweenValue(primary: mIIC, secondary: mAIC),
                    tabIconSize: widget.tabIconSize ??
                        TabNavigationTweenValue(primary: iconSize),
                    rippleColor: primary.withOpacity(0.1),
                    pressedColor: primary.withOpacity(0.1),
                    isSelected: selectedIndex == index,
                    width: width,
                    height: 60,
                    onClick: item._isValidItem ? () => _onTap(index) : null,
                  );
                }).toList(),
              ),
              Positioned(
                bottom: bottomPadding,
                child: AnimatedIndicator(
                  controller: widget.controller,
                  type: TabNavigationIndicatorType.full,
                  width: width,
                  height: 4,
                  color: mIC,
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
