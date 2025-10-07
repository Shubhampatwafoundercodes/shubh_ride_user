class AppValidator {
  /// ✅ Validate Mobile Number
  static String? validateMobile(String? value) {
    if (value == null || value.trim().isEmpty) return 'Enter mobile number';
    final mobileRegex = RegExp(r'^[6-9]\d{9}$');
    if (!mobileRegex.hasMatch(value)) return 'Enter valid mobile number';
    return null;
  }

  /// ✅ Validate Name
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Enter name';
    if (value.length > 40) return 'Name must be under 40 characters';
    final nameRegex = RegExp(r'^[a-zA-Z\s]+$');
    if (!nameRegex.hasMatch(value)) return 'Only letters allowed';
    return null;
  }
  /// ✅ Validate OTP
  static String? validateOtp(String? value) {
    if (value == null || value.trim().isEmpty) return 'Enter OTP';
    final otpRegex = RegExp(r'^\d{4}$'); // 4-digit OTP
    if (!otpRegex.hasMatch(value)) return 'Enter valid 4-digit OTP';
    return null;
  }
  /// ✅ Validate Email
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'Enter email';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) return 'Enter valid email';
    return null;
  }

  /// ✅ Validate Password
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Enter password';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  /// ✅ Validate Confirm Password
  static String? validateConfirmPassword(String? value, String? originalPassword) {
    if (value == null || value.isEmpty) return 'Enter confirm password';
    if (value != originalPassword) return 'Passwords do not match';
    return null;
  }

  /// ✅ Validate PAN Number
  static String? validatePan(String? value) {
    if (value == null || value.isEmpty) return 'Enter PAN number';
    final panRegex = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]$');
    if (!panRegex.hasMatch(value)) return 'Enter valid PAN (ABCDE1234F)';
    return null;
  }

  /// ✅ Validate Aadhaar Number
  static String? validateAadhaar(String? value) {
    if (value == null || value.isEmpty) return 'Enter Aadhaar number';
    final aadhaarRegex = RegExp(r'^\d{12}$');
    if (!aadhaarRegex.hasMatch(value)) return 'Enter valid 12-digit Aadhaar number';
    return null;
  }

  /// ✅ Validate Account Number
  static String? validateAccount(String? value) {
    if (value == null || value.isEmpty) return 'Enter account number';
    final accountRegex = RegExp(r'^\d{9,18}$');
    if (!accountRegex.hasMatch(value)) return 'Enter valid account number';
    return null;
  }

  /// ✅ Validate IFSC Code
  static String? validateIFSC(String? value) {
    if (value == null || value.isEmpty) return 'Enter IFSC code';
    final ifscRegex = RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$');
    if (!ifscRegex.hasMatch(value)) return 'Enter valid IFSC code (e.g. SBIN0001234)';
    return null;
  }
  /// ✅ Validate Amount
  static String? validateAmount(String? value) {
    if (value == null || value.trim().isEmpty) return 'Enter amount';
    final amount = int.tryParse(value);
    if (amount == null || amount <= 0) return 'Enter valid amount';
    return null;
  }
  /// ✅ Bank Name
  static String? validateBankName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Enter bank name';
    if (value.length > 50) return 'Bank name must be under 50 characters';
    final regex = RegExp(r'^[A-Z\s]+$');
    if (!regex.hasMatch(value)) return 'Bank name must be in UPPERCASE letters only';
    return null;
  }
/// transaction
 static String? validateTransactionId(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Transaction ID is required';
    }
    if (value.length < 8) {
      return 'Transaction ID is too short';
    }
    if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
      return 'Only alphanumeric characters allowed';
    }
    return null;
  }
}
