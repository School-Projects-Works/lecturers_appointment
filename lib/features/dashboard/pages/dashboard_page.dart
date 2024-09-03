import 'package:collection/collection.dart';
import 'package:lecturers_appointment/features/dashboard/state/main_provider.dart';
import 'package:lecturers_appointment/features/dashboard/views/components/dasboard_item.dart';
import 'package:lecturers_appointment/features/dashboard/views/components/graph_item.dart';
import 'package:lecturers_appointment/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    var styles = Styles(context);
    var lecturersList = ref.watch(lecturerFilterProvider);
    var studentsList = ref.watch(studentFilterProvider);
    var appointmentsList = ref.watch(appointmentFilterProvider(null));

    var lecturersByCreatedAt = groupBy(
        lecturersList.items,
        (obj) => DateFormat('dd/MM/yy')
            .format(DateTime.fromMillisecondsSinceEpoch(obj.createdAt!)));
    var lecturersByCreatedAtToEntries = lecturersByCreatedAt.keys
        .toList()
        .map((e) => {'date': e, 'count': lecturersByCreatedAt[e]!.length})
        .toList();

    var lecturersByDepart = groupBy(
        lecturersList.items, (obj) => obj.department);
    var lecturersByDepartToEntries = lecturersByDepart.keys
        .toList()
        .map((e) => {'date': e, 'count': lecturersByDepart[e]!.length})
        .toList();

    var appointmentsByDate = groupBy(
        appointmentsList.items,
        (obj) => DateFormat('dd/MM/yy')
            .format(DateTime.fromMillisecondsSinceEpoch(obj.createdAt!)));
    var appointmentsByDateToEntries = appointmentsByDate.keys
        .toList()
        .map((e) => {'date': e, 'count': appointmentsByDate[e]!.length})
        .toList();

    var students = studentsList.items;
    var studentsByDate = groupBy(
        students,
        (obj) => DateFormat('dd/MM/yy')
            .format(DateTime.fromMillisecondsSinceEpoch(obj.createdAt!)));
    var studentsByDateToEntries = studentsByDate.keys
        .toList()
        .map((e) => {'date': e, 'count': studentsByDate[e]!.length})
        .toList();
    return Container(
        color: Colors.white,
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              styles.rowColumnWidget([
                DashBoardItem(
                  icon: Icons.people,
                  title: 'Students',
                  itemCount: studentsList.items.length,
                  color: Colors.blue,
                  onTap: () {},
                ),
                DashBoardItem(
                  icon: Icons.people,
                  title: 'Lecturers',
                  itemCount: lecturersList.items.length,
                  color: Colors.green,
                  onTap: () {
                    //ref.read(lecturersFilterProvider.notifier).saveDummyData();
                  },
                ),
                DashBoardItem(
                  icon: Icons.calendar_today,
                  title: 'Appointments',
                  itemCount: appointmentsList.items.length,
                  color: Colors.orange,
                  onTap: () {},
                ),
              ],
                  isRow: styles.largerThanMobile,
                  mainAxisAlignment: MainAxisAlignment.center),
              const SizedBox(height: 20),
              Wrap(
                runSpacing: 20,
                alignment: WrapAlignment.center,
                runAlignment: WrapAlignment.center,
                children: [
                  GraphItel(
                    data: lecturersByCreatedAtToEntries.length > 12
                        ? lecturersByCreatedAtToEntries.sublist(0, 11)
                        : lecturersByCreatedAtToEntries,
                    title: 'Lecturers By Joining Date',
                    gradientColors: [
                      Colors.blue,
                      Colors.blue.withOpacity(.5),
                      Colors.blue.withOpacity(.2),
                    ],
                  ),
                  GraphItel(
                    data: lecturersByDepartToEntries.length > 9
                        ? lecturersByDepartToEntries.sublist(0, 8)
                        : lecturersByDepartToEntries,
                    gradientColors: [
                      Colors.green,
                      Colors.green.withOpacity(.5),
                      Colors.green.withOpacity(.2),
                    ],
                    title: 'Lecturers By Department',
                  ),
                  GraphItel(
                    data: appointmentsByDateToEntries.length > 12
                        ? appointmentsByDateToEntries.sublist(0, 11)
                        : appointmentsByDateToEntries,
                    title: 'Appointments By Date',
                    gradientColors: [
                      Colors.orange,
                      Colors.orange.withOpacity(.5),
                      Colors.orange.withOpacity(.2),
                    ],
                  ),
                  GraphItel(
                    data: studentsByDateToEntries.length > 12
                        ? studentsByDateToEntries.sublist(0, 11)
                        : studentsByDateToEntries,
                    title: 'students By Date',
                    gradientColors: [
                      Colors.purple,
                      Colors.purple.withOpacity(.5),
                      Colors.purple.withOpacity(.2),
                    ],
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
