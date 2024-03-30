import 'package:echno_attendance/auth/widgets/phone_login_widgets/phone_login_footer.dart';
import 'package:echno_attendance/auth/widgets/phone_login_widgets/phone_login_form.dart';
import 'package:echno_attendance/constants/image_strings.dart';
import 'package:echno_attendance/constants/sizes.dart';
import 'package:echno_attendance/constants/static_text.dart';
import 'package:echno_attendance/utilities/helpers/helper_functions.dart';
import 'package:echno_attendance/utilities/styles/padding_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PhoneLoginScreen extends StatelessWidget {
  const PhoneLoginScreen({super.key});

  @override
  Widget build(context) {
    final isDark = EchnoHelperFunctions.isDarkMode(context);

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: CustomPaddingStyle.defaultPaddingWithoutAppbar,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      EchnoImages.signIn,
                      height: EchnoSize.imageHeaderHeightMd,
                    ),
                    const SizedBox(height: EchnoSize.spaceBtwItems),
                    Text(EchnoText.loginTitle,
                        style: Theme.of(context).textTheme.displaySmall),
                    Text(
                      EchnoText.loginSubtitle,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: EchnoSize.spaceBtwSections),

                    // Phone Login Form Widget
                    const PhoneLoginForm(),

                    const SizedBox(height: EchnoSize.spaceBtwSections),

                    // Footer Section Widget
                    PhoneLoginFooter(isDark: isDark),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
