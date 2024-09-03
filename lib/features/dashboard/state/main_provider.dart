import 'package:lecturers_appointment/core/functions/sms_api.dart';
import 'package:lecturers_appointment/features/auth/pages/login/state/login_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lecturers_appointment/core/views/custom_dialog.dart';
import 'package:lecturers_appointment/features/appointment/data/appointment_model.dart';
import 'package:lecturers_appointment/features/appointment/services/appointment_services.dart';
import 'package:lecturers_appointment/features/auth/pages/register/data/user_model.dart';
import 'package:lecturers_appointment/features/auth/pages/register/services/registration_services.dart';

import '../../home/services/lecturer_services.dart';

final adminLecturerStreamProvider = StreamProvider<List<UserModel>>((ref) async* {
  var data = LecturerServices.getLecturersByAdmin();
  await for (var item in data) {
    ref.read(lecturerFilterProvider.notifier).setItems(item);
    yield item;
  }
});

class LecturerFilter {
  List<UserModel> items;
  List<UserModel> filteredList;
  LecturerFilter({
    this.items = const [],
    this.filteredList = const [],
  });

  LecturerFilter copyWith({
    List<UserModel>? items,
    List<UserModel>? filteredList,
  }) {
    return LecturerFilter(
      items: items ?? this.items,
      filteredList: filteredList ?? this.filteredList,
    );
  }
}

final lecturerFilterProvider =
    StateNotifierProvider<LecturerFilterProvider, LecturerFilter>((ref) {
  return LecturerFilterProvider();
});

class LecturerFilterProvider extends StateNotifier<LecturerFilter> {
  LecturerFilterProvider() : super(LecturerFilter(items: [], filteredList: []));

  void setItems(List<UserModel> items) async {
    state = state.copyWith(items: items, filteredList: items);
  }

  void filterLecturers(String query) {
    if (query.isEmpty) {
    } else {
      var filtered = state.items.where((element) {
       
        return element.department.toLowerCase().contains(query.toLowerCase()) ||
            element.userName.toLowerCase().contains(query.toLowerCase());
      }).toList();
      state = state.copyWith(filteredList: filtered);
    }
  }

  void updateLecturer(UserModel lecturer, String status) async {
    CustomDialogs.dismiss();
    CustomDialogs.loading(
        message: status == 'banned'
            ? 'Blocking Lecturer...'
            : 'Unblocking Lecturer...');
    lecturer = lecturer.copyWith(userStatus:  status);
    var res = await RegistrationServices.updateUser(lecturer);
    if (res) {
      //send notification to lecturer
      var phone = lecturer.userPhone;
      var message = status == 'banned'
          ? 'Your Account has been Blocked.You can no longer access the Lecturer-Student Appointment Platform. Contact Admin for more information'
          : 'Your Account has been Unblocked. You can now access the Lecturer-Student Appointment Platform';
      await SmsApi().sendMessage(phone, message);
      state = state.copyWith(
          filteredList: state.filteredList
              .map((e) => e.id == lecturer.id ? lecturer : e)
              .toList(),
          items: state.items
              .map((e) => e.id == lecturer.id ? lecturer : e)
              .toList());
      CustomDialogs.dismiss();
      CustomDialogs.toast(
          message: status == 'banned'
              ? 'Lecturer Banned Successfully'
              : 'Lecturer Unbanned Successfully',
          type: DialogType.success);
    } else {
      CustomDialogs.dismiss();
      CustomDialogs.toast(
          message: status == 'banned'
              ? 'Failed to Band Lecturer'
              : 'Failed to Unbanned Lecturer',
          type: DialogType.error);
    }
  }
}

final adminStudentStreamProvider =
    StreamProvider<List<UserModel>>((ref) async* {
  var data = RegistrationServices.getStudents();
  await for (var item in data) {
    ref.read(studentFilterProvider.notifier).setItems(item);
    yield item;
  }
});

class StudentFilter {
  List<UserModel> items;
  List<UserModel> filteredList;
  StudentFilter({
    this.items = const [],
    this.filteredList = const [],
  });

  StudentFilter copyWith({
    List<UserModel>? items,
    List<UserModel>? filteredList,
  }) {
    return StudentFilter(
      items: items ?? this.items,
      filteredList: filteredList ?? this.filteredList,
    );
  }
}

final studentFilterProvider =
    StateNotifierProvider<StudentFilterProvider, StudentFilter>((ref) {
  return StudentFilterProvider();
});

class StudentFilterProvider extends StateNotifier<StudentFilter> {
  StudentFilterProvider() : super(StudentFilter(items: [], filteredList: []));

  void setItems(List<UserModel> items) async {
    state = state.copyWith(items: items, filteredList: items);
  }

  void filterStudent(String query) {
    if (query.isEmpty) {
      state = state.copyWith(filteredList: state.items);
    } else {
      var filtered = state.items.where((element) {
        return element.userName.toLowerCase().contains(query.toLowerCase());
      }).toList();

      state = state.copyWith(filteredList: filtered);
    }
  }

  void updateStudent(UserModel student, String status) async {
    CustomDialogs.dismiss();
    CustomDialogs.loading(
        message: status == 'banned'
            ? 'Blocking student...'
            : 'Unblocking student...');
    student = student.copyWith(userStatus:status);
    var res = await RegistrationServices.updateUser(student);
    if (res) {
      state = state.copyWith(
          filteredList: state.filteredList
              .map((e) => e.id == student.id ? student : e)
              .toList(),
          items: state.items
              .map((e) => e.id == student.id ? student : e)
              .toList());
      CustomDialogs.dismiss();
      CustomDialogs.toast(
          message: status == 'banned'
              ? 'student Banned Successfully'
              : 'student Unbanned Successfully',
          type: DialogType.success);
    } else {
      CustomDialogs.dismiss();
      CustomDialogs.toast(
          message: status == 'banned'
              ? 'Failed to Band student'
              : 'Failed to Unbanned student',
          type: DialogType.error);
    }
  }
}

final adminAppointmentStreamProvider =
    StreamProvider<List<AppointmentModel>>((ref) async* {
  var data = AppointmentServices.getAllAppointments();
  await for (var item in data) {
    ref.read(allAppointmentsProvider.notifier).state = item;
    yield item;
  }
});

class AppointmentFilter {
  List<AppointmentModel> items;
  List<AppointmentModel> filter;

  AppointmentFilter({
    this.items = const [],
    this.filter = const [],
  });

  AppointmentFilter copyWith({
    List<AppointmentModel>? items,
    List<AppointmentModel>? filter,
  }) {
    return AppointmentFilter(
      items: items ?? this.items,
      filter: filter ?? this.filter,
    );
  }
}

final allAppointmentsProvider = StateProvider<List<AppointmentModel>>((ref) {
  return [];
});

final appointmentFilterProvider = StateNotifierProvider.family<
    AppointmentFilterProvider, AppointmentFilter, String?>((ref, id) {
  var data = ref.watch(allAppointmentsProvider);
  if (id != null && id.isNotEmpty) {
    var items = data
        .where((element) => element.studentId == id || element.lecturerId == id)
        .toList();
    return AppointmentFilterProvider()..setItems(items);
  }
  return AppointmentFilterProvider()..setItems(data);
});

class AppointmentFilterProvider extends StateNotifier<AppointmentFilter> {
  AppointmentFilterProvider() : super(AppointmentFilter(items: []));

  void setItems(List<AppointmentModel> items) async {
    state = state.copyWith(items: items, filter: items);
  }

  void filterAppointments(String query) {
    if (query.isEmpty) {
      state = state.copyWith(filter: state.items);
    } else {
      var filtered = state.items.where((element) {
        return element.studentName
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            element.lecturerName.toLowerCase().contains(query.toLowerCase());
      }).toList();
      state = state.copyWith(filter: filtered);
    }
  }

  void cancelAppointment(AppointmentModel appointment, UserModel user) async {
    CustomDialogs.dismiss();
    CustomDialogs.loading(message: 'Cancelling Appointment');
    var data = await AppointmentServices.updateAppointment(
        appointment.id, {'status': 'cancelled'});

    if (data) {
      //send notification to student
      var phone = appointment.studentId == user.id
          ? appointment.lecturerPhone
          : appointment.studentPhone;
      var toWho = appointment.studentId == user.id
          ? appointment.studentName
          : appointment.lecturerName;
      var message = 'Your Appointment with $toWho has been cancelled';
      await SmsApi().sendMessage(phone, message);
      state = state.copyWith(
          items: state.items
              .map((e) => e.id == appointment.id
                  ? appointment.copyWith(status: 'cancelled')
                  : e)
              .toList());
      CustomDialogs.dismiss();
      CustomDialogs.dismiss();
      CustomDialogs.toast(
          message: 'Appointment Cancelled', type: DialogType.success);
    } else {
      CustomDialogs.dismiss();
      CustomDialogs.toast(
          message: 'Failed to Cancel Appointment', type: DialogType.error);
    }
  }

  void acceptAppointment(AppointmentModel appointment, UserModel user) async {
    CustomDialogs.dismiss();
    CustomDialogs.loading(message: 'Accepting Appointment');
    var data = await AppointmentServices.updateAppointment(
        appointment.id, {'status': 'accepted'});

    if (data) {
      var phone = appointment.studentId == user.id
          ? appointment.lecturerPhone
          : appointment.studentPhone;
      var toWho = appointment.studentId == user.id
          ? appointment.studentName
          : appointment.lecturerName;
      var message = 'Your Appointment with $toWho has been Accepted';
      await SmsApi().sendMessage(phone, message);
      state = state.copyWith(
          items: state.items
              .map((e) => e.id == appointment.id
                  ? appointment.copyWith(status: 'accepted')
                  : e)
              .toList());
      CustomDialogs.dismiss();
      CustomDialogs.toast(
          message: 'Appointment Accepted', type: DialogType.success);
    } else {
      CustomDialogs.dismiss();
      CustomDialogs.toast(
          message: 'Failed to Accept Appointment', type: DialogType.error);
    }
  }

  void completeAppointment(AppointmentModel appointment, UserModel user) async {
    CustomDialogs.dismiss();
    CustomDialogs.loading(message: 'Completing Appointment..');
    var data = await AppointmentServices.updateAppointment(
        appointment.id, {'status': 'completed'});
    if (data) {
      //send notification to student
      var phone = appointment.studentId == user.id
          ? appointment.lecturerPhone
          : appointment.studentPhone;
      var toWho = appointment.studentId == user.id
          ? appointment.studentName
          : appointment.lecturerName;
      var message = 'Your Appointment with $toWho has been Completed';
      await SmsApi().sendMessage(phone, message);
      CustomDialogs.dismiss();
      state = state.copyWith(
          items: state.items
              .map((e) => e.id == appointment.id
                  ? appointment.copyWith(status: 'completed')
                  : e)
              .toList());
      CustomDialogs.dismiss();
      CustomDialogs.toast(
          message: 'Appointment Completed', type: DialogType.success);
    } else {
      CustomDialogs.dismiss();
      CustomDialogs.toast(
          message: 'Failed to Complete Appointment', type: DialogType.error);
    }
  }
}

final newDateTimeProvider = StateProvider<NewDateTime>((ref) {
  return NewDateTime(date: '', time: '');
});

final isRescheduleProvider = StateProvider<bool>((ref) => false);

final selectedAppointmentProvider =
    StateNotifierProvider<RescheduleApp, AppointmentModel?>((ref) {
  return RescheduleApp();
});

class RescheduleApp extends StateNotifier<AppointmentModel?> {
  RescheduleApp() : super(null);
  void setAppointment(AppointmentModel appointment) {
    state = appointment;
  }

  void clear() {
    state = null;
  }

  void reschedule({required WidgetRef ref}) async {
    CustomDialogs.loading(message: 'Rescheduling Appointment');
    var data = ref.read(newDateTimeProvider);
    var user = ref.read(userProvider);
    var appointment = state!.copyWith(date: data.date, time: data.time);
    var res = await AppointmentServices.updateAppointment(appointment.id, {
      'date': data.date,
      'time': data.time,
    });

    if (res) {
      var phone = appointment.studentId == user.id
          ? appointment.lecturerPhone
          : appointment.studentPhone;
      var toWho = appointment.studentId == user.id
          ? appointment.studentName
          : appointment.lecturerName;
      var message =
          'Your Appointment with $toWho has been Rescheduled to ${data.date} at ${data.time}';
      await SmsApi().sendMessage(phone, message);
      clear();
      CustomDialogs.dismiss();
      CustomDialogs.toast(
          message: 'Appointment Rescheduled', type: DialogType.success);
    } else {
      CustomDialogs.dismiss();
      CustomDialogs.toast(
          message: 'Failed to Reschedule Appointment', type: DialogType.error);
    }
  }
}

class NewDateTime {
  String date;
  String time;
  NewDateTime({
    required this.date,
    required this.time,
  });

  NewDateTime copyWith({
    String? date,
    String? time,
  }) {
    return NewDateTime(
      date: date ?? this.date,
      time: time ?? this.time,
    );
  }
}



