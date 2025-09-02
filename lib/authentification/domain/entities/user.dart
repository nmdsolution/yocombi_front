// lib/authentification/domain/entities/user.dart
class User {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final DateTime? emailVerifiedAt;
  final DateTime? phoneVerifiedAt;
  final String? profilePhoto;
  final String userType; // "individual", "business"
  final String accountType; // "client", "provider", "both"
  final UserSubscription subscription;
  final UserVerification verification;
  final UserRating rating;
  final UserLocation location;
  final String? bio;
  final List<String>? skills;
  final UserCompany? company;
  final UserReferral referral;
  final UserStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.emailVerifiedAt,
    this.phoneVerifiedAt,
    this.profilePhoto,
    required this.userType,
    required this.accountType,
    required this.subscription,
    required this.verification,
    required this.rating,
    required this.location,
    this.bio,
    this.skills,
    this.company,
    required this.referral,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String?,
      emailVerifiedAt: json['email_verified_at'] != null
          ? DateTime.tryParse(json['email_verified_at'] as String)
          : null,
      phoneVerifiedAt: json['phone_verified_at'] != null
          ? DateTime.tryParse(json['phone_verified_at'] as String)
          : null,
      profilePhoto: json['profile_photo'] as String?,
      userType: json['user_type'] as String? ?? 'individual',
      accountType: json['account_type'] as String? ?? 'client',
      subscription: UserSubscription.fromJson(json['subscription'] ?? {}),
      verification: UserVerification.fromJson(json['verification'] ?? {}),
      rating: UserRating.fromJson(json['rating'] ?? {}),
      location: UserLocation.fromJson(json['location'] ?? {}),
      bio: json['bio'] as String?,
      skills: json['skills'] != null 
          ? List<String>.from(json['skills'] as List)
          : null,
      company: json['company'] != null 
          ? UserCompany.fromJson(json['company'])
          : null,
      referral: UserReferral.fromJson(json['referral'] ?? {}),
      status: UserStatus.fromJson(json['status'] ?? {}),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'email_verified_at': emailVerifiedAt?.toIso8601String(),
      'phone_verified_at': phoneVerifiedAt?.toIso8601String(),
      'profile_photo': profilePhoto,
      'user_type': userType,
      'account_type': accountType,
      'subscription': subscription.toJson(),
      'verification': verification.toJson(),
      'rating': rating.toJson(),
      'location': location.toJson(),
      'bio': bio,
      'skills': skills,
      'company': company?.toJson(),
      'referral': referral.toJson(),
      'status': status.toJson(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    DateTime? emailVerifiedAt,
    DateTime? phoneVerifiedAt,
    String? profilePhoto,
    String? userType,
    String? accountType,
    UserSubscription? subscription,
    UserVerification? verification,
    UserRating? rating,
    UserLocation? location,
    String? bio,
    List<String>? skills,
    UserCompany? company,
    UserReferral? referral,
    UserStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
      phoneVerifiedAt: phoneVerifiedAt ?? this.phoneVerifiedAt,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      userType: userType ?? this.userType,
      accountType: accountType ?? this.accountType,
      subscription: subscription ?? this.subscription,
      verification: verification ?? this.verification,
      rating: rating ?? this.rating,
      location: location ?? this.location,
      bio: bio ?? this.bio,
      skills: skills ?? this.skills,
      company: company ?? this.company,
      referral: referral ?? this.referral,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Helper methods
  bool get isEmailVerified => emailVerifiedAt != null;
  bool get isPhoneVerified => phoneVerifiedAt != null;
  bool get isSubscribed => subscription.isSubscribed;
  bool get isActive => status.isActive;
  bool get isBanned => status.isBanned;

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, userType: $userType, accountType: $accountType)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is User &&
        other.id == id &&
        other.name == name &&
        other.email == email &&
        other.userType == userType &&
        other.accountType == accountType;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        email.hashCode ^
        userType.hashCode ^
        accountType.hashCode;
  }
}

// Supporting classes for nested objects

class UserSubscription {
  final bool isSubscribed;
  final String? type;
  final DateTime? startDate;
  final DateTime? endDate;
  final double? amount;

  const UserSubscription({
    required this.isSubscribed,
    this.type,
    this.startDate,
    this.endDate,
    this.amount,
  });

  factory UserSubscription.fromJson(Map<String, dynamic> json) {
    return UserSubscription(
      isSubscribed: json['is_subscribed'] as bool? ?? false,
      type: json['type'] as String?,
      startDate: json['start_date'] != null
          ? DateTime.tryParse(json['start_date'] as String)
          : null,
      endDate: json['end_date'] != null
          ? DateTime.tryParse(json['end_date'] as String)
          : null,
      amount: json['amount'] != null
          ? double.tryParse(json['amount'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'is_subscribed': isSubscribed,
      'type': type,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'amount': amount,
    };
  }
}

class UserVerification {
  final String level;
  final Map<String, dynamic>? documents;
  final DateTime? verifiedAt;
  final String? verifiedBy;

  const UserVerification({
    required this.level,
    this.documents,
    this.verifiedAt,
    this.verifiedBy,
  });

  factory UserVerification.fromJson(Map<String, dynamic> json) {
    return UserVerification(
      level: json['level'] as String? ?? 'none',
      documents: json['documents'] as Map<String, dynamic>?,
      verifiedAt: json['verified_at'] != null
          ? DateTime.tryParse(json['verified_at'] as String)
          : null,
      verifiedBy: json['verified_by'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'level': level,
      'documents': documents,
      'verified_at': verifiedAt?.toIso8601String(),
      'verified_by': verifiedBy,
    };
  }

  bool get isVerified => level != 'none';
}

class UserRating {
  final double average;
  final int totalReviews;

  const UserRating({
    required this.average,
    required this.totalReviews,
  });

  factory UserRating.fromJson(Map<String, dynamic> json) {
    return UserRating(
      average: (json['average'] as num?)?.toDouble() ?? 0.0,
      totalReviews: json['total_reviews'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'average': average,
      'total_reviews': totalReviews,
    };
  }
}

class UserLocation {
  final String? city;
  final String? region;
  final String? country;

  const UserLocation({
    this.city,
    this.region,
    this.country,
  });

  factory UserLocation.fromJson(Map<String, dynamic> json) {
    return UserLocation(
      city: json['city'] as String?,
      region: json['region'] as String?,
      country: json['country'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'city': city,
      'region': region,
      'country': country,
    };
  }

  bool get hasLocation => city != null || region != null || country != null;
}

class UserCompany {
  final String? name;
  final String? registration;

  const UserCompany({
    this.name,
    this.registration,
  });

  factory UserCompany.fromJson(Map<String, dynamic> json) {
    return UserCompany(
      name: json['name'] as String?,
      registration: json['registration'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'registration': registration,
    };
  }
}

class UserReferral {
  final String? code;
  final String? referredBy;
  final double bonus;

  const UserReferral({
    this.code,
    this.referredBy,
    required this.bonus,
  });

  factory UserReferral.fromJson(Map<String, dynamic> json) {
    return UserReferral(
      code: json['code'] as String?,
      referredBy: json['referred_by'] as String?,
      bonus: (json['bonus'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'referred_by': referredBy,
      'bonus': bonus,
    };
  }
}

class UserStatus {
  final bool isActive;
  final bool isBanned;
  final DateTime? lastLoginAt;

  const UserStatus({
    required this.isActive,
    required this.isBanned,
    this.lastLoginAt,
  });

  factory UserStatus.fromJson(Map<String, dynamic> json) {
    return UserStatus(
      isActive: json['is_active'] as bool? ?? true,
      isBanned: json['is_banned'] as bool? ?? false,
      lastLoginAt: json['last_login_at'] != null
          ? DateTime.tryParse(json['last_login_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'is_active': isActive,
      'is_banned': isBanned,
      'last_login_at': lastLoginAt?.toIso8601String(),
    };
  }
}