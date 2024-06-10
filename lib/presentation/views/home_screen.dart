import 'package:boostme2/presentation/views/profile_screen.dart';
import 'package:boostme2/presentation/views/responsive_scaffold.dart';
import 'package:boostme2/presentation/views/shopping_screen.dart';
import 'package:boostme2/presentation/views/weight_screen.dart';
import 'package:flutter/material.dart';
import 'animated_dog_with_chat.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Destination> _destinations = [
    const Destination(title: 'Home', icon: Icons.home, widget: ProfileScreen()),
    const Destination(
        title: 'Profile', icon: Icons.person, widget: ProfileScreen()),
    const Destination(
        title: 'Weight', icon: Icons.fitness_center, widget: WeightScreen()),
    const Destination(
        title: 'Shopping', icon: Icons.shopping_cart, widget: ShoppingScreen()),
    const Destination(
        title: 'Settings',
        icon: Icons.settings,
        widget: Center(child: Text('Settings Screen'))),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ResponsiveScaffold(
            appBarTitle: _destinations[_selectedIndex].title,
            body: _destinations[_selectedIndex].widget,
            destinations: _destinations,
            onItemTapped: _onItemTapped,
            selectedIndex: _selectedIndex,
          ),
          const AnimatedDogWithChat(),
        ],
      ),
    );
  }
}
