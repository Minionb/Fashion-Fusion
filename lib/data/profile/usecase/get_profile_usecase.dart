import 'package:dartz/dartz.dart';
import 'package:fashion_fusion/error/failures.dart';
import '../repository/profile_repository.dart';

import '../model/profile_model.dart';


class GetProfileUsecase {
  final ProfileRepository repository;
  GetProfileUsecase({required this.repository});
  Future<Either<Failure, ProfileModel>> call(String userID) async {
    return await repository.get(userID);
  }
}
