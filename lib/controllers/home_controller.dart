import '../models/user_profile.dart';
import '../models/user_model.dart';
import '../services/database_service.dart';

class HomeController {
  final DatabaseService _databaseService = DatabaseService();
  List<UserProfile> _allProfiles = [];

  List<UserProfile> get allProfiles => _allProfiles;

  // Load profiles from database
  Future<void> loadProfiles() async {
    try {
      final users = await _databaseService.getAllUsers();
      _allProfiles = users.map((user) => _convertUserToProfile(user)).toList();
    } catch (e) {
      // Fallback to mock data if database fails
      _allProfiles = _getMockProfiles();
    }
  }

  UserProfile _convertUserToProfile(User user) {
    // Use the new comma-separated string fields if present
    List<String> offered = user.skillsOfferedStr != null && user.skillsOfferedStr!.isNotEmpty
      ? user.skillsOfferedStr!.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList()
      : _getSkillsForUser(user.skillsOfferedId);
    List<String> wanted = user.skillsWantedStr != null && user.skillsWantedStr!.isNotEmpty
      ? user.skillsWantedStr!.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList()
      : _getSkillsForUser(user.skillsWantedId);
    return UserProfile(
      id: user.id,
      name: user.name,
      location: user.location,
      profilePhotoUrl: user.profilePhoto,
      skillsOffered: offered,
      skillsWanted: wanted,
      availability: 'Weekends', // Default availability
      isPublic: user.privacy,
      rating: 4.5, // Default rating
    );
  }

  List<String> _getSkillsForUser(int? skillId) {
    // This would be enhanced to get actual skills from database
    // For now, return default skills based on ID
    if (skillId == null) return ['Web Development'];
    
    final skills = [
      'Web Development',
      'App Development',
      'Python Programming',
      'Java Programming',
      'Database Management',
      'Cybersecurity Basics',
      'DSA',
      'Machine Learning',
      'Data Analysis',
      'Git and Github',
      'Excel, PowerPoint and Word',
    ];
    
    // Ensure skillId is within bounds
    final index = (skillId - 1) % skills.length;
    return [skills[index >= 0 ? index : 0]];
  }

  List<UserProfile> _getMockProfiles() {
    return [
      UserProfile(
        id: 1,
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
        id: 2,
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
        id: 3,
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
  }

  List<UserProfile> filterProfiles(String query) {
    if (query.isEmpty) return _allProfiles;
    return _allProfiles.where((profile) =>
      profile.skillsOffered.any((skill) => skill.toLowerCase().contains(query.toLowerCase())) ||
      profile.skillsWanted.any((skill) => skill.toLowerCase().contains(query.toLowerCase()))
    ).toList();
  }
} 