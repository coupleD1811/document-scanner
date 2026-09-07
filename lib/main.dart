import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';

import 'app/scanly_app.dart';
import 'features/auth/repository/firebase_auth_repository.dart';
import 'features/documents/repository/local_document_repository.dart';
import 'features/documents/service/database/document_database.dart';
import 'features/documents/service/document_export_service.dart';
import 'features/documents/service/document_storage_service.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    final documentRepository = LocalDocumentRepository(
      dataSource: DocumentDatabase(),
      storage: DocumentStorageService(),
      exporter: const LocalDocumentExportService(),
    );

    runApp(
      ScanlyApp(
        authRepository: FirebaseAuthRepository(
          firebaseAuth: FirebaseAuth.instance,
        ),
        documentRepository: documentRepository,
      ),
    );
  } on Object catch (error) {
    runApp(FirebaseSetupApp(error: error));
  }
}
