import 'package:echno_attendance/auth/bloc/auth_bloc.dart';
import 'package:echno_attendance/auth/bloc/auth_event.dart';
import 'package:echno_attendance/constants/colors.dart';
import 'package:echno_attendance/constants/sizes.dart';
import 'package:echno_attendance/constants/static_text.dart';
import 'package:echno_attendance/utilities/helpers/form_validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EnterEmployeeIdForm extends StatelessWidget {
  const EnterEmployeeIdForm({
    super.key,
    required GlobalKey<FormState> authEmployeeIdFormKey,
    required TextEditingController controller,
    required this.isDark,
  })  : _forgotPasswordFormKey = authEmployeeIdFormKey,
        _controller = controller;

  final GlobalKey<FormState> _forgotPasswordFormKey;
  final TextEditingController _controller;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _forgotPasswordFormKey,
      child: Column(
        children: [
          TextFormField(
            controller: _controller,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            maxLines: 1,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.mail_outline),
              labelText: 'Employee ID',
              hintText: 'Employee ID',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  (15.0),
                ),
              ),
            ),
            validator: (value) => EchnoValidator.defaultValidator(value),
          ),
          const SizedBox(height: EchnoSize.spaceBtwItems),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                if (_forgotPasswordFormKey.currentState!.validate()) {}
              },
              child: const Text(
                EchnoText.enterEmployeeIdButton,
              ),
            ),
          ),
          const SizedBox(height: EchnoSize.spaceBtwItems),
          TextButton(
            onPressed: () {
              context.read<AuthBloc>().add(
                    const AuthLogOutEvent(),
                  );
            },
            child: Text(EchnoText.backToLogin,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: isDark
                          ? EchnoColors.buttonSecondary
                          : EchnoColors.buttonPrimary,
                    )),
          ),
        ],
      ),
    );
  }
}
