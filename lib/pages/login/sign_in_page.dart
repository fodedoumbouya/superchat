import 'dart:developer';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:superchat/base/baseWidget.dart';
import 'package:superchat/pages/home.dart';
import 'package:superchat/pages/login/sign_up_page.dart';
import 'package:superchat/util/adapterHelper/responsive_sizer.dart';
import 'package:superchat/util/constants.dart';
import 'package:superchat/widgets/custom/customTextWidget.dart';

class SignInPage extends BaseWidget {
  const SignInPage({super.key});

  @override
  BaseWidgetState<BaseWidget> getState() {
    return _SignInPageState();
  }
}

class _SignInPageState extends BaseWidgetState<SignInPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _emailFieldController = TextEditingController();
  final _passwordFieldController = TextEditingController();
  bool _showPassword = false;

  @override
  void dispose() {
    _emailFieldController.dispose();
    _passwordFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: CustomTextWidget(kAppTitle, color: bp()),
        backgroundColor: bc(),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(Insets.medium),
              child: AutofillGroup(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomTextWidget(
                        'Connectez-vous à votre compte Superchat',
                        size: 22.sp,
                        withOverflow: false,
                        fontWeight: FontWeight.w600,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: Insets.extraLarge),
                      const CustomTextWidget(
                        'Email',
                        textAlign: TextAlign.center,
                      ),
                      RepaintBoundary(
                        child: TextFormField(
                          controller: _emailFieldController,
                          autofillHints: const [AutofillHints.email],
                          decoration: InputDecoration(
                            hintText: 'Email',
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: bcGrey()),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: bc()),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          validator: (value) =>
                              value != null && EmailValidator.validate(value)
                                  ? null
                                  : 'Email invalide',
                        ),
                      ),
                      const SizedBox(height: Insets.medium),
                      const CustomTextWidget(
                        'Mot de passe',
                        textAlign: TextAlign.center,
                      ),
                      StatefulBuilder(
                        builder: (context, setState) {
                          return RepaintBoundary(
                            child: TextFormField(
                              controller: _passwordFieldController,
                              autofillHints: const [AutofillHints.password],
                              obscureText: !_showPassword,
                              decoration: InputDecoration(
                                hintText: 'Mot de passe',
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: bcGrey()),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: bc()),
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () => setState(
                                      () => _showPassword = !_showPassword),
                                  icon: _showPassword
                                      ? const Icon(Icons.visibility_off)
                                      : const Icon(Icons.visibility),
                                ),
                              ),
                              keyboardType: TextInputType.visiblePassword,
                              textInputAction: TextInputAction.done,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: Insets.medium),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: bc(),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(Insets.small),
                            ),
                          ),
                          onPressed: () => _signIn(),
                          child: const CustomTextWidget('Se connecter'),
                        ),
                      ),
                      const SizedBox(height: Insets.medium),
                      const Center(
                        child: CustomTextWidget(
                          'Vous n\'avez pas de compte ?',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Center(
                        child: TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: bc(),
                          ),
                          onPressed: () => Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                                  builder: (_) => const SignUpPage())),
                          child: const CustomTextWidget('S\'inscrire'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _signIn() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    if (_formKey.currentState?.validate() ?? false) {
      try {
        final credential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailFieldController.text.trim(),
          password: _passwordFieldController.text.trim(),
        );

        if (credential.user != null) {
          navigator.pushReplacement(
              MaterialPageRoute(builder: (_) => const HomePage()));
        }
      } on FirebaseAuthException catch (e, stackTrace) {
        final String errorMessage;

        if (e.code == 'user-not-found') {
          errorMessage = 'Aucun utilisateur trouvé pour cet email.';
        } else if (e.code == 'wrong-password') {
          errorMessage = 'Mot de passe incorrect.';
        } else {
          errorMessage = 'Une erreur s\'est produite';
        }

        log(
          'Error while signing in: ${e.code}',
          error: e,
          stackTrace: stackTrace,
          name: 'SignInPage',
        );
        scaffoldMessenger.showSnackBar(SnackBar(content: Text(errorMessage)));
      }
    }
  }
}
