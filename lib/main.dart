import 'package:flutter/material.dart';
import 'package:flutter_code_challenge/pages/home/home_page.dart';
import 'package:flutter_code_challenge/providers/auth.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => Auth(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Code Challenge',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: context.watch<Auth>().isLoggedIn ? AppTabs() : HomePage(),
    );
  }
}

class AppTabs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: 'Weather',
            icon: Icon(Icons.wb_sunny),
          ),
        ],
      ),
    );
  }
}
