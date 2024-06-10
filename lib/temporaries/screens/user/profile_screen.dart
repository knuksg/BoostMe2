import 'package:boostme2/temporaries/models/post.dart';
import 'package:boostme2/temporaries/resources/auth_methods.dart';
import 'package:boostme2/temporaries/resources/sql_methods.dart';
import 'package:boostme2/temporaries/utils/colors.dart';
import 'package:boostme2/temporaries/utils/global_variables.dart';
import 'package:boostme2/temporaries/utils/utils.dart';
import 'package:boostme2/temporaries/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:boostme2/temporaries/models/user.dart' as model;

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({super.key, required this.uid});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late model.User user;
  bool isLoading = false;
  List<Post> posts = []; // State variable to hold posts
  bool _isLoadingMore = false;
  bool _hasMore = true;
  int _page = 1;
  final int _limit = 10;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    getData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !_isLoadingMore &&
          _hasMore) {
        _fetchMorePosts();
      }
    });
  }

  Future<void> getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      user = await AuthMethods.fetchUserById(widget.uid);
      await _fetchMorePosts();
    } catch (e) {
      showSnackBar(context, e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchMorePosts() async {
    if (_isLoadingMore) return;
    setState(() {
      _isLoadingMore = true;
    });

    try {
      Map<String, dynamic> result =
          await SqlMethods.fetchPostsByUid(widget.uid, _page, _limit);
      List<Post> fetchedPosts = result['posts'];
      int total = result['total'];

      setState(() {
        _page++;
        posts.addAll(fetchedPosts);
        _hasMore = posts.length < total;
      });
    } catch (e) {
      print('Error fetching posts: $e');
    } finally {
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
              controller: _scrollController,
              children: [
                profileInfo(),
                const Divider(),
                buildPostsList(width),
                if (_isLoadingMore)
                  const Center(child: CircularProgressIndicator()),
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
                  children: [buildStatColumn(posts.length, "posts")],
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

  Widget buildPostsList(double width) => posts.isEmpty
      ? const Center(child: Text('No posts found'))
      : ListView.builder(
          shrinkWrap: true, // Important to prevent nested scrolling issues
          physics:
              const NeverScrollableScrollPhysics(), // Disables scrolling for nested ListView
          itemCount: posts.length,
          itemBuilder: (ctx, index) => Container(
            margin: EdgeInsets.symmetric(
              horizontal: width > webScreenSize ? width * 0.3 : 0,
              vertical: width > webScreenSize ? 15 : 0,
            ),
            child: PostCard(post: posts[index]),
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
