import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'utils/init_firebase.dart';
import 'app/app.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([.portraitUp, .portraitDown]);

  initFirebase();

  runApp(const App());
}
