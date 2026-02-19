class FormValidators {
  // البريد الإلكتروني
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  // كلمة المرور
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    final regex = RegExp(
      r'^(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$&*~^%()_\-+=\[\]{};:"\\|,.<>\/?]).{8,}$',
    );

    if (!regex.hasMatch(value)) {
      return 'Password must be at least 8 characters and include an uppercase letter, a number, and a symbol';
    }

    return null;
  }

  static String? validateConfirmPassword(
      String? password, String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Password is required';
    }

    if (password != confirmPassword) {
      return 'Password does not match';
    }

    return null;
  }

  // رقم الهاتف
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone is required';
    }
    final cleanedValue = value.replaceAll(RegExp(r'[\s-]'), '');
    if (!RegExp(r'^[0-9+]+$').hasMatch(cleanedValue)) {
      return 'Enter a valid phone number';
    }
    if (cleanedValue.length < 8 || cleanedValue.length > 15) {
      return 'phone number must to be between 8 and 15';
    }
    return null;
  }

  // الاسم
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }
    if (value.trim().length < 2) {
      return 'Name must to be 2 character at least';
    }
    return null;
  }

  // حقل مطلوب
  static String? validateRequired(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'this field'} required';
    }
    return null;
  }
}
