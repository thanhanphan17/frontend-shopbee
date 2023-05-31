import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:http/http.dart';
class SignUpPage extends StatefulWidget {
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final emailControler = TextEditingController();
  final passController = TextEditingController();
  final nameControler = TextEditingController();
 
  bool termAndConditions = false;
  bool passToggle = true;

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Color(0xFF44E49E);
  }

  void signup(String email , password, name) async {
    
    try{
      Response response = await post(
        Uri.parse('http://4.194.216.57:3000/v1/sign-in'),
        body: {
          'full name': name, 
          'email' : email,
          'password' : password
        }
      );

      if(response.statusCode == 200){
        var data = jsonDecode(response.body.toString());
        print(data['token']);
        print('Sign up successfully');

      }else {
        print('failed');
      }
    }catch(e){
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFC0F4D0),
            Color(0xFFECFAB3),
          ],
        )),
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Image.asset(
                  "images/logo.png",
                  height: 300,
                  width: 300,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Welcome you,",
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 40),
                TextFormField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: " name",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.account_circle),
                  ),
                ),
                // SizedBox(height: 40),
                // TextFormField(
                //   keyboardType: TextInputType.name,
                //   decoration: InputDecoration(
                //     labelText: "Full name",
                //     border: OutlineInputBorder(),
                //     prefixIcon: Icon(Icons.person),
                //   ),
                // ),
                SizedBox(height: 40),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                SizedBox(height: 40),
                TextFormField(
                  keyboardType: TextInputType.visiblePassword,
                  controller: passController,
                  obscureText: passToggle,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                    suffix: InkWell(
                      onTap: () {
                        setState(() {
                          if (passToggle == true) {
                            passToggle = false;
                          } else {
                            passToggle = true;
                          }
                        });
                      },
                      child: Icon(
                          passToggle ? Icons.visibility : Icons.visibility_off),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                      checkColor: Colors.white,
                      fillColor: MaterialStateProperty.resolveWith(getColor),
                      value: termAndConditions,
                      onChanged: (bool? value) {
                        setState(() {
                          termAndConditions = value!;
                        });
                      },
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, "TermsAndConditionsPage");
                        },
                        child: Text(
                          "Agree with terms and conditions",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                InkWell(
                  onTap: () {
                    signup(emailControler.text.toString(), passController.text.toString(), nameControler.text.toString());
                    //Main page
                  },
                  child: Container(
                    height: 49,
                    width: 84,
                    decoration: BoxDecoration(
                      color: Color(0xFF44E49E),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/");
                      },
                      child: Text(
                        "Log In",
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
