import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Blocked extends StatelessWidget {
  const Blocked({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('the user has blocked you'),
    );
  }
}
