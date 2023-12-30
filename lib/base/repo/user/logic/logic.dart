import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:superchat/base/baseStateNotifier.dart';
import 'package:superchat/common/data/data_persistence.dart';
import 'package:superchat/model/users.dart';

final userProvider = StateNotifierProvider<UserNotifier, UsersModel?>(
  (_) {
    // get user data from the local storage to the userState for the app
    UsersModel? userState;
    final userLocalData = DataPersistence.getAccount();
    if (userLocalData != null) {
      userState = userLocalData;
    }
    return UserNotifier(user: userState);
  },
);

class UserNotifier extends BaseStateNotifier<UsersModel?> {
  UsersModel? user;
  UserNotifier({UsersModel? user}) : super(user);

  UsersModel? get getUser => state;

  setUser({UsersModel? newUser}) {
    if (newUser == null) {
      state = null;
      DataPersistence.removeAccount();
    } else {
      state = newUser;
      DataPersistence.putAccount(newUser);
    }
  }
}
