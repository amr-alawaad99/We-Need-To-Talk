import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_need_to_talk/layout/cubit/cubit.dart';
import 'package:we_need_to_talk/layout/cubit/states.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatAppCubit, ChatAppStates>(
        listener: (context, state) {},
        builder: (context, state) {

          var cubit = ChatAppCubit.get(context);

          return ConditionalBuilder(
            condition: cubit.originalUser != null,
            builder: (context) => Scaffold(
              bottomNavigationBar: BottomNavigationBar(
                onTap: (index) {
                  cubit.changeBottomNav(index);
                },
                currentIndex: cubit.currentIndex,
                items: const [
                  BottomNavigationBarItem(icon: Icon(Icons.chair), label: 'Hallway'),
                  BottomNavigationBarItem(icon: Icon(Icons.people_alt_outlined), label: 'Friends'),
                  BottomNavigationBarItem(icon: Icon(Icons.videocam), label: 'Calls'),
                ],
              ),
              body: cubit.screens[cubit.currentIndex],
            ),
            fallback: (context) => Container(
              color: Colors.white,
              child:const Center(child: CircularProgressIndicator(),
            )),
          );
        },
    );
  }
}
