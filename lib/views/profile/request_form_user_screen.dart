import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/text_styles.dart';
import '../../services/swap_service.dart';
import '../../services/auth_service.dart';

class RequestFormScreen extends StatefulWidget {
  final List<String> yourSkills;
  final List<String> theirSkills;

  const RequestFormScreen({
    Key? key,
    required this.yourSkills,
    required this.theirSkills,
  }) : super(key: key);

  @override
  State<RequestFormScreen> createState() => _RequestFormScreen5State();
}

class _RequestFormScreen5State extends State<RequestFormScreen> {
  String? selectedYourSkill;
  String? selectedTheirSkill;
  final TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.accent,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          'Skill Swap Request',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Choose one of your offered skills', style: AppTextStyles.body),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedYourSkill,
              items: widget.yourSkills
                  .map((skill) => DropdownMenuItem(
                        value: skill,
                        child: Text(skill, style: AppTextStyles.body),
                      ))
                  .toList(),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              onChanged: (value) {
                setState(() {
                  selectedYourSkill = value;
                });
              },
            ),
            const SizedBox(height: 20),
            Text('Choose one of their wanted skills', style: AppTextStyles.body),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedTheirSkill,
              items: widget.theirSkills
                  .map((skill) => DropdownMenuItem(
                        value: skill,
                        child: Text(skill, style: AppTextStyles.body),
                      ))
                  .toList(),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              onChanged: (value) {
                setState(() {
                  selectedTheirSkill = value;
                });
              },
            ),
            const SizedBox(height: 20),
            Text('Message', style: AppTextStyles.body),
            const SizedBox(height: 8),
            TextField(
              controller: messageController,
              maxLines: 4,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                hintText: 'Enter your message...',
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: (selectedYourSkill != null && selectedTheirSkill != null)
                    ? () async {
                        // Get current user and target user (dummy for now)
                        final authService = AuthService();
                        final swapService = SwapService();
                        final currentUser = authService.currentUser;
                        if (currentUser == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('You must be logged in.')),
                          );
                          return;
                        }
                        // For demo, use 2 as the target user ID
                        final success = await swapService.createSwapRequest(
                          fromUserId: currentUser.id ?? 1,
                          toUserId: 2,
                          offeredSkills: selectedYourSkill!,
                          requestedSkills: selectedTheirSkill!,
                        );
                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Request submitted!')),
                          );
                          Navigator.of(context).pop();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Failed to submit request.')),
                          );
                        }
                      }
                    : null,
                child: Text('Submit', style: AppTextStyles.button),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 