import 'package:flutter/material.dart';

class ResponsiveScaffold extends StatelessWidget {
  final String appBarTitle;
  final Widget body;
  final List<Destination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const ResponsiveScaffold({
    super.key,
    required this.appBarTitle,
    required this.body,
    required this.destinations,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
      ),
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: destinations.map((destination) {
          return BottomNavigationBarItem(
            icon: Icon(destination.icon),
            label: destination.title,
          );
        }).toList(),
        currentIndex: selectedIndex,
        onTap: onItemTapped,
      ),
    );
  }
}

class Destination {
  final String title;
  final IconData icon;
  final Widget widget;

  const Destination({
    required this.title,
    required this.icon,
    required this.widget,
  });
}
