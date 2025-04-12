import 'dart:io';

import 'package:belog/core/common/entities/user.dart';
import 'package:belog/core/error/failures.dart';
import 'package:fpdart/fpdart.dart';

abstract class UserRepository {
  Future<Either<Failure, User>> editUserInfo(
      {required String userId,
      required String name,
      required String email,
      required File? avatar,
      required String website});

  Future<Either<Failure, void>> changeEmail(String newEmail);
  Future<Either<Failure, void>> resetPassword(String newPassword);
}
