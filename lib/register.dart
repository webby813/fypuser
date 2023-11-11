import 'package:fypuser/Firebase/create_data.dart';
import 'package:fypuser/login.dart';
import 'package:flutter/material.dart';
import 'package:fypuser/Components/title_widget.dart';
import 'package:fypuser/Components/button_widget.dart';
import 'package:fypuser/Components/text_widget.dart';
import 'package:fypuser/Components/inputField_widget.dart';
import 'package:fypuser/Components/alertDialog_widget.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  bool hideText = true;

  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController passwordConfirm = TextEditingController();

  bool isEmailValid(String email) {
    final pattern = r'^[\w-]+(\.[\w-]+)*@([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,7}$';
    final regExp = RegExp(pattern);
    return regExp.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 90,
            left: -90,
            child: TitleWidget.title('REGISTER'),
          ),

          Container(
            margin: const EdgeInsets.only(top: 125.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  child: inputWidget.inputField('Username', Icons.person_outline, username),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  child: inputWidget.inputField('E-mail', Icons.email, email),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  child: PasswordInputWidget.passwordInput('Password', Icons.lock, password),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  child: PasswordInputWidget.passwordInput('confirm your password', Icons.lock, passwordConfirm),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 15),
                  child: ButtonWidget.buttonWidget('REGISTER', () {
                    if (username.text.isNotEmpty && email.text.isNotEmpty && password.text == passwordConfirm.text) {
                      if (isEmailValid(email.text)) {
                        if (password.text.length >= 8 &&
                            RegExp(r'^(?=.*?[A-Z])(?=.*?[0-9])(?=.*?[!@#$&*~]).*$').hasMatch(password.text)) {
                            RegisterService().createData(context, username.text, email.text, password.text);
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialogWidget(
                                Title: 'Error',
                                content: 'Password must contain at least 8 characters, including at least 1 uppercase letter, 1 number, and 1 special symbol.',
                              );
                            },
                          );
                        }
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialogWidget(Title: 'Error', content: 'Invalid email format');
                          },
                        );
                      }
                    } else if (username.text.isEmpty || email.text.isEmpty || password.text.isEmpty || passwordConfirm.text.isEmpty) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialogWidget(Title: 'Error', content: 'Please don\'t leave any fields empty');
                        },
                      );
                    } else if (password.text != passwordConfirm.text) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialogWidget(Title: 'Error', content: 'Password inputs are different');
                        },
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialogWidget(Title: 'Error', content: 'Something went wrong');
                        },
                      );
                    }
                  }),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text('Already a member?'),
                    TextButton(
                      child: TextWidget.textWidget('SignIn'),
                      onPressed: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Login()));
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
