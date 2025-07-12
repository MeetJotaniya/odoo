import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/text_styles.dart';
import 'request_form_user_screen.dart';

class UserProfileScreen extends StatelessWidget {
  // Example data; in a real app, pass these as arguments or fetch from a provider.
  final String userName;
  final List<String> skillsOffered;
  final List<String> skillsWanted;
  final double rating;
  final int feedbackCount;
  final String profileImageUrl;

  const UserProfileScreen({
    Key? key,
    required this.userName,
    required this.skillsOffered,
    required this.skillsWanted,
    required this.rating,
    required this.feedbackCount,
    required this.profileImageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.accent,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          'Skill Swap Platform',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(profileImageUrl),
              radius: 18,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                backgroundImage: NetworkImage(profileImageUrl),
                radius: 48,
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(userName, style: AppTextStyles.heading),
            ),
            const SizedBox(height: 24),
            Text('Skills Offered', style: AppTextStyles.subheading),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: skillsOffered
                  .map(
                    (skill) => Chip(
                  label: Text(skill, style: AppTextStyles.body),
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  shape: StadiumBorder(
                    side: BorderSide(color: AppColors.primary),
                  ),
                ),
              )
                  .toList(),
            ),
            const SizedBox(height: 16),
            Text('Skills Wanted', style: AppTextStyles.subheading),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: skillsWanted
                  .map(
                    (skill) => Chip(
                  label: Text(skill, style: AppTextStyles.body),
                  backgroundColor: AppColors.secondary.withOpacity(0.1),
                  shape: StadiumBorder(
                    side: BorderSide(color: AppColors.secondary),
                  ),
                ),
              )
                  .toList(),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Icon(Icons.star, color: AppColors.primary, size: 24),
                const SizedBox(width: 4),
                Text(rating.toStringAsFixed(1), style: AppTextStyles.body),
                const SizedBox(width: 8),
                Text(
                  '($feedbackCount feedback)',
                  style: AppTextStyles.body.copyWith(color: Colors.grey),
                ),
              ],
            ),
            const Spacer(),
            Center(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RequestFormScreen(
                          yourSkills: skillsOffered,
                          theirSkills: skillsWanted,
                        ),
                      ),
                    );
                  },
                  child: Text('Request', style: AppTextStyles.button),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}