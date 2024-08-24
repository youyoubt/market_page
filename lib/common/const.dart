import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// white style
SystemUiOverlayStyle systemUiWhiteStyle = const SystemUiOverlayStyle(
  statusBarColor: Colors.transparent,
  statusBarIconBrightness: Brightness.dark,
  systemNavigationBarColor: Colors.white,
);

/// tab style
TextStyle tabStyle = const TextStyle(
  fontSize: 14,
  color: Color(0XFF333333),
  fontWeight: FontWeight.w400,
);

/// tab selected style
TextStyle tabSelectedStyle = const TextStyle(
  fontSize: 14,
  color: Colors.blueAccent,
  fontWeight: FontWeight.w400,
);

/// list title bg color
Color listTitleBgColor = const Color(0x22B1B1B1);

/// list title bg sort color
Color listTitleHighLightBgColor = Colors.blueAccent;

/// list title text style
TextStyle listTitleStyle = const TextStyle(
  fontSize: 14,
  color: Color(0XFF616161),
  fontWeight: FontWeight.bold,
);

/// list title text sort style
TextStyle listTitleHighStyle = const TextStyle(
  fontSize: 14,
  color: Colors.white,
  fontWeight: FontWeight.bold,
);

/// list item text style
TextStyle listItemStyle = const TextStyle(
  fontSize: 14,
  color: Color(0XFF333333),
  fontWeight: FontWeight.w400,
);

Widget buildVerLine() {
  return Container(
    width: 1,
    height: 30,
    color: const Color(0xFFE7E7E7),
  );
}

Widget buildHorLine() {
  return const SizedBox(
    height: 1,
    child: Divider(thickness: 1, color: Color(0xFFE7E7E7)),
  );
}
