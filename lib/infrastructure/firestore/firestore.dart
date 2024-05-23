import 'package:cloud_firestore/cloud_firestore.dart';

class Firestore {
  Firestore._();

  static DocumentReference<Map<String, dynamic>> get version =>
      FirebaseFirestore.instance.collection('versions').doc('0.0.1');

  static CollectionReference<Map<String, dynamic>> get users =>
      version.collection('users');
}
