import '../models/user_profile.dart';

class HomeController {
  List<UserProfile> _allProfiles = [
    UserProfile(
      name: 'Marc Demo',
      location: 'New York',
      profilePhotoUrl: null,
      skillsOffered: ['Photoshop', 'Excel'],
      skillsWanted: ['Python'],
      availability: 'Weekends',
      isPublic: true,
      rating: 4.8,
    ),
    UserProfile(
      name: 'Mitchell',
      location: 'London',
      profilePhotoUrl: null,
      skillsOffered: ['Flutter', 'UI Design'],
      skillsWanted: ['Excel'],
      availability: 'Evenings',
      isPublic: true,
      rating: 4.5,
    ),
    UserProfile(
      name: 'Joe Wills',
      location: 'Berlin',
      profilePhotoUrl: null,
      skillsOffered: ['Java', 'React'],
      skillsWanted: ['Photoshop'],
      availability: 'Weekends',
      isPublic: true,
      rating: 4.2,
    ),
  ];

  List<UserProfile> get allProfiles => _allProfiles;

  List<UserProfile> filterProfiles(String query) {
    if (query.isEmpty) return _allProfiles;
    return _allProfiles.where((profile) =>
      profile.skillsOffered.any((skill) => skill.toLowerCase().contains(query.toLowerCase())) ||
      profile.skillsWanted.any((skill) => skill.toLowerCase().contains(query.toLowerCase()))
    ).toList();
  }
} 