import 'package:lecturers_appointment/core/functions/sms_api.dart';
import 'package:lecturers_appointment/core/views/custom_dialog.dart';
import 'package:lecturers_appointment/features/appointment/data/appointment_model.dart';
import 'package:lecturers_appointment/features/appointment/services/appointment_services.dart';
import 'package:lecturers_appointment/features/auth/pages/login/state/login_provider.dart';
import 'package:lecturers_appointment/features/auth/pages/register/services/registration_services.dart';
import 'package:faker/faker.dart';
// ignore: implementation_imports
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lecturers_appointment/features/auth/pages/register/data/user_model.dart';
import 'package:intl/intl.dart';

import '../services/lecturer_services.dart';

final lecturersStreamProvider =
    StreamProvider.autoDispose<List<UserModel>>((ref) async* {
  var data = LecturerServices.getLecturers();
  await for (var item in data) {
    ref.read(lecturersFilterProvider.notifier).setItems(item.where((element) {
          return element.userImage.isNotEmpty;
        }).toList());
    yield item;
  }
});

class LecturersFilter {
  List<UserModel> items;
  List<UserModel> filter;
  LecturersFilter({required this.items, this.filter = const []});

  LecturersFilter copyWith({
    List<UserModel>? items,
    List<UserModel>? filter,
  }) {
    return LecturersFilter(
      items: items ?? this.items,
      filter: filter ?? this.filter,
    );
  }
}

final lecturersFilterProvider =
    StateNotifierProvider<LecturersFilterProvider, LecturersFilter>((ref) {
  //return LecturersFilterProvider()..updateData();
  return LecturersFilterProvider();
});

class LecturersFilterProvider extends StateNotifier<LecturersFilter> {
  LecturersFilterProvider() : super(LecturersFilter(items: []));

  void setItems(List<UserModel> items) async {
    state = state.copyWith(items: items, filter: items);
  }

  void filterLecturers(String query) {
    if (query.isEmpty) {
      state = state.copyWith(filter: state.items);
    } else {
      var filtered = state.items.where((element) {
        return element.department.toLowerCase().contains(query.toLowerCase()) ||
            element.userName.toLowerCase().contains(query.toLowerCase());
      }).toList();
      state = state.copyWith(filter: filtered);
    }
  }

  void saveDummyData() async {
    var data = dummyLecturer();
    for (var item in data) {
      item.id = RegistrationServices.getId();
      await RegistrationServices.createUser(item);
    }
  }

  void updateData() async {
    var faker = Faker();
    var data = await LecturerServices.getAllLecturers();
    for (var lecturer in data) {
      lecturer.createdAt = DateTime(
              faker.randomGenerator.integer(2020, min: 2010),
              faker.randomGenerator.integer(12, min: 1),
              faker.randomGenerator.integer(28, min: 1))
          .millisecondsSinceEpoch;
      await RegistrationServices.updateUser(lecturer);
    }
  }
}

final isSearchingProvider = StateProvider<bool>((ref) => false);

final appointmentBookingProvider =
    StateNotifierProvider<SelectedLecturerProvider, AppointmentModel?>(
        (ref) => SelectedLecturerProvider());

class SelectedLecturerProvider extends StateNotifier<AppointmentModel?> {
  SelectedLecturerProvider() : super(null);
  void setLecturer(UserModel lecturer) {
    state = AppointmentModel(
      lecturerId: lecturer.id,
      lecturerName: lecturer.userName,
      lecturerPhone: lecturer.userPhone,
      lecturerImage: lecturer.userImage,
      studentPhone: '',
      date: '',
      time: '',
      status: 'pending',
      studentId: '',
      studentName: '',
      id: '',
    );
  }

  void clear() {
    state = null;
  }

  void setDate(DateTime value) {
    var date = DateFormat('EEE, MMM d, yyyy').format(value);
    state = state!.copyWith(date: date);
  }

  void setTime(String format) {
    state = state!.copyWith(time: format);
  }

  void book({required WidgetRef ref, required BuildContext context}) async {
    CustomDialogs.loading(
      message: 'Booking Appointment...',
    );
    var user = ref.read(userProvider);
    //check if user do not have pending or accepted appointment with the same lecturer
    var existenAppointment = await AppointmentServices.getAppByUserAndLecturer(
        user.id, state!.lecturerId);
    var pendingApp = existenAppointment
        .where((element) =>
            element.status.toLowerCase() == 'pending' ||
            element.status.toLowerCase() == 'accepted')
        .toList();
    if (pendingApp.isNotEmpty) {
      CustomDialogs.dismiss();
      CustomDialogs.showDialog(
        type: DialogType.error,
        message:
            'You already have an appointment with this lecturer, please cancel the existing appointment to book a new one',
      );
      return;
    }
    state = state!.copyWith(
      studentId: user.id,
      studentName: user.userName,
      studentImage: () => user.userImage,
      studentPhone: user.userPhone,
      id: AppointmentServices.getId(),
      createdAt: () => DateTime.now().millisecondsSinceEpoch,
    );
    var result = await AppointmentServices.createAppointment(state!);
    if (result) {
      //send sms notification to lecturer
      await SmsApi().sendMessage(state!.lecturerPhone,
          'You have a new appointment request from ${user.userName} on ${state!.date} at ${state!.time}');

      state = null;
      CustomDialogs.dismiss();
      CustomDialogs.showDialog(
        type: DialogType.success,
        message: 'Appointment booked successfully',
      );
    } else {
      CustomDialogs.dismiss();
      CustomDialogs.showDialog(
        type: DialogType.error,
        message: 'Failed to book appointment, please try again',
      );
    }
  }
}
