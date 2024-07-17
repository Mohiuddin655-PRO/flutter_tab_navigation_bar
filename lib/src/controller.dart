part of '../tab_navigation_bar.dart';

class TabNavigationController extends PageController {
  TabNavigationController({
    super.initialPage = 0,
    super.keepPage = true,
    super.viewportFraction = 1.0,
    super.onAttach,
    super.onDetach,
  });

  // EXTERNAL
  late List<TabNavigationItem> _items;
  late ValueChanged<int>? _onItemSelected;
  late int _selectedIndex;

  // INTERNAL
  late Duration _animationDuration;
  late VoidCallback _notifier;

  // INNER
  int _previousIndex = 0;

  void _init({
    required List<TabNavigationItem> items,
    required ValueChanged<int>? onChanged,
    required int selectedIndex,
    required AnimationController animation,
    required Duration animationDuration,
    required VoidCallback notifier,
  }) {
    _items = items;
    _onItemSelected = onChanged;
    _selectedIndex = selectedIndex;
    _animationDuration = animationDuration;
    _notifier = notifier;
    addListener(_pageListener);
  }

  @override
  void dispose() {
    removeListener(_pageListener);
    super.dispose();
  }

  void _pageListener() {
    final int index = page?.round() ?? _selectedIndex;
    if (_items[index].inkWell) {
      if (_selectedIndex != index) {
        _onItemSelected?.call(index);
        _selectedIndex = index;
        _notifier();
      }
    }
  }

  void changeIndex(int index) {
    if (_selectedIndex != index) {
      _onItemSelected?.call(index);
      _previousIndex = _selectedIndex;
      _selectedIndex = index;
      animateToPage(
        index,
        duration: _animationDuration,
        curve: Curves.easeInOut,
      );
      _notifier();
    }
  }
}
