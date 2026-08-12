import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';

import 'app/scanly_app.dart';
import 'features/auth/repository/firebase_auth_repository.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    runApp(
      ScanlyApp(
        authRepository: FirebaseAuthRepository(
          firebaseAuth: FirebaseAuth.instance,
        ),
      ),
    );
  } on Object catch (error) {
    runApp(FirebaseSetupApp(error: error));
  }
}
