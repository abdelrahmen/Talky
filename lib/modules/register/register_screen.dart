import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talky/modules/chats_screen.dart';
import 'package:talky/modules/register/cubit/cubit.dart';
import 'package:talky/modules/register/cubit/states.dart';
import 'package:talky/shared/components.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state is RegisterSuccessfulState) {
            navigateWithNoBack(context, ChatsScreen());
          }
          if (state is RegisterErrorState) {
            showSnackBar(context, state.error);
          }
        },
        builder: (context, state) {
          final cubit = RegisterCubit.get(context);
          return Scaffold(
            body: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //big login text
                        const Text(
                          'REGISTER',
                          style: TextStyle(
                            fontSize: 40,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        //name form field
                        TextFormField(
                          controller: nameController,
                          keyboardType: TextInputType.name,
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return "Please Enter a Valid Name";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text('Name'),
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
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
                        //register button
                        SizedBox(
                          width: double.infinity,
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState?.validate() ?? false) {
                                cubit.register(
                                  email: emailController.text,
                                  password: passwordController.text,
                                  name: nameController.text,
                                );
                              }
                            },
                            child: const Text('Register'),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const SizedBox(height: 10,),
                        if(state is RegisterLoadingState)
                          const Center(child: CircularProgressIndicator(),),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
