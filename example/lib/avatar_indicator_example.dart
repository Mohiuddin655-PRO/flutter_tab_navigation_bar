import 'package:example/bottom_indicator_example.dart';
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

class _AvatarIndicatorExampleState extends State<AvatarIndicatorExample>
    with SingleTickerProviderStateMixin {
  final Color navigationBarColor = Colors.white;
  late TabNavigationController controller;
  final index = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    controller = TabNavigationController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _onTabChanged(int index) {
    print(index);
    this.index.value = index;
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: navigationBarColor,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: ValueListenableBuilder(
            valueListenable: index,
            builder: (context, value, child) {
              return IndexedStack(
                index: value,
                // physics: NeverScrollableScrollPhysics(),
                // controller: pageController,
                children: <Widget>[
                  BottomIndicatorExample(),
                  // Container(
                  //   alignment: Alignment.center,
                  //   child: const Icon(
                  //     Icons.favorite,
                  //     size: 56,
                  //     color: Colors.grey,
                  //   ),
                  // ),
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
              );
            }),
        bottomNavigationBar: TabNavigationBar(
          backgroundColor: Colors.white,
          controller: controller,
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
          tabCornerRadius: TabNavigationItemProperty.all(100),
          tabBackground: TabNavigationItemProperty(
            selected: Colors.green,
            unselected: Colors.green.shade50,
          ),
          items: [
            TabNavigationItem(
              builder: (context, selected) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    selected ? Icons.home : Icons.home_outlined,
                  ),
                );
              },
            ),
            TabNavigationItem(
              builder: (context, selected) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    selected ? Icons.feed : Icons.feed_outlined,
                  ),
                );
              },
            ),
            TabNavigationItem(
              builder: (context, selected) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    selected ? Icons.bookmark : Icons.bookmark_outline,
                  ),
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
                      strokeAlign: BorderSide.strokeAlignInside,
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
