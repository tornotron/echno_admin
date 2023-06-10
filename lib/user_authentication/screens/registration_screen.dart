import 'package:echno_attendance/constants/image_string.dart';
import 'package:echno_attendance/user_authentication/widgets/password_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});
  static const EdgeInsetsGeometry containerPadding =
      EdgeInsets.symmetric(vertical: 30.0, horizontal: 30.0);

  @override
  Widget build(context) {
    final mediaQuery = MediaQuery.of(context);
    final height = mediaQuery.size.height;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              height: height,
              padding: containerPadding,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /*---------- Register Screen Header Start ----------*/

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        echnoRegister,
                        height: height * 0.15,
                      ),
                      const SizedBox(height: 15.0),
                      Text('Get On Board!',
                          style: Theme.of(context).textTheme.displaySmall),
                      Text(
                        'Create an account to start your Journey ...',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),

                  /*---------- Register Screen Header End ----------*/

                  /*---------- Register Screen Form Start ----------*/

                  const SizedBox(height: 15.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        maxLines: 1,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.person_outline_outlined),
                          labelText: 'Full Name',
                          hintText: 'Full Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              (15.0),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      TextFormField(
                        enableSuggestions: false,
                        autocorrect: false,
                        keyboardType: TextInputType.emailAddress,
                        maxLines: 1,
                        decoration: InputDecoration(
                          // filled: true,
                          // fillColor:
                          // const Color.fromARGB(255, 214, 214, 214),
                          prefixIcon: const Icon(Icons.person_outline_outlined),
                          labelText: 'Email ID',
                          hintText: 'E-Mail',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        maxLines: 1,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.phone_android_outlined),
                          labelText: 'Phone Number',
                          hintText: '+1-1234567890',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0)),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      const PasswordTextField(
                        labelText: 'Password',
                        hintText: 'Password',
                      ),
                      const SizedBox(height: 10.0),
                      const PasswordTextField(
                        labelText: 'Re-Enter Password',
                        hintText: 'Re-Enter Password',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
