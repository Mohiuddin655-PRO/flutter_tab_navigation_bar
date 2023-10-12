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
  final EdgeInsets padding;

  /// Tab properties
  final double tabHeight;
  final TabNavigationItemProperty<double>? tabCornerRadius;
  final TabNavigationItemProperty<Color>? tabBackground;
  final TabNavigationItemProperty<Color>? tabIconColor;
  final TabNavigationItemProperty<double>? tabIconSize;

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
    this.padding = const EdgeInsets.only(bottom: 8),
    this.tabHeight = 60,
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

    final paddingTop = widget.padding.top;
    final paddingBottom = widget.padding.bottom;

    return WidgetWrapper(
      wrap: (context, size) {
        var width = size.width / items.length;

        return Container(
          width: widget.width,
          height: widget.tabHeight + paddingTop + paddingBottom,
          color: backgroundColor,
          padding: EdgeInsets.only(
            top: paddingTop,
            left: widget.padding.left,
            right: widget.padding.right,
          ),
          child: Stack(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: items.map((item) {
                  final int index = items.indexOf(item);
                  return _TabNavigationButton(
                    item: item,
                    tabBackground: widget.tabBackground ??
                        TabNavigationItemProperty(primary: backgroundColor),
                    tabCornerRadius: widget.tabCornerRadius ??
                        const TabNavigationItemProperty(primary: 25),
                    tabIconColor: widget.tabIconColor ??
                        TabNavigationItemProperty(
                            primary: mIIC, secondary: mAIC),
                    tabIconSize: widget.tabIconSize ??
                        const TabNavigationItemProperty(primary: null),
                    rippleColor: primary.withOpacity(0.1),
                    pressedColor: primary.withOpacity(0.1),
                    isSelected: selectedIndex == index,
                    controller: _controller,
                    width: width,
                    height: widget.tabHeight,
                    onClick: item._isValidItem ? () => _onTap(index) : null,
                  );
                }).toList(),
              ),
              Positioned(
                bottom: paddingBottom,
                child: AnimatedIndicator(
                  controller: widget.controller,
                  tabWidth: width,
                  indicatorColor: mIC,
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
