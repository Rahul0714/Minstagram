import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:minstagram/providers/user_provider.dart';
import 'package:minstagram/resources/firestore_methods.dart';
import 'package:minstagram/utils/colors.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../utils/utils.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  final TextEditingController _descController = TextEditingController();

  bool _isLoading = false;
  void postImage(
    String uid,
    String username,
    String profilePicture,
  ) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await FireStoreMethods().uploadPost(
          _descController.text, username, _file!, profilePicture, uid);
      if (res == "Success!") {
        setState(() {
          _isLoading = false;
        });
        showSnackbar(context, "Posted");
        clearImg();
      } else {
        setState(() {
          _isLoading = false;
        });
        showSnackbar(context, res);
        clearImg();
      }
    } catch (err) {
      showSnackbar(context, err.toString());
    }
  }

  void clearImg() {
    setState(() {
      _file = null;
    });
  }

  _selectImg(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text("Create a Post"),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text("Take a photo"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await imgPicker(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text("Choose from Gallery"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await imgPicker(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text("Cancel "),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).getUser;
    return _file == null
        ? Center(
            child: IconButton(
              icon: const Icon(Icons.upload),
              onPressed: () => _selectImg(context),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                onPressed: clearImg,
                icon: const Icon(Icons.arrow_back),
              ),
              title: const Text('Post to'),
              actions: [
                TextButton(
                  onPressed: () =>
                      postImage(user.uid, user.username, user.photoUrl),
                  child: const Text(
                    'Post',
                    style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                )
              ],
            ),
            body: Column(children: [
              _isLoading
                  ? const LinearProgressIndicator()
                  : const Padding(
                      padding: EdgeInsets.all(0),
                    ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(user.photoUrl),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.47,
                    child: TextField(
                      controller: _descController,
                      decoration: const InputDecoration(
                          hintText: 'Write  a caption...',
                          border: InputBorder.none),
                      maxLines: 7,
                    ),
                  ),
                  SizedBox(
                    height: 45,
                    width: 45,
                    child: AspectRatio(
                      aspectRatio: 487 / 451,
                      child: Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          image: MemoryImage(_file!),
                          fit: BoxFit.fill,
                          alignment: FractionalOffset.topCenter,
                        )),
                      ),
                    ),
                  ),
                  const Divider(),
                ],
              )
            ]),
          );
  }
}
