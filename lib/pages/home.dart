import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:superchat/base/baseStateNotifier.dart';
import 'package:superchat/base/baseWidget.dart';
import 'package:superchat/base/repo/lastMessages/model/model.dart';
import 'package:superchat/base/repo/theme/logic/logic.dart';
import 'package:superchat/base/repo/theme/model/model.dart';
import 'package:superchat/base/repo/user/logic/logic.dart';
import 'package:superchat/model/users.dart';
import 'package:superchat/pages/chat/chatView.dart';
import 'package:superchat/pages/login/sign_in_page.dart';
import 'package:superchat/pages/profil/profil.dart';
import 'package:superchat/util/constants.dart';
import 'package:superchat/widgets/stream_listener.dart';

import '../base/repo/lastMessages/logic/logic.dart';
import '../widgets/custom/custom.dart';

class HomePage extends BaseWidget {
  const HomePage({super.key});

  @override
  BaseWidgetState<BaseWidget> getState() {
    return _HomePageState();
  }
}

// test@qq.com
//1122aa

class _HomePageState extends BaseWidgetState<HomePage> {
  @override
  Widget build(BuildContext context) {
    /// calling the userProvider to get the contacts state
    final contacts = userProvider.getState(ref);
    final ThemeNotifier themeMode = themeProvider.getFunction(ref);
    final ThemeState themeState = themeProvider.getState(ref);

    final List<LastMessages> lastMessages = lastMessagesProvider.getState(ref);

    return StreamListener<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      listener: (user) {
        if (user == null) {
          // Navigator.of(context).pushAndRemoveUntil(
          //     MaterialPageRoute(builder: (_) => const SignInPage()),
          //     (route) => false);
          jumpToPage(const SignInPage());
        }
      },
      child: Scaffold(
        backgroundColor: bpLight(),
        appBar: AppBar(
          title: CustomTextWidget(
            kAppTitle,
            color: bp(),
          ),
          backgroundColor: bc(),
          actions: [
            IconButton(
                onPressed: () {
                  themeMode.setTheme(isDarkMode: !themeState.isDarkMode);
                },
                icon: Icon(
                  themeState.isDarkMode
                      ? Icons.light_mode_outlined
                      : Icons.dark_mode_outlined,
                  color: bp(),
                )),
            IconButton(
              icon: Icon(Icons.person, color: bp()),
              onPressed: () {
                toPage(const Profil());
              },
            ),
          ],
        ),
        body: FutureBuilder<List<UsersModel>>(
            future: contacts,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return _buildErrorView();
                case ConnectionState.waiting:
                  return _buildLoadingDataView();
                case ConnectionState.done:
                  if (snapshot.hasData) {
                    return _buildContactsView(
                        contacts: snapshot.data!, lastMessages: lastMessages);
                  } else {
                    return _buildEmptyView();
                  }
                default:
                  return const CustomTextWidget("");
              }
            }),
      ),
    );
  }

  /// Loading data view
  Widget _buildLoadingDataView() {
    return const Center(
      child: CircularProgressIndicator(),
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

  /// Contacts view
  Widget _buildContactsView(
      {required List<UsersModel> contacts,
      required List<LastMessages> lastMessages}) {
    return ListView.separated(
      itemCount: contacts.length,
      itemBuilder: (context, index) {
        final con = contacts[index];
        final lastMsg = lastMessages
            .firstWhere((element) => element.id == con.id,
                orElse: () => LastMessages(id: "", message: ""))
            .message;

        return ContactView(
          user: con,
          lastMessage: lastMsg,
          onTap: () {
            toPage(ChatView(user: contacts[index]))
                .then((value) => rebuidState());
          },
        );
      },
      separatorBuilder: (context, index) {
        return const SizedBox(
          height: 2,
        );
      },
    );
  }
}
