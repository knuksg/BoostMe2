import 'package:boostme2/presentation/viewmodels/auth_viewmodel.dart';
import 'package:boostme2/presentation/views/profile_screen.dart';
import 'package:boostme2/presentation/views/responsive_scaffold.dart';
import 'package:boostme2/presentation/views/shopping_screen.dart';
import 'package:boostme2/presentation/views/weight_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'animated_dog_with_chat.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Destination> _destinations = [
    const Destination(
        title: 'Home', icon: Icons.home, widget: HomeTestScreen()),
    const Destination(
        title: 'Profile', icon: Icons.person, widget: ProfileScreen()),
    const Destination(
        title: 'Weight', icon: Icons.fitness_center, widget: WeightScreen()),
    const Destination(
        title: 'BMI', icon: Icons.monitor_weight, widget: BMICal()),
    const Destination(
        title: 'Calorie Tracker',
        icon: Icons.fastfood,
        widget: CaloryTrackerScreen()),
    const Destination(
        title: 'Reminder', icon: Icons.alarm, widget: ReminderScreen()),
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
      // if (_selectedIndex == 7) {
      //   await FirebaseAuth.instance.signOut();
      // }
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

class HomeTestScreen extends StatelessWidget {
  const HomeTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildPost(
            context,
            'assets/images/user1.jpg',
            'User 1',
            'Daily gym',
            'assets/images/gym.jpg',
            '4 likes',
            'View all 1 comments',
            'Apr 3, 2023',
          ),
          const SizedBox(height: 20),
          _buildPost(
            context,
            'assets/images/user2.jpg',
            'User 2',
            'Morning run',
            'assets/images/run.jpg',
            '8 likes',
            'View all 3 comments',
            'Apr 2, 2023',
          ),
          // Add more posts here...
        ],
      ),
    );
  }

  Widget _buildPost(
    BuildContext context,
    String userImage,
    String userName,
    String postTitle,
    String postImage,
    String likes,
    String comments,
    String date,
  ) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(userImage),
              ),
              title: Text(userName,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(date),
              trailing: IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {
                  // Handle more options
                },
              ),
            ),
            const SizedBox(height: 8),
            Text(postTitle,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Image.asset(postImage),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.favorite_border),
                      onPressed: () {
                        // Handle like press
                      },
                    ),
                    Text(likes),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chat_bubble_outline),
                      onPressed: () {
                        // Handle comment press
                      },
                    ),
                    Text(comments),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.bookmark_border),
                  onPressed: () {
                    // Handle save press
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BMICal extends StatefulWidget {
  const BMICal({
    super.key,
  });

  @override
  State<BMICal> createState() => _BMICalState();
}

class _BMICalState extends State<BMICal> {
  double _height = 170.0;
  double _weight = 70.0;
  double _bmi = 0.0;
  String _condition = "Select Data";

  void _calculateBMI() {
    setState(() {
      _bmi = _weight / ((_height / 100) * (_height / 100));
      if (_bmi < 18.5) {
        _condition = "Underweight";
      } else if (_bmi < 24.9) {
        _condition = "Normal";
      } else if (_bmi < 29.9) {
        _condition = "Overweight";
      } else {
        _condition = "Obese";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BMI Calculator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundImage: AssetImage(
                      'assets/images/user1.jpg'), // 여기에 실제 이미지를 넣어주세요.
                  radius: 30,
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'BMI Value: ',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      _bmi.toStringAsFixed(1),
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text('Condition: $_condition'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),
            const Text(
              'Choose Data',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Height: ${_height.toStringAsFixed(1)} cm'),
                Text('Weight: ${_weight.toStringAsFixed(1)} kg'),
              ],
            ),
            Slider(
              value: _height,
              min: 100,
              max: 220,
              divisions: 120,
              label: _height.toStringAsFixed(1),
              onChanged: (double value) {
                setState(() {
                  _height = value;
                });
              },
            ),
            Slider(
              value: _weight,
              min: 30,
              max: 150,
              divisions: 120,
              label: _weight.toStringAsFixed(1),
              onChanged: (double value) {
                setState(() {
                  _weight = value;
                });
              },
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _calculateBMI,
              child: const Text('Calculate'),
            ),
          ],
        ),
      ),
    );
  }
}

class CaloryTrackerScreen extends StatelessWidget {
  const CaloryTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calorie Tracker'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: _buildFoodList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  List<Widget> _buildFoodList() {
    final List<Map<String, String>> foods = [
      {
        'name': 'Apple',
        'calories': '52 cal',
        'image': 'assets/images/apple.png'
      },
      {
        'name': 'Banana',
        'calories': '89 cal',
        'image': 'assets/images/banana.png'
      },
      {
        'name': 'Burger',
        'calories': '295 cal',
        'image': 'assets/images/burger.png'
      },
      {
        'name': 'Cheese',
        'calories': '402 cal',
        'image': 'assets/images/cheese.png'
      },
      {
        'name': 'Chocolate',
        'calories': '546 cal',
        'image': 'assets/images/chocolate.png'
      },
      {
        'name': 'Coffee',
        'calories': '2 cal',
        'image': 'assets/images/coffee.png'
      },
      {
        'name': 'Eggs',
        'calories': '155 cal',
        'image': 'assets/images/eggs.png'
      },
      {
        'name': 'Fries',
        'calories': '312 cal',
        'image': 'assets/images/fries.png'
      },
      {
        'name': 'Pizza',
        'calories': '266 cal',
        'image': 'assets/images/pizza.png'
      },
      {
        'name': 'Soda',
        'calories': '140 cal',
        'image': 'assets/images/soda.png'
      },
      {
        'name': 'Steak',
        'calories': '271 cal',
        'image': 'assets/images/steak.png'
      },
      {
        'name': 'Water',
        'calories': '0 cal',
        'image': 'assets/images/water.png'
      },
    ];

    return foods.map((food) {
      return Card(
        child: ListTile(
          leading: Image.asset(food['image']!,
              width: 50, height: 50, fit: BoxFit.cover),
          title: Text(food['name']!),
          subtitle: Text(food['calories']!),
          trailing: const Icon(Icons.check_box_outline_blank),
        ),
      );
    }).toList();
  }
}

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  _ReminderScreenState createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  DateTime? _selectedDateTime;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (time != null) {
        setState(() {
          _selectedDateTime = DateTime(
              picked.year, picked.month, picked.day, time.hour, time.minute);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminder App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _textEditingController,
              decoration: const InputDecoration(
                hintText: 'Enter reminder text',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _selectDateTime(context),
              child: Text(_selectedDateTime == null
                  ? 'Select Date and Time'
                  : 'Change Date and Time'),
            ),
            const SizedBox(height: 20),
            if (_selectedDateTime != null) ...[
              Text(
                'Selected Date and Time: ${_selectedDateTime!.toLocal()}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Set Reminder'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
