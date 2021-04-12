import 'package:flutter/material.dart';
import 'package:flutter_code_challenge/providers/auth.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome!'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Hello!'),
            // Watch logging-in state and display appropriate widget.
            context.watch<Auth>().isBusy
                ? CircularProgressIndicator()
                : ElevatedButton(
                    child: Text('LOGIN'),
                    onPressed: context.read<Auth>().loginAction,
                  ),
          ],
        ),
      ),
    );
  }
}
