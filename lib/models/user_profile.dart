class UserProfile {
  final int? id;
  final String name;
  final String? location;
  final String? profilePhotoUrl;
  final List<String> skillsOffered;
  final List<String> skillsWanted;
  final String availability;
  final bool isPublic;
  final double rating;

  UserProfile({
    this.id,
    required this.name,
    this.location,
    this.profilePhotoUrl,
    required this.skillsOffered,
    required this.skillsWanted,
    required this.availability,
    required this.isPublic,
    required this.rating,
  });
} 