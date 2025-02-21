import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/providers/auth_provider.dart';
import 'package:story_app/widgets/border.dart';

class RegisterScreen extends StatefulWidget {
  final Function() onRegister;
  final Function() onLogin;

  const RegisterScreen(
      {super.key, required this.onRegister, required this.onLogin});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 140,
                  ),
                  Text(
                    'Register',
                    style: Theme.of(context).textTheme.displayLarge,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24),
                  TextFormField(
                    controller: nameController,
                    onSaved: (name) {},
                    onChanged: (name) {},
                    validator: (name) {
                      if (name == null || name.isEmpty) {
                        return 'Please enter your name.';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        hintText: "Enter your name",
                        labelText: "Name",
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintStyle: const TextStyle(color: Color(0xFF757575)),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        suffix: Icon(Icons.person_rounded),
                        border: authOutlineInputBorder,
                        enabledBorder: authOutlineInputBorder,
                        focusedBorder: authOutlineInputBorder.copyWith(
                            borderSide:
                                const BorderSide(color: Colors.pinkAccent))),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: TextFormField(
                      controller: emailController,
                      onSaved: (email) {},
                      onChanged: (email) {},
                      validator: (email) {
                        if (email == null || email.isEmpty) {
                          return 'Please enter your email.';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          hintText: "Enter your email",
                          labelText: "Email",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintStyle: const TextStyle(color: Color(0xFF757575)),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                          suffix: Icon(Icons.mail),
                          border: authOutlineInputBorder,
                          enabledBorder: authOutlineInputBorder,
                          focusedBorder: authOutlineInputBorder.copyWith(
                              borderSide:
                                  const BorderSide(color: Colors.pinkAccent))),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: TextFormField(
                      controller: passwordController,
                      onSaved: (password) {},
                      onChanged: (password) {},
                      validator: (password) {
                        if (password == null || password.isEmpty) {
                          return 'Please enter your password.';
                        } else if (password.length < 8) {
                          return 'Password must be at least 8 characters long';
                        }
                        return null;
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                          hintText: "Enter your password",
                          labelText: "Password",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintStyle: const TextStyle(color: Color(0xFF757575)),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                          suffix: Icon(Icons.lock),
                          border: authOutlineInputBorder,
                          enabledBorder: authOutlineInputBorder,
                          focusedBorder: authOutlineInputBorder.copyWith(
                              borderSide:
                                  const BorderSide(color: Colors.pinkAccent))),
                    ),
                  ),
                  context.watch<AuthProvider>().isLoadingRegister
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.pinkAccent,
                          ),
                        )
                      : ElevatedButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              final scaffoldMessenger =
                                  ScaffoldMessenger.of(context);
                              final provider = context.read<AuthProvider>();
                              final name = nameController.text;
                              final email = emailController.text;
                              final password = passwordController.text;
                              final result = await provider.register(
                                  name, email, password);
                              if (result) {
                                _clearInput();
                                scaffoldMessenger.showSnackBar(SnackBar(
                                    duration: Duration(seconds: 1),
                                    content: const Text('User created.')));
                                await Future.delayed(Duration(seconds: 2));
                                widget.onLogin();
                              } else {
                                scaffoldMessenger.showSnackBar(SnackBar(
                                    content: Text(provider.errorMessage)));
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Colors.pinkAccent,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 48),
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16)),
                            ),
                          ),
                          child: const Text("Register"),
                        ),
                  TextButton(
                    style: TextButton.styleFrom(
                      splashFactory:
                          NoSplash.splashFactory, // Menonaktifkan efek ripple
                    ),
                    onPressed: () {
                      _clearInput();
                      widget.onLogin();
                    },
                    child: Text.rich(
                      const TextSpan(
                        text: "Do you have an account ? ",
                        children: [
                          TextSpan(
                            text: "Login",
                            style: TextStyle(color: Colors.pinkAccent),
                          ),
                        ],
                      ),
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .color!
                                .withValues(alpha: 0.64),
                          ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      )),
    );
  }

  void _clearInput() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
  }
}
