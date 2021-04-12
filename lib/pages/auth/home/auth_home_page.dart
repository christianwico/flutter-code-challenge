import 'package:flutter/material.dart';
import 'package:flutter_code_challenge/providers/auth.dart';
import 'package:provider/provider.dart';

class AuthHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Name: ${context.read<Auth>().name}'),
            Text('GitHub URL: ${context.read<Auth>().githubPageUrl}'),
            ElevatedButton(
              onPressed: () {},
              child: Text('Get Coordinates'),
            ),
          ],
        ),
      ),
    );
  }
}
