import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_need_to_talk/layout/cubit/cubit.dart';
import 'package:we_need_to_talk/layout/cubit/states.dart';
import 'package:we_need_to_talk/model/user_model.dart';
import 'package:we_need_to_talk/shared/components/components.dart';

class SearchUsersScreen extends StatelessWidget {
  const SearchUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var searchController = TextEditingController();

    return BlocConsumer<ChatAppCubit, ChatAppStates>(
      listener: (context, state) {
        if (state is GetFriendsListSuccessState) {
          ChatAppCubit.get(context)
              .findUsers(searchUser: searchController.text);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            flexibleSpace: SafeArea(
              child: Container(
                padding: const EdgeInsetsDirectional.only(
                    start: 55.0, end: 10.0, top: 5.0, bottom: 5.0),
                child: defaultTextFromField(
                  controller: searchController,
                  inputType: TextInputType.name,
                  prefixIcon: Icons.search,
                  hintText: 'Search',
                  borderRadius: 25.0,
                  isLabel: false,
                  onFieldSubmitted: (value) {
                    ChatAppCubit.get(context)
                        .findUsers(searchUser: searchController.text);
                  },
                ),
              ),
            ),
          ),
          body: ConditionalBuilder(
            condition: ChatAppCubit.get(context).usersFound.isNotEmpty,
            builder: (context) => ListView.separated(
              itemBuilder: (context, index) => searchResults(
                model: ChatAppCubit.get(context).usersFound[index],
                context: context,
              ),
              separatorBuilder: (context, index) => divider(),
              itemCount: ChatAppCubit.get(context).usersFound.length,
            ),
            fallback: (context) => state is GetFriendsListSuccessState
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : const Center(child: Text('no users found')),
          ),
        );
      },
    );
  }

  Widget searchResults({
    context,
    required UserModel model,
  }) =>
      InkWell(
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
                  //add/remove
                  IconButton(
                    onPressed: () {
                      ChatAppCubit.get(context).manageFriendList(
                        model: model,
                      );
                    },
                    icon: Icon(model.isFriend == true
                        ? Icons.person_add_disabled
                        : Icons.person_add),
                  ),
                ],
              ),
            ],
          ),
        ),
        onTap: () {},
      );
}
