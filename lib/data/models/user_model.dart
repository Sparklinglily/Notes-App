import 'package:note_app/domain/entities/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class UserModel extends User {
  const UserModel({required super.id, required super.email});

  factory UserModel.fromFirebaseUser(firebase_auth.User firebaseUser) {
    return UserModel(id: firebaseUser.uid, email: firebaseUser.email ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'email': email};
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(id: json['id'] as String, email: json['email'] as String);
  }

  User toEntity() {
    return User(id: id, email: email);
  }
}
