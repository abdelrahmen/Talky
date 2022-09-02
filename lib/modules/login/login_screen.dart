import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talky/modules/chats_screen.dart';
import 'package:talky/modules/cubit/cubit.dart';
import 'package:talky/modules/cubit/states.dart';
import 'package:talky/modules/login/cubit/cubit.dart';
import 'package:talky/modules/login/cubit/states.dart';
import 'package:talky/modules/register/register_screen.dart';
import 'package:talky/shared/components.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<MainCubit, MainState>(
        listener: (context, state) {},
        builder: (context, state) {
          return BlocConsumer<LoginCubit, LoginStates>(
            listener: (context, state) {
              if (state is LoginSuccessfulState) {
                MainCubit.get(context).getAllUsers();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => ChatsScreen(),
                    ),
                    (route) => false);
              }
              if (state is LoginErrorState) {
                showSnackBar(context, state.error);
              }
            },
            builder: (context, state) {
              var cubit = LoginCubit.get(context);
              return Scaffold(
                body: Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //big login text
                            const Text(
                              'LOGIN',
                              style: TextStyle(
                                fontSize: 40,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            //email form field
                            TextFormField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return "Please Enter a Valid Email";
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                label: Text('Email'),
                                prefixIcon: Icon(Icons.email_outlined),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            //password form field
                            TextFormField(
                              controller: passwordController,
                              obscureText: cubit.isVisibile,
                              keyboardType: TextInputType.visiblePassword,
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return "Please Enter a Valid Password";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                label: const Text('Password'),
                                prefixIcon: const Icon(Icons.lock_outlined),
                                suffixIcon: IconButton(
                                  icon: Icon(cubit.eyeIcon),
                                  onPressed: () {
                                    cubit.changePassVisibility();
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            //login button
                            SizedBox(
                              width: double.infinity,
                              height: 40,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (formKey.currentState?.validate() ??
                                      false) {
                                    cubit.login(
                                      email: emailController.text,
                                      password: passwordController.text,
                                    );
                                  }
                                },
                                child: const Text('Login'),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            if (state is LoginLoadingState)
                              const Center(
                                child: CircularProgressIndicator(),
                              ),
                            const SizedBox(
                              height: 20,
                            ),
                            //dont have an account
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Don't have an account?"),
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              RegisterScreen(),
                                        ),
                                      );
                                    },
                                    child: const Text("Register")),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
