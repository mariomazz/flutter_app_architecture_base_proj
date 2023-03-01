import 'package:flutter/material.dart';

extension ExtWidget on Widget {
  Widget center() {
    return Center(child: this);
  }

  Widget expand() {
    return SizedBox.expand(child: this);
  }

  Widget list() {
    return SingleChildScrollView(child: this);
  }

  Widget padding(EdgeInsetsGeometry padding) {
    return Padding(
      padding: padding,
      child: this,
    );
  }
}
