import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lecturers_appointment/core/views/custom_dialog.dart';
import 'package:lecturers_appointment/core/views/custom_input.dart';
import 'package:lecturers_appointment/features/auth/pages/login/state/login_provider.dart';
import 'package:lecturers_appointment/features/dashboard/state/main_provider.dart';
import 'package:lecturers_appointment/utils/colors.dart';
import 'package:lecturers_appointment/utils/styles.dart';

class AppointmentsPage extends ConsumerStatefulWidget {
  const AppointmentsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AppointmentPageState();
}

class _AppointmentPageState extends ConsumerState<AppointmentsPage> {
  @override
  Widget build(BuildContext context) {
    var user = ref.watch(userProvider);
    var styles = Styles(context);
    var appointmentList = ref.watch(appointmentFilterProvider(
        user.userRole.toLowerCase() != 'admin' ? user.id : null));
    var notifier = ref.read(appointmentFilterProvider(
            user.userRole.toLowerCase() != 'admin' ? user.id : null)
        .notifier);
    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
                width: styles.isDesktop
                    ? styles.width * .5
                    : styles.isMobile
                        ? styles.width * .8
                        : styles.width * 55,
                child: CustomTextFields(
                  hintText: 'Search for Appointment',
                  onChanged: (value) {
                    notifier.filterAppointments(value);
                  },
                  suffixIcon: const Icon(Icons.search),
                )),
          ),
          Expanded(
            child: appointmentList.filter.isEmpty
                ? const Center(child: Text('No Appointment Found'))
                : Padding(
                    padding: const EdgeInsets.all(16),
                    child: DataTable2(
                        columnSpacing: 12,
                        horizontalMargin: 12,
                        headingRowColor: WidgetStateProperty.all(primaryColor),
                        minWidth: 1200,
                        columns: [
                          DataColumn2(
                            label: Text(
                              'DARE',
                              style: styles.subtitle(color: Colors.white),
                            ),
                            size: ColumnSize.S,
                          ),
                          DataColumn2(
                              label: Text(
                                'DOCTOR',
                                style: styles.subtitle(color: Colors.white),
                              ),
                              size: ColumnSize.L),
                          DataColumn(
                            label: Text(
                              'student',
                              style: styles.subtitle(color: Colors.white),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'STATUS',
                              style: styles.subtitle(color: Colors.white),
                            ),
                          ),
                          DataColumn2(
                              label: Text(
                                'TIME',
                                style: styles.subtitle(color: Colors.white),
                              ),
                              numeric: false,
                              size: ColumnSize.S),
                          if (user.userRole.toLowerCase() != 'admin')
                            DataColumn2(
                                label: Text(
                                  'ACTION',
                                  style: styles.subtitle(color: Colors.white),
                                ),
                                numeric: false,
                                size: ColumnSize.L),
                        ],
                        rows: appointmentList.filter.isNotEmpty
                            ? appointmentList.filter.map((appointment) {
                                return DataRow(cells: [
                                  DataCell(Text(appointment.date)),
                                  DataCell(Text(
                                      appointment.lecturerId == user.id
                                          ? 'Me'
                                          : appointment.lecturerName)),
                                  DataCell(Text(appointment.studentId == user.id
                                      ? 'Me'
                                      : appointment.studentName)),
                                  DataCell(Container(
                                      width: 122,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                      decoration: BoxDecoration(
                                          color: appointment.status
                                                      .toLowerCase() ==
                                                  'cancelled'
                                              ? Colors.red.withOpacity(.8)
                                              : appointment.status
                                                          .toLowerCase() ==
                                                      'pending'
                                                  ? Colors.grey.withOpacity(.8)
                                                  : Colors.green
                                                      .withOpacity(.8),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Text(
                                        appointment.status,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ))),
                                  DataCell(Text(appointment.time)),
                                  if (user.userRole.toLowerCase() != 'admin')
                                    DataCell(ref.watch(
                                                    selectedAppointmentProvider) !=
                                                null &&
                                            appointment.id ==
                                                ref
                                                    .watch(
                                                        selectedAppointmentProvider)!
                                                    .id
                                        ? Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Expanded(
                                                child: CustomTextFields(
                                                  controller: TextEditingController(
                                                      text: ref
                                                          .watch(
                                                              newDateTimeProvider)
                                                          .date),
                                                  hintText: 'Date',
                                                  onTap: () async {
                                                    var date =
                                                        await showDatePicker(
                                                      context: context,
                                                      initialDate:
                                                          DateTime.now(),
                                                      firstDate: DateTime.now(),
                                                      lastDate: DateTime.now()
                                                          .add(const Duration(
                                                              days: 365)),
                                                    );
                                                    if (date != null) {
                                                      ref
                                                              .read(
                                                                  newDateTimeProvider
                                                                      .notifier)
                                                              .state =
                                                          ref
                                                              .watch(
                                                                  newDateTimeProvider)
                                                              .copyWith(
                                                                  date: DateFormat(
                                                                          'EEE,MMM dd, yyyy')
                                                                      .format(
                                                                          date));
                                                    }
                                                  },
                                                ),
                                              ),
                                              const SizedBox(width: 5),
                                              Expanded(
                                                child: CustomTextFields(
                                                  controller: TextEditingController(
                                                      text: ref
                                                          .watch(
                                                              newDateTimeProvider)
                                                          .time),
                                                  hintText: 'Time',
                                                  onTap: () async {
                                                    var time =
                                                        await showTimePicker(
                                                      context: context,
                                                      initialTime:
                                                          TimeOfDay.now(),
                                                    );
                                                    if (time != null) {
                                                      ref
                                                              .read(
                                                                  newDateTimeProvider
                                                                      .notifier)
                                                              .state =
                                                          ref
                                                              .watch(
                                                                  newDateTimeProvider)
                                                              .copyWith(
                                                                  time: time.format(
                                                                      context));
                                                    }
                                                  },
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(2.0),
                                                child: Column(
                                                  children: [
                                                    InkWell(
                                                        onTap: () {
                                                          if (ref
                                                                  .watch(
                                                                      newDateTimeProvider)
                                                                  .date
                                                                  .isEmpty ||
                                                              ref
                                                                  .watch(
                                                                      newDateTimeProvider)
                                                                  .time
                                                                  .isEmpty) {
                                                            CustomDialogs.showDialog(
                                                                message:
                                                                    'Please select a date and time to reschedule the appointment.',
                                                                type: DialogType
                                                                    .error);
                                                            return;
                                                          }
                                                          ref
                                                              .read(
                                                                  selectedAppointmentProvider
                                                                      .notifier)
                                                              .reschedule(
                                                                  ref: ref);
                                                        },
                                                        child: const Text(
                                                            'Reschedule')),
                                                    const SizedBox(height: 2),
                                                    InkWell(
                                                        onTap: () {
                                                          ref
                                                              .read(
                                                                  selectedAppointmentProvider
                                                                      .notifier)
                                                              .clear();
                                                        },
                                                        child: const Text(
                                                          'Cancel',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red),
                                                        ))
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )
                                        : appointment.status.toLowerCase() !=
                                                    'cancelled' &&
                                                appointment.status
                                                        .toLowerCase() !=
                                                    'completed'
                                            ? PopupMenuButton(
                                                itemBuilder: (context) {
                                                  return [
                                                    //mark as completed
                                                    if (appointment.status
                                                                .toLowerCase() !=
                                                            'completed' &&
                                                        appointment.status
                                                                .toLowerCase() !=
                                                            'cancelled')
                                                      const PopupMenuItem(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 10,
                                                                right: 20),
                                                        value: 'completed',
                                                        child: ListTile(
                                                          title: Text(
                                                              'Mark Completed'),
                                                          leading: Icon(
                                                            Icons.check,
                                                            color: Colors.green,
                                                          ),
                                                        ),
                                                      ),
                                                    //cancel appointment
                                                    if (appointment.status
                                                                .toLowerCase() !=
                                                            'cancelled' &&
                                                        appointment.status
                                                                .toLowerCase() !=
                                                            'completed')
                                                      const PopupMenuItem(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 10,
                                                                right: 20),
                                                        value: 'cancel',
                                                        child: ListTile(
                                                          title: Text('Cancel'),
                                                          leading: Icon(
                                                            Icons.cancel,
                                                            color: Colors.red,
                                                          ),
                                                        ),
                                                      ),
                                                    //reschedule appointment
                                                    if (appointment.status
                                                                .toLowerCase() !=
                                                            'cancelled' &&
                                                        appointment.status
                                                                .toLowerCase() !=
                                                            'completed')
                                                      const PopupMenuItem(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 10,
                                                                right: 20),
                                                        value: 'reschedule',
                                                        child: ListTile(
                                                          title: Text(
                                                              'Reschedule'),
                                                          leading: Icon(
                                                            Icons
                                                                .calendar_today,
                                                            color: Colors.blue,
                                                          ),
                                                        ),
                                                      ),
                                                    if (appointment.status
                                                                .toLowerCase() ==
                                                            'pending' &&
                                                        appointment
                                                                .lecturerId ==
                                                            user.id)
                                                      const PopupMenuItem(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 10,
                                                                right: 20),
                                                        value: 'accept',
                                                        child: ListTile(
                                                          title: Text('Accept'),
                                                          leading: Icon(
                                                            Icons.check,
                                                            color: Colors.green,
                                                          ),
                                                        ),
                                                      ),
                                                  ];
                                                },
                                                onSelected: (value) {
                                                  if (value == 'cancel') {
                                                    CustomDialogs.showDialog(
                                                        message:
                                                            'Are you sure you want to cancel this appointment?',
                                                        secondBtnText: 'Cancel',
                                                        type:
                                                            DialogType.warning,
                                                        onConfirm: () {
                                                          ref
                                                              .read(appointmentFilterProvider(
                                                                      user.id)
                                                                  .notifier)
                                                              .cancelAppointment(
                                                                  appointment,
                                                                  user);
                                                        });
                                                  } else if (value ==
                                                      'reschedule') {
                                                    //show reschedule dialog
                                                    ref
                                                        .read(
                                                            selectedAppointmentProvider
                                                                .notifier)
                                                        .setAppointment(
                                                            appointment);
                                                  } else if (value ==
                                                      'accept') {
                                                    CustomDialogs.showDialog(
                                                        message:
                                                            'Are you sure you want to accept this appointment?',
                                                        secondBtnText: 'Accept',
                                                        type:
                                                            DialogType.warning,
                                                        onConfirm: () {
                                                          ref
                                                              .read(appointmentFilterProvider(
                                                                      user.id)
                                                                  .notifier)
                                                              .acceptAppointment(
                                                                  appointment,
                                                                  user);
                                                        });
                                                  } else if (value ==
                                                      'completed') {
                                                    CustomDialogs.showDialog(
                                                        message:
                                                            'Are you sure you want to mark this appointment as completed?',
                                                        secondBtnText:
                                                            'Completed',
                                                        type:
                                                            DialogType.warning,
                                                        onConfirm: () {
                                                          ref
                                                              .read(appointmentFilterProvider(
                                                                      user.id)
                                                                  .notifier)
                                                              .completeAppointment(
                                                                  appointment,
                                                                  user);
                                                        });
                                                  }
                                                },
                                                child: const Icon(Icons.apps),
                                              )
                                            : const SizedBox.shrink())
                                ]);
                              }).toList()
                            : []),
                  ),
          ),
          
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
