import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';   // <-- new import
import 'app.dart';

Future<void> main() async {
  // -------------------------------------------------------------
  // 1️⃣ Ensure Flutter bindings are ready (required for Hive)
  // -------------------------------------------------------------
  WidgetsFlutterBinding.ensureInitialized();

  // -------------------------------------------------------------
  // 2️⃣ Initialise Hive (stores data in the app’s documents dir)
  // -------------------------------------------------------------
  await Hive.initFlutter();

  // -------------------------------------------------------------
  // 3️⃣ Open the box that GraphQLCache will use.
  //    The default name used by GraphQLCache is "graphqlCache".
  // -------------------------------------------------------------
  //await Hive.openBox('graphqlCache');

  // -------------------------------------------------------------
  // 4️⃣ Now we can safely start the UI.
  // -------------------------------------------------------------
  runApp(const EcoChefApp());
}