import 'package:data_table_2/data_table_2.dart';
import 'package:lecturers_appointment/core/views/custom_dialog.dart';
import 'package:lecturers_appointment/core/views/custom_input.dart';
import 'package:lecturers_appointment/features/dashboard/pages/view_user.dart';
import 'package:lecturers_appointment/features/dashboard/state/main_provider.dart';
import 'package:lecturers_appointment/generated/assets.dart';
import 'package:lecturers_appointment/utils/colors.dart';
import 'package:lecturers_appointment/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';


class LecturersPage extends ConsumerStatefulWidget {
  const LecturersPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LecturersPageState();
}

class _LecturersPageState extends ConsumerState<LecturersPage> {
  @override
  Widget build(BuildContext context) {
    var styles = Styles(context);
    var lecturersList = ref.watch(lecturerFilterProvider);
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
                  hintText: 'Search for Lecturer',
                  onChanged: (value) {
                    ref
                        .read(lecturerFilterProvider.notifier)
                        .filterLecturers(value);
                  },
                  suffixIcon: const Icon(Icons.search),
                )),
          ),
          Expanded(
            child: lecturersList.filteredList.isEmpty
                ? const Center(child: Text('No Lecturer Found'))
                : Padding(
                    padding: const EdgeInsets.all(16),
                    child: DataTable2(
                        columnSpacing: 12,
                        horizontalMargin: 12,
                        headingRowColor: WidgetStateProperty.all(primaryColor),
                        minWidth: 600,
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
                          DataColumn(
                            label: Text(
                              'DEPARTMENT',
                              style: styles.subtitle(color: Colors.white),
                            ),
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
                        rows: lecturersList.filteredList.isNotEmpty
                            ? lecturersList.filteredList.map((lecturer) {
                                
                                return DataRow(cells: [
                                  DataCell(Container(
                                    decoration:
                                        BoxDecoration(border: Border.all()),
                                    margin: const EdgeInsets.all(2),
                                    child: lecturer.userImage.isNotEmpty
                                        ? Image.network(
                                            lecturer.userImage,
                                            width: 50,
                                            height: 50,
                                            fit: BoxFit.fill,
                                          )
                                        : Image.asset(
                                            lecturer.userGender == 'Male'
                                                ? Assets.imagesMale
                                                : Assets.imagesFemale,
                                            width: 50,
                                            height: 50,
                                            fit: BoxFit.fill,
                                          ),
                                  )),
                                  DataCell(Text(lecturer.userName )),
                                  DataCell(
                                      Text(lecturer.department)),
                                  
                                  
                                  DataCell(Container(
                                      width: 122,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                      decoration: BoxDecoration(
                                          color: lecturer.userStatus
                                                      .toLowerCase() ==
                                                  'banned'
                                              ? Colors.red.withOpacity(.8)
                                              : lecturer.userStatus
                                                          .toLowerCase() ==
                                                      'inactive'
                                                  ? Colors.grey.withOpacity(.8)
                                                  : Colors.green
                                                      .withOpacity(.8),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Text(
                                        lecturer.userStatus,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ))),
                                  DataCell(Text(DateFormat('EEE,MMM dd, yyyy')
                                      .format(
                                          DateTime.fromMillisecondsSinceEpoch(
                                              lecturer.createdAt!)))),
                                  DataCell(Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      //view button
                                      IconButton(
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return ViewUser(
                                                      user: lecturer);
                                                });
                                          },
                                          icon: const Icon(
                                            Icons.remove_red_eye,
                                            color: Colors.blue,
                                          )),

                                      if (lecturer.userStatus.toLowerCase() ==
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
                                                            lecturer, 'active');
                                                  });
                                            },
                                            icon: const Icon(
                                              Icons.lock_open,
                                              color: Colors.green,
                                            )),
                                      if (lecturer.userStatus.toLowerCase() !=
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
                                                            lecturer, 'banned');
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
