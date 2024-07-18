part of '../tab_navigation_bar.dart';

class TabNavigationBar extends StatefulWidget {
  final TabNavigationController? controller;
  final PageController? pageController;
  final bool autoDisposeMode;
  final Color? primaryColor;
  final Color? rippleColor;
  final Color? pressedColor;
  final double? width;
  final double height;
  final Color backgroundColor;
  final ValueChanged<int>? onChanged;
  final int initialIndex;
  final List<TabNavigationItem> items;
  final double? bottomPadding;
  final Duration animationDuration;
  final Widget? indicator;
  final double indicatorWidth;
  final double indicatorHeight;
  final Color? indicatorColor;
  final double indicatorRadius;
  final IndicatorMode indicatorMode;
  final IndicatorPosition indicatorPosition;

  /// Tab properties
  final TabNavigationItemProperty<double>? tabCornerRadius;
  final TabNavigationItemProperty<Color>? tabBackground;

  const TabNavigationBar({
    super.key,
    this.pageController,
    this.autoDisposeMode = false,
    this.width,
    this.height = 54,
    this.primaryColor,
    this.pressedColor,
    this.rippleColor,
    required this.items,
    this.initialIndex = 0,
    this.onChanged,
    this.bottomPadding,
    this.backgroundColor = Colors.white,
    this.animationDuration = const Duration(milliseconds: 500),
    this.indicator,
    this.indicatorWidth = 24,
    this.indicatorHeight = 2.5,
    this.indicatorColor,
    this.indicatorRadius = 8,
    this.indicatorPosition = const IndicatorPosition.centerToFloat(),
    this.indicatorMode = IndicatorMode.back,
    this.controller,
    this.tabCornerRadius,
    this.tabBackground,
  });

  @override
  State<TabNavigationBar> createState() => _TabNavigationBarState();
}

class _TabNavigationBarState extends State<TabNavigationBar>
    with TickerProviderStateMixin {
  late TabNavigationController controller;

  @override
  void initState() {
    super.initState();
    controller = (widget.controller ?? TabNavigationController())
      .._init(
        pageController: widget.pageController,
        animation: widget.pageController != null
            ? null
            : AnimationController(
                vsync: this,
                duration: widget.animationDuration,
              ),
        items: widget.items,
        onChanged: widget.onChanged,
        selectedIndex: widget.initialIndex,
        animationDuration: widget.animationDuration,
        notifier: () => setState(() {}),
      );
  }

  @override
  void dispose() {
    if (widget.autoDisposeMode) controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary =
        widget.primaryColor ?? Theme.of(context).colorScheme.primary;

    final mIC = widget.indicatorColor ?? primary;

    final backgroundColor = widget.backgroundColor;
    final mIP = widget.indicatorPosition;
    final mHeight = widget.height;
    return LayoutBuilder(
      builder: (context, size) {
        var width = size.maxWidth / controller._items.length;
        final mIndicator = Positioned(
          top: 0,
          bottom: 0,
          child: Container(
            margin: mIP._current(mHeight, widget.indicatorHeight),
            child: AnimatedIndicator(
              controller: controller._pageController,
              animation: controller._animation,
              currentIndex: controller._selectedIndex,
              previousIndex: controller._previousIndex,
              indicator: widget.indicator,
              indicatorColor: widget.indicatorColor ?? mIC,
              indicatorWidth: widget.indicatorWidth,
              indicatorHeight: widget.indicatorHeight,
              indicatorRadius: widget.indicatorRadius,
              tabWidth: width,
            ),
          ),
        );
        return Container(
          width: widget.width,
          height: mHeight,
          color: backgroundColor,
          child: Stack(
            children: <Widget>[
              if (widget.indicatorMode.isBack) mIndicator,
              SizedBox(
                width: double.infinity,
                height: mHeight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: List.generate(
                    widget.items.length,
                    (index) {
                      final item = widget.items[index];
                      return _TabNavigationButton(
                        item: item,
                        tabBackground: widget.tabBackground,
                        tabCornerRadius: widget.tabCornerRadius,
                        rippleColor:
                            widget.rippleColor ?? primary.withOpacity(0.1),
                        pressedColor:
                            widget.pressedColor ?? primary.withOpacity(0.1),
                        isSelected: controller._selectedIndex == index,
                        controller: controller,
                        width: width,
                        onClick: () => controller.changeIndex(index),
                      );
                    },
                  ),
                ),
              ),
              if (widget.indicatorMode.isFront) mIndicator,
            ],
          ),
        );
      },
    );
  }
}

enum IndicatorMode {
  front,
  back;

  bool get isFront => this == IndicatorMode.front;

  bool get isBack => this == IndicatorMode.back;
}

class IndicatorPosition {
  final double _value;
  final _IPSType _type;

  const IndicatorPosition._(this._value, this._type);

  const IndicatorPosition.ceil([double value = 0])
      : this._(value, _IPSType.ceil);

  const IndicatorPosition.center() : this._(0, _IPSType.center);

  const IndicatorPosition.centerToCeil([double value = 16])
      : this._(value, _IPSType.centerToCeil);

  const IndicatorPosition.centerToFloat([double value = 16])
      : this._(value, _IPSType.centerToFloat);

  const IndicatorPosition.float([double value = 0])
      : this._(value, _IPSType.float);

  double get value => _value * 2;

  bool get isTop => _type == _IPSType.centerToCeil;

  bool get isBottom => _type == _IPSType.centerToFloat;

  bool get isCeil => _type == _IPSType.ceil;

  bool get isMiddle => _type == _IPSType.centerToFloat;

  bool get isFloat => _type == _IPSType.float;

  EdgeInsets _current(double height, indicatorHeight) {
    final space = height - (indicatorHeight + value);
    final ceil = isCeil && space > 0 ? space : null;
    final float = isFloat && space > 0 ? space : null;
    final asCeiling = isBottom && value > 0 ? value : 0.0;
    final asFloating = isTop && value > 0 ? value : 0.0;
    return EdgeInsets.only(
      top: float ?? asCeiling,
      bottom: ceil ?? asFloating,
    );
  }
}

enum _IPSType {
  center,
  ceil,
  float,
  centerToCeil,
  centerToFloat,
}
