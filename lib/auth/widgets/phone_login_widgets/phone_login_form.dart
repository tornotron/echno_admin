import 'package:country_picker/country_picker.dart';
import 'package:echno_attendance/auth/utilities/alert_dialogue.dart';
import 'package:echno_attendance/constants/colors.dart';
import 'package:echno_attendance/constants/sizes.dart';
import 'package:echno_attendance/constants/static_text.dart';
import 'package:echno_attendance/utilities/helpers/form_validators.dart';
import 'package:flutter/material.dart';

class PhoneLoginForm extends StatefulWidget {
  const PhoneLoginForm({super.key});

  @override
  State<PhoneLoginForm> createState() => _PhoneLoginFormState();
}

class _PhoneLoginFormState extends State<PhoneLoginForm> {
  final GlobalKey<FormState> _phoneLoginFormKey = GlobalKey<FormState>();
  final TextEditingController phoneController = TextEditingController();

  Country selectedCountry = Country(
    phoneCode: "91",
    countryCode: "IN",
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: "India",
    example: "India",
    displayName: "India",
    displayNameNoCountryCode: "IN",
    e164Key: "",
  );
  @override
  Widget build(BuildContext context) {
    phoneController.selection = TextSelection.fromPosition(
      TextPosition(
        offset: phoneController.text.length,
      ),
    );
    return Form(
      key: _phoneLoginFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: phoneController,
            onChanged: (value) {
              setState(() {
                phoneController.text = value;
              });
            },
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.number,
            maxLines: 1,
            decoration: InputDecoration(
              labelText: 'Mobile Number',
              hintText: '1234 567 890',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              prefixIcon: Container(
                padding: const EdgeInsets.all(13.5),
                child: InkWell(
                  onTap: () {
                    showCountryPicker(
                      context: context,
                      countryListTheme: const CountryListThemeData(
                        bottomSheetHeight: 550,
                      ),
                      onSelect: (value) {
                        setState(() {
                          selectedCountry = value;
                        });
                      },
                    );
                  },
                  child: Text(
                    "${selectedCountry.flagEmoji} + ${selectedCountry.phoneCode}",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ),
              suffixIcon: phoneController.text.length > 9
                  ? Container(
                      height: 30,
                      width: 30,
                      margin: const EdgeInsets.all(10.0),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: EchnoColors.success,
                      ),
                      child: const Icon(
                        Icons.done,
                        color: EchnoColors.white,
                        size: 20,
                      ),
                    )
                  : null,
            ),
            validator: (value) => EchnoValidator.validatePhoneNumber(value),
          ),
          const SizedBox(height: EchnoSize.spaceBtwItems),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                if (_phoneLoginFormKey.currentState!.validate()) {
                  await genericAlertDialog(context, EchnoText.featureDisabled);
                }
              },
              child: const Text(
                EchnoText.loginButton,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
