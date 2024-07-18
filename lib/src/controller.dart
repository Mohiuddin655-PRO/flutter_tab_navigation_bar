part of '../tab_navigation_bar.dart';

class TabNavigationController {
  PageController? _pageController;

  TabNavigationController();

  // EXTERNAL
  late List<TabNavigationItem> _items;
  late ValueChanged<int>? _onChanged;
  late int _selectedIndex;

  // INTERNAL
  late AnimationController? _animation;
  late Duration _animationDuration;
  late VoidCallback _notifier;
  late Curve? _pageAnimation;

  // INNER
  int _previousIndex = 0;

  int get index => _selectedIndex;

  void _init({
    required PageController? pageController,
    required List<TabNavigationItem> items,
    required ValueChanged<int>? onChanged,
    required int selectedIndex,
    required AnimationController? animation,
    required Duration animationDuration,
    required Curve? pageAnimation,
    required VoidCallback notifier,
  }) {
    _pageAnimation = pageAnimation;
    _pageController = pageController;
    _animation = animation?..forward(from: 0.0);
    _items = items;
    _onChanged = onChanged;
    _selectedIndex = selectedIndex;
    _animationDuration = animationDuration;
    _notifier = notifier;
    _addListeners();
  }

  void dispose() {
    _removeListeners();
    _animation?.dispose();
  }

  void _addListeners() {
    _pageController?.addListener(_pageListener);
  }

  void _removeListeners() {
    _pageController?.removeListener(_pageListener);
  }

  bool isClicked = false;

  void _pageListener() {
    final index = _pageController?.page?.round() ?? _selectedIndex;
    if (_selectedIndex != index) {
      _previousIndex = _selectedIndex;
      _selectedIndex = index;
      _notifier();
      _onChanged?.call(index);
    }
  }

  void changeIndex(int index) {
    if (_pageController != null) {
      if (_pageAnimation != null) {
        _pageController?.animateToPage(
          index,
          duration: _animationDuration,
          curve: _pageAnimation!,
        );
      } else {
        _pageController?.jumpToPage(index);
      }
    } else if (_selectedIndex != index) {
      _previousIndex = _selectedIndex;
      _selectedIndex = index;
      _animation?.forward(from: 0.0);
      _notifier();
      _onChanged?.call(index);
    }
  }
}
