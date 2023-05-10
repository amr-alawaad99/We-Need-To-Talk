import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:we_need_to_talk/layout/cubit/states.dart';
import 'package:we_need_to_talk/module/profile_screen/profile_screen.dart';
import 'package:we_need_to_talk/module/settings_screen/settings_screen.dart';
import 'package:we_need_to_talk/shared/components/components.dart';

import '../../layout/cubit/cubit.dart';
import '../login_screen/login_screen.dart';

class DrawerScreen extends StatelessWidget {
  const DrawerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var chatCubit = ChatAppCubit.get(context);
    var profilePic = ChatAppCubit.get(context).profilePic;
    return BlocConsumer<ChatAppCubit, ChatAppStates>(
      listener: (context, state) {
        if(state is SignOutSuccessState) {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen(),),(route) => false,);
        }
      },
      builder: (context, state) {
        return SafeArea(
          child: Drawer(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  // Profile : profile pic > name/bio
                  InkWell(
                    child: Row(
                      children: [
                        // profile pic
                        CircleAvatar(
                          radius: 35.0,
                          backgroundImage: (profilePic == null) ? NetworkImage('${chatCubit.originalUser!.profilePic}')
                              : FileImage(File(profilePic.path)) as ImageProvider,),
                        const SizedBox(
                          width: 20.0,
                        ),
                        // name/bio
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                chatCubit.originalUser!.username!,
                                style: GoogleFonts.aBeeZee(
                                  fontSize: 20.0,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 5.0,),
                              Text(
                                chatCubit.originalUser!.bio!,
                                style: Theme.of(context).textTheme.bodySmall,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    onTap: () => navigatePush(context, const ProfileScreen()),
                  ),
                  divider(),
                  InkWell(
                    child: Container(
                      height: 60.0,
                      padding: const EdgeInsetsDirectional.only(start: 20.0,),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.settings,
                            size: 30.0,
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          Text(
                            'Settings',
                            style: TextStyle(
                              fontSize: 20.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen(),),);
                    },
                  ),
                  const SizedBox(height: 20.0,),
                  Container(
                    child: defaultButton(
                      onPressedFunction: () {
                          ChatAppCubit.get(context).singOut();
                      },
                      buttonColor: Colors.deepPurpleAccent,
                      text: 'Sign-out',
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },

    );
  }
}
