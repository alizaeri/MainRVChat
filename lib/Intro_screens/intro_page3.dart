import 'package:flutter/material.dart';

class IntroPage3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          //=> Background Linear Gradient
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xffb5e48c),
            Color(0xff34a0a4),
            Color(0xff1a759f),
            Color(0xff184e77),
          ],
        ),
      ),
    );
  }
}
