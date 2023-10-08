part of '../tab_navigation_bar.dart';

class _TabNavigationIndicator extends StatelessWidget {
  final AnimationController controller;
  final double width;
  final double height;
  final double borderRadius;
  final int selectedIndex;
  final int previousIndex;
  final Color color;
  final int itemCount;
  final Widget? indicator;

  const _TabNavigationIndicator({
    Key? key,
    required this.controller,
    required this.selectedIndex,
    required this.previousIndex,
    required this.color,
    required this.itemCount,
    required this.width,
    required this.height,
    required this.borderRadius,
    this.indicator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double maxElementWidth = deviceWidth / itemCount;
    final mIndicator = indicator ??
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        );
    return AnimatedBuilder(
      animation: controller,
      builder: (_, child) {
        return Transform.translate(
          offset: Tween<Offset>(
                  begin: Offset(previousIndex * maxElementWidth, 0),
                  end: Offset(selectedIndex * maxElementWidth, 0))
              .animate(CurvedAnimation(
                parent: controller,
                curve: const Interval(0.0, 0.35),
              ))
              .value,
          child: child,
        );
      },
      child: SizedBox(
        width: maxElementWidth,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [mIndicator],
        ),
      ),
    );
  }
}
