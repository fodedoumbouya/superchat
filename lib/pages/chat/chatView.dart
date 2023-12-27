import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:superchat/base/baseStateNotifier.dart';
import 'package:superchat/base/baseWidget.dart';
import 'package:superchat/base/repo/lastMessages/logic/logic.dart';
import 'package:superchat/base/repo/lastMessages/model/model.dart';
import 'package:superchat/model/message.dart';
import 'package:superchat/model/users.dart';
import 'package:superchat/pages/login/sign_in_page.dart';
import 'package:superchat/util/adapterHelper/responsive_sizer.dart';
import 'package:superchat/widgets/coreToast.dart';
import 'package:superchat/widgets/custom/custom.dart';

class ChatView extends BaseWidget {
  final UsersModel user;
  const ChatView({required this.user, super.key});

  @override
  BaseWidgetState<BaseWidget> getState() {
    return _ChatViewState();
  }
}

class _ChatViewState extends BaseWidgetState<ChatView> {
  final CollectionReference<Map<String, dynamic>> _contactsCollection =
      FirebaseFirestore.instance.collection('messages');
  final TextEditingController textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Message> extractConversation(
      String user1Id, String user2Id, List<Message> messages) {
    List<Message> conversation = messages
        .where((message) =>
            (message.from == user1Id && message.to == user2Id) ||
            (message.from == user2Id && message.to == user1Id))
        .toList();

    return conversation;
  }

  sendMessage(
      {required String from,
      required String to,
      required String content}) async {
    try {
      await _contactsCollection.add({
        'from': from,
        'to': to,
        'content': content,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
      textController.clear();
      moveKeyboard();
    } catch (e) {
      CoreToast.showError("Message not sent");
    }
  }

  void moveKeyboard() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 200,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 100), () {
        moveKeyboard();
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const SignInPage()),
          (route) => false);
    }
    final LastMessagesNotifier lastMessageFunc =
        lastMessagesProvider.getFunction(ref);
    return Scaffold(
        appBar: AppBar(
            title: CustomTextWidget(
              widget.user.displayName ?? '',
              color: bp(),
            ),
            backgroundColor: bc(),
            leading: IconButton(
              onPressed: () {
                pop();
              },
              icon: Icon(
                Icons.arrow_back,
                color: bp(),
              ),
            )),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                  stream: _contactsCollection.snapshots(),
                  builder: (context, snapshot) {
                    // print("snapshot: ${snapshot.data.docs}");
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return _buildErrorView();
                      // case ConnectionState.waiting:
                      //   return _buildLoadingDataView();
                      case ConnectionState.done ||
                            ConnectionState.waiting ||
                            ConnectionState.active:
                        if (snapshot.hasData) {
                          moveKeyboard();
                          final event = snapshot.data!.docs;
                          List<Map<String, dynamic>> temp = [];
                          for (var msg in event) {
                            temp.add(msg.data());
                          }
                          List<Message> messages = temp
                              .map((message) => Message.fromJson(message))
                              .toList();
                          List<Message> conversation = extractConversation(
                              widget.user.id ?? "", user!.uid, messages);
                          conversation.sort(
                              (a, b) => a.timestamp.compareTo(b.timestamp));
                          // add last message to last message state notifier
                          if (conversation.isNotEmpty) {
                            lastMessageFunc.setLastMessage(
                                lastMessages: LastMessages(
                                    id: widget.user.id ?? "",
                                    message: conversation.last.content ?? ''));
                          }
                          return _buildContactsView(messages: conversation);
                        } else {
                          return _buildEmptyView();
                        }
                      default:
                        return const CustomTextWidget("");
                    }
                  }),
            ),
            TapRegion(
              onTapInside: (event) {
                Future.delayed(const Duration(milliseconds: 300), () {
                  moveKeyboard();
                });
              },
              child: Container(
                height: 10.h,
                padding: EdgeInsets.only(left: 2.w, right: 5.w),
                decoration: BoxDecoration(
                    color: bp(),
                    // borderRadius: const BorderRadius.only(
                    //   topLeft: Radius.circular(10),
                    //   topRight: Radius.circular(10),
                    // ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        spreadRadius: 0.5,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ]),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: textController,
                        decoration: InputDecoration(
                          hintText: 'Type a message',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        sendMessage(
                            from: user!.uid,
                            to: widget.user.id ?? '',
                            content: textController.text);
                      },
                      icon: Icon(
                        Icons.send,
                        color: bc(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Widget _buildContactsView({required List<Message> messages}) {
    return ListView.builder(
      itemCount: messages.length,
      controller: _scrollController,
      itemBuilder: (context, index) {
        final msg = messages[index];
        final isCurrentUser =
            msg.from == FirebaseAuth.instance.currentUser!.uid;
        final msgSender = isCurrentUser ? "You" : widget.user.displayName;

        return MessageBubble(
            msgText: msg.content ?? '',
            msgSender: msgSender ?? '',
            isCurrentUser: isCurrentUser);
      },
    );
  }

  /// Error view
  Widget _buildErrorView() {
    return const Center(
      child: CustomTextWidget("Error"),
    );
  }

  /// Empty view
  Widget _buildEmptyView() {
    return const Center(
      child: CustomTextWidget("Pas de contacts"),
    );
  }
}
