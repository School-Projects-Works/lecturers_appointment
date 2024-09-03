import 'package:lecturers_appointment/config/router.dart';
import 'package:lecturers_appointment/config/routes/router_item.dart';
import 'package:lecturers_appointment/features/auth/pages/login/state/login_provider.dart';
import 'package:lecturers_appointment/features/dashboard/views/components/side_bar_item.dart';
import 'package:lecturers_appointment/utils/colors.dart';
import 'package:lecturers_appointment/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SideBar extends ConsumerWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var styles = Styles(context);
    var user = ref.watch(userProvider);
    return Container(
        width: 200,
        height: styles.height,
        color: primaryColor,
        child: Column(children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RichText(
                text: TextSpan(
                    text: 'Hello, \n',
                    style: styles.body(
                        color: Colors.white38, fontFamily: 'Raleway'),
                    children: [
                  TextSpan(
                      text: ref.watch(userProvider).userName,
                      style: styles.subtitle(
                          fontWeight: FontWeight.bold,
                          desktop: 16,
                          mobile: 13,
                          tablet: 14,
                          color: Colors.white,
                          fontFamily: 'Raleway'))
                ])),
          ),
          const SizedBox(
            height: 25,
          ),
          Expanded(
            child: Column(
              children: [
                SideBarItem(
                  title: 'Dashboard',
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  icon: Icons.dashboard,
                  isActive: ref.watch(routerProvider) ==
                      RouterItem.dashboardRoute.name,
                  onTap: () {
                    MyRouter(context: context, ref: ref)
                        .navigateToRoute(RouterItem.dashboardRoute);
                  },
                ),
                if (user.userRole.toLowerCase() == 'admin')
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: SideBarItem(
                      title: 'Lecturers',
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 10),
                      icon: Icons.people,
                      isActive: ref.watch(routerProvider) ==
                          RouterItem.lecturersRoute.name,
                      onTap: () {
                        MyRouter(context: context, ref: ref)
                            .navigateToRoute(RouterItem.lecturersRoute);
                      },
                    ),
                  ),
                if (user.userRole.toLowerCase() == 'admin')
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: SideBarItem(
                      title: 'Students',
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 10),
                      icon: Icons.person,
                      isActive: ref.watch(routerProvider) ==
                          RouterItem.studentsRoute.name,
                      onTap: () {
                        MyRouter(context: context, ref: ref)
                            .navigateToRoute(RouterItem.studentsRoute);
                      },
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: SideBarItem(
                    title: 'Appointments',
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 10),
                    icon: Icons.calendar_today,
                    isActive: ref.watch(routerProvider) ==
                        RouterItem.appointmentsRoute.name,
                    onTap: () {
                      MyRouter(context: context, ref: ref)
                          .navigateToRoute(RouterItem.appointmentsRoute);
                    },
                  ),
                ),
                if (user.userRole.toLowerCase() != 'admin')
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: SideBarItem(
                      title: 'Profile',
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 10),
                      icon: Icons.person,
                      isActive: ref.watch(routerProvider) ==
                          RouterItem.profileRoute.name,
                      onTap: () {
                        MyRouter(context: context, ref: ref)
                            .navigateToRoute(RouterItem.profileRoute);
                      },
                    ),
                  ),
              ],
            ),
          ),
          // footer
          Text('© 2021 All rights reserved',
              style: styles.body(
                  color: Colors.white38, desktop: 12, fontFamily: 'Raleway')),
        ]));
  }
}
