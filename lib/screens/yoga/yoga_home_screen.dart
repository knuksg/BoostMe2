import 'package:boostme2/models/yoga.dart';
import 'package:boostme2/resources/sql_methods.dart';
import 'package:boostme2/screens/yoga/yoga_add_screen.dart';
import 'package:boostme2/widgets/yoga_list.dart';
import 'package:flutter/material.dart';

class YogaHomeScreen extends StatelessWidget {
  const YogaHomeScreen({super.key});

  void navigateToWorkouts() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const YogaAddScreen()));
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(
          Icons.add,
          size: 30.0,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: FutureBuilder<List<Yoga>>(
          future: SqlMethods().fetchYogas(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Failed to load yogas: ${snapshot.error}'),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text('No yogas found'),
              );
            }

            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) => YogaList(
                yogaSnap: snapshot.data![index],
              ),
            );
          },
        ),
      ),
    );
  }
}
