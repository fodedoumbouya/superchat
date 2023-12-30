import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:superchat/common/data/data_persistence.dart';
import 'package:superchat/model/users.dart';

import '../../../baseStateNotifier.dart';

final userProvider =
    StateNotifierProvider<ContactsNotifier, Future<List<UsersModel>>>(
  (_) => ContactsNotifier(),
);

class ContactsNotifier extends BaseStateNotifier<Future<List<UsersModel>>> {
  ContactsNotifier() : super(Future.value([])) {
    _addListener();
  }

  final CollectionReference<Map<String, dynamic>> _contactsCollection =
      FirebaseFirestore.instance.collection('users');
  _addListener() {
    state = Future.wait([]);
    final currentUser = DataPersistence.getAccount();
    _contactsCollection.snapshots().listen((event) {
      List<UsersModel> temp = [];
      for (var user in event.docs) {
        // print("user: ${user.data()}");
        if (user.data()["id"] != null && user.data()["id"] != currentUser?.id) {
          // print("user: ${user.data()}");
          temp.add(UsersModel.fromJson(user.data()));
        }
      }
      state = Future.value(temp);
    }).onError((e) {
      state = Future.error([]);
    });
  }
}
