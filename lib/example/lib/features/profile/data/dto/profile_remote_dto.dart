class ProfileRemoteDto {
  final String name;
  final int age;

  ProfileRemoteDto({
    required this.name,
    required this.age,
  });

  factory ProfileRemoteDto.fromJson(Map<String, dynamic> json) {
    return ProfileRemoteDto(
      name: json['name'],
      age: json['age'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
    };
  }
}
