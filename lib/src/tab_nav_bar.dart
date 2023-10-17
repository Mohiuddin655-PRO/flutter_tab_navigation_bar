part of '../tab_navigation_bar.dart';

typedef OnButtonPressCallback = void Function(int index);

class TabNavigationBar extends StatefulWidget {
  final PageController? controller;
  final Color? primaryColor;
  final Color? activeColor;
  final Color? inactiveColor;
  final double? width;
  final double height;
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
  final IndicatorMode indicatorMode;
  final IndicatorPosition indicatorPosition;

  /// Tab properties
  final TabNavigationItemProperty<double>? tabCornerRadius;
  final TabNavigationItemProperty<Color>? tabBackground;
  final TabNavigationItemProperty<Color>? tabIconColor;
  final TabNavigationItemProperty<double>? tabIconSize;

  const TabNavigationBar({
    super.key,
    this.width,
    this.height = 54,
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
    this.indicatorWidth = 24,
    this.indicatorHeight = 2.5,
    this.indicatorColor,
    this.indicatorRadius = 8,
    this.indicatorPosition = const IndicatorPosition.centerToFloat(),
    this.indicatorMode = IndicatorMode.back,
    this.controller,
    this.tabCornerRadius,
    this.tabBackground,
    this.tabIconColor,
    this.tabIconSize,
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

    final mHeight = widget.height;
    return WidgetWrapper(
      wrap: (context, size) {
        var width = size.width / items.length;
        final mIndicator = Positioned(
          top: 0,
          bottom: 0,
          child: Container(
            margin: mIP._current(mHeight, widget.indicatorHeight),
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
                        tabBackground: widget.tabBackground ??
                            const TabNavigationItemProperty(
                                primary: Colors.transparent),
                        tabCornerRadius: widget.tabCornerRadius ??
                            const TabNavigationItemProperty(primary: 25),
                        tabIconColor: widget.tabIconColor ??
                            TabNavigationItemProperty(
                                primary: mIIC, secondary: mAIC),
                        tabIconSize: widget.tabIconSize ??
                            const TabNavigationItemProperty(primary: 24),
                        rippleColor: primary.withOpacity(0.1),
                        pressedColor: primary.withOpacity(0.1),
                        isSelected: selectedIndex == index,
                        controller: _animation,
                        width: width,
                        onClick: () => _onTap(index),
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
