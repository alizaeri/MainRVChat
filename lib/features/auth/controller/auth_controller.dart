import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rvchat/models/user_model.dart';

import '../repository/auth_repository.dart';

final authControllerProvider = Provider((ref) {
  final authRepository = ref.watch(AuthRepositoryProvider);
  return AuthController(authRepository: authRepository, ref: ref);
});
final userDataAuthProvider = FutureProvider((ref) {
  final AuthController = ref.watch(authControllerProvider);
  return AuthController.getUserData();
});

class AuthController {
  final ProviderRef ref;
  final AuthRepository authRepository;
  AuthController({required this.authRepository, required this.ref});

  void singInWithPhone(BuildContext context, String phoneNumber) {
    authRepository.signInWithPhone(context, phoneNumber);
  }

  void verifyOTP(BuildContext context, String verficationID, String userOTP) {
    authRepository.verifyOTP(
        context: context, verficationID: verficationID, userOTP: userOTP);
  }

  void saveUserDataToFirebase(
      BuildContext context, String name, File? profilePic, String defPic) {
    authRepository.saveUserDataToFirebase(
        name: name,
        profilePic: profilePic,
        ref: ref,
        context: context,
        defPic: defPic);
  }

  Future<UserModel?> getUserData() async {
    UserModel? user = await authRepository.getCurrentUserData();
    return user;
  }

  Stream<UserModel> userDataById(String userId) {
    return authRepository.userData(userId);
  }

  void setUserState(bool isOnline) {
    authRepository.setUserState(isOnline);
  }

  void setUserRandomState(bool rVChat) {
    authRepository.setUserRandomState(rVChat);
    print('????? marhaleye aval');
  }
}
