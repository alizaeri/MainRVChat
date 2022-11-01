import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget
      mobileScreenLayout; // دو تا ارگومنت که ویدجت هستند را به عنوان ورودی قبول میکند
  final Widget webScreenLayout;
  const ResponsiveLayout({
    // اینجا کنستارکتور برای این کلاس تعریف میشه
    Key? key,
    required this.mobileScreenLayout,
    required this.webScreenLayout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 938) {
          // اینجا بر اساس نوع پلت فرم ویدجت مخصوصش برگردانده میشه
          return webScreenLayout;
        }
        return mobileScreenLayout;
      },
    );
  }
}
