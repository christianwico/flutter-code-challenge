import 'package:flutter/material.dart';
import 'package:flutter_code_challenge/pages/app_tabs.dart';
import 'package:flutter_code_challenge/pages/auth/home/auth_home_page.dart';
import 'package:flutter_code_challenge/pages/auth/weather/weather_page.dart';
import 'package:flutter_code_challenge/pages/home/home_page.dart';
import 'package:flutter_code_challenge/providers/auth.dart';
import 'package:flutter_code_challenge/providers/location.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    // Register our providers from the top-level.
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
        ChangeNotifierProvider(
          create: (_) => Location(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.read<Auth>().init();

    return MaterialApp(
      title: 'Flutter Code Challenge',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Switch between page sets here. If logged-in, display AppTabs...
      // Otherwise, display HomePage.
      home: context.watch<Auth>().isLoggedIn ? AppTabs() : HomePage(),
    );
  }
}
