import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:we_need_to_talk/shared/components/components.dart';

import '../../layout/cubit/cubit.dart';
import '../../layout/main_screen.dart';
import '../../model/user_model.dart';
import '../../shared/local/cache_helper.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var usernameController = TextEditingController();
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    var phoneNumberController = TextEditingController();
    var formKey = GlobalKey<FormState>();

    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
        listener: (context, state) {
          if (state is RegisterUserErrorState) {
            print('can\'t login');
          }
          if (state is RegisterUserSuccessState) {
            CacheHelper.saveData(key: 'uid', value: state.uid)
                .then((value) {
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const MainScreen(),), (route) => false);
              ChatAppCubit.get(context).originalUser = UserModel();
              ChatAppCubit.get(context).getUserData();    //TO GET THE NEW LOGGED IN ACCOUNT IMMEDIATELY RATHER THAN THE PREVIOUS ACCOUNT!!
            });
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0.0,
              foregroundColor: Colors.black,
            ),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Register',
                          style: GoogleFonts.abhayaLibre(
                            fontSize: 50.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        Text(
                          'Register ysta so we can nr3\'y in peace!',
                          style: GoogleFonts.abhayaLibre(
                            color: Colors.grey,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        // User name TFF
                        Container(
                          child: defaultTextFromField(
                            controller: usernameController,
                            inputType: TextInputType.name,
                            prefixIcon: Icons.person,
                            label: 'User Name',
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'username can\'t be empty';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        // Email TFF
                        Container(
                          child: defaultTextFromField(
                            controller: emailController,
                            inputType: TextInputType.emailAddress,
                            prefixIcon: Icons.email_outlined,
                            label: 'Email Address',
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'email address can\'t be empty';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        // Password TFF
                        Container(
                          child: defaultTextFromField(
                            controller: passwordController,
                            inputType: TextInputType.visiblePassword,
                            prefixIcon: Icons.password,
                            isObscure: RegisterCubit.get(context).isInvisible,
                            suffixIcon: RegisterCubit.get(context).passSuffix,
                            label: 'Password',
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'password can\'t be empty';
                              }
                              return null;
                            },
                            suffixPressFunction: () {
                              RegisterCubit.get(context)
                                  .changePasswordVisibility();
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        // Phone number TFF
                        Container(
                          child: defaultTextFromField(
                            controller: phoneNumberController,
                            inputType: TextInputType.phone,
                            prefixIcon: Icons.phone,
                            label: 'Phone Number',
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'phone number can\'t be empty';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        if (state is RegisterUserLoadingState)
                          const LinearProgressIndicator(),
                        const SizedBox(height: 5.0),
                        // Register Button
                        Container(
                          child: defaultButton(
                            onPressedFunction: () {
                              if (formKey.currentState!.validate()) {
                                RegisterCubit.get(context).registerUser(
                                    username: usernameController.text,
                                    email: emailController.text,
                                    password: passwordController.text,
                                    phone: phoneNumberController.text);
                              }
                            },
                            text: 'Register',
                          ),
                        ),
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
