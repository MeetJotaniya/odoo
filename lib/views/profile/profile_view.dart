import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/text_styles.dart';
import '../../models/user_profile.dart';
import '../../services/auth_service.dart';
import '../../services/database_service.dart';
 // Added import for SwapRequestsScreen
import '../swap_requests/swap_requests_screen.dart';
class ProfileView extends StatefulWidget {
  final UserProfile profile;
  final void Function(UserProfile updatedProfile)? onSave;
  const ProfileView({Key? key, required this.profile, this.onSave}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late TextEditingController _nameController;
  late TextEditingController _locationController;
  late TextEditingController _availabilityController;
  late bool _isPublic;
  late List<String> _skillsOffered;
  late List<String> _skillsWanted;
  late String _originalName;
  late String _originalLocation;
  late String _originalAvailability;
  late bool _originalIsPublic;

  static const List<String> _availabilityOptions = [
    'Weekends',
    'Evenings',
    'Mornings',
    'Full-time',
    'Custom',
  ];
  String? _selectedAvailability;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile.name);
    _locationController = TextEditingController(text: widget.profile.location ?? '');
    _availabilityController = TextEditingController(text: widget.profile.availability);
    _isPublic = widget.profile.isPublic;
    _skillsOffered = List<String>.from(widget.profile.skillsOffered);
    _skillsWanted = List<String>.from(widget.profile.skillsWanted);
    _selectedAvailability = _availabilityOptions.contains(widget.profile.availability)
        ? widget.profile.availability
        : 'Custom';
    if (_selectedAvailability == 'Custom') {
      _availabilityController.text = widget.profile.availability;
    }
    // Save originals for discard
    _originalName = widget.profile.name;
    _originalLocation = widget.profile.location ?? '';
    _originalAvailability = widget.profile.availability;
    _originalIsPublic = widget.profile.isPublic;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _availabilityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.accent,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: AppColors.accent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              TextButton(
                onPressed: () async {
                  // Save logic: update user profile in database
                  final authService = AuthService();
                  final user = authService.currentUser;
                  if (user != null) {
                    final updatedUser = user.copyWith(
                      name: _nameController.text,
                      location: _locationController.text,
                      privacy: _isPublic,
                      skillsOfferedStr: _skillsOffered.join(','),
                      skillsWantedStr: _skillsWanted.join(','),
                      // Save availability as a string field (add to User model if needed)
                    );
                    await authService.updateCurrentUser(updatedUser);
                    // Also persist to database
                    await DatabaseService().updateUser(updatedUser);
                    // Save availability and profile type as original for discard
                    setState(() {
                      _originalName = _nameController.text;
                      _originalLocation = _locationController.text;
                      _originalAvailability = _selectedAvailability == 'Custom'
                          ? _availabilityController.text
                          : _selectedAvailability ?? '';
                      _originalIsPublic = _isPublic;
                    });
                    // Notify parent (e.g. home screen) of update
                    if (widget.onSave != null) {
                      widget.onSave!(UserProfile(
                        id: user.id,
                        name: _nameController.text,
                        location: _locationController.text,
                        profilePhotoUrl: user.profilePhoto,
                        skillsOffered: _skillsOffered,
                        skillsWanted: _skillsWanted,
                        availability: _selectedAvailability == 'Custom' ? _availabilityController.text : _selectedAvailability ?? '',
                        isPublic: _isPublic,
                        rating: 4.5, // or user.rating if available
                      ));
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Profile saved!')),
                    );
                  }
                },
                child: Text('Save', style: AppTextStyles.body.copyWith(color: Colors.green, fontWeight: FontWeight.bold)),
              ),
              TextButton(
                onPressed: () {
                  // Discard logic: revert changes
                  setState(() {
                    _nameController.text = _originalName;
                    _locationController.text = _originalLocation;
                    _availabilityController.text = _originalAvailability;
                    _isPublic = _originalIsPublic;
                    _selectedAvailability = _availabilityOptions.contains(_originalAvailability)
                        ? _originalAvailability
                        : 'Custom';
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Changes discarded.')),
                  );
                },
                child: Text('Discard', style: AppTextStyles.body.copyWith(color: AppColors.secondary, fontWeight: FontWeight.bold)),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Home', style: AppTextStyles.body.copyWith(decoration: TextDecoration.underline)),
              ),
              const SizedBox(width: 8),
              // Swap Requests Button
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SwapRequestsScreen(),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Icon(Icons.swap_horiz, color: AppColors.primary),
                    const SizedBox(width: 4),
                    Text('Swap Requests', style: AppTextStyles.body.copyWith(color: AppColors.primary)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: AppColors.primary),
              ),
            ],
          ),
        ),
        toolbarHeight: 56,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 600;
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 24),
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 12),
                        Center(child: _profilePhotoSection(context)),
                        const SizedBox(height: 18),
                        _editableField('Name', _nameController),
                        const SizedBox(height: 14),
                        _editableField('Location', _locationController),
                        const SizedBox(height: 14),
                        Text('Skills Offered', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 8,
                          children: [
                            ..._skillsOffered.asMap().entries.map((entry) {
                              final i = entry.key;
                              final skill = entry.value;
                              return Chip(
                                label: Text(skill),
                                deleteIcon: Icon(Icons.close, size: 18),
                                onDeleted: () {
                                  setState(() => _skillsOffered.removeAt(i));
                                },
                                backgroundColor: AppColors.primary.withOpacity(0.1),
                                labelStyle: AppTextStyles.body,
                              );
                            }),
                            ActionChip(
                              label: Row(children: [Icon(Icons.add, size: 16), Text('Add')]),
                              onPressed: () async {
                                final controller = TextEditingController();
                                final result = await showDialog<String>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    backgroundColor: AppColors.accent,
                                    title: Text('Add Skill Offered', style: AppTextStyles.heading.copyWith(color: AppColors.primary)),
                                    content: TextField(
                                      controller: controller,
                                      decoration: InputDecoration(
                                        labelText: 'Skill',
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                      ),
                                    ),
                                    actions: [
                                      TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                                        onPressed: () => Navigator.pop(context, controller.text),
                                        child: Text('Add', style: TextStyle(color: Colors.white)),
                                      ),
                                    ],
                                  ),
                                );
                                if (result != null && result.trim().isNotEmpty) {
                                  setState(() => _skillsOffered.add(result.trim()));
                                }
                              },
                              backgroundColor: AppColors.primary.withOpacity(0.15),
                              labelStyle: AppTextStyles.body,
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Text('Skills Wanted', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 8,
                          children: [
                            ..._skillsWanted.asMap().entries.map((entry) {
                              final i = entry.key;
                              final skill = entry.value;
                              return Chip(
                                label: Text(skill),
                                deleteIcon: Icon(Icons.close, size: 18),
                                onDeleted: () {
                                  setState(() => _skillsWanted.removeAt(i));
                                },
                                backgroundColor: AppColors.secondary.withOpacity(0.1),
                                labelStyle: AppTextStyles.body,
                              );
                            }),
                            ActionChip(
                              label: Row(children: [Icon(Icons.add, size: 16), Text('Add')]),
                              onPressed: () async {
                                final controller = TextEditingController();
                                final result = await showDialog<String>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    backgroundColor: AppColors.accent,
                                    title: Text('Add Skill Wanted', style: AppTextStyles.heading.copyWith(color: AppColors.primary)),
                                    content: TextField(
                                      controller: controller,
                                      decoration: InputDecoration(
                                        labelText: 'Skill',
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                      ),
                                    ),
                                    actions: [
                                      TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                                        onPressed: () => Navigator.pop(context, controller.text),
                                        child: Text('Add', style: TextStyle(color: Colors.white)),
                                      ),
                                    ],
                                  ),
                                );
                                if (result != null && result.trim().isNotEmpty) {
                                  setState(() => _skillsWanted.add(result.trim()));
                                }
                              },
                              backgroundColor: AppColors.secondary.withOpacity(0.15),
                              labelStyle: AppTextStyles.body,
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        _availabilityDropdown(),
                        const SizedBox(height: 14),
                        _profileTypeDropdown(),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _editableField(String label, TextEditingController controller) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 90,
          child: Text(label, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            controller: controller,
            style: AppTextStyles.body,
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              border: UnderlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _profileTypeDropdown() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 90,
          child: Text('Profile', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
        ),
        const SizedBox(width: 8),
        DropdownButton<bool>(
          value: _isPublic,
          items: const [
            DropdownMenuItem(value: true, child: Text('Public')),
            DropdownMenuItem(value: false, child: Text('Private')),
          ],
          onChanged: (val) => setState(() => _isPublic = val ?? true),
        ),
      ],
    );
  }

  Widget _profilePhotoSection(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 48,
          backgroundColor: AppColors.primary.withOpacity(0.15),
          backgroundImage: widget.profile.profilePhotoUrl != null ? NetworkImage(widget.profile.profilePhotoUrl!) : null,
          child: widget.profile.profilePhotoUrl == null
              ? Icon(Icons.person, size: 48, color: AppColors.primary)
              : null,
        ),
        const SizedBox(height: 8),
        // Remove Add/Edit/Remove buttons
      ],
    );
  }

  Widget _availabilityDropdown() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 90,
          child: Text('Availability', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Row(
            children: [
              DropdownButton<String>(
                value: _selectedAvailability,
                items: _availabilityOptions.map((option) => DropdownMenuItem(
                  value: option,
                  child: Text(option),
                )).toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedAvailability = val;
                    if (val != 'Custom') {
                      _availabilityController.text = val ?? '';
                    }
                  });
                },
              ),
              if (_selectedAvailability == 'Custom')
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: TextField(
                      controller: _availabilityController,
                      style: AppTextStyles.body,
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                        border: UnderlineInputBorder(),
                        hintText: 'Enter availability',
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
