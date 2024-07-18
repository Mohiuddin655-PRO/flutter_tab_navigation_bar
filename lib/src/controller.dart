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
    required VoidCallback notifier,
  }) {
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

  void _pageListener() {
    final index = _pageController?.page?.round() ?? _selectedIndex;
    if (_items[index].inkWell && _selectedIndex != index) {
      _selectedIndex = index;
      _notifier();
      if (_pageController == null) _animation?.forward(from: 0.0);
      _onChanged?.call(index);
    }
  }

  void changeIndex(int index) {
    if (_selectedIndex != index) {
      _onChanged?.call(index);
      if (_pageController == null) _animation?.forward(from: 0.0);
      _previousIndex = _selectedIndex;
      _selectedIndex = index;
      _pageController?.animateToPage(
        index,
        duration: _animationDuration,
        curve: Curves.easeInOut,
      );
      _notifier();
    }
  }
}
