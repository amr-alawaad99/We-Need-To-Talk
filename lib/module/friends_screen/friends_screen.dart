import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_need_to_talk/module/chat_screen/chat_screen.dart';
import 'package:we_need_to_talk/module/friends_screen/search_users_screen/search_users_screen.dart';
import '../../layout/cubit/cubit.dart';
import '../../layout/cubit/states.dart';
import '../../model/user_model.dart';
import '../../shared/components/components.dart';
import '../drawer_screen/drawer_screen.dart';

class FriendsScreen extends StatelessWidget {
  const FriendsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = ChatAppCubit.get(context);
    return Builder(
      builder: (context) {
        if(cubit.friendsList.isEmpty)
          cubit.getFriendList();
        return BlocConsumer<ChatAppCubit, ChatAppStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return Scaffold(
              drawer: const DrawerScreen(),
              appBar: AppBar(
                title: Text(
                  cubit.titles[cubit.currentIndex],
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      ChatAppCubit.get(context).findUsers(searchUser: '');
                      navigatePush(context, const SearchUsersScreen());
                    },
                    icon: const Icon(Icons.person_add),
                  ),
                  IconButton(
                    onPressed: () {
                      cubit.getFriendList();
                    },
                    icon: const Icon(Icons.list),
                  ),
                ],
              ),
              body: ConditionalBuilder(
                condition: cubit.friendsList.isNotEmpty,
                builder: (context) => Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: ListView.separated(
                    itemBuilder: (context, index) => buildFriendCard(model: cubit.friendsList[index], context: context),
                    itemCount: cubit.friendsList.length,
                    separatorBuilder: (context, index) => divider(),
                  ),
                ),
                fallback: (context) => const Center( child: CircularProgressIndicator()),
              ),
            );
          },
        );
      },
    );
  }
}


Widget buildFriendCard({required context, required UserModel model}) => InkWell(
  child: Padding(
    padding: const EdgeInsets.all(10.0),
    child: Column(
      children: [
        Row(
          children: [
            //account pic
            CircleAvatar(
              radius: 35.0,
              backgroundImage: NetworkImage('${model.profilePic}'),
            ),
            const SizedBox(
              width: 10.0,
            ),
            //chat name and bio
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${model.username}',
                    style: const TextStyle(
                      fontSize: 18.0,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${model.bio}',
                    style: Theme.of(context)
                        .textTheme
                        .caption
                        ?.copyWith(fontSize: 16.0),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 10.0,
            ),
          ],
        ),
      ],
    ),
  ),
  onTap: () {
    navigatePush(context, ChatScreen(model.uid!, model.username!, model.profilePic!));
  },
);