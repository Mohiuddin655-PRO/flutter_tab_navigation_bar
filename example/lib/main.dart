import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tab_navigation_bar/tab_navigation_bar.dart';

String _imageUrl =
    "https://images.unsplash.com/photo-1529665253569-6d01c0eaf7b6?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8cHJvZmlsZXxlbnwwfHwwfHx8MA%3D%3D&w=1000&q=80";

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
    if (index != 3) {
      setState(() {
        selectedIndex = index;
      });
    }
  }

  void _onProfileVisit(){
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          color: Colors.white,
          width: double.infinity,
          height: 300,
        );
      },
    );
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
          indicatorHeight: 8,
          padding: const EdgeInsets.only(bottom: 8, top: 0),
          tabHeight: 60,
          indicatorWidth: 8,
          onItemSelected: _onTabChanged,
          selectedIndex: selectedIndex,
          primaryColor: Colors.green,
          items: [
            TabNavigationItem(
              activeIcon: Icons.favorite,
              icon: Icons.favorite_outline,
              tabBackground: TabNavigationItemProperty(
                primary: Colors.green.withOpacity(0.1),
                secondary: Colors.green,
              ),
              tabCornerRadius: const TabNavigationItemProperty(primary: 25),
              tabIconColor: const TabNavigationItemProperty(
                primary: Colors.green,
                secondary: Colors.white,
              ),
            ),
            TabNavigationItem(
              activeIcon: Icons.feed,
              icon: Icons.feed_outlined,
              tabBackground: TabNavigationItemProperty(
                primary: Colors.green.withOpacity(0.1),
                secondary: Colors.green,
              ),
              tabCornerRadius: const TabNavigationItemProperty(primary: 25),
              tabIconColor: const TabNavigationItemProperty(
                primary: Colors.green,
                secondary: Colors.white,
              ),
            ),
            TabNavigationItem(
              activeIcon: Icons.bookmark_rounded,
              icon: Icons.bookmark_border_rounded,
              tabBackground: TabNavigationItemProperty(
                primary: Colors.green.withOpacity(0.1),
                secondary: Colors.green,
              ),
              tabCornerRadius: const TabNavigationItemProperty(primary: 25),
              tabIconColor: const TabNavigationItemProperty(
                primary: Colors.green,
                secondary: Colors.white,
              ),
            ),
            TabNavigationItem(
              listener: false,
              tabBuilder: (con, isSelected) {
                return GestureDetector(
                  onTap: _onProfileVisit,
                  child: Container(
                    width: 40,
                    height: 40,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        border: Border.all(
                            width: 2.5,
                            color: isSelected ? Colors.green : Colors.transparent,
                            strokeAlign: BorderSide.strokeAlignOutside),
                        borderRadius: BorderRadius.circular(32)),
                    child: Image.network(
                      _imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
