import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repository/auth_repository.dart';

final authControllerProvider = Provider((ref) {
  final authRepository = ref.watch(AuthRepositoryProvider);
  return AuthController(authRepository: authRepository, ref: ref);
});

class AuthController {
  final ProviderRef ref;
  final AuthRepository authRepository;
  AuthController({required this.authRepository, required this.ref});

  void singInWithPhone(BuildContext context, String phoneNumber) {
    authRepository.signInWithPhone(context, phoneNumber);
  }

  void verfiyOTP(BuildContext context, String verficationID, String userOTP) {
    authRepository.verifyOTP(
        context: context, verficationID: verficationID, userOTP: userOTP);
  }

  void saveUserDataToFirebase(
      BuildContext context, String name, File? profilePic) {
    authRepository.saveUserDataToFirebase(
        name: name, profilePic: profilePic, ref: ref, context: context);
  }
}
