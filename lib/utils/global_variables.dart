import 'package:flutter/material.dart';
import 'package:minstagram/screens/add_post_screen.dart';

import '../screens/feed_screen.dart';
import '../screens/search_screen.dart';

const webScreenSize = 600;

const homeScreenItems = [
  FeedScreen(),
  SearchScreen(),
  AddPostScreen(),
  Center(child: Text("4")),
  Center(child: Text("5")),
];
