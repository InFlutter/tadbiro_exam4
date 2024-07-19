import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tadbiroemas_78/data/models/user/user_model.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import '../../logic/blocs/auth/auth_bloc.dart';
import '../../logic/blocs/user_bloc/user_bloc.dart';
import '../../logic/blocs/user_bloc/user_event.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmationController = TextEditingController();

  void submit() {
    if (formKey.currentState!.validate()) {
      // register
      // login
      context.read<AuthBloc>().add(
            RegisterEvent(
              emailController.text,
              passwordController.text,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Tadbiro",style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),),
              const SizedBox(height: 20),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Email",
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Email kiriting";
                  }

                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Parol",
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Parol kiriting";
                  }

                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: passwordConfirmationController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Parolni tasdiqlang",
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Parolni tasdiqlang";
                  }

                  if (passwordController.text !=
                      passwordConfirmationController.text) {
                    return "Parollar mos emas";
                  }

                  return null;
                },
              ),
              const SizedBox(height: 20),
              BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is ErrorAuthState) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.error),
                      ),
                    );
                  }

                  if (state is LoggedInState) {
                    UserModel userModel = UserModel.initialValue();
                    userModel = userModel.copyWith(
                      email:  emailController.text,
                      password: passwordController.text,
                    );
                    context.read<UserBloc>().add(UserInsertEvent(userModel));
                    Navigator.pop(context);
                  }
                },
                builder: (ctx, state) {
                  if (state is LoadingAuthState) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return Column(
                    children: [
                      ZoomTapAnimation(
                        onTap: submit,
                        child: Container(
                          width: double.infinity,
                          height: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.blue
                          ),
                          child: Center(
                            child: const Text("Royxatdan o'tish",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),),
                      ),
                      const SizedBox(height: 10),
                      ZoomTapAnimation(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: double.infinity,
                          height: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.deepPurple
                          ),
                          child: const Center(
                            child: Text("Kirish",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
