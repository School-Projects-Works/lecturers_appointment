import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:flutter/foundation.dart';

import '../../../../../core/constants/constant_data.dart';

class UserModel {
  String id;
  String email;
  String userName;
  String userRole;
  String userStatus;
  String userImage;
  String userPhone;
  String userGender;
  String password;
  String department;
  Map<String, dynamic> officeAddress;
  Map<String, dynamic> userMetaData;
  int? createdAt;
  UserModel({
    required this.id,
    required this.email,
    required this.userName,
    required this.userRole,
    required this.userStatus,
    required this.userImage,
    required this.userPhone,
    required this.userGender,
    required this.password,
    required this.department,
    required this.officeAddress,
    required this.userMetaData,
    this.createdAt,
  });

  static UserModel empty() {
    return UserModel(
      id: '',
      email: '',
      userName: '',
      userRole: '',
      userStatus: '',
      userImage: '',
      userPhone: '',
      userGender: '',
      password: '',
      department: '',
      officeAddress: {},
      userMetaData: {},
      createdAt: null,
    );
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? userName,
    String? userRole,
    String? userStatus,
    String? userImage,
    String? userPhone,
    String? userGender,
    String? password,
    String? department,
    Map<String, dynamic>? officeAddress,
    Map<String, dynamic>? userMetaData,
    int? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      userName: userName ?? this.userName,
      userRole: userRole ?? this.userRole,
      userStatus: userStatus ?? this.userStatus,
      userImage: userImage ?? this.userImage,
      userPhone: userPhone ?? this.userPhone,
      userGender: userGender ?? this.userGender,
      password: password ?? this.password,
      department: department ?? this.department,
      officeAddress: officeAddress ?? this.officeAddress,
      userMetaData: userMetaData ?? this.userMetaData,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'email': email});
    result.addAll({'userName': userName});
    result.addAll({'userRole': userRole});
    result.addAll({'userStatus': userStatus});
    result.addAll({'userImage': userImage});
    result.addAll({'userPhone': userPhone});
    result.addAll({'userGender': userGender});
    result.addAll({'password': password});
    result.addAll({'department': department});
    result.addAll({'officeAddress': officeAddress});
    result.addAll({'userMetaData': userMetaData});
    if (createdAt != null) {
      result.addAll({'createdAt': createdAt});
    }

    return result;
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      userName: map['userName'] ?? '',
      userRole: map['userRole'] ?? '',
      userStatus: map['userStatus'] ?? '',
      userImage: map['userImage'] ?? '',
      userPhone: map['userPhone'] ?? '',
      userGender: map['userGender'] ?? '',
      password: map['password'] ?? '',
      department: map['department'] ?? '',
      officeAddress: Map<String, dynamic>.from(map['officeAddress']),
      userMetaData: Map<String, dynamic>.from(map['userMetaData']),
      createdAt: map['createdAt']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, userName: $userName, userRole: $userRole, userStatus: $userStatus, userImage: $userImage, userPhone: $userPhone, userGender: $userGender, password: $password, department: $department, officeAddress: $officeAddress, userMetaData: $userMetaData, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.id == id &&
        other.email == email &&
        other.userName == userName &&
        other.userRole == userRole &&
        other.userStatus == userStatus &&
        other.userImage == userImage &&
        other.userPhone == userPhone &&
        other.userGender == userGender &&
        other.password == password &&
        other.department == department &&
        mapEquals(other.officeAddress, officeAddress) &&
        mapEquals(other.userMetaData, userMetaData) &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        email.hashCode ^
        userName.hashCode ^
        userRole.hashCode ^
        userStatus.hashCode ^
        userImage.hashCode ^
        userPhone.hashCode ^
        userGender.hashCode ^
        password.hashCode ^
        department.hashCode ^
        officeAddress.hashCode ^
        userMetaData.hashCode ^
        createdAt.hashCode;
  }
}

class StudentMetaData {
  String? level;
  String? program;

  StudentMetaData({
    this.level,
    this.program,
  });

  StudentMetaData copyWith({
    String? level,
    String? program,
  }) {
    return StudentMetaData(
      level: level ?? this.level,
      program: program ?? this.program,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (level != null) {
      result.addAll({'level': level});
    }
    if (program != null) {
      result.addAll({'program': program});
    }

    return result;
  }

  factory StudentMetaData.fromMap(Map<String, dynamic> map) {
    return StudentMetaData(
      level: map['level'],
      program: map['program'],
    );
  }

  String toJson() => json.encode(toMap());

  factory StudentMetaData.fromJson(String source) =>
      StudentMetaData.fromMap(json.decode(source));

  @override
  String toString() => 'studentMetaData(level: $level, program: $program)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is StudentMetaData &&
        other.level == level &&
        other.program == program;
  }

  @override
  int get hashCode => level.hashCode ^ program.hashCode;
}

class LecturerOfficeAddress {
  String building;
  String officeNumber;
  String floor;
  LecturerOfficeAddress({
    required this.building,
    required this.officeNumber,
    required this.floor,
  });

  static LecturerOfficeAddress empty() {
    return LecturerOfficeAddress(
      building: '',
      officeNumber: '',
      floor: '',
    );
  }

  LecturerOfficeAddress copyWith({
    String? building,
    String? officeNumber,
    String? floor,
  }) {
    return LecturerOfficeAddress(
      building: building ?? this.building,
      officeNumber: officeNumber ?? this.officeNumber,
      floor: floor ?? this.floor,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'building': building});
    result.addAll({'officeNumber': officeNumber});
    result.addAll({'floor': floor});

    return result;
  }

  factory LecturerOfficeAddress.fromMap(Map<String, dynamic> map) {
    return LecturerOfficeAddress(
      building: map['building'] ?? '',
      officeNumber: map['officeNumber'] ?? '',
      floor: map['floor'] ?? '',
    );
  }
}

List<UserModel> dummyLecturer() {
  List<UserModel> lecturers = [];
  var _faker = Faker();
  List<Map<String, dynamic>> takenNames = [];
  for (var i = 0; i < imagesList.length; i++) {
    var gender = imagesList[i]['gender'];
    var availableName = africanLecturers
        .where((element) =>
            element['userGender'] == gender && !takenNames.contains(element))
        .toList();
    var address = LecturerOfficeAddress(
        building: _faker.address.city(),
        officeNumber: _faker.address.streetName(),
        floor: _faker.address.streetSuffix());

    var user = UserModel.empty();
    user = user.copyWith(
        email: _faker.internet.email(),
        userName: availableName.first['userName'],
        userRole: 'Lecturer',
        userStatus:
            _faker.randomGenerator.boolean() ? 'available' : 'unavailable',
        userImage: imagesList[i]['image'],
        userPhone: _faker.phoneNumber.us(),
        userGender: imagesList[i]['gender'],
        officeAddress: address.toMap(),
        department: _faker.randomGenerator.element(departmentList),
        createdAt: DateTime(
          _faker.randomGenerator.integer(2020, min: 2019),
          _faker.randomGenerator.integer(12, min: 1),
          _faker.randomGenerator.integer(12, min: 1),
          _faker.randomGenerator.integer(28, min: 1),
          0,
          0,
          0,
        ).millisecondsSinceEpoch);
    takenNames.add(availableName.first);
    lecturers.add(user);
  }
  return lecturers;
}
