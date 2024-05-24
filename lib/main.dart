import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './core/app_color.dart';
import './views/screens/home_screen.dart';
import './core/app_theme.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: AppColor.background,
      systemNavigationBarColor: AppColor.background,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: AppTheme.lightAppTheme,
      home: const HomeScreen(),
    );
  }
}
