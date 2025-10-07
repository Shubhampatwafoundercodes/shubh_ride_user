import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void toastMsg(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.TOP,
    backgroundColor: Colors.black45,
    textColor: Colors.white,
    fontSize: 16,
  );
}
