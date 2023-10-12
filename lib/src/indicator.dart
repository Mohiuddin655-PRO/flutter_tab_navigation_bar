part of '../tab_navigation_bar.dart';

class AnimatedIndicator extends StatelessWidget {
  final PageController controller;
  final double tabWidth;
  final double? tabHeight;
  final Widget? indicator;
  final double indicatorWidth;
  final double indicatorHeight;
  final Color? indicatorColor;
  final double indicatorRadius;

  const AnimatedIndicator({
    super.key,
    required this.controller,
    required this.tabWidth,
    this.tabHeight,
    this.indicator,
    this.indicatorWidth = 6,
    this.indicatorHeight = 6,
    this.indicatorColor,
    this.indicatorRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final page = controller.page ?? 0.0;
        return Container(
          width: tabWidth,
          height: tabHeight,
          margin: EdgeInsets.only(left: page * tabWidth),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              indicator ??
                  Container(
                    width: indicatorWidth,
                    height: indicatorHeight,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(indicatorRadius),
                      color: indicatorColor ??
                          Theme.of(context).colorScheme.primary,
                    ),
                  ),
            ],
          ),
        );
      },
    );
  }
}
