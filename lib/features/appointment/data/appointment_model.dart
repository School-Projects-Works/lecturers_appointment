import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppointmentModel {
  String id;
  String lecturerId;
  String studentId;
  String lecturerName;
  String lecturerPhone;
  String lecturerImage;
  String studentName;
  String studentPhone;
  String? studentImage;
  String date;
  String time;
  String status;
  int? createdAt;
  AppointmentModel({
    required this.id,
    required this.lecturerId,
    required this.studentId,
    required this.lecturerName,
    required this.lecturerPhone,
    required this.lecturerImage,
    required this.studentName,
    required this.studentPhone,
    this.studentImage,
    required this.date,
    required this.time,
    required this.status,
    this.createdAt,
  });

  AppointmentModel copyWith({
    String? id,
    String? lecturerId,
    String? studentId,
    String? lecturerName,
    String? lecturerPhone,
    String? lecturerImage,
    String? studentName,
    String? studentPhone,
    ValueGetter<String?>? studentImage,
    String? date,
    String? time,
    String? status,
    ValueGetter<int?>? createdAt,
  }) {
    return AppointmentModel(
      id: id ?? this.id,
      lecturerId: lecturerId ?? this.lecturerId,
      studentId: studentId ?? this.studentId,
      lecturerName: lecturerName ?? this.lecturerName,
      lecturerPhone: lecturerPhone ?? this.lecturerPhone,
      lecturerImage: lecturerImage ?? this.lecturerImage,
      studentName: studentName ?? this.studentName,
      studentPhone: studentPhone ?? this.studentPhone,
      studentImage: studentImage != null ? studentImage() : this.studentImage,
      date: date ?? this.date,
      time: time ?? this.time,
      status: status ?? this.status,
      createdAt: createdAt != null ? createdAt() : this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'lecturerId': lecturerId,
      'studentId': studentId,
      'lecturerName': lecturerName,
      'lecturerPhone': lecturerPhone,
      'lecturerImage': lecturerImage,
      'studentName': studentName,
      'studentPhone': studentPhone,
      'studentImage': studentImage,
      'date': date,
      'time': time,
      'status': status,
      'createdAt': createdAt,
    };
  }

  factory AppointmentModel.fromMap(Map<String, dynamic> map) {
    return AppointmentModel(
      id: map['id'] ?? '',
      lecturerId: map['lecturerId'] ?? '',
      studentId: map['studentId'] ?? '',
      lecturerName: map['lecturerName'] ?? '',
      lecturerPhone: map['lecturerPhone'] ?? '',
      lecturerImage: map['lecturerImage'] ?? '',
      studentName: map['studentName'] ?? '',
      studentPhone: map['studentPhone'] ?? '',
      studentImage: map['studentImage'],
      date: map['date'] ?? '',
      time: map['time'] ?? '',
      status: map['status'] ?? '',
      createdAt: map['createdAt']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory AppointmentModel.fromJson(String source) =>
      AppointmentModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AppointmentModel(id: $id, lecturerId: $lecturerId, studentId: $studentId, lecturerName: $lecturerName, lecturerPhone: $lecturerPhone, lecturerImage: $lecturerImage, studentName: $studentName, studentPhone: $studentPhone, studentImage: $studentImage, date: $date, time: $time, status: $status, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AppointmentModel &&
        other.id == id &&
        other.lecturerId == lecturerId &&
        other.studentId == studentId &&
        other.lecturerName == lecturerName &&
        other.lecturerPhone == lecturerPhone &&
        other.lecturerImage == lecturerImage &&
        other.studentName == studentName &&
        other.studentPhone == studentPhone &&
        other.studentImage == studentImage &&
        other.date == date &&
        other.time == time &&
        other.status == status &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        lecturerId.hashCode ^
        studentId.hashCode ^
        lecturerName.hashCode ^
        lecturerPhone.hashCode ^
        lecturerImage.hashCode ^
        studentName.hashCode ^
        studentPhone.hashCode ^
        studentImage.hashCode ^
        date.hashCode ^
        time.hashCode ^
        status.hashCode ^
        createdAt.hashCode;
  }
}
