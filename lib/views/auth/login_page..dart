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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(_userId ?? 'Not Signed In'),
            ElevatedButton(
                onPressed: () async {
                  await googleAuthLogin();
                  Navigator.pushReplacementNamed(context, '/dashboard');
                  // Navigator.pushReplacementNamed(context, '/role_selection');
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
      ),
    );
  }
}
