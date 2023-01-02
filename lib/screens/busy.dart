import 'package:flutter/material.dart';
import 'package:rvchat/colors.dart';
import 'package:rvchat/common/widgets/loademini.dart';
import 'package:rvchat/common/widgets/loaderT.dart';
import 'package:rvchat/common/widgets/loaderW.dart';

import '../common/widgets/loader.dart';

class Busy extends StatefulWidget {
  @override
  _Busy createState() => _Busy();
}

class _Busy extends State<Busy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            //=> Background Linear Gradient
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [pinkL1, pinkL2],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontFamily: "yknir",
                      fontWeight: FontWeight.w300,
                      fontSize: 25,
                      color: white),
                  "the contact is busy"),
              SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: pink,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  minimumSize: const Size.fromHeight(60),
                  padding: const EdgeInsets.all(0),
                  //////// HERE
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: "yknir",
                            fontWeight: FontWeight.w400,
                            fontSize: 25,
                          ),
                          "decline"),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(15.0),
                          topRight: Radius.circular(15.0),
                        ),
                        color: white.withOpacity(0.3),
                      ),
                      height: 60,
                      width: 60,
                      child: Loadermini(), // loaderT
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
