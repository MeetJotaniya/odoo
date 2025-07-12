import 'package:flutter/material.dart';
import 'package:odoo_try/views/profile/user_profile_screen.dart';
import 'package:odoo_try/views/widgets/search_bar.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../controllers/home_controller.dart';
import '../models/user_profile.dart';
import 'widgets/profile_card.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController _controller = HomeController();
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

  void _onRequest(UserProfile profile) {
    // For now, just show a snackbar. Replace with request logic.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Request sent to ${profile.name}')),
    );
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
          IconButton(
            icon: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: AppColors.primary),
            ),
            onPressed: () {
              // Navigate to profile page (to be implemented)
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile icon tapped')),
              );
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