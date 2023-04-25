import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:minstagram/resources/firestore_methods.dart';
import 'package:minstagram/utils/colors.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';
import '../widget/comment_card.dart';

class CommentScreen extends StatefulWidget {
  final snap;
  const CommentScreen({super.key, required this.snap});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  TextEditingController _controller = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text("Comments"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.snap['postId'])
            .collection('comments')
            .orderBy('datePublished', descending: true)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          print((snapshot.data!).docs.length);
          return ListView.builder(
            itemCount: (snapshot.data!).docs.length,
            itemBuilder: (context, index) => CommentCard(
              snap: (snapshot.data!).docs[index].data(),
            ),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Row(children: [
            CircleAvatar(
              backgroundImage: NetworkImage(user.photoUrl),
              radius: 18,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 8.0),
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: "Comment as ${user.username}",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                await FireStoreMethods().postComment(widget.snap['postId'],
                    _controller.text, user.uid, user.username, user.photoUrl);
                setState(() {
                  _controller.text = "";
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: const Text(
                  "Post",
                  style: TextStyle(color: blueColor),
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
