part of '../tab_navigation_bar.dart';

class AnimatedIndicator extends StatelessWidget {
  final PageController controller;
  final double width;
  final double height;
  final Color? color;
  final double radius;
  final TabNavigationIndicatorType type;

  const AnimatedIndicator({
    super.key,
    required this.controller,
    required this.width,
    this.height = 2,
    this.color,
    this.type = TabNavigationIndicatorType.dot,
    this.radius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final page = controller.page ?? 0.0;
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            shape: type.isDot ? BoxShape.circle : BoxShape.rectangle,
            borderRadius: !type.isDot ? BorderRadius.circular(radius) : null,
            color: color ?? Theme.of(context).colorScheme.primary,
          ),
          margin: EdgeInsets.only(left: page * width),
        );
      },
    );
  }
}

enum TabNavigationIndicatorType {
  dot,
  full,
  short;

  bool get isDot => this == TabNavigationIndicatorType.dot;

  bool get isFull => this == TabNavigationIndicatorType.full;

  bool get isShort => this == TabNavigationIndicatorType.short;
}

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
