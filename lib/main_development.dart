// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vzn/app/app.dart';
import 'package:vzn/bootstrap.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: 'assets/.env');

  await Supabase.initialize(
    url: dotenv.get('SUPABASE_URL'),
    anonKey: dotenv.get('SUPABASE_ANON_KEY'),
    authCallbackUrlHostname: 'login-callback', // optional
    debug: true, // optional
  );
  await bootstrap(() async {
    // Future<void> getInitialAuthState() async {

    //TODO use this on Supabase 1.0
    // try {
    //   final initialSession = await SupabaseAuth.instance.initialSession;
    //   // Redirect users to different screens depending on the initial session
    // } catch (e) {
    //   // Handle initial auth state fetch error here
    // }
    // }

    final email = 'pulford+randy@gmail.com';
    final password = 'randyrandy';

    // Future<void> signIn(String email, String password) async {
    final response = await Supabase.instance.client.auth
        .signIn(email: email, password: password);
    print(response.toString());
    // if (response.error != null) {
    //   /// Handle error
    // } else {
    //   /// Sign in with success
    // }
    // }

    return App();
  });
}
