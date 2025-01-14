import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future<void> showToast({
  required String message,
  required double fontSize,
  ToastGravity gravity = ToastGravity.CENTER,
  Color color = Colors.black,
  double opacity = 0.8,
}) async {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: gravity,
    timeInSecForIosWeb: 20,
    backgroundColor: color.withOpacity(opacity),
    textColor: Colors.white,
    fontSize: fontSize,
  );
  if (Platform.isIOS) {
    Future.delayed(
      const Duration(seconds: 3),
      () {
        Fluttertoast.cancel();
      },
    );
  }
}
