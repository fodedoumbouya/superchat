import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:superchat/base/baseStateNotifier.dart';
import 'package:superchat/base/repo/lastMessages/model/model.dart';

final lastMessagesProvider =
    StateNotifierProvider<LastMessagesNotifier, List<LastMessages>>(
  (_) => LastMessagesNotifier(),
);

class LastMessagesNotifier extends BaseStateNotifier<List<LastMessages>> {
  LastMessagesNotifier() : super([]);

  setLastMessage({required LastMessages lastMessages}) {
    final List<LastMessages> temp = state;
    // temp.addAll(state);
    final index = temp.indexWhere((element) => element.id == lastMessages.id);
    if (index != -1) {
      temp[index] = lastMessages;
    } else {
      temp.add(lastMessages);
    }
    // state.clear();
    state = temp;
    // print(state);
  }

  removeLastMessage({required String id}) {
    final List<LastMessages> temp = state;
    final index = temp.indexWhere((element) => element.id == id);
    if (index != -1) {
      temp.removeAt(index);
    }
    state = temp;
  }
}
