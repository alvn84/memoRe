class User {
  final int id;
  final String email;
  final String? gender;
  final String? birthDate;
  final String? job;

  User({
    required this.id,
    required this.email,
    this.gender,
    this.birthDate,
    this.job,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'] ?? '',
      gender: json['gender'],
      birthDate: json['birthDate'],
      job: json['job'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'gender': gender,
      'birthDate': birthDate,
      'job': job,
    };
  }
}