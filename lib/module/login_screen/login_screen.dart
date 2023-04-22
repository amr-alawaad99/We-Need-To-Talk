import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:we_need_to_talk/layout/cubit/cubit.dart';
import 'package:we_need_to_talk/layout/main_screen.dart';
import 'package:we_need_to_talk/module/login_screen/cubit/cubit.dart';
import 'package:we_need_to_talk/module/login_screen/cubit/states.dart';
import 'package:we_need_to_talk/module/register_screen/register_screen.dart';
import 'package:we_need_to_talk/shared/components/components.dart';
import 'package:we_need_to_talk/shared/local/cache_helper.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    var formKey = GlobalKey<FormState>();

    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {
          if (state is LoginErrorState) {
            showToast(
                message:
                    'Login Failed\nYour email or password is incorrect.\nPlease try again', toastColor: Colors.red);
          }
          if (state is LoginSuccessState) {
            CacheHelper.saveData(key: 'uid', value: state.uid).then((value) {
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const MainScreen(),), (route) => false);
              ChatAppCubit.get(context).getUserData();    //TO GET THE NEW LOGGED IN ACCOUNT IMMEDIATELY RATHER THAN THE PREVIOUS ACCOUNT!!
            });
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0.0,
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
                          'Login',
                          style: GoogleFonts.abhayaLibre(
                            fontSize: 50.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        Text(
                          'login ysta so we can nr3\'y in peace!',
                          style: GoogleFonts.abhayaLibre(
                            color: Colors.grey,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
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
                                return 'please ysta enter your email address b-allah 3lek mt4lne4';
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
                            isObscure: LoginCubit.get(context).isInvisible,
                            suffixIcon: LoginCubit.get(context).passSuffix,
                            label: 'Password',
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'please ysta enter your password b-allah 3lek mt4lne4';
                              }
                              return null;
                            },
                            suffixPressFunction: () {
                              LoginCubit.get(context)
                                  .changePasswordVisibility();
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        if (state is LoginLoadingState)
                          const LinearProgressIndicator(),
                        const SizedBox(height: 5.0),
                        // Login Button
                        Container(
                          child: defaultButton(
                            onPressedFunction: () {
                              if (formKey.currentState!.validate()) {
                                LoginCubit.get(context).userLogin(
                                    email: emailController.text,
                                    password: passwordController.text);
                              }
                            },
                            text: 'login',
                          ),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        // Text > TextButton
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Don\'t have an account?',
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const RegisterScreen(),
                                    ));
                              },
                              child: const Text(
                                'Register now!',
                              ),
                            ),
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
      ),
    );
  }
}
