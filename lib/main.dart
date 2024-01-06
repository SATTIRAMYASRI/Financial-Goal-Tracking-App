import 'dart:io';

import 'package:flutter/material.dart';
import 'package:goalbudgettracker/widgets/goals.dart';
import 'package:firebase_core/firebase_core.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Goals(),
      debugShowCheckedModeBanner: false,
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    Platform.isAndroid
        ? await Firebase.initializeApp(
            options: const FirebaseOptions(
                apiKey: 'AIzaSyBGlEQbTdjiZ5dW5Alwk80pL1DAvNPCdck',
                appId: '1:1001163686238:android:0f7ae0ccdb605038f84fcf',
                messagingSenderId: '1001163686238',
                projectId: 'budgettracker-35122'))
        : await Firebase.initializeApp();
    runApp(MyApp());
  } catch (e) {
    print('Firebase initialization error: $e');
  }
}
