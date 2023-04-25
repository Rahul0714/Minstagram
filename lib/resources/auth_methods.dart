import 'dart:typed_data';
import '../models/user.dart' as model;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:minstagram/resources/storage_methods.dart';

class Authentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();
    return model.User.fromSnap(snap);
  }

  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "Some Error Occurred!";
    try {
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          username.isNotEmpty &&
          bio.isNotEmpty &&
          file != null) {
        UserCredential userCredential = await _auth
            .createUserWithEmailAndPassword(email: email, password: password);
        print(userCredential.user!.uid);

        String photoUrl = await StorageMethods()
            .uploadImgToStorage('profilePictures', file, false);

        model.User user = model.User(
          username: username,
          uid: userCredential.user!.uid,
          email: email,
          bio: bio,
          followers: [],
          following: [],
          photoUrl: photoUrl,
        );

        await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(user.toJson());
        res = "Success!";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> LoginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some Error Occurred";
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      res = "Success!";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
