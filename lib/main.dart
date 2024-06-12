import 'package:clocklify/activity_model.dart';
import 'package:clocklify/splash_screen.dart';
import 'package:clocklify/timer_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  // runApp(const MyApp());
  runApp(
  MultiProvider(
      providers: [
        ChangeNotifierProvider<TimerModel>(create: (_) {
          return TimerModel();
        }),
        ChangeNotifierProvider<ActivityProvider>(create: (_) {
          return ActivityProvider();
        }),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // final String token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImJhZGFrQGdtYWlsLmNvbSIsInVzZXJJZCI6MTcsInVzZXIiOnsiaWQiOjE3LCJlbWFpbCI6ImJhZGFrQGdtYWlsLmNvbSIsInBhc3N3b3JkIjoiYXNkMTIzIn0sImlhdCI6MTcxMTUyNzAzOCwiZXhwIjoxNzExNTQ1MDM4fQ.gY8WoxD4Bhke7NsnX-HMtH7grEH0T7cxjZl3EuBRkEc';
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // initialRoute: '/splash_screen',
      // routes: {
      //   '/splash_screen': (context) => SplashScreen(),
      // },
      home: SplashScreen(),
      // home: HomePage(token: token,),
    );
  }
}