import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lecturers_appointment/features/auth/pages/register/data/user_model.dart';

class LecturerServices {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final CollectionReference _lecturersCollection =
      _firestore.collection('users');

  static Stream<List<UserModel>> getLecturers() {
    final snapshot = _lecturersCollection
        .where('userRole', isEqualTo: 'Lecturer')
        .where('userStatus',
            whereIn: ['available', 'unavailable', 'Unavailable', 'Available']).snapshots();
    return snapshot.map((event) => event.docs
        .map((e) => UserModel.fromMap(e.data() as Map<String, dynamic>))
        .toList());
  }

  static Stream<List<UserModel>> getLecturersByAdmin() {
    final snapshot = _lecturersCollection
        .where('userRole', isEqualTo: 'Lecturer')
        .where('userStatus', whereIn: [
      'available',
      'unavailable',
      'Unavailable',
      'Available',
      'banned',
      'Banned'
    ]).snapshots();
    return snapshot.map((event) => event.docs
        .map((e) => UserModel.fromMap(e.data() as Map<String, dynamic>))
        .toList());
  }

  static Future<UserModel?> getLecturerById(String id) async {
    final snapshot = await _lecturersCollection.doc(id).get();
    if (snapshot.exists) {
      return UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
    }
    return null;
  }

  static Future<void> updateLecturerStatus(String id, String status) async {
    await _lecturersCollection.doc(id).update({'userStatus': status});
  }

  static Future<void> updateLecturer(UserModel user) async {
    await _lecturersCollection.doc(user.id).update(user.toMap());
  }

  static Future<List<UserModel>> getAllLecturers() async {
    final snapshot = await _lecturersCollection
        .where('userRole', isEqualTo: 'Lecturer')
        .get();
    return snapshot.docs
        .map((e) => UserModel.fromMap(e.data() as Map<String, dynamic>))
        .toList();
  }
}
