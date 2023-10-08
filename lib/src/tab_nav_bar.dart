part of '../tab_navigation_bar.dart';

typedef OnButtonPressCallback = void Function(int index);

class TabNavigationBar extends StatefulWidget {
  final Color backgroundColor;
  final OnButtonPressCallback onItemSelected;
  final int selectedIndex;
  final List<TabNavigationItem> barItems;
  final Color waterDropColor;
  final Color inactiveIconColor;
  final double iconSize;
  final double? bottomPadding;

  const TabNavigationBar({
    required this.barItems,
    required this.selectedIndex,
    required this.onItemSelected,
    this.bottomPadding,
    this.backgroundColor = Colors.white,
    this.waterDropColor = const Color(0xFF5B75F0),
    this.iconSize = 28,
    Color? inactiveIconColor,
    Key? key,
  })  : inactiveIconColor = inactiveIconColor ?? waterDropColor,
        super(key: key);

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
      duration: const Duration(milliseconds: 800),
    )..forward(from: 0.0);
  }

  void _onTap(int index) {
    final int selectedIndex = widget.selectedIndex;

    if (selectedIndex == index || _controller.isAnimating) {
      return;
    } else {
      widget.onItemSelected(index);
      _controller.forward(from: 0.0);
      _previousIndex = widget.selectedIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    final int selectedIndex = widget.selectedIndex;
    final Color backgroundColor = widget.backgroundColor;
    final Color dropColor = widget.waterDropColor;
    final List<TabNavigationItem> items = widget.barItems;
    final double iconSize = widget.iconSize;
    final Color inactiveIconColor = widget.inactiveIconColor;
    final double bottomPadding =
        widget.bottomPadding ?? MediaQuery.of(context).padding.bottom;
    final double barHeight = 60 + bottomPadding;
    return Container(
      height: barHeight,
      color: backgroundColor,
      child: Stack(
        children: <Widget>[
          AnimatedBuilder(
            animation: _controller,
            builder: (_, __) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: items.map((item) {
                  final int index = items.indexOf(item);
                  return _TabNavigationButton(
                    bottomPadding: bottomPadding,
                    barHeight: barHeight,
                    barColor: backgroundColor,
                    inactiveColor: inactiveIconColor,
                    color: dropColor,
                    index: index,
                    iconSize: iconSize,
                    selectedIndex: selectedIndex.toInt(),
                    controller: _controller,
                    selectedIcon: item.activeIcon ?? item.icon,
                    unselectedIcon: item.icon,
                    onPressed: () => _onTap(index),
                  );
                }).toList(),
              );
            },
          ),
          Positioned(
            bottom: 0,
            child: _TabNavigationIndicator(
              itemCount: items.length,
              controller: _controller,
              selectedIndex: selectedIndex,
              previousIndex: _previousIndex,
              color: dropColor,
              width: 32,
              height: 4,
              borderRadius: 50,
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
