part of '../tab_navigation_bar.dart';

typedef OnButtonPressCallback = void Function(int index);

class TabNavigationBar extends StatefulWidget {
  final PageController? controller;
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
  final double indicatorRadius;
  final IndicatorPosition indicatorPosition;

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
    this.indicatorRadius = 8,
    this.indicatorPosition = const IndicatorPositionBottom(32),
    this.controller,
    this.tabCornerRadius,
    this.tabBackground,
    this.tabIconColor,
    this.tabIconSize,
    this.tabHeight = 60,
  });

  @override
  State<TabNavigationBar> createState() => _TabNavigationBarState();
}

class _TabNavigationBarState extends State<TabNavigationBar>
    with TickerProviderStateMixin {
  late PageController? _controller;
  late AnimationController _animation;

  int _previousIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    _animation = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    )..forward(from: 0.0);
    _controller?.addListener(_pageListener);
  }

  @override
  void dispose() {
    _controller?.removeListener(_pageListener);
    _animation.dispose();
    super.dispose();
  }

  void _pageListener() {
    final int selectedIndex = widget.selectedIndex;
    final int index = _controller?.page?.round() ?? selectedIndex;
    if (widget.items[index].useRoot) {
      if (selectedIndex != index && !_animation.isAnimating) {
        widget.onItemSelected(index);
        _animation.forward(from: 0.0);
      }
    }
  }

  void _onTap(int index) {
    if (widget.selectedIndex != index) {
      widget.onItemSelected(index);
      _animation.forward(from: 0.0);
      _previousIndex = widget.selectedIndex;
      _controller?.animateToPage(
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

    final mIP = widget.indicatorPosition;
    return WidgetWrapper(
      wrap: (context, size) {
        var width = size.width / items.length;

        return Container(
          width: widget.width,
          height: widget.tabHeight,
          color: backgroundColor,
          child: Stack(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(
                  widget.items.length,
                  (index) {
                    final item = widget.items[index];
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
                      controller: _animation,
                      width: width,
                      height: widget.tabHeight,
                      onClick: () => _onTap(index),
                    );
                  },
                ),
              ),
              Positioned(
                top: 0,
                bottom: 0,
                child: Container(
                  margin: EdgeInsets.only(
                    top: mIP.isBottom ? mIP.value : 0,
                    bottom: mIP.isTop ? mIP.value : 0,
                    left: mIP.isStart ? mIP.value : 0,
                    right: mIP.isEnd ? mIP.value : 0,
                  ),
                  child: AnimatedIndicator(
                    animation: _animation,
                    controller: _controller,
                    currentIndex: widget.selectedIndex,
                    previousIndex: _previousIndex,
                    indicator: widget.indicator,
                    indicatorColor: widget.indicatorColor ?? mIC,
                    indicatorWidth: widget.indicatorWidth,
                    indicatorHeight: widget.indicatorHeight,
                    indicatorRadius: widget.indicatorRadius,
                    tabWidth: width,
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
