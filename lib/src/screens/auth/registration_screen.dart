import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:state_change_demo/src/controllers/auth_controller.dart';
import 'package:state_change_demo/src/dialogs/waiting_dialog.dart';

class RegisterScreen extends StatefulWidget {
  static const String route = "/register";
  static const String name = "Register Screen";
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late GlobalKey<FormState> formKey;
  late TextEditingController username, password, passwordSec;
  late FocusNode usernameFn, passwordFn, passwordFnSec;

  bool obfuscate = true;

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    username = TextEditingController();
    password = TextEditingController();
    passwordSec = TextEditingController();
    usernameFn = FocusNode();
    passwordFn = FocusNode();
    passwordFnSec = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    username.dispose();
    password.dispose();
    passwordSec.dispose();
    usernameFn.dispose();
    passwordFn.dispose();
    passwordFnSec.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Register",
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
            ),
          ),
        ),
        bottomOpacity: 100,
        backgroundColor: Colors.green,
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: TextFormField(
                    decoration: decoration.copyWith(
                        labelText: "Username",
                        prefixIcon: const Icon(Icons.person)),
                    focusNode: usernameFn,
                    controller: username,
                    onEditingComplete: () {
                      passwordFn.requestFocus();
                    },
                    validator: MultiValidator([
                      RequiredValidator(
                          errorText: 'Please fill out the username'),
                      MaxLengthValidator(32,
                          errorText: "Username cannot exceed 32 characters"),
                    ]).call,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Flexible(
                  child: TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: obfuscate,
                    decoration: decoration.copyWith(
                        labelText: "Password",
                        prefixIcon: const Icon(Icons.password),
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                obfuscate = !obfuscate;
                              });
                            },
                            icon: Icon(obfuscate
                                ? Icons.remove_red_eye_rounded
                                : CupertinoIcons.eye_slash))),
                    focusNode: passwordFn,
                    controller: password,
                    onEditingComplete: () {
                      passwordFnSec.requestFocus();

                      ///call submit maybe?
                    },
                    validator: MultiValidator([
                      RequiredValidator(errorText: "Password is required"),
                      MinLengthValidator(12,
                          errorText:
                              "Password must be at least 12 characters long"),
                      MaxLengthValidator(128,
                          errorText: "Password cannot exceed 72 characters"),
                      PatternValidator(
                          r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_+?\-=[\]{};':,.<>]).*$",
                          errorText:
                              'Password must contain at least one symbol, one uppercase letter, one lowercase letter, and one number.')
                    ]).call,
                  ),
                ),
                Flexible(
                  child: TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: obfuscate,
                      decoration: decoration.copyWith(
                          labelText: "Confirm Password",
                          prefixIcon: const Icon(Icons.password),
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  obfuscate = !obfuscate;
                                });
                              },
                              icon: Icon(obfuscate
                                  ? Icons.remove_red_eye_rounded
                                  : CupertinoIcons.eye_slash))),
                      focusNode: passwordFnSec,
                      controller: passwordSec,
                      onEditingComplete: () {
                        passwordFn.unfocus();
                      },
                      validator: (v) {
                        String? passwordMatch =
                            password.text.trim() == passwordSec.text.trim()
                                ? null
                                : "Password Doesnt Match";
                        if (passwordMatch != null) {
                          return passwordMatch;
                        } else {
                          MultiValidator([
                            RequiredValidator(
                                errorText: "Password is required"),
                            MinLengthValidator(12,
                                errorText:
                                    "Password must be at least 12 characters long"),
                            MaxLengthValidator(128,
                                errorText:
                                    "Password cannot exceed 72 characters"),
                            PatternValidator(
                                r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_+?\-=[\]{};':,.<>]).*$",
                                errorText:
                                    'Password must contain at least one symbol, one uppercase letter, one lowercase letter, and one number.')
                          ]).call;
                        }
                      }),
                ),
                TextButton(
                    onPressed: () {
                      onSubmit();
                    },
                    child: Container(
                        height: 50,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Center(
                            child: Text(
                          "Register",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        )))),
              ],
            ),
          ),
        ),
      ),
    );
  }

  onSubmit() {
    if (formKey.currentState?.validate() ?? false) {
      WaitingDialog.show(context,
          future: AuthController.I
              .register(username.text.trim(), password.text.trim()));
    }
  }

  final OutlineInputBorder _baseBorder = const OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey),
    borderRadius: BorderRadius.all(Radius.circular(4)),
  );

  InputDecoration get decoration => InputDecoration(
      // prefixIconColor: AppColors.primary.shade700,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      filled: true,
      fillColor: Colors.white,
      errorMaxLines: 3,
      disabledBorder: _baseBorder,
      enabledBorder: _baseBorder.copyWith(
        borderSide: const BorderSide(color: Colors.black87, width: 1),
      ),
      focusedBorder: _baseBorder.copyWith(
        borderSide: const BorderSide(color: Colors.blueAccent, width: 1),
      ),
      errorBorder: _baseBorder.copyWith(
        borderSide: const BorderSide(color: Colors.deepOrangeAccent, width: 1),
      )
      // errorStyle:
      // AppTypography.body.b5.copyWith(color: AppColors.highlight.shade900),
      // focusedErrorBorder: _baseBorder.copyWith(
      // borderSide: BorderSide(color: AppColors.highlight.shade900, width: 1),
      // ),
      // labelStyle: AppTypography.subheading.s1
      //     .copyWith(color: AppColors.secondary.shade2),
      // floatingLabelStyle: AppTypography.heading.h5
      //     .copyWith(color: AppColors.primary.shade400, fontSize: 18),
      // hintStyle: AppTypography.subheading.s1
      //     .copyWith(color: AppColors.secondary.shade2),
      );
}
