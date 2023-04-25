import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:minstagram/models/user.dart';
import 'package:minstagram/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

import '../models/posts.dart';

class FireStoreMethods {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<String> uploadPost(String description, String username, Uint8List file,
      String profImg, String uid) async {
    String res = "Some Error Occurred";
    try {
      String photoUrl =
          await StorageMethods().uploadImgToStorage('posts', file, true);
      String postId = const Uuid().v1();
      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImg: profImg,
        likes: [],
      );
      _firebaseFirestore.collection('posts').doc(postId).set(post.toJson());
      res = "Success!";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firebaseFirestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        await _firebaseFirestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (err) {
      print(err.toString());
    }
  }

  Future<String> postComment(String postId, String text, String uid,
      String name, String ProfilePic) async {
    String res = "Some Error Occurred!";
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        _firebaseFirestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'ProfilePic': ProfilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': 'commentId',
          'datePublished': DateTime.now(),
        });
        res = "Success";
      } else {
        res = "Empty";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> deletePost(String postId) async {
    try {
      await _firebaseFirestore.collection('posts').doc(postId).delete();
    } catch (err) {
      print(err.toString());
    }
  }
}
