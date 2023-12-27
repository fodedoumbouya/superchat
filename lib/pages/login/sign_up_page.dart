import 'dart:developer';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:superchat/base/baseWidget.dart';
import 'package:superchat/pages/home.dart';
import 'package:superchat/pages/login/sign_in_page.dart';
import 'package:superchat/util/adapterHelper/responsive_sizer.dart';
import 'package:superchat/util/constants.dart';
import 'package:superchat/widgets/custom/customTextWidget.dart';

class SignUpPage extends BaseWidget {
  const SignUpPage({super.key});

  @override
  BaseWidgetState<BaseWidget> getState() {
    return _SignUpPageState();
  }
}

class _SignUpPageState extends BaseWidgetState<SignUpPage> {
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
          title: CustomTextWidget(
            kAppTitle,
            color: bp(),
          ),
          backgroundColor: bc()),
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
                        'Créez votre compte Superchat',
                        // style: theme.textTheme.headlineLarge,
                        size: 25.sp,
                        withOverflow: false,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: Insets.extraLarge),
                      const CustomTextWidget(
                        'Email',
                        textAlign: TextAlign.center,
                      ),
                      TextFormField(
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
                      const SizedBox(height: Insets.medium),
                      const CustomTextWidget(
                        'Mot de passe',
                        textAlign: TextAlign.center,
                      ),
                      StatefulBuilder(
                        builder: (context, setState) {
                          return TextFormField(
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
                          );
                        },
                      ),
                      const SizedBox(height: Insets.medium),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: bp(),
                            backgroundColor: bc(),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(Insets.small),
                            ),
                          ),
                          onPressed: () => _signUp(),
                          child: const CustomTextWidget('S\'inscrire'),
                        ),
                      ),
                      const SizedBox(height: Insets.medium),
                      const Center(
                        child: CustomTextWidget(
                          'Vous avez déjà un compte ?',
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
                                  builder: (_) => const SignInPage())),
                          child: const CustomTextWidget('Se connecter'),
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

  Future<void> _signUp() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    if (_formKey.currentState?.validate() ?? false) {
      try {
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailFieldController.text.trim(),
          password: _passwordFieldController.text.trim(),
        );

        if (credential.user != null) {
          navigator.pushReplacement(
              MaterialPageRoute(builder: (_) => const HomePage()));
        }
      } on FirebaseAuthException catch (e, stackTrace) {
        final String errorMessage;

        if (e.code == 'weak-password') {
          errorMessage = 'Le mot de passe est trop faible.';
        } else if (e.code == 'email-already-in-use') {
          errorMessage = 'Cet email est déjà associé à un compte existant.';
        } else {
          errorMessage = 'Une erreur est survenue.';
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
