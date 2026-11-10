import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/widgets/atoms/custom_back_button.dart';
import '../../../../../core/widgets/atoms/primary_button.dart';
import '../../../../../core/utils/validators.dart';
import '../../../../../core/enums/user_type.dart';

class BirthDateScreen extends StatefulWidget {
  final String phoneNumber;
  final String name;
  final UserType userType;
  final String? email; // Email de Google (opcional)

  const BirthDateScreen({
    super.key,
    required this.phoneNumber,
    required this.name,
    this.userType = UserType.male,
    this.email,
  });

  @override
  State<BirthDateScreen> createState() => _BirthDateScreenState();
}

class _BirthDateScreenState extends State<BirthDateScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  bool _isButtonEnabled = false;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _dateController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      _isButtonEnabled = _dateController.text.length == 10;
    });
  }

  void _formatDate(String value) {
    // Auto-formatear la fecha mientras se escribe
    String cleaned = value.replaceAll('/', '');
    String formatted = '';

    for (int i = 0; i < cleaned.length && i < 8; i++) {
      if (i == 4 || i == 6) {
        formatted += '/';
      }
      formatted += cleaned[i];
    }

    if (formatted != value) {
      _dateController.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
  }

  void _handleContinue() {
    if (_formKey.currentState!.validate()) {
      // Parsear la fecha del formato YYYY/MM/DD
      final parts = _dateController.text.split('/');
      if (parts.length == 3) {
        _selectedDate = DateTime(
          int.parse(parts[0]), // año
          int.parse(parts[1]), // mes
          int.parse(parts[2]), // día
        );
      }

      // Convertir birthDate a String para poder pasarlo como argumento
      final birthDateString = _selectedDate != null
          ? '${_selectedDate!.day.toString().padLeft(2, '0')}/${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.year}'
          : '';

      Modular.to.pushNamed(
        '/auth/profile-confirmation',
        arguments: {
          'phoneNumber': widget.phoneNumber,
          'name': widget.name,
          'birthDate': birthDateString,
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
                // Indicador de progreso
                Row(
                  children: List.generate(4, (index) {
                    return Expanded(
                      child: Container(
                        height: 4,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          color: index < 3
                              ? AppColors.primary
                              : AppColors.textHint,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 32),

                // Título
                const Text(
                  AppStrings.birthDateTitle,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 32),

                // Campo de fecha con validación
                TextFormField(
                  controller: _dateController,
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 2,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9/]')),
                    LengthLimitingTextInputFormatter(10),
                  ],
                  decoration: const InputDecoration(
                    hintText: AppStrings.birthDatePlaceholder,
                    counterText: '',
                    helperText: 'Formato: YYYY/MM/DD',
                  ),
                  validator: Validators.validateBirthDate,
                  onChanged: (value) {
                    _formatDate(value);
                    _validateForm();
                  },
                ),

                const SizedBox(height: 8),

                // Hint
                Text(
                  AppStrings.birthDateHint,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
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
