import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tab_navigation_bar/tab_navigation_bar.dart';

class BottomIndicatorExample extends StatefulWidget {
  const BottomIndicatorExample({Key? key}) : super(key: key);

  @override
  State<BottomIndicatorExample> createState() => _BottomIndicatorExampleState();
}

class _BottomIndicatorExampleState extends State<BottomIndicatorExample> {
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: PageView(
          controller: pageController,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              child: const Icon(
                Icons.favorite,
                size: 56,
                color: Colors.grey,
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: const Icon(
                Icons.feed,
                size: 56,
                color: Colors.grey,
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: const Icon(
                Icons.bookmark,
                size: 56,
                color: Colors.grey,
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: const Icon(
                Icons.notifications,
                size: 56,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        bottomNavigationBar: TabNavigationBar(
          backgroundColor: Colors.white,
          pageController: pageController,
          indicatorMode: IndicatorMode.back,
          indicatorPosition: const IndicatorPosition.centerToFloat(24),
          indicatorWidth: 8,
          indicatorHeight: 8,
          primaryColor: Colors.green,
          items: [
            TabNavigationItem(
              builder: (context, selected) {
                return Icon(
                  selected ? Icons.home : Icons.home_outlined,
                );
              },
            ),
            TabNavigationItem(
              builder: (context, selected) {
                return Icon(
                  selected ? Icons.feed : Icons.feed_outlined,
                );
              },
            ),
            TabNavigationItem(
              builder: (context, selected) {
                return Icon(
                  selected ? Icons.bookmark : Icons.bookmark_outline,
                );
              },
            ),
            TabNavigationItem(
              builder: (context, selected) {
                return Icon(
                  selected ? Icons.notifications : Icons.notifications_outlined,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
