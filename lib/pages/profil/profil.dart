import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:superchat/base/baseStateNotifier.dart';
import 'package:superchat/base/baseWidget.dart';
import 'package:superchat/base/repo/user/logic/logic.dart';
import 'package:superchat/model/users.dart';
import 'package:superchat/util/adapterHelper/responsive_sizer.dart';
import 'package:superchat/widgets/coreToast.dart';
import 'package:superchat/widgets/custom/customConfirmButton.dart';
import 'package:superchat/widgets/custom/customTextWidget.dart';
import 'package:superchat/widgets/waiting_loading_view.dart';

class Profil extends BaseWidget {
  const Profil({super.key});

  @override
  BaseWidgetState<BaseWidget> getState() {
    return _ProfilState();
  }
}

class _ProfilState extends BaseWidgetState<Profil> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  ValueNotifier<bool> onModify = ValueNotifier<bool>(false);
  late UserNotifier userNotifier;
  late UsersModel? user;
  final CollectionReference<Map<String, dynamic>> contactsCollection =
      FirebaseFirestore.instance.collection('users');
  String docId = "";
  @override
  void initState() {
    userNotifier = userProvider.getFunction(ref);
    user = userNotifier.getUser;
    _nomController.text = user?.displayName ?? "";
    _bioController.text = user?.bio ?? "";
    getDocID(
      id: user?.id ?? "",
      docID: (data) {
        docId = data;
        rebuidState();
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _nomController.dispose();
    _bioController.dispose();
  }

  getDocID({required String id, required FunctionStringCallback docID}) async {
    final res = contactsCollection.snapshots();

    res.forEach((event) {
      for (var doc in event.docs) {
        if (doc.data()["id"].toString().trim() == id.trim()) {
          docID(doc.id);
        }
      }
    });
  }

  upadeUser() async {
    if (_nomController.text != user?.displayName ||
        _bioController.text != user?.bio) {
      LoadingView(context: context).wrap(asyncFunction: () async {
        if (docId != "") {
          await FirebaseAuth.instance.currentUser
              ?.updateDisplayName(_nomController.text);
          await contactsCollection.doc(docId).update({
            "id": user?.id,
            'displayName': _nomController.text,
            'bio': _bioController.text,
          });
          userNotifier.setUser(
              newUser: UsersModel(
                  id: user!.id,
                  displayName: _nomController.text,
                  bio: _bioController.text));

          CoreToast.showSuccess("succès");
        } else {
          CoreToast.showError("Votre Id n'a pas été trouvé");
        }
        onModify.value = false;
      });
    } else {
      onModify.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0;
    userNotifier = userProvider.getFunction(ref);
    user = userProvider.getState(ref);

    return Scaffold(
        appBar: AppBar(
          title: CustomTextWidget(
            "Profil",
            color: bp(),
          ),
          actions: [
            IconButton(
              onPressed: () {
                showMyDialog(
                    title: "Déconnexion ?",
                    content: "Êtes-vous sûr de vouloir vous déconnecter ?",
                    cancelTxt: "Annuler",
                    confirmTxt: "Oui",
                    onCancel: () {},
                    onConfirm: () {
                      FirebaseAuth.instance.signOut();
                    });
              },
              icon: Icon(
                Icons.logout,
                color: bp(),
              ),
            )
          ],
        ),
        body: ValueListenableBuilder(
            valueListenable: onModify,
            builder: (context, value, child) {
              return ListView(
                children: [
                  Container(
                    height: 30.h,
                    width: sw(),
                    padding: EdgeInsets.all(5.w),
                    child: const CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(
                          'https://avatars.githubusercontent.com/u/17093612?v=4'),
                    ),
                  ),
                  SizedBox(
                      height: 40.h,
                      child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              _infoBox(
                                  title: "Nom",
                                  controller: _nomController,
                                  autofocus: true),
                              _infoBox(
                                  title: "Bio", controller: _bioController),
                            ],
                          ))),
                  isKeyboardOpen
                      ? const SizedBox.shrink()
                      : value
                          ? ConfirmButton(
                              txt: "Enregistrer",
                              bColor: Colors.red,
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  upadeUser();
                                }
                              })
                          : ConfirmButton(
                              txt: "Modifier",
                              onPressed: () {
                                onModify.value = true;
                              }),
                ],
              );
            }));
  }

  Widget _infoBox(
      {required String title,
      required TextEditingController controller,
      bool autofocus = false}) {
    return Container(
      height: 7.h,
      width: sw(),
      // color: Colors.black,
      padding: EdgeInsets.only(left: 2.w),
      margin: EdgeInsets.only(bottom: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextWidget(
            title,
            color: bd(),
            fontWeight: FontWeight.bold,
          ),
          Expanded(
            child: Container(
                decoration: BoxDecoration(
                  color: bcGrey().withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: EdgeInsets.only(right: 1.w), // 5.w == 5% of total width
                child: TextFormField(
                  autofocus: autofocus,
                  enabled: onModify.value,
                  cursorColor: Colors.black,
                  // keyboardType: inputType,
                  // initialValue: initialValue,
                  controller: controller,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre $title';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    contentPadding: EdgeInsets.only(
                      left: 2.w,
                      bottom: 0.1.h,
                    ),
                    // hintText: "Hint here"
                  ),
                )),
          )
        ],
      ),
    );
  }
}
