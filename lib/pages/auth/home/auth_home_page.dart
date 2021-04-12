import 'package:flutter/material.dart';
import 'package:flutter_code_challenge/providers/auth.dart';
import 'package:flutter_code_challenge/providers/location.dart';
import 'package:provider/provider.dart';

class AuthHomePage extends StatefulWidget {
  @override
  _AuthHomePageState createState() => _AuthHomePageState();
}

class _AuthHomePageState extends State<AuthHomePage> {
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
            context.watch<Location>().isBusy
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: context.read<Location>().getPosition,
                    child: Text('Get Coordinates'),
                  ),
            Text(context.watch<Location>().coordinates?.toString() ?? ''),
          ],
        ),
      ),
    );
  }
}
