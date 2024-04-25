import 'package:fypuser/Components/button_widget.dart';
import 'package:fypuser/Components/text_widget.dart';
import 'package:fypuser/Components/title_widget.dart';
import 'package:fypuser/Components/Input_Field_widget.dart';
import 'package:fypuser/Firebase/retrieve_data.dart';
import 'package:fypuser/register.dart';
import 'package:flutter/material.dart';
import 'package:fypuser/Components/alertDialog_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    return isLoggedIn;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
            children: [
              Positioned(
                top: 90,
                left: -90,
                child: TitleWidget.title('SIGN IN'),
              ),

              Container(
                margin: const EdgeInsets.only(top:50.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,

                  children:[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      child: InputWidget.inputField('Username', Icons.person_outline, email),
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      child: PasswordInputWidget.passwordInput('Password', Icons.lock, password),
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 15),
                      child: ButtonWidget.buttonWidget('LOG IN', (){
                        if(email.text.isNotEmpty && password.text.isNotEmpty){
                          // Identify().loginCheck(context, username.text, password.text);
                          Checking().checkCredential(context, email.text, password.text);
                        }
                        else if(email.text.isEmpty || password.text.isEmpty){
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const AlertDialogWidget(title: 'Error', content: 'Empty credential');
                            },
                          );
                        }
                        else{
                          showDialog(context: context, builder: (BuildContext context){
                            return const AlertDialogWidget(title: 'Error', content: 'Unknown error');
                          });
                        }
                      }),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text('Wanna join us?'),
                        TextButton(
                          child: TextWidget.textWidget('Register'),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const Register()));
                          },
                        ),
                      ],
                    ),
                  ]
                )
              )
        ],
      ),
    );
  }
}
