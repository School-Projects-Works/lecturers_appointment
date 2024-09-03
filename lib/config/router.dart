import 'package:lecturers_appointment/features/about/views/about_page.dart';
import 'package:lecturers_appointment/features/auth/pages/login/state/login_provider.dart';
import 'package:lecturers_appointment/features/auth/pages/login/views/login_page.dart';
import 'package:lecturers_appointment/features/auth/pages/register/views/register_page.dart';
import 'package:lecturers_appointment/features/contact/views/contact_page.dart';
import 'package:lecturers_appointment/features/dashboard/pages/appointment_page.dart';
import 'package:lecturers_appointment/features/dashboard/pages/dashboard_page.dart';
import 'package:lecturers_appointment/features/dashboard/views/main_page.dart';
import 'package:lecturers_appointment/features/home/views/home_page.dart';
import 'package:lecturers_appointment/features/main/views/main_page.dart';
import 'package:lecturers_appointment/features/profile/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lecturers_appointment/config/routes/router_item.dart';
import '../features/dashboard/pages/lecturers_page.dart';

import '../features/dashboard/pages/students_page.dart';
import '../features/home/views/components/user_view_page.dart';

class MyRouter {
  final WidgetRef ref;
  final BuildContext context;
  MyRouter({
    required this.ref,
    required this.context,
  });
  router() => GoRouter(
          initialLocation: RouterItem.homeRoute.path,
          redirect: (context, state) {
            var route = state.fullPath;
            //check if widget is done building
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (route != null && route.isNotEmpty) {
                var item = RouterItem.getRouteByPath(route);
                ref.read(routerProvider.notifier).state = item.name;
              }
            });
            return null;
          },
          routes: [
            ShellRoute(
                builder: (context, state, child) {
                  return MainPage(
                    child,
                  );
                },
                routes: [
                  GoRoute(
                      path: RouterItem.viewUserRoute.path,
                      name: RouterItem.viewUserRoute.name,
                      builder: (context, state) {
                        var id = state.pathParameters['id']!;
                        return ViewLecturer(
                          userId: id,
                        );
                      }),
                  GoRoute(
                    path: RouterItem.homeRoute.path,
                    builder: (context, state) {
                      return const HomePage();
                    },
                  ),
                  GoRoute(
                    path: RouterItem.aboutRoute.path,
                    builder: (context, state) {
                      return const AboutPage();
                    },
                  ),
                  //contact page
                  GoRoute(
                      path: RouterItem.contactRoute.path,
                      builder: (context, state) {
                        return const ContactPage();
                      }),
                  //login page
                  GoRoute(
                    path: RouterItem.loginRoute.path,
                    builder: (context, state) {
                      return const LoginPage();
                    },
                  ),

                  GoRoute(
                      path: RouterItem.registerRoute.path,
                      builder: (context, state) {
                        return const RegistrationPage();
                      }),
                ]),
            ShellRoute(
                builder: (context, state, child) {
                  return DashboardMain(
                    child,
                  );
                },
                redirect: (context, state) {
                  var userInfo = ref.watch(userProvider);
                  if (userInfo.id.isEmpty) {
                    return RouterItem.loginRoute.path;
                  }
                  return null;
                },
                routes: [
                  GoRoute(
                      path: RouterItem.dashboardRoute.path,
                      name: RouterItem.dashboardRoute.name,
                      builder: (context, state) {
                        return const DashboardPage();
                      }),
                  GoRoute(
                      path: RouterItem.lecturersRoute.path,
                      builder: (context, state) {
                        return const LecturersPage();
                      }),
                  GoRoute(
                    path: RouterItem.studentsRoute.path,
                    name: RouterItem.studentsRoute.name,
                    builder: (context, state) {
                      return const StudentsPage();
                    },
                  ),
                  GoRoute(
                      path: RouterItem.appointmentsRoute.path,
                      name: RouterItem.appointmentsRoute.name,
                      builder: (context, state) {
                        return const AppointmentsPage();
                      }),
                  GoRoute(
                      path: RouterItem.profileRoute.path,
                      name: RouterItem.profileRoute.name,
                      builder: (context, state) {
                        return const ProfilePage();
                      }),
                ])
          ]);

  void navigateToRoute(RouterItem item) {
    ref.read(routerProvider.notifier).state = item.name;
    context.go(item.path);
  }

  void navigateToNamed(
      {required Map<String, String> pathPrams,
      required RouterItem item,
      Map<String, dynamic>? extra}) {
    ref.read(routerProvider.notifier).state = item.name;
    context.goNamed(item.name, pathParameters: pathPrams, extra: extra);
  }
}

final routerProvider = StateProvider<String>((ref) {
  return RouterItem.homeRoute.name;
});
