class User {
  final String? id;
  final String fullName;
  final String email;
  final String? phoneNumber;
  final String? profileImageUrl;
  final String? password; // Added for simple auth
  final bool isFirstTime;
  final bool isLoggedIn;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const User({
    this.id,
    required this.fullName,
    required this.email,
    this.phoneNumber,
    this.profileImageUrl,
    this.password,
    this.isFirstTime = true,
    this.isLoggedIn = false,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      fullName: json['full_name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      profileImageUrl: json['profile_image_url'],
      password: json['password'],
      isFirstTime: json['is_first_time'] ?? true,
      isLoggedIn: json['is_logged_in'] ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'phone_number': phoneNumber,
      'profile_image_url': profileImageUrl,
      'password': password,
      'is_first_time': isFirstTime,
      'is_logged_in': isLoggedIn,
    };
  }

  User copyWith({
    String? id,
    String? fullName,
    String? email,
    String? phoneNumber,
    String? profileImageUrl,
    String? password,
    bool? isFirstTime,
    bool? isLoggedIn,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      password: password ?? this.password,
      isFirstTime: isFirstTime ?? this.isFirstTime,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
