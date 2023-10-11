part of '../tab_navigation_bar.dart';

typedef OnButtonPressCallback = void Function(int index);

class TabNavigationBar extends StatefulWidget {
  final PageController controller;
  final Color backgroundColor;
  final OnButtonPressCallback onItemSelected;
  final int selectedIndex;
  final List<TabNavigationItem> items;
  final Color? primaryColor;
  final Color? secondaryColor;
  final double iconSize;
  final double? bottomPadding;
  final Duration animationDuration;
  final Widget? indicator;
  final double indicatorWidth;
  final double indicatorHeight;
  final Color? indicatorColor;
  final double indicatorCornerRadius;

  const TabNavigationBar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onItemSelected,
    this.bottomPadding,
    this.backgroundColor = Colors.white,
    this.primaryColor,
    this.iconSize = 28,
    this.animationDuration = const Duration(milliseconds: 500),
    Color? inactiveIconColor,
    this.indicator,
    this.indicatorWidth = 32,
    this.indicatorHeight = 4,
    this.indicatorColor,
    this.indicatorCornerRadius = 8,
    required this.controller,
  }) : secondaryColor = inactiveIconColor ?? primaryColor;

  @override
  State<TabNavigationBar> createState() => _TabNavigationBarState();
}

class _TabNavigationBarState extends State<TabNavigationBar>
    with TickerProviderStateMixin {
  int _previousIndex = 0;

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
    widget.controller.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _pageListener() {
    final int selectedIndex = widget.selectedIndex;

    final int index = widget.controller.page?.round() ?? selectedIndex;

    if (selectedIndex == index || _controller.isAnimating) {
      return;
    } else {
      widget.onItemSelected(index);
      _previousIndex = widget.selectedIndex;
      _controller.forward(from: 0.0);
    }
  }

  void _onTap(int index) {
    final int selectedIndex = widget.selectedIndex;

    if (selectedIndex == index || _controller.isAnimating) {
      return;
    } else {
      widget.onItemSelected(index);
      _controller.forward(from: 0.0);
      _previousIndex = widget.selectedIndex;

      widget.controller.animateToPage(
        index,
        duration: widget.animationDuration,
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final int selectedIndex = widget.selectedIndex;
    final Color backgroundColor = widget.backgroundColor;
    final Color primaryColor =
        widget.primaryColor ?? Theme.of(context).colorScheme.primary;
    final List<TabNavigationItem> items = widget.items;
    final double iconSize = widget.iconSize;
    final double bottomPadding =
        widget.bottomPadding ?? MediaQuery.of(context).padding.bottom;
    return Container(
      height: 54 + bottomPadding,
      color: backgroundColor,
      child: Stack(
        children: <Widget>[
          AnimatedBuilder(
            animation: widget.controller,
            builder: (_, __) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: items.map((item) {
                  final int index = items.indexOf(item);
                  return _TabNavigationButton(
                    itemCount: items.length,
                    bottomPadding: bottomPadding,
                    height: 54,
                    barColor: backgroundColor,
                    inactiveColor: widget.secondaryColor,
                    color: primaryColor,
                    index: index,
                    iconSize: iconSize,
                    selectedIndex: selectedIndex.toInt(),
                    activeIcon: item.activeIcon ?? item.tabIcon,
                    tabIcon: item.tabIcon,
                    onClick: item._isValidItem ? () => _onTap(index) : null,
                  );
                }).toList(),
              );
            },
          ),
          Positioned(
            bottom: bottomPadding,
            child: AnimatedIndicator(
              tabWidth: MediaQuery.sizeOf(context).width,
              controller: widget.controller,
              itemCount: items.length,
            ),
            // child: _TabNavigationIndicator(
            //   itemCount: items.length,
            //   controller: _controller,
            //   selectedIndex: selectedIndex,
            //   previousIndex: _previousIndex,
            //   color: widget.indicatorColor ?? primaryColor,
            //   width: widget.indicatorWidth,
            //   height: widget.indicatorHeight,
            //   borderRadius: widget.indicatorCornerRadius,
            //   indicator: widget.indicator,
            // ),
          )
        ],
      ),
    );
  }
}

class AnimatedIndicator extends StatelessWidget {
  final double tabWidth;
  final int itemCount;
  final PageController controller;

  const AnimatedIndicator({
    super.key,
    required this.tabWidth,
    required this.itemCount,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final width = tabWidth / itemCount;
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final page = controller.page ?? 0.0;
        return Container(
          width: width,
          height: 2,
          margin: EdgeInsets.only(left: page * width),
          color: Colors.blue,
        );
      },
    );
  }
}
