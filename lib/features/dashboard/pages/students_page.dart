import 'package:data_table_2/data_table_2.dart';
import 'package:image_network/image_network.dart';
import 'package:lecturers_appointment/core/views/custom_dialog.dart';
import 'package:lecturers_appointment/core/views/custom_input.dart';
import 'package:lecturers_appointment/features/auth/pages/register/data/user_model.dart';
import 'package:lecturers_appointment/features/dashboard/pages/view_user.dart';
import 'package:lecturers_appointment/features/dashboard/state/main_provider.dart';
import 'package:lecturers_appointment/generated/assets.dart';
import 'package:lecturers_appointment/utils/colors.dart';
import 'package:lecturers_appointment/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class StudentsPage extends ConsumerStatefulWidget {
  const StudentsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StudentsPageState();
}

class _StudentsPageState extends ConsumerState<StudentsPage> {
  @override
  Widget build(BuildContext context) {
    var styles = Styles(context);
    var studentsList = ref.watch(studentFilterProvider);
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
                  hintText: 'Search for students',
                  onChanged: (value) {
                    ref
                        .read(studentFilterProvider.notifier)
                        .filterStudent(value);
                  },
                  suffixIcon: const Icon(Icons.search),
                )),
          ),
          Expanded(
            child: studentsList.filteredList.isEmpty
                ? const Center(child: Text('No Student Found'))
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
                              'IMAGE',
                              style: styles.subtitle(color: Colors.white),
                            ),
                            size: ColumnSize.S,
                          ),
                          DataColumn2(
                              label: Text(
                                'NAME',
                                style: styles.subtitle(color: Colors.white),
                              ),
                              size: ColumnSize.L),
                          DataColumn2(
                            label: Text(
                              'DEPARTMENT',
                              style: styles.subtitle(color: Colors.white),
                            ),
                            size: ColumnSize.L,
                          ),
                          DataColumn2(
                            label: Text(
                              'PROGRAMME',
                              style: styles.subtitle(color: Colors.white),
                            ),
                            size: ColumnSize.L,
                          ),
                          DataColumn2(
                            label: Text(
                              'LEVEL',
                              style: styles.subtitle(color: Colors.white),
                            ),
                            size: ColumnSize.S,
                          ),
                          DataColumn2(
                              label: Text(
                                'STATUS',
                                style: styles.subtitle(color: Colors.white),
                              ),
                              numeric: false,
                              size: ColumnSize.S),
                          DataColumn(
                            label: Text(
                              'CREATED AT',
                              style: styles.subtitle(color: Colors.white),
                            ),
                            numeric: false,
                          ),
                          DataColumn(
                            label: Text(
                              'ACTION',
                              style: styles.subtitle(color: Colors.white),
                            ),
                            numeric: false,
                          ),
                        ],
                        rows: studentsList.filteredList.isNotEmpty
                            ? studentsList.filteredList.map((student) {
                                var metaData = StudentMetaData.fromMap(
                                    student.userMetaData);
                                return DataRow(cells: [
                                  DataCell(Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: student.userImage.isNotEmpty
                                        ? ImageNetwork(
                                            image: student.userImage,
                                            width: 50,
                                            height: 50,
                                            borderRadius: BorderRadius.circular(10),
                                          )
                                        : Image.asset(
                                            student.userGender == 'Male'
                                                ? Assets.imagesMale
                                                : Assets.imagesFemale,
                                            width: 50,
                                            height: 50,
                                            fit: BoxFit.fill,
                                          ),
                                  )),
                                  DataCell(Text(student.userName)),
                                  DataCell(Text(
                                    student.department,
                                    maxLines: 2,
                                  )),
                                  DataCell(Text(
                                    metaData.program ?? '',
                                    maxLines: 2,
                                  )),
                                  DataCell(Text(metaData.level ?? '')),
                                  DataCell(Container(
                                      width: 122,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                      decoration: BoxDecoration(
                                          color: student.userStatus
                                                      .toLowerCase() ==
                                                  'band'
                                              ? Colors.red.withOpacity(.8)
                                              : student.userStatus
                                                          .toLowerCase() ==
                                                      'unavailable'
                                                  ? Colors.grey.withOpacity(.8)
                                                  : Colors.green
                                                      .withOpacity(.8),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Text(
                                        student.userStatus,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ))),
                                  DataCell(Text(DateFormat('EEE,MMM dd, yyyy')
                                      .format(
                                          DateTime.fromMillisecondsSinceEpoch(
                                              student.createdAt!)))),
                                  DataCell(Row(
                                    children: [
                                      //view button
                                      IconButton(
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return ViewUser(
                                                      user: student);
                                                });
                                          },
                                          icon: const Icon(
                                            Icons.remove_red_eye,
                                            color: Colors.blue,
                                          )),
                                      const SizedBox(width: 10),
                                      if (student.userStatus.toLowerCase() ==
                                          'banned')
                                        IconButton(
                                            onPressed: () {
                                              CustomDialogs.showDialog(
                                                  message:
                                                      'Are you sure you want to unblock this user',
                                                  secondBtnText: 'Unbanned',
                                                  onConfirm: () {
                                                    ref
                                                        .read(
                                                            lecturerFilterProvider
                                                                .notifier)
                                                        .updateLecturer(
                                                            student, 'active');
                                                  });
                                            },
                                            icon: const Icon(
                                              Icons.lock_open,
                                              color: Colors.green,
                                            )),
                                      if (student.userStatus.toLowerCase() !=
                                          'banned')
                                        IconButton(
                                            onPressed: () {
                                              CustomDialogs.showDialog(
                                                  message:
                                                      'Are you sure you want to block this user',
                                                  secondBtnText: 'Band',
                                                  onConfirm: () {
                                                    ref
                                                        .read(
                                                            lecturerFilterProvider
                                                                .notifier)
                                                        .updateLecturer(
                                                            student, 'banned');
                                                  });
                                            },
                                            icon: const Icon(
                                              Icons.lock,
                                              color: Colors.red,
                                            )),
                                    ],
                                  ))
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
