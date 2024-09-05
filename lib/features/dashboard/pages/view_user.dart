import 'package:image_network/image_network.dart';
import 'package:lecturers_appointment/features/auth/pages/register/data/user_model.dart';
import 'package:lecturers_appointment/generated/assets.dart';
import 'package:lecturers_appointment/utils/colors.dart';
import 'package:lecturers_appointment/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ViewUser extends ConsumerWidget {
  const ViewUser({super.key, required this.user});
  final UserModel user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var styles = Styles(context);

    return SizedBox(
      width: styles.width,
      height: styles.height,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: styles.width < 700
                  ? styles.width * .95
                  : styles.width >= 700 && styles.width <= 1500
                      ? styles.width * .9
                      : styles.width * 0.6,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back)),
                      const SizedBox(width: 10),
                      Text(
                        'USER DETAILS',
                        style: styles.title(
                            color: primaryColor,
                            mobile: 20,
                            desktop: 25,
                            tablet: 22),
                      ),
                    ],
                  ),
                  const Divider(
                    height: 20,
                    thickness: 3,
                    color: primaryColor,
                  ),
                  const SizedBox(height: 20),
                  // styles.width <= 700
                  //     ? buildSmallScreen(context, styles, ref)
                  //     : buildLargeScreen(context, styles, ref)
                  Wrap(
                      alignment: WrapAlignment.start,
                      runAlignment: WrapAlignment.start,
                      spacing: 10,
                      children: [
                        imageBuilder(styles, user),
                        buildUserDetails(styles, user),
                        buildOtherDetails(styles, user, ref)
                      ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget imageBuilder(Styles styles, UserModel user) {
    return SizedBox(
      width: 150,
      child: user.userImage.isEmpty
          ? Image.asset(user.userGender == 'Male'
              ? Assets.imagesMale
              : Assets.imagesFemale)
          : ImageNetwork(
              image: user.userImage,
              width: 150,
              height: 200,
              borderRadius: BorderRadius.circular(10),
            ),
    );
  }

  Widget buildUserDetails(Styles styles, UserModel user) {
    LecturerOfficeAddress? address = user.officeAddress.isNotEmpty
        ? LecturerOfficeAddress.fromMap(user.officeAddress)
        : null;
    var labelStyle =
        styles.body(color: Colors.grey, mobile: 14, desktop: 14, tablet: 14);
    var infoStyle = styles.body(
        color: primaryColor,
        fontFamily: 'Raleway',
        desktop: 16,
        tablet: 15,
        mobile: 14,
        fontWeight: FontWeight.w500);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Full Name: ', style: labelStyle),
              const SizedBox(width: 5),
              Expanded(
                child: Text(user.userName, maxLines: 1, style: infoStyle),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text('Email: ', style: labelStyle),
              const SizedBox(width: 5),
              Expanded(
                child: Text(user.email, maxLines: 1, style: infoStyle),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text('Phone: ', style: labelStyle),
              const SizedBox(width: 5),
              Expanded(
                child: Text(user.userPhone, style: infoStyle),
              ),
            ],
          ),
          const SizedBox(height: 10),
          //address
          if (address != null) Text('Address: ', style: infoStyle),
          if (address != null)
            Padding(
                padding: const EdgeInsets.only(left: 20, top: 5),
                child: Column(children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: primaryColor,
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          '${address.building}, ${address.officeNumber}',
                          style: infoStyle,
                        ),
                      ),
                    ],
                  ),
                ])),

          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget buildOtherDetails(Styles styles, UserModel user, WidgetRef ref) {
    StudentMetaData? studentMetaData = user.userRole.toLowerCase() != 'lecturer'
        ? StudentMetaData.fromMap(user.userMetaData)
        : null;
    var labelStyle =
        styles.body(color: Colors.grey, mobile: 14, desktop: 14, tablet: 14);
    var infoStyle = styles.body(
        color: primaryColor,
        fontFamily: 'Raleway',
        desktop: 16,
        tablet: 15,
        mobile: 14,
        fontWeight: FontWeight.w500);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      width: 320,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (studentMetaData != null)
            Row(
              children: [
                Text(
                  'Program: ',
                  style: labelStyle,
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    studentMetaData.program ?? '',
                    style: infoStyle,
                  ),
                ),
              ],
            ),
          const SizedBox(height: 10),
          if (studentMetaData != null)
            Row(
              children: [
                Text(
                  'Level:  ',
                  style: labelStyle,
                ),
                const SizedBox(width: 5),
                Text(
                  studentMetaData.level ?? '',
                  style: infoStyle,
                ),
              ],
            ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: user.userStatus.toLowerCase() == 'active'
                    ? Colors.green
                    : user.userStatus.toLowerCase() == 'inactive'
                        ? Colors.grey
                        : Colors.red),
            child: Text(
              user.userStatus,
              style: styles.body(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
