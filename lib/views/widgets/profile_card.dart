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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.primary.withOpacity(0.18),
                backgroundImage: profile.profilePhotoUrl != null
                    ? NetworkImage(profile.profilePhotoUrl!)
                    : null,
                child: profile.profilePhotoUrl == null
                    ? Icon(Icons.person, size: 22, color: AppColors.primary)
                    : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(profile.name, style: AppTextStyles.heading.copyWith(fontSize: 18)),
                    if (profile.location != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 1.0),
                        child: Text(profile.location!, style: AppTextStyles.body.copyWith(fontSize: 12, color: AppColors.primary)),
                      ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.star, color: AppColors.secondary, size: 15),
                        const SizedBox(width: 2),
                        Text(profile.rating.toString(), style: AppTextStyles.body.copyWith(fontSize: 13)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    if (profile.skillsOffered.isNotEmpty) ...[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Skill Offered:', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold, fontSize: 13)),
                          const SizedBox(width: 6),
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: profile.skillsOffered.map((skill) => Padding(
                                  padding: const EdgeInsets.only(right: 4),
                                  child: SizedBox(
                                    height: 22,
                                    child: ElevatedButton(
                                      onPressed: null,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primary,
                                        foregroundColor: Colors.white,
                                        minimumSize: const Size(0, 22),
                                        padding: const EdgeInsets.symmetric(horizontal: 8),
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                        textStyle: AppTextStyles.body.copyWith(fontSize: 11),
                                      ),
                                      child: Text(skill),
                                    ),
                                  ),
                                )).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (profile.skillsWanted.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Skill Wanted:', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold, fontSize: 13)),
                          const SizedBox(width: 6),
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: profile.skillsWanted.map((skill) => Padding(
                                  padding: const EdgeInsets.only(right: 4),
                                  child: SizedBox(
                                    height: 22,
                                    child: ElevatedButton(
                                      onPressed: null,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor: AppColors.primary,
                                        side: const BorderSide(color: AppColors.primary),
                                        minimumSize: const Size(0, 22),
                                        padding: const EdgeInsets.symmetric(horizontal: 8),
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                        textStyle: AppTextStyles.body.copyWith(fontSize: 11),
                                      ),
                                      child: Text(skill),
                                    ),
                                  ),
                                )).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 6),
                    Text('Availability: ${profile.availability}', style: AppTextStyles.body.copyWith(fontSize: 12)),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              SizedBox(
                height: 28,
                child: ElevatedButton(
                  onPressed: onRequest,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                    minimumSize: const Size(0, 28),
                    textStyle: AppTextStyles.button.copyWith(fontSize: 13),
                  ),
                  child: const Text('Request' , style: TextStyle(color: Colors.white),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 