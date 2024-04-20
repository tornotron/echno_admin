import 'package:echno_attendance/auth/bloc/auth_bloc.dart';
import 'package:echno_attendance/auth/bloc/auth_event.dart';
import 'package:echno_attendance/auth/utilities/alert_dialogue.dart';
import 'package:echno_attendance/auth/widgets/password_form_field.dart';
import 'package:echno_attendance/constants/sizes.dart';
import 'package:echno_attendance/constants/static_text.dart';
import 'package:echno_attendance/utilities/helpers/form_validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegistrationForm extends StatelessWidget {
  const RegistrationForm({
    super.key,
    required GlobalKey<FormState> registrationFormKey,
    required TextEditingController employeeIdController,
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required TextEditingController confirmPasswordController,
  })  : _registrationFormKey = registrationFormKey,
        _employeeIdController = employeeIdController,
        _emailController = emailController,
        _passwordController = passwordController,
        _confirmPasswordController = confirmPasswordController;

  final GlobalKey<FormState> _registrationFormKey;
  final TextEditingController _employeeIdController;
  final TextEditingController _emailController;
  final TextEditingController _passwordController;
  final TextEditingController _confirmPasswordController;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _registrationFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Employee ID TextField
          TextFormField(
            controller: _employeeIdController,
            maxLines: 1,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.person_outline_outlined),
              labelText: 'Employee ID',
              hintText: 'Enter Employee ID...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  (EchnoSize.borderRadiusLg),
                ),
              ),
            ),
          ),
          const SizedBox(height: EchnoSize.spaceBtwInputFields),

          // Email TextField
          TextFormField(
            controller: _emailController,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            maxLines: 1,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.person_outline_outlined),
              labelText: 'Email ID',
              hintText: 'E-Mail',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(EchnoSize.borderRadiusLg),
              ),
            ),
            validator: (value) => EchnoValidator.validateEmail(value),
          ),
          const SizedBox(height: EchnoSize.spaceBtwInputFields),

          // Password TextField
          PasswordTextField(
            controller: _passwordController,
            labelText: 'Password',
            hintText: 'Password',
            validator: (value) => EchnoValidator.validatePassword(value),
          ),
          const SizedBox(height: EchnoSize.spaceBtwItems),

          PasswordTextField(
            controller: _confirmPasswordController,
            labelText: 'Confirm Password',
            hintText: 'Confirm Password',
            validator: (value) {
              if (value != _passwordController.text) {
                return 'Passwords do not match...';
              } else if (value == null || value.isEmpty) {
                return 'Password is required...';
              }
              return null;
            },
          ),
          const SizedBox(height: EchnoSize.spaceBtwItems),

          // Register Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                if (_registrationFormKey.currentState!.validate()) {
                  final String email = _emailController.text;
                  final String password = _passwordController.text;
                  final String? employeeId = _employeeIdController.text.isEmpty
                      ? null
                      : _employeeIdController.text;

                  context.read<AuthBloc>().add(
                        AuthRegistrationEvent(
                          employeeId,
                          authUserEmail: email,
                          password: password,
                        ),
                      );
                  verificationMailAltert(context);
                }
              },
              child: const Text(
                EchnoText.registerbutton,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
