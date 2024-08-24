import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:market_page/page/market_main_widget.dart';
import 'package:market_page/provider/market_provider.dart';
import 'package:market_page/provider/tab_changed_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: MyCustomScrollBehavior(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => MarketProvider()),
          ChangeNotifierProvider(create: (_) => TabChangedProvider()),
        ],
        child: const MarketMainPage(),
      ),
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        // etc.
      };
}
