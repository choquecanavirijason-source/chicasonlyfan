import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/widgets/atoms/custom_back_button.dart';
import '../../../../../core/widgets/atoms/primary_button.dart';
import '../../../../../core/utils/validators.dart';
import '../../../../../core/enums/user_type.dart';

class NameScreen extends StatefulWidget {
  final String phoneNumber;
  final UserType userType;
  final String? email; // Email de Google (opcional)

  const NameScreen({
    super.key,
    required this.phoneNumber,
    this.userType = UserType.male,
    this.email,
  });

  @override
  State<NameScreen> createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  bool _isButtonEnabled = false;

  final List<String> _randomNames = [
    'Carlos',
    'Miguel',
    'Juan',
    'Diego',
    'Luis',
    'Pedro',
    'Fernando',
    'Roberto',
    'Andres',
    'Mario',
    'Jorge',
    'Ricardo',
  ];

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      _isButtonEnabled = _nameController.text.length >= 2;
    });
  }

  void _generateRandomName() {
    final random = Random();
    final randomName = _randomNames[random.nextInt(_randomNames.length)];
    final randomNumber = random.nextInt(999);
    setState(() {
      _nameController.text = '$randomName$randomNumber';
    });
  }

  void _handleContinue() {
    if (_formKey.currentState!.validate()) {
      Modular.to.pushNamed(
        '/auth/birthdate',
        arguments: {
          'phoneNumber': widget.phoneNumber,
          'name': _nameController.text,
          'userType': widget.userType == UserType.female ? 'female' : 'male',
          'email': widget.email, // Pasar email a siguiente pantalla
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.textWhite,
      appBar: AppBar(
        leading: CustomBackButton(color: AppColors.textSecondary),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),

                // Título
                const Text(
                  AppStrings.nameTitle,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 32),

                // Campo de nombre con validación
                TextFormField(
                  controller: _nameController,
                  maxLength: 30,
                  autofocus: true,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: AppStrings.namePlaceholder,
                    counterText: '${_nameController.text.length}/30',
                  ),
                  validator: Validators.validateName,
                  onChanged: (value) => _validateForm(),
                ),

                const SizedBox(height: 8),

                // Hint
                Text(
                  AppStrings.nameHint,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 24),

                // Botón generar nombre aleatorio
                PrimaryButton(
                  text: AppStrings.generateButton,
                  onPressed: _generateRandomName,
                ),

                const Spacer(),

                // Botón continuar
                PrimaryButton(
                  text: AppStrings.continueButton,
                  onPressed: _isButtonEnabled ? _handleContinue : null,
                ),

                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
