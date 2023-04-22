import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_need_to_talk/layout/cubit/cubit.dart';
import 'package:we_need_to_talk/layout/cubit/states.dart';
import 'package:we_need_to_talk/shared/components/components.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatAppCubit, ChatAppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = ChatAppCubit.get(context).originalUser;
        return Scaffold(
            appBar: AppBar(),
            body: Column(
              children: [
                Text('SettingsScreen'),
                defaultButton(
                    onPressedFunction: () {
                      print(cubit!.username);
                      print(cubit.bio);
                      print(cubit.profilePic);
                    },
                    text: 'here')
              ],
            ));
      },
    );
  }
}
