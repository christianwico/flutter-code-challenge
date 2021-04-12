import 'package:flutter/material.dart';
import 'package:flutter_code_challenge/pages/auth/home/auth_home_page.dart';
import 'package:flutter_code_challenge/pages/auth/weather/weather_page.dart';
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

class AppTabs extends StatefulWidget {
  final List<Widget> pages = [
    AuthHomePage(),
    WeatherPage(),
  ];

  @override
  _AppTabsState createState() => _AppTabsState();
}

class _AppTabsState extends State<AppTabs> {
  int currentIndex = 0;

  void itemTapped(int index) {
    setState(() => currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
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
        onTap: itemTapped,
      ),
      body: widget.pages[currentIndex],
    );
  }
}
