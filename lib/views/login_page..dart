import 'package:flutter/material.dart';
import 'package:inturn/main.dart';
import 'package:inturn/services/google_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

String? _userId;

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    supabase.auth.onAuthStateChange.listen((data) {
      setState(() {
        _userId = data.session?.user.id;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: Column(
        children: [
          Text(_userId ?? 'Not Signed In'),
          ElevatedButton(
              onPressed: () async {
                googleAuthLogin();
              },
              child: const Text("Sign In With Google")),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
              onPressed: () async {
                googleAuthLogout();
              },
              child: const Text('Logout'))
        ],
      ),
    );
  }
}
