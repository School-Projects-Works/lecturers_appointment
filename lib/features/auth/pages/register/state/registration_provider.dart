import 'dart:typed_data';

import 'package:lecturers_appointment/config/router.dart';
import 'package:lecturers_appointment/config/routes/router_item.dart';
import 'package:lecturers_appointment/core/views/custom_dialog.dart';
import 'package:lecturers_appointment/features/auth/pages/register/data/user_model.dart';
import 'package:lecturers_appointment/features/auth/pages/register/services/registration_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userRegistrationProvider =
    StateNotifierProvider<UserRegistrationProvider, UserModel>((ref) {
  return UserRegistrationProvider();
});

class UserRegistrationProvider extends StateNotifier<UserModel> {
  UserRegistrationProvider() : super(UserModel.empty());

  void setEmail(String email) {
    state = state.copyWith(email: email);
  }

  void setDepartment(department) {
    state = state.copyWith(department: department);
  }

  void setPassword(String password) {
    state = state.copyWith(password: password);
  }

  void setUserRole(String? value) {
    state = state.copyWith(userRole: value);
  }

  void setName(String s) {
    state = state.copyWith(userName: s);
  }

  void setGender(value) {
    state = state.copyWith(userGender: value);
  }

  void setPhone(String s) {
    state = state.copyWith(userPhone: s);
  }

  void reset() {
    state = UserModel.empty();
  }

  void register(
      {required WidgetRef ref,
      required BuildContext context,
      required Uint8List image}) async {
    CustomDialogs.loading(message: 'Registering User');
    var url = await RegistrationServices.uploadImage(image);
    var user = state;
    if (state.userRole == 'Student') {
      user = state.copyWith(
        userMetaData: ref.watch(regStudentMetaDataProvider).toMap(),
      );
    } else {
      user = state.copyWith(
        officeAddress: ref.watch(regOfficeAddressProvider).toMap(),
      );
    }
    user = user.copyWith(
      userStatus: 'available',
      userImage: url,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );
    user.createdAt = DateTime.now().millisecondsSinceEpoch;
    user.id = RegistrationServices.getId();
    var (message, createdUser) = await RegistrationServices.registerUser(user);
    if (createdUser != null) {
      await RegistrationServices.signOut();
      reset();
      ref.read(regOfficeAddressProvider.notifier).reset();
      CustomDialogs.dismiss();
      CustomDialogs.toast(
          message: '$message. Please verify your email',
          type: DialogType.success);
      MyRouter(context: context, ref: ref)
          .navigateToRoute(RouterItem.loginRoute);
    } else {
      CustomDialogs.dismiss();
      CustomDialogs.toast(message: message, type: DialogType.error);
    }
  }
}

final regOfficeAddressProvider =
    StateNotifierProvider<RegAddressProvider, LecturerOfficeAddress>((ref) {
  return RegAddressProvider();
});

class RegAddressProvider extends StateNotifier<LecturerOfficeAddress> {
  RegAddressProvider() : super(LecturerOfficeAddress.empty());

  void reset() {
    state = LecturerOfficeAddress.empty();
  }

  void setBuilding(String s) {
    state = state.copyWith(building: s);
  }

  void setFloor(String s) {
    state = state.copyWith(floor: s);
  }

  void setOfficeNumber(String s) {
    state = state.copyWith(officeNumber: s);
  }
}

final regStudentMetaDataProvider =
    StateNotifierProvider<RegMetaStudentDataProvider, StudentMetaData>((ref) {
  return RegMetaStudentDataProvider();
});

class RegMetaStudentDataProvider extends StateNotifier<StudentMetaData> {
  RegMetaStudentDataProvider() : super(StudentMetaData());

  void setLevel(value) {
    state = state.copyWith(level: value);
  }

  void setProgram(String s) {
    state = state.copyWith(program: s);
  }
}

final regPagesProvider = StateProvider<int>((ref) => 0);
