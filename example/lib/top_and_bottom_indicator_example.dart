import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tab_navigation_bar/tab_navigation_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        canvasColor: const Color.fromARGB(255, 232, 232, 232),
      ),
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Color navigationBarColor = Colors.white;
  int selectedIndex = 0;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(
      initialPage: selectedIndex,
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void _onTabChanged(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: navigationBarColor,
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
                Icons.bookmark,
                size: 56,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        bottomNavigationBar: TabNavigationBar(
          backgroundColor: Colors.white,
          controller: pageController,
          indicatorMode: IndicatorMode.back,
          indicatorWidth: 1,
          indicatorHeight: 60,
          indicatorPosition: const IndicatorPosition.center(),
          onItemSelected: _onTabChanged,
          selectedIndex: selectedIndex,

          /// Customize indicator as you like
          indicator: SizedBox(
            width: 8,
            height: double.infinity,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,
                    ),
                  ),
                ),
                const Spacer(flex: 3),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          primaryColor: Colors.green,
          items: const [
            TabNavigationItem(
              activeIcon: Icons.home,
              icon: Icons.home_outlined,
            ),
            TabNavigationItem(
              activeIcon: Icons.feed,
              icon: Icons.feed_outlined,
            ),
            TabNavigationItem(
              activeIcon: Icons.bookmark_rounded,
              icon: Icons.bookmark_border_rounded,
            ),
            TabNavigationItem(
              activeIcon: Icons.notifications,
              icon: Icons.notifications_outlined,
            ),
          ],
        ),
      ),
    );
  }
}
