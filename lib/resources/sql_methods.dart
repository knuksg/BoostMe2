import 'dart:typed_data';
import 'package:boostme2/models/post.dart';
import 'package:boostme2/models/workout.dart';
import 'package:boostme2/models/yoga.dart';
import 'package:boostme2/resources/storage_method.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:uuid/uuid.dart';

class SqlMethods {
  final Dio _dio = Dio();
  final String baseUrl = dotenv.env['API_URL']!;

  Future<String> uploadPost(String description, Uint8List file, String uid,
      String username, String profImage) async {
    // asking uid here because we dont want to make extra calls to firebase auth when we can just get from our state management
    String res = "Some error occurred";
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);
      String postId = const Uuid().v1(); // creates unique id based on time
      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        likes: [],
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
      );

      await createPost(post);

      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // // Add a new exercise
  Future<String> addExercise(
    String uid,
    String exerciseName,
    String exWeight,
    String exReps,
    String exSets,
    String exDate,
  ) async {
    String res = 'Some error occured';
    try {
      String exId = const Uuid().v1();
      Workout workout = Workout(
        uid: uid,
        exerciseName: exerciseName,
        exWeight: exWeight,
        exReps: exReps,
        exSets: exSets,
        exDate: exDate,
        exId: exId,
      );

      await createWorkout(workout);
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // // Add a new Yoga
  Future<String> saveYoga(
    String uid,
    String yDate,
    String yType,
    String yDuration,
    String yInstructor,
    String yNote,
  ) async {
    String res = 'Some error occured';
    try {
      String yogaId = const Uuid().v1();
      Yoga workout = Yoga(
        yogaDate: yDate,
        yogaType: yType,
        yogaDuration: yDuration,
        yogaInstructor: yInstructor,
        yogaNote: yNote,
        uid: uid,
        yId: yogaId,
      );
      print(workout.toJson());

      await createYoga(workout);
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Future<String> likePost(String postId, String uid, List likes) async {
  //   String res = "Some error occurred";
  //   try {
  //     if (likes.contains(uid)) {
  //       // if the likes list contains the user uid, we need to remove it
  //       _firestore.collection('posts').doc(postId).update({
  //         'likes': FieldValue.arrayRemove([uid])
  //       });
  //     } else {
  //       // else we need to add uid to the likes array
  //       _firestore.collection('posts').doc(postId).update({
  //         'likes': FieldValue.arrayUnion([uid])
  //       });
  //     }
  //     res = 'success';
  //   } catch (err) {
  //     res = err.toString();
  //   }
  //   return res;
  // }

  // // Post comment
  // Future<String> postComment(String postId, String text, String uid,
  //     String name, String profilePic) async {
  //   String res = "Some error occurred";
  //   try {
  //     if (text.isNotEmpty) {
  //       // if the likes list contains the user uid, we need to remove it
  //       String commentId = const Uuid().v1();
  //       _firestore
  //           .collection('posts')
  //           .doc(postId)
  //           .collection('comments')
  //           .doc(commentId)
  //           .set({
  //         'profilePic': profilePic,
  //         'name': name,
  //         'uid': uid,
  //         'text': text,
  //         'commentId': commentId,
  //         'datePublished': DateTime.now(),
  //       });
  //       res = 'success';
  //     } else {
  //       res = "Please enter text";
  //     }
  //   } catch (err) {
  //     res = err.toString();
  //   }
  //   return res;
  // }

  // // Delete Exercise
  // Future<String> deleteExercise(String exId) async {
  //   String res = "Some error occurred";
  //   try {
  //     await _firestore.collection('workout').doc(exId).delete();
  //     res = 'success';
  //   } catch (err) {
  //     res = err.toString();
  //   }
  //   return res;
  // }

  // // Delete Yoga Info
  // Future<String> deleteYogaInfo(String yId) async {
  //   String res = "Some error occurred";
  //   try {
  //     await _firestore.collection('yoga').doc(yId).delete();
  //     res = 'success';
  //   } catch (err) {
  //     res = err.toString();
  //   }
  //   return res;
  // }

  // Future<void> followUser(String uid, String followId) async {
  //   try {
  //     DocumentSnapshot snap =
  //         await _firestore.collection('users').doc(uid).get();
  //     List following = (snap.data()! as dynamic)['following'];

  //     if (following.contains(followId)) {
  //       await _firestore.collection('users').doc(followId).update({
  //         'followers': FieldValue.arrayRemove([uid])
  //       });

  //       await _firestore.collection('users').doc(uid).update({
  //         'following': FieldValue.arrayRemove([followId])
  //       });
  //     } else {
  //       await _firestore.collection('users').doc(followId).update({
  //         'followers': FieldValue.arrayUnion([uid])
  //       });

  //       await _firestore.collection('users').doc(uid).update({
  //         'following': FieldValue.arrayUnion([followId])
  //       });
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  static Future<List<Post>> fetchPosts() async {
    print('🔓 Fetching posts');
    final dio = Dio();
    const String baseUrl = "https://www.flyingstone.me/boostme/";
    try {
      final response = await dio.get('$baseUrl/api/posts');
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        print("data: $data");
        List<Post> posts =
            data.map((userJson) => Post.fromJson(userJson)).toList();
        print("posts: $posts");
        return posts;
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (e) {
      print("Error while fetching posts: $e");
      throw Exception('Failed to load posts: $e');
    }
  }

  Future<Post> fetchPostById(String id) async {
    try {
      final response = await _dio.get('$baseUrl/api/posts/$id');
      if (response.statusCode == 200) {
        return Post.fromJson(response.data);
      } else {
        throw Exception('Failed to load post');
      }
    } catch (e) {
      throw Exception('Failed to load post: $e');
    }
  }

  Future<void> createPost(Post post) async {
    try {
      final response = await _dio.post(
        '$baseUrl/api/posts',
        data: post.toJson(),
      );
      if (response.statusCode != 201) {
        throw Exception('Failed to create post');
      }
    } catch (e) {
      throw Exception('Failed to create post: $e');
    }
  }

  Future<void> updatePost(String id, Post post) async {
    try {
      final response = await _dio.put(
        '$baseUrl/api/posts/$id',
        data: post.toJson(),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to update post');
      }
    } catch (e) {
      throw Exception('Failed to update post: $e');
    }
  }

  Future<String> deletePost(String id) async {
    String res = "Some error occurred";
    try {
      final response = await _dio.delete('$baseUrl/api/posts/$id');
      if (response.statusCode != 200) {
        throw Exception('Failed to delete post');
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
      throw Exception('Failed to delete post: $err');
    }
    return res;
  }

  Future<List<Yoga>> fetchYogas() async {
    try {
      final response = await _dio.get('$baseUrl/api/yogas');
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        List<Yoga> yogas =
            data.map((userJson) => Yoga.fromJson(userJson)).toList();
        return yogas;
      } else {
        throw Exception('Failed to load yogas');
      }
    } catch (e) {
      throw Exception('Failed to load yogas: $e');
    }
  }

  Future<Yoga> fetchYogaById(String id) async {
    try {
      final response = await _dio.get('$baseUrl/api/yogas/$id');
      if (response.statusCode == 200) {
        return Yoga.fromJson(response.data);
      } else {
        throw Exception('Failed to load yoga');
      }
    } catch (e) {
      throw Exception('Failed to load yoga: $e');
    }
  }

  Future<void> createYoga(Yoga yoga) async {
    try {
      final response = await _dio.post(
        '$baseUrl/api/yogas',
        data: yoga.toJson(),
      );
      if (response.statusCode != 201) {
        throw Exception('Failed to create yoga');
      }
    } catch (e) {
      throw Exception('Failed to create yoga: $e');
    }
  }

  Future<void> updateYoga(String id, Yoga yoga) async {
    try {
      final response = await _dio.put(
        '$baseUrl/api/yogas/$id',
        data: yoga.toJson(),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to update yoga');
      }
    } catch (e) {
      throw Exception('Failed to update yoga: $e');
    }
  }

  Future<String> deleteYoga(String id) async {
    String res = "Some error occurred";
    try {
      final response = await _dio.delete('$baseUrl/api/yogas/$id');
      if (response.statusCode != 200) {
        throw Exception('Failed to delete yoga');
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
      throw Exception('Failed to delete yoga: $err');
    }
    return res;
  }

  Future<List<Workout>> fetchWorkouts() async {
    try {
      final response = await _dio.get('$baseUrl/api/workouts');
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        List<Workout> workouts =
            data.map((userJson) => Workout.fromJson(userJson)).toList();
        return workouts;
      } else {
        throw Exception('Failed to load workouts');
      }
    } catch (e) {
      throw Exception('Failed to load workouts: $e');
    }
  }

  Future<Workout> fetchWorkoutById(String id) async {
    try {
      final response = await _dio.get('$baseUrl/api/workouts/$id');
      if (response.statusCode == 200) {
        return Workout.fromJson(response.data);
      } else {
        throw Exception('Failed to load workout');
      }
    } catch (e) {
      throw Exception('Failed to load workout: $e');
    }
  }

  Future<void> createWorkout(Workout workout) async {
    try {
      final response = await _dio.post(
        '$baseUrl/api/workouts',
        data: workout.toJson(),
      );
      if (response.statusCode != 201) {
        throw Exception('Failed to create workout');
      }
    } catch (e) {
      throw Exception('Failed to create workout: $e');
    }
  }

  Future<void> updateWorkout(String id, Workout workout) async {
    try {
      final response = await _dio.put(
        '$baseUrl/api/workouts/$id',
        data: workout.toJson(),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to update workout');
      }
    } catch (e) {
      throw Exception('Failed to update workout: $e');
    }
  }

  Future<String> deleteWorkout(String id) async {
    String res = "Some error occurred";
    try {
      final response = await _dio.delete('$baseUrl/api/workouts/$id');
      if (response.statusCode != 200) {
        throw Exception('Failed to delete workout');
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
      throw Exception('Failed to delete workout: $err');
    }
    return res;
  }
}
