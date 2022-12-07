import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:rvchat/colors.dart';

class LoaderW extends StatelessWidget {
  const LoaderW({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        color: white.withOpacity(0.8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Container(
                height: 50,
                width: 50,
                margin: const EdgeInsets.all(5),
                child: const CircularProgressIndicator(
                  strokeWidth: 4.0,
                  valueColor: AlwaysStoppedAnimation(pinkL2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
