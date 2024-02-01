import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastMsg {
  // Base function to display the toast
  void _showToast(String msg, Color bgColor) {
    Fluttertoast.cancel(); // Cancel any active toast
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      webPosition: "center",
      timeInSecForIosWeb: 1,
      backgroundColor: bgColor,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void sendErrorMsg(String msg) {
    _showToast(
        msg, Colors.red.withOpacity(0.7)); // Using a red color for errors
  }

  void sendSuccessMsg(String msg) {
    _showToast(msg,
        Colors.green.withOpacity(0.7)); // Using a green color for successes
  }
}
