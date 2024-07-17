import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tab_navigation_bar/tab_navigation_bar.dart';

String _imageUrl =
    "https://images.unsplash.com/photo-1529665253569-6d01c0eaf7b6?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8cHJvZmlsZXxlbnwwfHwwfHx8MA%3D%3D&w=1000&q=80";

class AvatarIndicatorExample extends StatefulWidget {
  const AvatarIndicatorExample({Key? key}) : super(key: key);

  @override
  State<AvatarIndicatorExample> createState() => _AvatarIndicatorExampleState();
}

class _AvatarIndicatorExampleState extends State<AvatarIndicatorExample> {
  final Color navigationBarColor = Colors.white;
  late TabNavigationController pageController;

  @override
  void initState() {
    super.initState();
    pageController = TabNavigationController(
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void _onTabChanged(int index) {
    print(index);
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
                Icons.notifications,
                size: 56,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        bottomNavigationBar: TabNavigationBar(
          backgroundColor: Colors.white,
          controller: pageController,
          indicatorPosition: const IndicatorPosition.center(),
          indicatorMode: IndicatorMode.front,
          indicator: Container(
            width: 35,
            height: 35,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              shape: BoxShape.circle,
            ),
            child: Image.network(
              _imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          onChanged: _onTabChanged,
          initialIndex: 0,
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
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  width: selected ? 40 : 32,
                  height: selected ? 40 : 32,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    border: Border.all(
                      width: 2.5,
                      color: selected ? Colors.green : Colors.transparent,
                      strokeAlign: BorderSide.strokeAlignOutside,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(2.5),
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
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
