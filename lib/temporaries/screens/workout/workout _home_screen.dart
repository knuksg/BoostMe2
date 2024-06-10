import 'package:boostme2/temporaries/models/workout.dart';
import 'package:boostme2/temporaries/resources/sql_methods.dart';
import 'package:boostme2/temporaries/screens/workout/workout_add_screen.dart';
import 'package:boostme2/temporaries/widgets/workout_list.dart';
import 'package:flutter/material.dart';

class WorkoutHome extends StatelessWidget {
  const WorkoutHome({super.key});

  void navigateToWorkouts() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const WorkoutAddScreen()));
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
        child: FutureBuilder<List<Workout>>(
          future: SqlMethods().fetchWorkouts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Failed to load workouts: ${snapshot.error}'),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text('No workouts found'),
              );
            }

            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) => WorkoutList(
                workout: snapshot.data![index],
              ),
            );
          },
        ),
      ),
    );
  }
}
