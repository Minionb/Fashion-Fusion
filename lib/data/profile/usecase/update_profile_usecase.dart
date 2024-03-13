import 'package:dartz/dartz.dart';
import 'package:fashion_fusion/data/profile/model/upload_profile_model.dart';
import 'package:fashion_fusion/error/failures.dart';
import '../repository/profile_repository.dart';


class UpdateProfileUsecase {
  final ProfileRepository repository;
  UpdateProfileUsecase({required this.repository});
  Future<Either<Failure, Unit>> call(UploadProfileModel model, String userID) async {
    return await repository.update(model, userID);
  }
}
