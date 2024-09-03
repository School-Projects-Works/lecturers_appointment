import 'package:lecturers_appointment/core/views/custom_button.dart';
import 'package:lecturers_appointment/core/views/custom_dialog.dart';
import 'package:lecturers_appointment/core/views/custom_input.dart';
import 'package:lecturers_appointment/features/auth/pages/login/state/login_provider.dart';
import 'package:lecturers_appointment/features/auth/pages/register/data/user_model.dart';
import 'package:lecturers_appointment/generated/assets.dart';
import 'package:lecturers_appointment/utils/colors.dart';
import 'package:lecturers_appointment/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/lecturer_provider.dart';

class ViewLecturer extends ConsumerStatefulWidget {
  const ViewLecturer({super.key, required this.userId});

  final String userId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ViewUserState();
}

class _ViewUserState extends ConsumerState<ViewLecturer> {
  @override
  Widget build(BuildContext context) {
    var styles = Styles(context);
    var lecturerStream = ref.watch(lecturersStreamProvider);
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(10),
      child: lecturerStream.when(
        data: (dat) {
          var lecturer = ref
              .watch(lecturersFilterProvider)
              .items
              .where((element) => element.id == widget.userId)
              .firstOrNull;
          if (lecturer == null) {
            return const Center(child: Text('Lecturer not found'));
          }

          return styles.width > 700
              ? _buildLargeScreen(lecturer)
              : _buildSmallScreen(lecturer);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildLargeScreen(
    UserModel user,
  ) {
    var styles = Styles(context);
    var address = LecturerOfficeAddress.fromMap(user.officeAddress);

    var appointmentProvider = ref.watch(appointmentBookingProvider);
    return SizedBox(
      width: styles.width * .8,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //left side
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 200,
                      height: 300,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey, width: 1),
                          image: user.userImage.isNotEmpty
                              ? DecorationImage(
                                  image: user.userImage.isNotEmpty
                                      ? NetworkImage(user.userImage)
                                      : const AssetImage(Assets.imagesAdmin),
                                  fit: BoxFit.cover)
                              : null),
                      child: user.userImage.isEmpty
                          ? Image.asset(Assets.imagesAdmin)
                          : null,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      user.userName,
                      style: styles.title(
                          color: primaryColor,
                          desktop: 26,
                          tablet: 22,
                          mobile: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      user.department,
                      style: styles.title(
                          color: Colors.blue,
                          desktop: 20,
                          tablet: 18,
                          mobile: 16,
                          fontFamily: 'Raleway'),
                    ),
                    const SizedBox(height: 5),
                    const Divider(
                      color: primaryColor,
                    ),
                    const SizedBox(height: 10),
                    if (user.userRole == 'Lecturer')
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: primaryColor,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '${address.building}, ${address.floor} ${address.officeNumber}',
                            style: styles.title(
                                color: primaryColor,
                                desktop: 16,
                                tablet: 15,
                                mobile: 13,
                                fontFamily: 'Raleway'),
                          ),
                        ],
                      ),
                    const SizedBox(height: 5),
                    //phone number
                    Row(
                      children: [
                        const Icon(
                          Icons.phone,
                          color: primaryColor,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          user.userPhone,
                          style: styles.title(
                              color: primaryColor,
                              desktop: 16,
                              tablet: 15,
                              mobile: 13,
                              fontFamily: 'Raleway'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    //email
                    Row(
                      children: [
                        const Icon(
                          Icons.email,
                          color: primaryColor,
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            user.email,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: styles.title(
                                color: primaryColor,
                                desktop: 16,
                                tablet: 15,
                                mobile: 13,
                                fontFamily: 'Raleway'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    //book appointment
                    if (appointmentProvider != null &&
                        appointmentProvider.lecturerId.isNotEmpty)
                      CustomTextFields(
                        onTap: () {
                          //pick date
                          //show date picker
                          showDatePicker(
                            context: context,
                            firstDate: DateTime.now(),
                            lastDate:
                                DateTime.now().add(const Duration(days: 30)),
                          ).then((value) {
                            if (value != null) {
                              ref
                                  .read(appointmentBookingProvider.notifier)
                                  .setDate(value);
                            }
                          });
                        },
                        controller: TextEditingController(
                            text: appointmentProvider.date.isNotEmpty
                                ? appointmentProvider.date
                                : ''),
                        hintText: 'Pick Date',
                        isReadOnly: true,
                      ),
                    const SizedBox(height: 15),
                    if (appointmentProvider != null &&
                        appointmentProvider.lecturerId.isNotEmpty)
                      CustomTextFields(
                        hintText: 'Pick Time',
                        onTap: () {
                          //pick time
                          //show time picker
                          showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          ).then((value) {
                            if (value != null) {
                              ref
                                  .read(appointmentBookingProvider.notifier)
                                  .setTime(value.format(context));
                            }
                          });
                        },
                        controller: TextEditingController(
                            text: appointmentProvider.time),
                        isReadOnly: true,
                      ),
                    const SizedBox(height: 15),
                    CustomButton(
                      color: primaryColor,
                      onPressed: () {
                        if (ref.watch(userProvider).id.isNotEmpty) {
                          if (ref.watch(userProvider).id == user.id) {
                            CustomDialogs.toast(
                              message:
                                  'You can not book appointment with yourself',
                            );
                            return;
                          }
                          if (appointmentProvider == null ||
                              appointmentProvider.lecturerId.isEmpty) {
                            ref
                                .read(appointmentBookingProvider.notifier)
                                .setLecturer(user);
                          } else {
                            if (appointmentProvider.date.isEmpty ||
                                appointmentProvider.time.isEmpty) {
                              CustomDialogs.toast(
                                message: 'Please select date and time',
                              );
                              return;
                            } else {
                              ref
                                  .read(appointmentBookingProvider.notifier)
                                  .book(ref: ref, context: context);
                            }
                          }
                        } else {
                          CustomDialogs.toast(
                            message: 'Please login to book appointment',
                          );
                        }
                      },
                      text: 'Book Appointment',
                    )
                  ],
                ),
              ),
            ),
          ),
          if (styles.width > 1500) Expanded(child: Container())
        ],
      ),
    );
  }

  Widget _buildSmallScreen(
    UserModel user,
  ) {
    var styles = Styles(context);
    var address = LecturerOfficeAddress.fromMap(user.officeAddress);
    var appointmentProvider = ref.watch(appointmentBookingProvider);
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: 200,
                  height: 300,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey, width: 1),
                      image: user.userImage.isNotEmpty
                          ? DecorationImage(
                              image: user.userImage.isNotEmpty
                                  ? NetworkImage(user.userImage)
                                  : const AssetImage(Assets.imagesAdmin),
                              fit: BoxFit.cover)
                          : null),
                  child: user.userImage.isNotEmpty
                      ? Image.asset(Assets.imagesAdmin)
                      : null,
                ),
                const SizedBox(height: 5),
                Text(
                  user.userName,
                  style: styles.title(
                      color: primaryColor,
                      desktop: 26,
                      tablet: 22,
                      mobile: 18,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(
                  user.department,
                  style: styles.title(
                      color: Colors.blue,
                      desktop: 20,
                      tablet: 18,
                      mobile: 16,
                      fontFamily: 'Raleway'),
                ),
                const SizedBox(height: 5),

                const Divider(
                  color: primaryColor,
                ),
                const SizedBox(height: 10),

                //address
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: primaryColor,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '${address.building}, ${address.floor} ${address.officeNumber}',
                      style: styles.title(
                          color: primaryColor,
                          desktop: 20,
                          tablet: 18,
                          mobile: 16,
                          fontFamily: 'Raleway'),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                //phone number
                Row(
                  children: [
                    const Icon(
                      Icons.phone,
                      color: primaryColor,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      user.userPhone,
                      style: styles.title(
                          color: primaryColor,
                          desktop: 20,
                          tablet: 18,
                          mobile: 16,
                          fontFamily: 'Raleway'),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                //email
                Row(
                  children: [
                    const Icon(
                      Icons.email,
                      color: primaryColor,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      user.email,
                      style: styles.title(
                          color: primaryColor,
                          desktop: 20,
                          tablet: 18,
                          mobile: 16,
                          fontFamily: 'Raleway'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
        //book appointment
        if (appointmentProvider != null &&
            appointmentProvider.lecturerId.isNotEmpty)
          CustomTextFields(
            onTap: () {
              //pick date
              //show date picker
              showDatePicker(
                context: context,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 30)),
              ).then((value) {
                if (value != null) {
                  ref.read(appointmentBookingProvider.notifier).setDate(value);
                }
              });
            },
            controller: TextEditingController(
                text: appointmentProvider.date.isNotEmpty
                    ? appointmentProvider.date
                    : ''),
            hintText: 'Pick Date',
            isReadOnly: true,
          ),
        const SizedBox(height: 15),
        if (appointmentProvider != null &&
            appointmentProvider.lecturerId.isNotEmpty)
          CustomTextFields(
            hintText: 'Pick Time',
            onTap: () {
              //pick time
              //show time picker
              showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              ).then((value) {
                if (value != null) {
                  ref
                      .read(appointmentBookingProvider.notifier)
                      .setTime(value.format(context));
                }
              });
            },
            controller: TextEditingController(text: appointmentProvider.time),
            isReadOnly: true,
          ),

        const SizedBox(height: 15),
        CustomButton(
          color: primaryColor,
          onPressed: () {
            if (ref.watch(userProvider).id.isNotEmpty) {
              if (ref.watch(userProvider).id == user.id) {
                CustomDialogs.toast(
                  message: 'You can not book appointment with yourself',
                );
                return;
              }
              if (appointmentProvider == null ||
                  appointmentProvider.lecturerId.isEmpty) {
                ref.read(appointmentBookingProvider.notifier).setLecturer(user);
              } else {
                if (appointmentProvider.date.isEmpty ||
                    appointmentProvider.time.isEmpty) {
                  CustomDialogs.toast(
                    message: 'Please select date and time',
                  );
                  return;
                } else {
                  ref
                      .read(appointmentBookingProvider.notifier)
                      .book(ref: ref, context: context);
                }
              }
            } else {
              CustomDialogs.toast(
                message: 'Please login to book appointment',
              );
            }
          },
          text: 'Book Appointment',
        )
      ],
    );
  }
}
