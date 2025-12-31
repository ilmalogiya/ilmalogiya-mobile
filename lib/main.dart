import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ilmalogiya/utils/init_firebase.dart';
import 'app/app.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([.portraitUp, .portraitDown]);

  await initFirebase();

  runApp(const App());
}
