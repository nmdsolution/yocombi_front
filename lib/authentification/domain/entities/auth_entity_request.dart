// lib/domain/entities/auth_entity_request.dart
class AuthEntityRequest {
  final String? identifier; // Can be email or phone
  final String? password; // For direct login
  final String? code; // OTP code
  final String? type; // "login", "register"
  final String? name;
  final String? passwordConfirmation;
  final String? sessionToken; // For completing registration
  final String? userType; // "individual", "business"
  final String? accountType; // "client", "provider", "both"
  final String? method; // "email", "phone" - from API response

  const AuthEntityRequest({
    this.identifier,
    this.password,
    this.code,
    this.type,
    this.name,
    this.passwordConfirmation,
    this.sessionToken,
    this.userType,
    this.accountType,
    this.method,
  });

  // Factory constructor for direct login (with password)
  factory AuthEntityRequest.directLogin({
    required String identifier,
    required String password,
  }) {
    return AuthEntityRequest(
      identifier: identifier,
      password: password,
    );
  }

  // Factory constructor for sending OTP (login)
  factory AuthEntityRequest.sendLoginOtp({
    required String identifier, // email or phone
  }) {
    return AuthEntityRequest(
      identifier: identifier,
      type: 'login',
    );
  }

  // Factory constructor for sending OTP (register)
  factory AuthEntityRequest.sendRegisterOtp({
    required String identifier, // email or phone
  }) {
    return AuthEntityRequest(
      identifier: identifier,
      type: 'register',
    );
  }

  // Factory constructor for verifying OTP
  factory AuthEntityRequest.verifyOtp({
    required String identifier,
    required String code,
    required String type, // "login" or "register"
  }) {
    return AuthEntityRequest(
      identifier: identifier,
      code: code,
      type: type,
    );
  }

  // Factory constructor for completing registration
  factory AuthEntityRequest.completeRegistration({
    required String identifier,
    required String name,
    required String password,
    required String passwordConfirmation,
    required String sessionToken,
    String userType = 'individual',
    String accountType = 'client',
  }) {
    return AuthEntityRequest(
      identifier: identifier,
      name: name,
      password: password,
      passwordConfirmation: passwordConfirmation,
      sessionToken: sessionToken,
      userType: userType,
      accountType: accountType,
    );
  }

  // Copy with method for modifications
  AuthEntityRequest copyWith({
    String? identifier,
    String? password,
    String? code,
    String? type,
    String? name,
    String? passwordConfirmation,
    String? sessionToken,
    String? userType,
    String? accountType,
    String? method,
  }) {
    return AuthEntityRequest(
      identifier: identifier ?? this.identifier,
      password: password ?? this.password,
      code: code ?? this.code,
      type: type ?? this.type,
      name: name ?? this.name,
      passwordConfirmation: passwordConfirmation ?? this.passwordConfirmation,
      sessionToken: sessionToken ?? this.sessionToken,
      userType: userType ?? this.userType,
      accountType: accountType ?? this.accountType,
      method: method ?? this.method,
    );
  }

  // Validation methods
  bool get isValidForDirectLogin => 
      identifier != null && identifier!.isNotEmpty && 
      password != null && password!.isNotEmpty;

  bool get isValidForSendOtp => 
      identifier != null && identifier!.isNotEmpty && 
      type != null && (type == 'login' || type == 'register');

  bool get isValidForVerifyOtp => 
      identifier != null && identifier!.isNotEmpty &&
      code != null && code!.isNotEmpty &&
      type != null && (type == 'login' || type == 'register');

  bool get isValidForCompleteRegistration => 
      identifier != null && identifier!.isNotEmpty &&
      name != null && name!.isNotEmpty &&
      password != null && password!.isNotEmpty &&
      passwordConfirmation != null && passwordConfirmation!.isNotEmpty &&
      sessionToken != null && sessionToken!.isNotEmpty;

  // Helper to detect if identifier is email or phone
  bool get isEmail => identifier != null && identifier!.contains('@');
  bool get isPhone => identifier != null && !identifier!.contains('@');

  // Convert to JSON for API calls
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    
    if (identifier != null) data['identifier'] = identifier;
    if (password != null) data['password'] = password;
    if (code != null) data['code'] = code;
    if (type != null) data['type'] = type;
    if (name != null) data['name'] = name;
    if (passwordConfirmation != null) data['password_confirmation'] = passwordConfirmation;
    if (sessionToken != null) data['session_token'] = sessionToken;
    if (userType != null) data['user_type'] = userType;
    if (accountType != null) data['account_type'] = accountType;
    
    return data;
  }

  @override
  String toString() {
    return 'AuthEntityRequest(identifier: $identifier, type: $type, name: $name, userType: $userType, accountType: $accountType, hasPassword: ${password != null})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is AuthEntityRequest &&
        other.identifier == identifier &&
        other.password == password &&
        other.code == code &&
        other.type == type &&
        other.name == name &&
        other.passwordConfirmation == passwordConfirmation &&
        other.sessionToken == sessionToken &&
        other.userType == userType &&
        other.accountType == accountType;
  }

  @override
  int get hashCode {
    return identifier.hashCode ^
        password.hashCode ^
        code.hashCode ^
        type.hashCode ^
        name.hashCode ^
        passwordConfirmation.hashCode ^
        sessionToken.hashCode ^
        userType.hashCode ^
        accountType.hashCode;
  }
}