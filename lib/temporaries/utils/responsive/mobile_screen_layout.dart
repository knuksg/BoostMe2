import 'package:boostme2/temporaries/screens/features/bmi_calculator.dart';
import 'package:boostme2/temporaries/screens/features/calory_tracker.dart';
import 'package:boostme2/temporaries/screens/features/reminder.dart';
import 'package:boostme2/temporaries/utils/colors.dart';
import 'package:boostme2/temporaries/utils/global_variables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({super.key});

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page = 0;
  late PageController pageController; // for tabs animation

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page) {
    //Animating Page
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: false,
        title: Image.asset(
          'assets/images/logo2.png',
          color: Colors.blueAccent,
          height: 40,
        ),
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                backgroundColor: mobileBackgroundColor.withOpacity(0.8),
                shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30))),
                context: context,
                builder: (BuildContext context) {
                  return SizedBox(
                    height: 780,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 350),
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.close_rounded,
                              size: 25,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 30),
                          child: Column(
                            children: [
                              Card(
                                child: InkWell(
                                  onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => BMICal(
                                        uid: FirebaseAuth
                                            .instance.currentUser!.uid,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 200.0,
                                        height: 100.0,
                                        child: Image.asset(
                                          'assets/images/bmi.png',
                                          height: 70,
                                          scale: 6,
                                        ),
                                      ),
                                      const Text('Check your BMI')
                                    ],
                                  ),
                                ),
                              ),
                              Card(
                                child: InkWell(
                                  onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const CalorieTracker(),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 200.0,
                                        height: 100.0,
                                        child: Image.asset(
                                          'assets/images/calorie.png',
                                          height: 70,
                                          scale: 6,
                                        ),
                                      ),
                                      const Text('Check your Calorie')
                                    ],
                                  ),
                                ),
                              ),
                              Card(
                                child: InkWell(
                                  onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => ReminderScreen(),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 200.0,
                                        height: 100.0,
                                        child: Image.asset(
                                          'assets/images/reminder.png',
                                          height: 70,
                                          scale: 6,
                                        ),
                                      ),
                                      const Text('Remind Me')
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            icon: const Icon(
              Icons.menu,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        children: homeScreenItems,
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: mobileBackgroundColor,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: (_page == 0) ? primaryColor : secondaryColor,
            ),
            label: '',
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                color: (_page == 1) ? primaryColor : secondaryColor,
              ),
              label: '',
              backgroundColor: primaryColor),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.add_circle,
                color: (_page == 2) ? primaryColor : secondaryColor,
              ),
              label: '',
              backgroundColor: primaryColor),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.fitness_center,
              color: (_page == 3) ? primaryColor : secondaryColor,
            ),
            label: '',
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.face_2,
              color: (_page == 4) ? primaryColor : secondaryColor,
            ),
            label: '',
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: (_page == 5) ? primaryColor : secondaryColor,
            ),
            label: '',
            backgroundColor: primaryColor,
          ),
        ],
        onTap: navigationTapped,
        currentIndex: _page,
      ),
    );
  }
}
