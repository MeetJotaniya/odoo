import 'package:flutter/material.dart';
import 'package:odoo_try/views/profile/user_profile_screen.dart';
import 'package:odoo_try/views/widgets/search_bar.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../controllers/home_controller.dart';
import '../services/auth_service.dart';
import '../services/swap_service.dart';
import '../models/user_profile.dart';
import '../models/swap_request_model.dart';
import 'widgets/profile_card.dart';
import 'profile/profile_view.dart';
import 'auth/login_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController _controller = HomeController();
  final AuthService _authService = AuthService();
  final SwapService _swapService = SwapService();
  String _searchQuery = '';
  int _currentPage = 1;
  final int _profilesPerPage = 2;

  List<UserProfile> get _filteredProfiles =>
      _controller.filterProfiles(_searchQuery);

  List<UserProfile> get _paginatedProfiles {
    final start = (_currentPage - 1) * _profilesPerPage;
    final end = (_currentPage * _profilesPerPage).clamp(0, _filteredProfiles.length);
    return _filteredProfiles.sublist(
        start, end > start ? end : start);
  }

  int get _totalPages =>
      (_filteredProfiles.length / _profilesPerPage).ceil().clamp(1, 999);

  void _onProfileTap(UserProfile profile) {
    // For now, just show a snackbar. Replace with navigation to profile details.
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserProfileScreen(
          userName: 'Marc Demo',
          skillsOffered: ['Flutter', 'Dart', 'UI Design'],
          skillsWanted: ['Python', 'Machine Learning'],
          rating: 4.8,
          feedbackCount: 23,
          profileImageUrl: 'https://i.pravatar.cc/150?img=3',
        ),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Tapped on ${profile.name}')),
    );
  }

  void _onRequest(UserProfile profile) async {
    // Check if user is logged in
    if (!_authService.checkLoginStatus()) {
      // Show login dialog
      _showLoginDialog();
      return;
    }
    
    // User is logged in, proceed with request
    try {
      final currentUser = _authService.currentUser;
      if (currentUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User not found'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Get the target user's skills
      final targetUserSkills = profile.skillsWanted.isNotEmpty 
          ? profile.skillsWanted.first 
          : 'Python Programming';
      
      // Get current user's skills
      final currentUserSkills = _getSkillsForUser(currentUser.skillsOfferedId).isNotEmpty
          ? _getSkillsForUser(currentUser.skillsOfferedId).first
          : 'Web Development';

      final success = await _swapService.createSwapRequest(
        fromUserId: currentUser.id!,
        toUserId: profile.id ?? 1, // Use the profile's ID
        offeredSkills: currentUserSkills,
        requestedSkills: targetUserSkills,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Request sent to ${profile.name}'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to send request'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error sending request'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showLoginDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Login Required',
            style: AppTextStyles.heading.copyWith(color: AppColors.text),
          ),
          content: Text(
            'You need to be logged in to send requests. Would you like to login now?',
            style: AppTextStyles.body.copyWith(
              color: AppColors.text.withOpacity(0.7),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.text.withOpacity(0.7),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _navigateToLogin();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: Text('Login'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
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

  @override
  void initState() {
    super.initState();
    _loadProfiles();
  }

  Future<void> _loadProfiles() async {
    await _controller.loadProfiles();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.accent,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: Text('Skill Swap Platform', style: AppTextStyles.heading.copyWith(color: Colors.white)),
        actions: [
          // Login/Logout Button
          IconButton(
            icon: Icon(
              _authService.checkLoginStatus() ? Icons.logout : Icons.login,
              color: Colors.white,
            ),
            onPressed: () {
              if (_authService.checkLoginStatus()) {
                // Logout
                _authService.logout();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Logged out successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              } else {
                // Navigate to login
                _navigateToLogin();
              }
            },
          ),
          const SizedBox(width: 8),
          // Profile Button
          IconButton(
            icon: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: AppColors.primary),
            ),
            onPressed: () {
              // Check if user is logged in
              if (!_authService.checkLoginStatus()) {
                _showLoginDialog();
                return;
              }
              
              // Get current user's profile
              final currentUser = _authService.currentUser;
              if (currentUser != null) {
                final userProfile = UserProfile(
                  id: currentUser.id,
                  name: currentUser.name,
                  location: currentUser.location,
                  profilePhotoUrl: currentUser.profilePhoto,
                  skillsOffered: _getSkillsForUser(currentUser.skillsOfferedId),
                  skillsWanted: _getSkillsForUser(currentUser.skillsWantedId),
                  availability: 'Weekends', // Default availability
                  isPublic: currentUser.privacy,
                  rating: 4.5, // Default rating
                );
                
                // Navigate to profile page with smooth animation
                Navigator.of(context).push(
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 400),
                    pageBuilder: (context, animation, secondaryAnimation) => FadeTransition(
                      opacity: animation,
                      child: ProfileView(
                        profile: userProfile,
                        onSave: (updatedProfile) {
                          // Handle profile updates here
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Profile updated successfully!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              }
            },
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Column(
        children: [
          SkillSearchBar(
            onChanged: (query) {
              setState(() {
                _searchQuery = query;
                _currentPage = 1;
              });
            },
          ),
          Expanded(
            child: _paginatedProfiles.isEmpty
                ? Center(
                    child: Text('No profiles found.', style: AppTextStyles.body),
                  )
                : ListView.builder(
                    itemCount: _paginatedProfiles.length,
                    itemBuilder: (context, index) {
                      final profile = _paginatedProfiles[index];
                      return ProfileCard(
                        profile: profile,
                        onTap: () => _onProfileTap(profile),
                        onRequest: () => _onRequest(profile),
                      );
                    },
                  ),
          ),
          if (_totalPages > 1)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_totalPages, (index) {
                  final page = index + 1;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _currentPage == page ? AppColors.primary : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.primary),
                      ),
                      child: Text(
                        '$page',
                        style: AppTextStyles.body.copyWith(
                          color: _currentPage == page ? Colors.white : AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }
} 