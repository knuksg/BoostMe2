import 'package:boostme2/models/post.dart';
import 'package:boostme2/resources/auth_methods.dart';
import 'package:boostme2/resources/sql_methods.dart';
import 'package:boostme2/utils/colors.dart';
import 'package:boostme2/utils/global_variables.dart';
import 'package:boostme2/utils/utils.dart';
import 'package:boostme2/widgets/post_card.dart';

import 'package:flutter/material.dart';
import 'package:boostme2/models/user.dart' as model;

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({super.key, required this.uid});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late model.User user;
  int postLen = 0;
  bool isLoading = false;
  List<Post>? posts; // Adding a state variable to hold posts

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      user = await AuthMethods.fetchUserById(widget.uid);
      posts =
          await SqlMethods.fetchPostsByUid(widget.uid); // Fetch and store posts
      postLen = posts?.length ?? 0;
    } catch (e) {
      showSnackBar(context, e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text(user.username),
              centerTitle: false,
            ),
            body: ListView(
              children: [
                profileInfo(),
                const Divider(),
                buildPostsList(width), // Refactor out posts list building
              ],
            ),
          );
  }

  Widget profileInfo() => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            userAvatarRow(),
            userInfoText(user.username, FontWeight.bold),
            userInfoText(user.bio, FontWeight.normal),
          ],
        ),
      );

  Widget userAvatarRow() => Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey,
            backgroundImage: NetworkImage(user.photoUrl),
            radius: 40,
          ),
          Expanded(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [buildStatColumn(postLen, "posts")],
                ),
              ],
            ),
          ),
        ],
      );

  Widget userInfoText(String text, FontWeight weight) => Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(top: 15),
        child: Text(text, style: TextStyle(fontWeight: weight)),
      );

  Widget buildPostsList(double width) => posts == null || posts!.isEmpty
      ? const Center(child: Text('No posts found'))
      : ListView.builder(
          shrinkWrap: true, // Important to prevent nested scrolling issues
          physics:
              const NeverScrollableScrollPhysics(), // Disables scrolling for nested ListView
          itemCount: posts!.length,
          itemBuilder: (ctx, index) => Container(
            margin: EdgeInsets.symmetric(
              horizontal: width > webScreenSize ? width * 0.3 : 0,
              vertical: width > webScreenSize ? 15 : 0,
            ),
            child: PostCard(post: posts![index]),
          ),
        );
}

Column buildStatColumn(int num, String label) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        num.toString(),
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      Container(
        margin: const EdgeInsets.only(top: 4),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
        ),
      ),
    ],
  );
}
