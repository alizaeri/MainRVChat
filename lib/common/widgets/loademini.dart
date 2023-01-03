import 'package:flutter/material.dart';
import 'package:rvchat/colors.dart';

class Loadermini extends StatelessWidget {
  const Loadermini({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        color: grayL1.withOpacity(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Container(
                height: 35,
                width: 35,
                margin: const EdgeInsets.all(5),
                child: const CircularProgressIndicator(
                  strokeWidth: 4.0,
                  valueColor: AlwaysStoppedAnimation(white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
