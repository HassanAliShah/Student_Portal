import 'package:flutter/material.dart';

const KTextField = InputDecoration(
    contentPadding: EdgeInsets.only(left: 25),
    labelText: '',
    labelStyle: TextStyle(color: Colors.black),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        borderSide: BorderSide(width: 2.0)),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
      borderSide: BorderSide(color: Colors.black, width: 2.0),
    ),
    filled: true,
    alignLabelWithHint: false);
