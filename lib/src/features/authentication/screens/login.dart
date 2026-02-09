import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:production/src/features/authentication/controllers/login_controller.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final loginController = Get.put(LoginController());

  Widget build(BuildContext context) {
    return (Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: 600,
          padding: const EdgeInsets.all(20),
          child: (Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text(
                "Enter Your Credentials",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Form(
                key: _formKey,
                child: SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextFormField(
                        controller: emailController,

                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          labelText: "email",
                          hintText: "Enter Your Mail ID",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(2)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        obscureText: true,
                        obscuringCharacter: "*",
                        controller: passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          labelText: "Password",
                          hintText: "Enter Your password",

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(2)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(5),
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                            fixedSize: const Size.fromWidth(240),
                            elevation: 3,
                            shape: const RoundedRectangleBorder(),
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.indigo,
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              loginController.tryLogin(
                                emailController.value.text,
                                passwordController.value.text,
                              );
                            }
                          },
                          child: const Text("SUBMIT"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
        ),
      ),
    ));
  }
}
