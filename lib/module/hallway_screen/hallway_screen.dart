import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:we_need_to_talk/layout/cubit/cubit.dart';
import 'package:we_need_to_talk/layout/cubit/states.dart';
import 'package:we_need_to_talk/model/hallway_model.dart';

import '../../shared/components/components.dart';
import '../../shared/components/constants.dart';
import '../chat_screen/chat_screen.dart';
import '../drawer_screen/drawer_screen.dart';

class HallWayScreen extends StatelessWidget {
  const HallWayScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = ChatAppCubit.get(context);
    return Builder(
      builder: (context) {
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
                    onPressed: () {},
                    icon: const Icon(Icons.search),
                  ),
                ],
              ),
              body: StreamBuilder<List<HallwayCardModel>>(
                stream: cubit.readHallway(),
                builder: (context, snapshot) {
                  if(snapshot.hasError){
                    return Text('Something went wrong! ${snapshot.error}');
                  } else if(snapshot.hasData){
                    final hallway = snapshot.data!.reversed;

                    return ListView(
                      children: hallway.map((e) => buildHallwayCard(e, context)).toList(),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
              // body: ConditionalBuilder(
              //   condition: cubit.reversedHallway.isNotEmpty,
              //   builder: (context) => Padding(
              //     padding: const EdgeInsets.only(top: 10.0),
              //     child: ListView.separated(
              //       itemBuilder: (context, index) => buildHallwayCard(cubit.reversedHallway[index] ,context),
              //       itemCount: cubit.reversedHallway.length,
              //       separatorBuilder: (context, index) => divider(),
              //     ),
              //   ),
              //   fallback: (context) => const Center( child: CircularProgressIndicator()),
              // ),
            );
          },
        );
      },
    );
  }

  Widget buildHallwayCard(HallwayCardModel model, context) => InkWell(
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          //chat pic
          CircleAvatar(
            radius: 35.0,
            backgroundImage: NetworkImage(
                '${model.endPic}'),
          ),
          const SizedBox(
            width: 10.0,
          ),
          //chat name and message
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${model.endName}',
                  style: const TextStyle(
                    fontSize: 18.0,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Container(
                  padding: const EdgeInsets.all(2.0),
                  child: Text(
                    model.senderId == uid?
                      'You : ${model.lastMessage}' : '${model.endName} : ${model.lastMessage}',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(fontSize: 16.0),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 10.0,
          ),
          //date/time
          Text(
            DateFormat.jm().format(DateTime.parse(model.dateTimeForOrder!).toLocal()).toString(),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    ),
    onTap: () {
      navigatePush(context, ChatScreen(model.endID!, model.endName!, model.endPic!));
    },
  );
}
