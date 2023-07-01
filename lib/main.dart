import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:minstagram/providers/user_provider.dart';
import 'package:minstagram/responsive/mobile_screen_layout.dart';
import 'package:minstagram/responsive/responsive_layout_screen.dart';
import 'package:minstagram/responsive/web_screen_layout.dart';
import 'package:minstagram/screens/signup_screen.dart';
import 'package:minstagram/utils/colors.dart';
import 'package:provider/provider.dart';

import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "API_KEY",
            authDomain: "AUTH_DOMAIN",
            projectId: "PROJECT_ID",
            storageBucket: "STORAGE_BUCKET",
            messagingSenderId: "SENDER_ID",
            appId: "APP_ID"));
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark()
            .copyWith(scaffoldBackgroundColor: mobileBackgroundColor),
        title: 'Minstagram',
        // home: const ResponsiveLayout(
        //     webScreenLayout: WebScreenLayout(),
        //     mobileScreenLayout: MobileScreenLayout()),
        home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),          
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  return const ResponsiveLayout(
                      webScreenLayout: WebScreenLayout(),
                      mobileScreenLayout: MobileScreenLayout());
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text('Some Error Occurred'),
                  );
                }
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                );
              }
              return const LoginScreen();
            }),
      ),
    );
  }
}
