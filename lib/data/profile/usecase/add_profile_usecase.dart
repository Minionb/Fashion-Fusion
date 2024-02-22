import 'package:dartz/dartz.dart';
import 'package:fashion_fusion/error/failures.dart';
import '../repository/profile_repository.dart';
import '../model/upload_profile_model.dart';

class AddProfileUsecase {
  final ProfileRepository repository;
  AddProfileUsecase({required this.repository});
  Future<Either<Failure, ResponseUploadProfileModel>> call(UploadProfileModel model) async {
    return await repository.add(model);
  }
}
