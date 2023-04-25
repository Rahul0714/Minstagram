import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:minstagram/resources/auth_methods.dart';
import 'package:minstagram/screens/login_screen.dart';
import 'package:minstagram/utils/colors.dart';
import 'package:minstagram/widget/text_field.dart';

import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/web_screen_layout.dart';
import '../utils/utils.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _img;
  bool _isLoading = false;
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  void selectImage() async {
    Uint8List _im = await imgPicker(ImageSource.gallery);
    setState(() {
      _img = _im;
    });
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await Authentication().signUpUser(
      email: _emailController.text,
      password: _passwordController.text,
      username: _usernameController.text,
      bio: _bioController.text,
      file: _img!,
    );
    setState(() {
      _isLoading = false;
    });
    if (res != "Success!") {
      showSnackbar(context, res);
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
              webScreenLayout: WebScreenLayout(),
              mobileScreenLayout: MobileScreenLayout()),
        ),
      );
    }
  }

  void moveToLogin() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              flex: 2,
              child: Container(),
            ),
            SafeArea(
                child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              width: double.infinity,
              child: Column(
                children: [
                  SvgPicture.asset(
                    'assets/ic_instagram.svg',
                    color: primaryColor,
                    height: MediaQuery.of(context).size.height * 0.09,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  Stack(
                    children: [
                      _img != null
                          ? CircleAvatar(
                              backgroundImage: MemoryImage(_img!),
                              radius: 64,
                            )
                          : const CircleAvatar(
                              backgroundImage: NetworkImage(
                                  'https://i.imgflip.com/6yvpkj.jpg'),
                              radius: 64,
                            ),
                      Positioned(
                        bottom: -10,
                        left: 80,
                        child: IconButton(
                          onPressed: selectImage,
                          icon: const Icon(Icons.add_a_photo),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  CustomTextField(
                    hintText: "Enter Username",
                    controller: _usernameController,
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  CustomTextField(
                    hintText: "Enter Email",
                    controller: _emailController,
                    obscureText: false,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  CustomTextField(
                    hintText: "Enter Password",
                    controller: _passwordController,
                    obscureText: true,
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  CustomTextField(
                    hintText: "Enter Bio",
                    controller: _bioController,
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  InkWell(
                    onTap: signUpUser,
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: const ShapeDecoration(
                        color: blueColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(4),
                          ),
                        ),
                      ),
                      child: _isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: primaryColor,
                              ),
                            )
                          : const Text("Sign Up"),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  // Flexible(
                  //   child: Container(),
                  // ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: const Text("Already have an Account?"),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: GestureDetector(
                          onTap: moveToLogin,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: const Text(
                              "Log in",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ))
          ]),
    );
  }
}
