import 'package:db_sqlite/data/local/db_helper.dart';
import 'package:db_sqlite/db_provider.dart';
import 'package:db_sqlite/home_page.dart';
import 'package:db_sqlite/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => DBProvider(dbHelper: DBHelper.getInstance),
      ),
      ChangeNotifierProvider(create: (context) => ThemeProvider())
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // DBHelper db = DBHelper.getInstance();

    return MaterialApp(
      title: 'Flutter Demo',
      themeMode: context.watch<ThemeProvider>().getThemeValue()
          ? ThemeMode.dark
          : ThemeMode.light,
      darkTheme: ThemeData.dark(),
      theme: ThemeData(
        // This is the theme of your application.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
