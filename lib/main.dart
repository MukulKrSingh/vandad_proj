import 'package:flutter/material.dart';
import 'package:vandad_proj/views/home_page.dart';

// extension Log on Object {
//   void log() => devtools.log(toString());
// }

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: HomePage(),
    ),
  );
}


