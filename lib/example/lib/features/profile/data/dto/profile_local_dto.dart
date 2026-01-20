import 'package:test_project_weather/example/lib/features/profile/data/gender.dart';

class ProfileLocalDto {
  final String name;
  final int age;
  final Gender gender;

  ProfileLocalDto({
    required this.name,
    required this.age,
    required this.gender,
  });
}
