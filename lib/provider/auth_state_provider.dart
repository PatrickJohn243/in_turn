import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:inturn/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthStateProvider extends ChangeNotifier {
  User? user;
  AuthChangeEvent? lastEvent;

  AuthStateProvider() {
    supabase.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      lastEvent = event;

      switch (event) {
        case AuthChangeEvent.signedIn:
          user = supabase.auth.currentUser;
          log("Signed In");

          break;
        case AuthChangeEvent.signedOut:
          user = null;
          log("Signed Out");
          break;
        case AuthChangeEvent.initialSession:
          log("User already signed in");
          user = supabase.auth.currentUser;
          break;
        default:
          break;
      }
      notifyListeners(); // Triggers rebuild
    });
  }
}
