class User {
  final int? id;
  final String name;
  final String email;
  final String password;
  final String? location;
  final String? profilePhoto;
  final bool privacy;
  final DateTime? createdAt;
  final int? skillsOfferedId;
  final int? skillsWantedId;
  final String? skillsOfferedStr; // comma-separated
  final String? skillsWantedStr; // comma-separated

  User({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    this.location,
    this.profilePhoto,
    this.privacy = true,
    this.createdAt,
    this.skillsOfferedId,
    this.skillsWantedId,
    this.skillsOfferedStr,
    this.skillsWantedStr,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['Name'] ?? json['name'],
      email: json['Email'] ?? json['email'],
      password: json['Password'] ?? json['password'],
      location: json['Location'] ?? json['location'],
      profilePhoto: json['Profile_photo'] ?? json['profile_photo'],
      privacy: json['Privacy'] ?? json['privacy'] ?? true,
      createdAt: json['Created_at'] != null 
          ? DateTime.parse(json['Created_at']) 
          : null,
      skillsOfferedId: json['Skills_offered'] ?? json['skills_offered'],
      skillsWantedId: json['Skills_wanted'] ?? json['skills_wanted'],
      skillsOfferedStr: json['Skills_offered_str'],
      skillsWantedStr: json['Skills_wanted_str'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'Name': name,
      'Email': email,
      'Password': password,
      'Location': location,
      'Profile_photo': profilePhoto,
      'Privacy': privacy,
      'Created_at': createdAt?.toIso8601String(),
      'Skills_offered': skillsOfferedId,
      'Skills_wanted': skillsWantedId,
      'Skills_offered_str': skillsOfferedStr,
      'Skills_wanted_str': skillsWantedStr,
    };
  }

  User copyWith({
    int? id,
    String? name,
    String? email,
    String? password,
    String? location,
    String? profilePhoto,
    bool? privacy,
    DateTime? createdAt,
    int? skillsOfferedId,
    int? skillsWantedId,
    String? skillsOfferedStr,
    String? skillsWantedStr,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      location: location ?? this.location,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      privacy: privacy ?? this.privacy,
      createdAt: createdAt ?? this.createdAt,
      skillsOfferedId: skillsOfferedId ?? this.skillsOfferedId,
      skillsWantedId: skillsWantedId ?? this.skillsWantedId,
      skillsOfferedStr: skillsOfferedStr ?? this.skillsOfferedStr,
      skillsWantedStr: skillsWantedStr ?? this.skillsWantedStr,
    );
  }
}
