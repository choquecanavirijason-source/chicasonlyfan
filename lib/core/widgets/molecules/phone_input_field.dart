import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PhoneInputField extends StatelessWidget {
  final TextEditingController? countryController;
  final TextEditingController? phoneController;
  final void Function(String)? onCountryChanged;
  final void Function(String)? onPhoneChanged;

  const PhoneInputField({
    super.key,
    this.countryController,
    this.phoneController,
    this.onCountryChanged,
    this.onPhoneChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Country code field - Fijo con bandera de Bolivia y código
        Container(
          width: 110,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('🇧🇴', style: TextStyle(fontSize: 24)),
              SizedBox(width: 8),
              Text(
                '+591',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        // Phone number field
        Expanded(
          child: TextFormField(
            controller: phoneController,
            onChanged: onPhoneChanged,
            keyboardType: TextInputType.phone,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            maxLength: 8,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(8),
            ],
            decoration: const InputDecoration(
              hintText: '70000000',
              counterText: '',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Ingresa tu número de teléfono';
              }
              if (value.length < 8) {
                return 'El número debe tener 8 dígitos';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}
