import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/providers/auth_provider.dart';
import 'package:story_app/widgets/border.dart';

class LoginScreen extends StatefulWidget {
  final Function() onLogin;
  final Function() onRegister;

  const LoginScreen(
      {super.key, required this.onLogin, required this.onRegister});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  double _btnLoginWidth = 500;

  @override
  void dispose() {
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
                    'Login',
                    style: Theme.of(context).textTheme.displayLarge,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24),
                  TextFormField(
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
                  context.watch<AuthProvider>().isLoadingLogin
                      ? Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.pinkAccent,
                          ),
                          child: Center(
                              child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          )),
                        )
                      : AnimatedContainer(
                          width: _btnLoginWidth,
                          duration: Duration(milliseconds: 150),
                          child: ElevatedButton(
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                setState(() {
                                  _btnLoginWidth = 0;
                                });
                                await Future.delayed(
                                    Duration(milliseconds: 160));
                                final scaffoldMessenger =
                                    ScaffoldMessenger.of(context);
                                final provider = context.read<AuthProvider>();
                                final email = emailController.text;
                                final password = passwordController.text;
                                final result =
                                    await provider.login(email, password);
                                if (result) {
                                  widget.onLogin();
                                } else {
                                  setState(() {
                                    _btnLoginWidth =
                                        MediaQuery.of(context).size.width;
                                  });
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
                            child: const FittedBox(child: Text("Login")),
                          ),
                        ),
                  TextButton(
                    style: TextButton.styleFrom(
                      splashFactory:
                          NoSplash.splashFactory, // Menonaktifkan efek ripple
                    ),
                    onPressed: () {
                      emailController.clear();
                      passwordController.clear();
                      widget.onRegister();
                    },
                    child: Text.rich(
                      const TextSpan(
                        text: "Don’t have an account ? ",
                        children: [
                          TextSpan(
                            text: "Register !",
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
}
