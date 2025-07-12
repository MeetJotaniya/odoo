import 'package:flutter/material.dart';
import '../../models/user_profile.dart';
import '../../constants/colors.dart';
import '../../constants/text_styles.dart';

class ProfileCard extends StatelessWidget {
  final UserProfile profile;
  final VoidCallback onTap;
  final VoidCallback onRequest;

  const ProfileCard({
    Key? key,
    required this.profile,
    required this.onTap,
    required this.onRequest,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Card(
        color: AppColors.accent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: AppColors.primary.withOpacity(0.2),
                backgroundImage: profile.profilePhotoUrl != null
                    ? NetworkImage(profile.profilePhotoUrl!)
                    : null,
                child: profile.profilePhotoUrl == null
                    ? Icon(Icons.person, size: 32, color: AppColors.primary)
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(profile.name, style: AppTextStyles.heading),
                    if (profile.location != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 2.0),
                        child: Text(profile.location!, style: AppTextStyles.body.copyWith(fontSize: 14, color: AppColors.primary)),
                      ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.star, color: AppColors.secondary, size: 18),
                        const SizedBox(width: 4),
                        Text(profile.rating.toString(), style: AppTextStyles.body),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 2,
                      children: profile.skillsOffered.map((skill) => Chip(
                        label: Text(skill, style: AppTextStyles.body.copyWith(color: Colors.white)),
                        backgroundColor: AppColors.primary,
                      )).toList(),
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 6,
                      runSpacing: 2,
                      children: profile.skillsWanted.map((skill) => Chip(
                        label: Text(skill, style: AppTextStyles.body.copyWith(color: AppColors.primary)),
                        backgroundColor: AppColors.accent,
                        shape: StadiumBorder(side: BorderSide(color: AppColors.primary)),
                      )).toList(),
                    ),
                    const SizedBox(height: 8),
                    Text('Availability: ${profile.availability}', style: AppTextStyles.body.copyWith(fontSize: 14)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: onRequest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text('Request', style: AppTextStyles.button),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 