import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_need_to_talk/layout/cubit/cubit.dart';
import 'package:we_need_to_talk/layout/cubit/states.dart';
import 'package:we_need_to_talk/shared/components/components.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatAppCubit, ChatAppStates>(
      listener: (context, state) {

      },
      builder: (context, state) {

        var nameController = TextEditingController();
        var bioController = TextEditingController();
        var chatCubit = ChatAppCubit.get(context);
        var profilePic = ChatAppCubit.get(context).profilePic;
        nameController.text = chatCubit.originalUser!.username!;
        bioController.text = chatCubit.originalUser!.bio!;
        var formKey = GlobalKey<FormState>();


        return Scaffold(
          appBar: AppBar(
            title: const Text('Profile'),
          ),
          body: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                            radius: 80.0,
                            backgroundImage: (profilePic == null) ? NetworkImage('${chatCubit.originalUser!.profilePic}')
                                : FileImage(File(profilePic.path)) as ImageProvider,
                        ),
                        IconButton(
                          onPressed: () {
                            ChatAppCubit.get(context).getProfilePic();
                          },
                          icon: const CircleAvatar(
                            backgroundColor: Colors.deepPurpleAccent,
                            child: Icon(
                              Icons.camera_alt_outlined,
                              size: 25.0,
                              color: Colors.white,
                            ),
                          ),
                          padding: EdgeInsetsDirectional.zero,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    Container(
                      child: defaultTextFromField(
                        controller: nameController,
                        inputType: TextInputType.name,
                        prefixIcon: Icons.person,
                        label: 'User Name',
                        validator: (value) {
                          if(value!.isEmpty){
                            return 'Username can not be empty';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    Container(
                      child: defaultTextFromField(
                        controller: bioController,
                        inputType: TextInputType.text,
                        prefixIcon: Icons.info_outline,
                        label: 'Bio..',
                        validator: (value) {
                          if(value!.isEmpty){
                            return 'Bio can not be empty';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    Container(
                        child: defaultButton(
                          onPressedFunction: () {
                            if(profilePic != null) {
                              chatCubit.uploadProfilePic(
                              name: nameController.text,
                              bio: bioController.text,
                            );
                            } else {
                              if(formKey.currentState!.validate()){
                                chatCubit.updateUserProfile(
                                  name: nameController.text,
                                  bio: bioController.text,
                                );
                              }
                            }
                          },
                          text: 'Update',
                          buttonColor: Colors.deepPurpleAccent,
                        )),
                    if(state is GetUserDataLoadingState || state is UploadProfilePicLoadingState)
                      SizedBox(height: 10.0,),
                    if(state is GetUserDataLoadingState || state is UploadProfilePicLoadingState)
                      LinearProgressIndicator(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
