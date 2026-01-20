import 'package:test_project_weather/example/lib/features/profile/data/datasources/profile_local_data_source.dart';
import 'package:test_project_weather/example/lib/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:test_project_weather/example/lib/features/profile/data/models/profile_model.dart';
import 'package:test_project_weather/example/lib/features/profile/data/models/rating_model.dart';

class ProfileRepository {
  final ProfileRemoteDataSource _profileRemoteDataSource;
  final ProfileLocalDataSource _profileLocalDataSource;

  ProfileRepository({
    required ProfileRemoteDataSource profileRemoteDataSource,
    required ProfileLocalDataSource profileLocalDataSource,
  }) : _profileRemoteDataSource = profileRemoteDataSource,
       _profileLocalDataSource = profileLocalDataSource;

  Future<ProfileModel> getProfile() async {
    final remoteProfileDto = await _profileRemoteDataSource.getProfile();
    final localProfileDto = await _profileLocalDataSource.getProfile();

    return ProfileModel(
      name: remoteProfileDto.name,
      age: remoteProfileDto.age,
      gender: localProfileDto.gender,
    );
  }

  Future<RatingModel> getRating() async {
    final rating = await _profileRemoteDataSource.getRating();
    await _profileLocalDataSource.setRating(rating);

    return rating;
  }
}
