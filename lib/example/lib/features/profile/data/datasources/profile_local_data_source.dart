import 'package:test_project_weather/example/lib/core/my_local_storage.dart';
import 'package:test_project_weather/example/lib/features/profile/data/dto/profile_local_dto.dart';
import 'package:test_project_weather/example/lib/features/profile/data/gender.dart';
import 'package:test_project_weather/example/lib/features/profile/data/models/profile_model.dart';
import 'package:test_project_weather/example/lib/features/profile/data/models/rating_model.dart';

class ProfileLocalDataSource {
  final MyLocalStorage _myLocalStorage;

  ProfileLocalDataSource({
    required MyLocalStorage myLocalStorage,
  }) : _myLocalStorage = myLocalStorage;

  Future<void> setProfile(ProfileModel profile) async {
    await _myLocalStorage.set('profile', profile.toString());
  }

  Future<ProfileLocalDto> getProfile() async {
    await _myLocalStorage.get('profile');

    return ProfileLocalDto(name: 'John Doe', age: 30, gender: Gender.male);
  }

  Future<void> setRating(RatingModel rating) async {
    await _myLocalStorage.set('rating', rating.toString());
  }
}
