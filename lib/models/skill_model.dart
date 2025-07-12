class Skill {
  final int? id;
  final String name;

  Skill({
    this.id,
    required this.name,
  });

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      id: json['id'],
      name: json['skill_name'] ?? json['Skill_name'] ?? json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'skill_name': name,
    };
  }

  Skill copyWith({
    int? id,
    String? name,
  }) {
    return Skill(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
} 