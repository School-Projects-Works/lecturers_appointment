import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lecturers_appointment/config/router.dart';
import 'package:lecturers_appointment/core/constants/constant_data.dart';
import 'package:lecturers_appointment/core/views/custom_button.dart';
import 'package:lecturers_appointment/core/views/custom_dialog.dart';
import 'package:lecturers_appointment/core/views/custom_drop_down.dart';
import 'package:lecturers_appointment/core/views/custom_input.dart';
import 'package:lecturers_appointment/core/views/footer_page.dart';
import 'package:lecturers_appointment/features/auth/pages/register/state/registration_provider.dart';
import 'package:lecturers_appointment/generated/assets.dart';
import 'package:lecturers_appointment/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../config/routes/router_item.dart';
import '../../../../../utils/styles.dart';

class RegistrationPage extends ConsumerStatefulWidget {
  const RegistrationPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RegistrationPageState();
}

class _RegistrationPageState extends ConsumerState<RegistrationPage> {
  bool obscureText = true;
  final _formKey = GlobalKey<FormState>();
  Uint8List? _image;
  @override
  Widget build(BuildContext context) {
    var styles = Styles(context);
    return SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Expanded(
                child: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: Container(
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(Assets.imagesSlide1),
                                  fit: BoxFit.fill))),
                    ),
                    Expanded(
                        child: Container(
                      color: Colors.white,
                    ))
                  ],
                ),
                // Login form
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        child: Align(
                            alignment: Alignment.center,
                            child: Container(
                                width: styles.isMobile ? styles.width : 500,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black.withOpacity(.1),
                                          blurRadius: 10,
                                          spreadRadius: 5)
                                    ]),
                                child: () {
                                  if (ref.watch(regPagesProvider) == 0) {
                                    return buildUserInit();
                                  } else if (ref.watch(regPagesProvider) == 1) {
                                    return buildOfficeAddressSection();
                                  } else if (ref.watch(regPagesProvider) == 2) {
                                    return buildStudentMetaData();
                                  }
                                  //return buildstudentMetaData();
                                }()))),
                  ],
                )
              ],
            )),
            const FooterPage(),
          ],
        ));
  }

  Widget buildUserInit() {
    var provider = ref.watch(userRegistrationProvider);
    var notifier = ref.read(userRegistrationProvider.notifier);
    var styles = Styles(context);
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Text('User Registration',
                  style: styles.body(
                      desktop: 22,
                      mobile: 20,
                      tablet: 21,
                      fontWeight: FontWeight.bold,
                      color: primaryColor)),
              const Divider(
                thickness: 2,
                height: 20,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Radio<String>(
                      value: 'Student',
                      activeColor: primaryColor,
                      groupValue: provider.userRole,
                      onChanged: (value) {
                        notifier.setUserRole(value);
                      }),
                  const Text('I am a Student'),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Radio<String>(
                      value: 'Lecturer',
                      activeColor: primaryColor,
                      groupValue: provider.userRole,
                      onChanged: (value) {
                        notifier.setUserRole(value);
                      }),
                  const Text('I am a lecturer'),
                ],
              ),
              const SizedBox(height: 20),
              //image upload
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(.2),
                    image: _image != null
                        ? DecorationImage(
                            image: MemoryImage(_image!), fit: BoxFit.cover)
                        : null,
                    borderRadius: BorderRadius.circular(50)),
                child: _image == null
                    ? IconButton(
                        onPressed: () {
                          if (kIsWeb) {
                            _pickImage('gallery');
                          } else {
                            //show bottom sheet
                            showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ListTile(
                                        leading: const Icon(Icons.camera),
                                        title: const Text('Camera'),
                                        onTap: () {
                                          Navigator.pop(context);
                                          _pickImage('camera');
                                        },
                                      ),
                                      ListTile(
                                        leading: const Icon(Icons.image),
                                        title: const Text('Gallery'),
                                        onTap: () {
                                          Navigator.pop(context);
                                          _pickImage('gallery');
                                        },
                                      )
                                    ],
                                  );
                                });
                          }
                        },
                        icon: const Icon(
                          Icons.camera_alt,
                          size: 40,
                        ))
                    : null,
              ),
              if (_image != null)
                TextButton(
                    onPressed: () {
                      setState(() {
                        _image = null;
                      });
                    },
                    child: const Text('Remove Image')),
              const SizedBox(height: 30),
              CustomTextFields(
                label: 'Full Name',
                prefixIcon: Icons.person,
                validator: (name) {
                  if (name == null || name.isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                },
                onSaved: (name) {
                  notifier.setName(name!);
                },
              ),
              const SizedBox(height: 20),
              CustomDropDown(
                  items: ['Male', 'Female']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  label: 'Gender',
                  prefixIcon: Icons.male,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'User gender is required';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    notifier.setGender(value);
                  }),
              const SizedBox(height: 20),
              CustomTextFields(
                label: 'Email',
                prefixIcon: Icons.email,
                onSaved: (email) {
                  notifier.setEmail(email!);
                },
                validator: (email) {
                  if (email == null || email.isEmpty) {
                    return 'Email is required';
                  } else if (!RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(email)) {
                    return 'Invalid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              CustomTextFields(
                label: 'Phone Number',
                prefixIcon: Icons.phone,
                keyboardType: TextInputType.phone,
                isDigitOnly: true,
                validator: (phone) {
                  if (phone == null || phone.isEmpty) {
                    return 'Phone number is required';
                  } else if (phone.length != 10) {
                    return 'Phone number must be exactly 10 characters';
                  }
                  return null;
                },
                onSaved: (phone) {
                  notifier.setPhone(phone!);
                },
              ),
              const SizedBox(height: 20),
              //department dropdown
              CustomDropDown(
                label: 'Department',
                prefixIcon: Icons.school,
                onChanged: (department) {
                  notifier.setDepartment(department);
                },
                items: departmentList
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
              ),
              const SizedBox(height: 20),
              CustomTextFields(
                label: 'Password',
                prefixIcon: Icons.lock,
                obscureText: obscureText,
                suffixIcon: IconButton(
                    icon: Icon(
                        obscureText ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        obscureText = !obscureText;
                      });
                    }),
                validator: (password) {
                  if (password == null || password.isEmpty) {
                    return 'Password is required';
                  } else if (password.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
                onSaved: (password) {
                  notifier.setPassword(password!);
                },
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: 'Continue',
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (provider.userRole.isEmpty) {
                      CustomDialogs.toast(
                        message: 'Select user role',
                        type: DialogType.error,
                      );
                    } else if (_image == null) {
                      CustomDialogs.toast(
                        message: 'Select an image',
                        type: DialogType.error,
                      );
                    } else {
                      _formKey.currentState!.save();
                      if (provider.userRole == 'Student') {
                        ref.read(regPagesProvider.notifier).state = 2;
                      } else {
                        ref.read(regPagesProvider.notifier).state = 1;
                      }
                    }
                  }
                },
                radius: 5,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account?'),
                  TextButton(
                      onPressed: () {
                        MyRouter(ref: ref, context: context)
                            .navigateToRoute(RouterItem.loginRoute);
                      },
                      child: const Text('Login'))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  final _formKeyForAddress = GlobalKey<FormState>();
  Widget buildOfficeAddressSection() {
    var notifier = ref.read(regOfficeAddressProvider.notifier);
    var styles = Styles(context);
    return SingleChildScrollView(
      child: Form(
        key: _formKeyForAddress,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        ref.read(regPagesProvider.notifier).state = 0;
                      },
                      icon: const Icon(Icons.arrow_back)),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text('Lecturer Office Address',
                        textAlign: TextAlign.center,
                        style: styles.body(
                            desktop: 22,
                            mobile: 20,
                            tablet: 21,
                            fontWeight: FontWeight.bold,
                            color: primaryColor)),
                  ),
                ],
              ),
              const Divider(
                thickness: 2,
                height: 20,
              ),
              const SizedBox(height: 20),
              CustomTextFields(
                label: 'Building Name',
                prefixIcon: Icons.home,
                validator: (address) {
                  if (address == null || address.isEmpty) {
                    return 'Building name is required';
                  }
                  return null;
                },
                onSaved: (name) {
                  notifier.setBuilding(name!);
                },
              ),
              const SizedBox(height: 20),
              CustomTextFields(
                label: 'Floor',
                prefixIcon: Icons.home,
                validator: (city) {
                  if (city == null || city.isEmpty) {
                    return 'City is required';
                  }
                  return null;
                },
                onSaved: (floor) {
                  notifier.setFloor(floor!);
                },
              ),
              const SizedBox(height: 20),
              CustomTextFields(
                label: 'Office Number',
                prefixIcon: Icons.numbers,
                isDigitOnly: true,
                validator: (office) {
                  if (office == null || office.isEmpty) {
                    return 'Office number is required';
                  }
                  return null;
                },
                onSaved: (office) {
                  notifier.setOfficeNumber(office!);
                },
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: 'Register',
                onPressed: () {
                  if (_formKeyForAddress.currentState!.validate()) {
                    _formKeyForAddress.currentState!.save();
                    ref
                        .read(userRegistrationProvider.notifier)
                        .register(ref: ref, context: context, image: _image!);
                  }
                },
                radius: 5,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account?'),
                  TextButton(
                      onPressed: () {
                        MyRouter(ref: ref, context: context)
                            .navigateToRoute(RouterItem.loginRoute);
                      },
                      child: const Text('Login'))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  final _formKeyForstudent = GlobalKey<FormState>();

  Widget buildStudentMetaData() {
    var styles = Styles(context);
    var notifier = ref.read(regStudentMetaDataProvider.notifier);
    return SingleChildScrollView(
        child: Form(
            key: _formKeyForstudent,
            child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(children: [
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            ref.read(regPagesProvider.notifier).state = 1;
                          },
                          icon: const Icon(Icons.arrow_back)),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text('Student Meta Data',
                            textAlign: TextAlign.center,
                            style: styles.body(
                                desktop: 22,
                                mobile: 20,
                                tablet: 21,
                                fontWeight: FontWeight.bold,
                                color: primaryColor)),
                      ),
                    ],
                  ),

                  const Divider(
                    thickness: 2,
                    height: 20,
                  ),
                  const SizedBox(height: 20),
                  //date of birth
                  CustomTextFields(
                    label: 'Program of Study',
                    prefixIcon: Icons.book,
                    validator: (program) {
                      if (program == null || program.isEmpty) {
                        return 'Program of study is required';
                      } else if (program.length < 3) {
                        return 'Program of study must be at least 3 characters';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      notifier.setProgram(value!);
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomDropDown(
                    label: 'Level',
                    items: ['100', '200', '300', '400', 'Graduate']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    prefixIcon: Icons.school,
                    onChanged: (value) {
                      notifier.setLevel(value);
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Level is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  const SizedBox(height: 20),
                  CustomButton(
                    text: 'Register',
                    onPressed: () {
                      if (_formKeyForstudent.currentState!.validate()) {
                        _formKeyForstudent.currentState!.save();
                        ref.read(userRegistrationProvider.notifier).register(
                            ref: ref, context: context, image: _image!);
                      }
                    },
                    radius: 5,
                  ),
                ]))));
  }

  void _pickImage(String source) async {
    var image = await ImagePicker().pickImage(
        source: source == 'camera' ? ImageSource.camera : ImageSource.gallery);
    if (image != null) {
      var bytes = await image.readAsBytes();
      setState(() {
        _image = bytes;
      });
    }
  }
}
