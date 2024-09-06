import 'package:lecturers_appointment/config/router.dart';
import 'package:lecturers_appointment/config/routes/router_item.dart';
import 'package:lecturers_appointment/core/views/custom_button.dart';
import 'package:lecturers_appointment/core/views/custom_dialog.dart';
import 'package:lecturers_appointment/core/views/custom_input.dart';
import 'package:lecturers_appointment/features/auth/pages/login/state/login_provider.dart';
import 'package:lecturers_appointment/features/auth/pages/register/data/user_model.dart';
import 'package:lecturers_appointment/utils/colors.dart';
import 'package:lecturers_appointment/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/lecturer_provider.dart';

class LecturerCard extends ConsumerStatefulWidget {
  const LecturerCard(this.lecturer, {super.key});
  final UserModel lecturer;

  @override
  ConsumerState<LecturerCard> createState() => _LecturerCardState();
}

class _LecturerCardState extends ConsumerState<LecturerCard> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var styles = Styles(context);
    var appointmentBookingProviderProvider =
        ref.watch(appointmentBookingProvider);
    return SizedBox(
      width: styles.isMobile
          ? styles.width * .84
          : styles.isDesktop
              ? styles.width * .3
              : styles.width * .4,
      height: 400,
      child: Stack(
        children: [
          InkWell(
            onTap: () {
              MyRouter(context: context, ref: ref)
                  .navigateToNamed(item: RouterItem.viewUserRoute, pathPrams: {
                'id': widget.lecturer.id,
              }, extra: {
                'isLecturer': 'true',
                'hasBookButton': 'true'
              });
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 3))
                  ]),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: widget.lecturer.userImage.isNotEmpty
                              ? DecorationImage(
                                  fit: BoxFit.fill,
                                  image:
                                      NetworkImage(widget.lecturer.userImage))
                              : null),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      widget.lecturer.userName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: styles.title(
                          color: primaryColor,
                          desktop: 18,
                          tablet: 16,
                          mobile: 14),
                    ),
                  ),
                  //status
                  const SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 3),
                    decoration: BoxDecoration(
                        color: widget.lecturer.userStatus.toLowerCase() ==
                                "available"
                            ? Colors.green
                            : Colors.red),
                    child: Text(widget.lecturer.userStatus),
                  ),
                  const SizedBox(height: 10),
                  CustomButton(
                    text: 'Book Appointment',
                    onPressed: () {
                      if (widget.lecturer.userStatus.toLowerCase() ==
                          'available') {
                        ref
                            .read(appointmentBookingProvider.notifier)
                            .setLecturer(widget.lecturer);
                      } else {
                        CustomDialogs.toast(
                          message: 'Lecturer is currently inactive',
                        );
                      }
                    },
                    color: secondaryColor,
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
          Visibility(
              visible: appointmentBookingProviderProvider != null &&
                  appointmentBookingProviderProvider.lecturerId ==
                      widget.lecturer.id,
              child: Container(
                decoration: const BoxDecoration(color: primaryColor),
                padding: const EdgeInsets.all(10),
                child: Center(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                ref
                                    .read(appointmentBookingProvider.notifier)
                                    .clear();
                              },
                              icon: const Icon(Icons.close),
                              color: Colors.white,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text('Book Appointment',
                                style: styles.title(
                                    color: Colors.white,
                                    fontFamily: 'Raleway',
                                    desktop: 22,
                                    tablet: 18,
                                    mobile: 16)),
                          ],
                        ),
                        const Divider(color: Colors.white),
                        const SizedBox(height: 10),
                        Text(
                          'You have selected ${widget.lecturer.userName}, who is from ${widget.lecturer.department} department',
                          style: styles.title(
                              color: Colors.white,
                              fontFamily: 'Raleway',
                              desktop: 16,
                              tablet: 14,
                              mobile: 13),
                        ),

                        //pick date and time
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: CustomTextFields(
                            onTap: () {
                              showDatePicker(
                                context: context,
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now()
                                    .add(const Duration(days: 30)),
                              ).then((value) {
                                if (value != null) {
                                  ref
                                      .read(appointmentBookingProvider.notifier)
                                      .setDate(value);
                                }
                              });
                            },
                            controller: TextEditingController(
                                text: appointmentBookingProviderProvider != null
                                    ? appointmentBookingProviderProvider.date
                                    : ''),
                            hintText: 'Pick Date',
                            isReadOnly: true,
                            validator: (date) {
                              if (date == null || date.isEmpty) {
                                return 'Date is required';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: CustomTextFields(
                            hintText: 'Pick Time',
                            validator: (time) {
                              if (time == null || time.isEmpty) {
                                return 'Time is required';
                              }
                              return null;
                            },
                            onTap: () {
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
                                text: appointmentBookingProviderProvider != null
                                    ? appointmentBookingProviderProvider.time
                                    : ''),
                            isReadOnly: true,
                          ),
                        ),
                        const SizedBox(height: 20),
                        CustomButton(
                          text: 'Book Appointment',
                          onPressed: () {
                            if (!_formKey.currentState!.validate()) {
                              return;
                            }
                            if (ref.watch(userProvider).id ==
                                widget.lecturer.id) {
                              CustomDialogs.toast(
                                message:
                                    'You can not book appointment with yourself',
                              );
                              return;
                            }
                            ref
                                .read(appointmentBookingProvider.notifier)
                                .book(ref: ref, context: context);
                          },
                          color: Colors.blue,
                        ),
                      ],
                    ),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
