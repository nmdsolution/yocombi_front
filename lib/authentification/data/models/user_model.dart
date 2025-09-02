// lib/authentification/data/models/user_model.dart
import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    super.phone,
    super.emailVerifiedAt,
    super.phoneVerifiedAt,
    super.profilePhoto,
    required super.userType,
    required super.accountType,
    required super.subscription,
    required super.verification,
    required super.rating,
    required super.location,
    super.bio,
    super.skills,
    super.company,
    required super.referral,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
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
      createdAt: _parseDateTime(json['created_at']),
      updatedAt: _parseDateTime(json['updated_at']),
    );
  }

  static DateTime _parseDateTime(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is DateTime) return value;
    if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.now();
    }
    return DateTime.now();
  }

  @override
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

  User toEntity() {
    return User(
      id: id,
      name: name,
      email: email,
      phone: phone,
      emailVerifiedAt: emailVerifiedAt,
      phoneVerifiedAt: phoneVerifiedAt,
      profilePhoto: profilePhoto,
      userType: userType,
      accountType: accountType,
      subscription: subscription,
      verification: verification,
      rating: rating,
      location: location,
      bio: bio,
      skills: skills,
      company: company,
      referral: referral,
      status: status,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  // Create a copy with updated values
  UserModel copyWith({
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
    return UserModel(
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
}