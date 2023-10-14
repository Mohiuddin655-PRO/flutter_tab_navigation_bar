part of '../tab_navigation_bar.dart';

class AnimatedIndicator extends StatelessWidget {
  final AnimationController animation;
  final PageController? controller;
  final int previousIndex;
  final int currentIndex;
  final double tabWidth;
  final Widget? indicator;
  final double indicatorWidth;
  final double indicatorHeight;
  final Color? indicatorColor;
  final double indicatorRadius;

  const AnimatedIndicator({
    super.key,
    required this.animation,
    required this.controller,
    required this.tabWidth,
    required this.currentIndex,
    required this.previousIndex,
    this.indicator,
    this.indicatorWidth = 6,
    this.indicatorHeight = 6,
    this.indicatorColor,
    this.indicatorRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    final mIndicator = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        indicator ??
            Container(
              width: indicatorWidth,
              height: indicatorHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(indicatorRadius),
                color: indicatorColor ?? Theme.of(context).colorScheme.primary,
              ),
            ),
      ],
    );
    if (controller != null) {
      return AnimatedBuilder(
        animation: controller!,
        builder: (context, child) {
          final page = controller!.page ?? currentIndex * animation.value;
          return Container(
            width: tabWidth,
            margin: EdgeInsets.only(left: page * tabWidth),
            child: mIndicator,
          );
        },
      );
    } else {
      return AnimatedBuilder(
        animation: animation,
        builder: (_, child) {
          return Transform.translate(
            offset: Tween(
              begin: Offset(previousIndex * tabWidth, 0),
              end: Offset(currentIndex * tabWidth, 0),
            ).animate(animation).value,
            child: child,
          );
        },
        child: SizedBox(
          width: tabWidth,
          child: mIndicator,
        ),
      );
    }
  }
}
