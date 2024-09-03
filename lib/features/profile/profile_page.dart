import 'package:lecturers_appointment/core/constants/constant_data.dart';
import 'package:lecturers_appointment/core/views/custom_button.dart';
import 'package:lecturers_appointment/core/views/custom_dialog.dart';
import 'package:lecturers_appointment/core/views/custom_drop_down.dart';
import 'package:lecturers_appointment/core/views/custom_input.dart';
import 'package:lecturers_appointment/features/auth/pages/login/state/login_provider.dart';
import 'package:lecturers_appointment/generated/assets.dart';
import 'package:lecturers_appointment/utils/colors.dart';
import 'package:lecturers_appointment/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var styles = Styles(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      var user = ref.watch(userProvider);
      ref.read(updateUserProvider.notifier).setUser(user);
    });

    return Container(
        color: Colors.white,
        width: double.infinity,
        height: styles.height,
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Text(
                'User Profile'.toUpperCase(),
                style: styles.title(
                    fontFamily: 'Raleway', desktop: 20, color: primaryColor),
              ),
              const Divider(
                height: 20,
                thickness: 5,
                color: primaryColor,
              ),
              SizedBox(
                width: styles.width >= 700
                    ? 650
                    : styles.width >= 900
                        ? 800
                        : styles.isMobile
                            ? styles.width
                            : 1000,
                child: (styles.width >= 700) ? buildLarge() : buildSmall(),
              ),
            ],
          ),
        ));
  }

  Widget buildLarge() {
    var user = ref.watch(userProvider);
    var notifier = ref.read(updateUserProvider.notifier);
    var styles = Styles(context);
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 200,
                    height: 300,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey, width: 1),
                        image: user.userImage.isNotEmpty ||
                                ref.watch(selectedUserImageProvider) != null
                            ? DecorationImage(
                                image: ref.watch(selectedUserImageProvider) !=
                                        null
                                    ? MemoryImage(
                                        ref.watch(selectedUserImageProvider)!)
                                    : user.userImage.isNotEmpty
                                        ? NetworkImage(user.userImage)
                                        : const AssetImage(Assets.imagesAdmin),
                                fit: BoxFit.cover)
                            : null),
                    child: user.userImage.isEmpty &&
                            ref.watch(selectedUserImageProvider) == null
                        ? const Icon(
                            Icons.person,
                            size: 100,
                          )
                        : null,
                  ),
                  const SizedBox(height: 5),
                  TextButton(
                      onPressed: () {
                        notifier.changeImage(ref);
                      },
                      child: const Text('Change Image')),
                  const SizedBox(height: 20),
                  if (user.userRole == 'Lecturer')
                    Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Container(
                        width: 220,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.all(5),
                        // active and inactive status
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            'Lecturer Status',
                            style: styles.body(),
                          ),
                          subtitle: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  notifier.changeStatus('Available');
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 5),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: ref
                                                  .watch(updateUserProvider)
                                                  .userStatus
                                                  .isNotEmpty &&
                                              ref
                                                      .watch(updateUserProvider)
                                                      .userStatus
                                                      .toLowerCase() ==
                                                  'available'
                                          ? Border.all(
                                              color: Colors.green, width: 1)
                                          : null),
                                  child: Text(
                                    'Available',
                                    style: styles.body(
                                        color: Colors.green,
                                        desktop: 14,
                                        mobile: 12,
                                        tablet: 13),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 5),
                              InkWell(
                                onTap: () {
                                  notifier.changeStatus('Unavailable');
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 5),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: ref
                                                      .watch(updateUserProvider)
                                                      .userStatus .isNotEmpty &&
                                              ref
                                                      .watch(updateUserProvider)
                                                      .userStatus
                                                      .toLowerCase() ==
                                                  'unavailable'
                                          ? Border.all(
                                              color: Colors.red, width: 1)
                                          : null),
                                  child: Text(
                                    'Unavailable',
                                    style: styles.body(
                                        color: Colors.red,
                                        desktop: 14,
                                        mobile: 12,
                                        tablet: 13),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                ],
              ),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text(
                          'User Name',
                          style: styles.body(),
                        ),
                        subtitle: CustomTextFields(
                          hintText: 'Name',
                          controller:
                              TextEditingController(text: user.userName),
                          validator: (name) {
                            if (name == null || name.length < 2) {
                              return 'Name is required';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            notifier.setName(value);
                          },
                        ),
                      ),
                      const SizedBox(height: 5),
                      ListTile(
                        title: Text(
                          'User Email',
                          style: styles.body(),
                        ),
                        subtitle: CustomTextFields(
                          controller: TextEditingController(text: user.email),
                          isReadOnly: true,
                          onChanged: (email) {
                            notifier.setEmail(email);
                          },
                          validator: (email) {
                            if (email == null || email.isEmpty) {
                              return 'Email is required';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 5),
                      ListTile(
                          title: Text('User Gender', style: styles.body()),
                          subtitle: CustomDropDown(
                            value: user.userGender,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Gender is required';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              notifier.setGender(value);
                            },
                            items: ['Male', 'Female']
                                .map((e) =>
                                    DropdownMenuItem(value: e, child: Text(e)))
                                .toList(),
                          )),
                      const SizedBox(height: 5),
                        ListTile(
                            title: Text('Department', style: styles.body()),
                            subtitle: CustomDropDown(
                              value: user.department,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Department is required';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                notifier.setDepartment(value);
                              },
                              items: departmentList
                                  .map((e) => DropdownMenuItem(
                                      value: e, child: Text(e)))
                                  .toList(),
                            )),
                      const SizedBox(height: 5),
                     
                      if (user.userRole == 'Student')
                        ListTile(
                          title: Text('Level', style: styles.body()),
                          subtitle: CustomDropDown(
                            value:
                                user.userMetaData['level'] ?? '',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Level is required';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              notifier.setLevel(value);
                            },
                            items: ['100', '200', '300', '400', 'Graduate']
                                .map((e) =>
                                    DropdownMenuItem(value: e, child: Text(e)))
                                .toList(),
                          ),
                        ),
                      const SizedBox(height: 5),
                      if (user.userRole == 'Student')
                        ListTile(
                          title: Text('Program of Study', style: styles.body()),
                          subtitle: CustomTextFields(
                            hintText: 'Program of Study',
                            isDigitOnly: true,
                            controller: TextEditingController(
                                text:
                                    user.userMetaData['program'] ?? ''),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Program of Study is required';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              notifier.setProgram(value);
                            },
                          ),
                        ),
                      ]),
              )
            ],
          ),
          const SizedBox(height: 5),
          CustomButton(
              text: 'Update Profile',
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // _formKey.currentState!.save();

                  CustomDialogs.showDialog(
                      message: 'Are you sure you want to update your profile?',
                      secondBtnText: 'Update',
                      onConfirm: () {
                        notifier.updateUser(context: context, ref: ref);
                      });
                }
              })
        ],
      ),
    );
  }

  Widget buildSmall() {
    var user = ref.watch(userProvider);
    var notifier = ref.read(updateUserProvider.notifier);
    var styles = Styles(context);
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Container(
            width: 200,
            height: 300,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey, width: 1),
                image: user.userImage.isNotEmpty ||
                        ref.watch(selectedUserImageProvider) != null
                    ? DecorationImage(
                        image: ref.watch(selectedUserImageProvider) != null
                            ? MemoryImage(ref.watch(selectedUserImageProvider)!)
                            : user.userImage.isNotEmpty
                                ? NetworkImage(user.userImage)
                                : const AssetImage(Assets.imagesAdmin),
                        fit: BoxFit.cover)
                    : null),
            child: user.userImage.isEmpty &&
                    ref.watch(selectedUserImageProvider) == null
                ? const Icon(
                    Icons.person,
                    size: 100,
                  )
                : null,
          ),
          const SizedBox(height: 5),
          TextButton(
              onPressed: () {
                notifier.changeImage(ref);
              },
              child: const Text('Change Image')),
          const SizedBox(height: 20),
          if (user.userRole == 'Lecturer')
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Container(
                width: 220,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.all(5),
                // active and inactive status
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'Lecturer Status',
                    style: styles.body(),
                  ),
                  subtitle: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          notifier.changeStatus(
                            
                              'Available');
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: ref
                                              .watch(updateUserProvider)
                                              .userStatus .isNotEmpty &&
                                      ref
                                              .watch(updateUserProvider)
                                              .userStatus
                                              .toLowerCase() ==
                                          'available'
                                  ? Border.all(color: Colors.green, width: 1)
                                  : null),
                          child: Text(
                            'Available',
                            style: styles.body(
                                color: Colors.green,
                                desktop: 14,
                                mobile: 12,
                                tablet: 13),
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      InkWell(
                        onTap: () {
                          notifier.changeStatus(
                             
                              'Unavailable');
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border:
                                  ref.watch(updateUserProvider).userStatus .isNotEmpty &&
                                          ref
                                                  .watch(updateUserProvider)
                                                  .userStatus
                                                  .toLowerCase() ==
                                              'unavailable'
                                      ? Border.all(color: Colors.red, width: 1)
                                      : null),
                          child: Text(
                            'Unavailable',
                            style: styles.body(
                                color: Colors.red,
                                desktop: 14,
                                mobile: 12,
                                tablet: 13),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ListTile(
            title: Text(
              'User Name',
              style: styles.body(),
            ),
            subtitle: CustomTextFields(
              hintText: 'Name',
              controller: TextEditingController(text: user.userName),
              validator: (name) {
                if (name == null || name.length < 2) {
                  return 'Name is required';
                }
                return null;
              },
              onChanged: (value) {
                notifier.setName(value);
              },
            ),
          ),
          const SizedBox(height: 5),
          ListTile(
            title: Text(
              'User Email',
              style: styles.body(),
            ),
            subtitle: CustomTextFields(
              controller: TextEditingController(text: user.email),
              isReadOnly: true,
              onChanged: (email) {
                notifier.setEmail(email);
              },
              validator: (email) {
                if (email == null || email.isEmpty) {
                  return 'Email is required';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 5),
          ListTile(
              title: Text('User Gender', style: styles.body()),
              subtitle: CustomDropDown(
                value: user.userGender,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Gender is required';
                  }
                  return null;
                },
                onChanged: (value) {
                  notifier.setGender(value);
                },
                items: ['Male', 'Female']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
              )),
          const SizedBox(height: 5),
            ListTile(
                title: Text('Department', style: styles.body()),
                subtitle: CustomDropDown(
                  value: user.department,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Department is required';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    notifier.setDepartment(value);
                  },
                  items: departmentList
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                )),
          const SizedBox(height: 5),
          if (user.userRole == 'Student')
            ListTile(
              title: Text('Level', style: styles.body()),
              subtitle: CustomDropDown(
                value: user.userMetaData['level'] ?? '',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Level is required';
                  }
                  return null;
                },
                onChanged: (value) {
                  notifier.setLevel(value);
                },
                items: ['100', '200', '300', '400', 'Graduate']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
              ),
            ),

         const SizedBox(height: 5),
          if (user.userRole == 'Student')
            ListTile(
              title: Text('Program of Study', style: styles.body()),
              subtitle: CustomTextFields(
                hintText: 'Program of Study',
                isDigitOnly: true,
                controller: TextEditingController(
                    text: user.userMetaData['program'] ?? ''),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Program of Study is required';
                  }
                  return null;
                },
                onChanged: (value) {
                  notifier.setProgram(value);
                },
              ),
            ),
          const SizedBox(height: 5),
          CustomButton(
              text: 'Update Profile',
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  CustomDialogs.showDialog(
                      message: 'Are you sure you want to update your profile?',
                      secondBtnText: 'Update',
                      onConfirm: () {
                        notifier.updateUser(context: context, ref: ref);
                      });
                }
              })
        ],
      ),
    );
  }
}
