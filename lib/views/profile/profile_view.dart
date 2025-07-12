import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/text_styles.dart';
import '../../models/user_profile.dart';

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
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _availabilityController.dispose();
    super.dispose();
  }

  void _addSkillDialog({required bool offered}) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Skill'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(hintText: 'Skill name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final skill = controller.text.trim();
              if (skill.isNotEmpty) {
                setState(() {
                  if (offered) {
                    _skillsOffered.add(skill);
                  } else {
                    _skillsWanted.add(skill);
                  }
                });
              }
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _editSkillDialog({required bool offered, required int index}) {
    final controller = TextEditingController(text: offered ? _skillsOffered[index] : _skillsWanted[index]);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Skill'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(hintText: 'Skill name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final skill = controller.text.trim();
              if (skill.isNotEmpty) {
                setState(() {
                  if (offered) {
                    _skillsOffered[index] = skill;
                  } else {
                    _skillsWanted[index] = skill;
                  }
                });
              }
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
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
                onPressed: () {
                  // Save logic: create new UserProfile and call onSave
                  final updatedProfile = UserProfile(
                    name: _nameController.text,
                    location: _locationController.text,
                    profilePhotoUrl: widget.profile.profilePhotoUrl,
                    skillsOffered: List<String>.from(_skillsOffered),
                    skillsWanted: List<String>.from(_skillsWanted),
                    availability: _selectedAvailability == 'Custom'
                        ? _availabilityController.text
                        : _selectedAvailability ?? '',
                    isPublic: _isPublic,
                    rating: widget.profile.rating,
                  );
                  if (widget.onSave != null) {
                    widget.onSave!(updatedProfile);
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Profile saved!')),
                  );
                },
                child: Text('Save', style: AppTextStyles.body.copyWith(color: Colors.green, fontWeight: FontWeight.bold)),
              ),
              TextButton(
                onPressed: () {},
                child: Text('Discard', style: AppTextStyles.body.copyWith(color: AppColors.secondary, fontWeight: FontWeight.bold)),
              ),
              TextButton(
                onPressed: () {},
                child: Text('Swap request', style: AppTextStyles.body.copyWith(decoration: TextDecoration.underline)),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Home', style: AppTextStyles.body.copyWith(decoration: TextDecoration.underline)),
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
                        Row(
                          children: [
                            Expanded(child: _skillsSection('Skills Offered', _skillsOffered, true)),
                            const SizedBox(width: 12),
                            Expanded(child: _skillsSection('Skills wanted', _skillsWanted, false)),
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

  Widget _skillsSection(String label, List<String> skills, bool offered) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(width: 6),
            IconButton(
              icon: const Icon(Icons.add_circle_outline, size: 20),
              color: AppColors.primary,
              tooltip: 'Add Skill',
              onPressed: () => _addSkillDialog(offered: offered),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: List.generate(skills.length, (i) => InputChip(
            label: Text(skills[i], style: AppTextStyles.body.copyWith(color: offered ? Colors.white : AppColors.primary)),
            backgroundColor: offered ? AppColors.primary : Colors.white,
            shape: StadiumBorder(side: BorderSide(color: AppColors.primary)),
            onDeleted: () => setState(() => skills.removeAt(i)),
            deleteIcon: const Icon(Icons.close, size: 16),
            onPressed: () => _editSkillDialog(offered: offered, index: i),
          )),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {},
              child: Text('Add/Edit', style: AppTextStyles.body.copyWith(color: AppColors.primary)),
            ),
            TextButton(
              onPressed: () {},
              child: Text('Remove', style: AppTextStyles.body.copyWith(color: AppColors.secondary)),
            ),
          ],
        ),
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
