import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:rvchat/colors.dart';
import 'package:rvchat/common/widgets/custom_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static const routeName = '/login-screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final phoneController = TextEditingController();
  Country? country;
  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
  }

  void pickCountry() {
    showCountryPicker(
      context: context,
      showPhoneCode:
          true, // optional. Shows phone code before the country name.
      onSelect: (Country _country) {
        setState(() {
          country = _country;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Your Phone Number'),
        elevation: 0,
        backgroundColor: backgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(children: [
          const Text("vared konid lamasabo"),
          const SizedBox(
            height: 10,
          ),
          TextButton(onPressed: pickCountry, child: Text("Pick Contry")),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              if (country != null) Text('+${country!.phoneCode}'),
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                width: size.width * 0.7,
                child: TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                    hintText: 'Phone number',
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: size.height * 0.6,
          ),
          SizedBox(
            width: 90,
            child: CustomButton(
              onPressed: () {},
              text: 'Next',
            ),
          )
        ]),
      ),
    );
  }
}
