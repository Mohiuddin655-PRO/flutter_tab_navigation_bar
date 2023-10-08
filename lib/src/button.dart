part of '../tab_navigation_bar.dart';

class _TabNavigationButton extends StatelessWidget {
  final VoidCallback onPressed;
  final AnimationController controller;
  final IconData selectedIcon;
  final IconData unselectedIcon;
  final int selectedIndex;
  final int index;
  final Color color;
  final double iconSize;
  final Color inactiveColor;
  final Color barColor;
  final double bottomPadding;
  final double barHeight;

  const _TabNavigationButton({
    super.key,
    required this.onPressed,
    required this.controller,
    required this.selectedIcon,
    required this.unselectedIcon,
    required this.index,
    required this.selectedIndex,
    required this.color,
    required this.iconSize,
    required this.inactiveColor,
    required this.barColor,
    required this.bottomPadding,
    required this.barHeight,
  });

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final double deviceWidth = mediaQueryData.size.width;
    final double maxElementWidth = deviceWidth / 4;
    final isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: maxElementWidth,
        height: barHeight,
        color: barColor,
        child: Icon(
          isSelected ? selectedIcon : unselectedIcon,
          size: iconSize,
          color: isSelected ? color : Colors.grey,
        ),
      ),
    );
  }
}
