import 'package:boostme2/resources/auth_methods.dart';
import 'package:boostme2/resources/sql_methods.dart';
import 'package:boostme2/screens/user/login_screen.dart';
import 'package:boostme2/utils/colors.dart';
import 'package:boostme2/utils/utils.dart';
import 'package:boostme2/widgets/follow_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      var post = await SqlMethods.fetchPosts();
      postLen = post.length;

      setState(() {});
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text(
                user.username,
              ),
              centerTitle: false,
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey,
                            backgroundImage: NetworkImage(
                              user.photoUrl,
                            ),
                            radius: 40,
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    buildStatColumn(postLen, "posts"),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(
                          top: 15,
                        ),
                        child: Text(
                          user.username,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(
                          top: 1,
                        ),
                        child: Text(
                          user.bio,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                // FutureBuilder(
                //   future: FirebaseFirestore.instance
                //       .collection('posts')
                //       .where('uid', isEqualTo: widget.uid)
                //       .get(),
                //   builder: (context, snapshot) {
                //     if (snapshot.connectionState == ConnectionState.waiting) {
                //       return const Center(
                //         child: CircularProgressIndicator(),
                //       );
                //     }

                //     return GridView.builder(
                //       shrinkWrap: true,
                //       itemCount: (snapshot.data! as dynamic).docs.length,
                //       gridDelegate:
                //           const SliverGridDelegateWithFixedCrossAxisCount(
                //         crossAxisCount: 3,
                //         crossAxisSpacing: 5,
                //         mainAxisSpacing: 1.5,
                //         childAspectRatio: 1,
                //       ),
                //       itemBuilder: (context, index) {
                //         DocumentSnapshot snap =
                //             (snapshot.data! as dynamic).docs[index];

                //         return Container(
                //           child: Image(
                //             image: NetworkImage(snap['postUrl']),
                //             fit: BoxFit.cover,
                //           ),
                //         );
                //       },
                //     );
                //   },
                // )
              ],
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
}
