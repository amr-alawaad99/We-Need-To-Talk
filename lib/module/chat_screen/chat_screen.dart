import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_list/chat_list.dart';
import 'package:we_need_to_talk/layout/cubit/cubit.dart';
import 'package:we_need_to_talk/layout/cubit/states.dart';
import 'package:we_need_to_talk/model/message_model.dart';

import '../../shared/components/constants.dart';

class ChatScreen extends StatefulWidget {

  final String chatUID;
  final String chatUsername;
  final String chatPicURL;

  const ChatScreen(this.chatUID, this.chatUsername, this.chatPicURL, {Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    var messageController = TextEditingController();
    double tffHeight = 40;
    return Builder(
      builder: (context) {
        ChatAppCubit.get(context).getMessages(receiverID: widget.chatUID);
        return BlocConsumer<ChatAppCubit,ChatAppStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                title: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(widget.chatPicURL),
                    ),
                    const SizedBox(width: 10.0,),
                    Expanded(
                      child: Text(widget.chatUsername,
                      overflow: TextOverflow.ellipsis,),
                    ),
                  ],
                ),
                actions: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.call),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.videocam_rounded),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.info_outline),
                  ),
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.only(left: 10.0,right: 10.0,bottom: 10.0),
                child: Column(
                  children: [
                    Expanded(
                      child: ChatList(
                        onMsgKey: (index) => ChatAppCubit.get(context).reversedChat[index].dateTime!,
                        itemBuilder: (context, index) {
                          if(ChatAppCubit.get(context).reversedChat[index].senderId == uid){
                                  return buildSentMessages(ChatAppCubit.get(context).reversedChat[index]);
                                } else {
                                  return buildReceivedMessages(ChatAppCubit.get(context).reversedChat[index]);
                                }
                        },
                        msgCount: ChatAppCubit.get(context).reversedChat.length,
                      ),
                    ),
                    const SizedBox(height: 20.0,),
                    Row(
                      children: [
                        Expanded(
                          child: Container(

                            padding: const EdgeInsets.only(left: 10.0,right: 10.0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey.shade600,
                              ),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: TextFormField(
                              controller: messageController,
                              keyboardType: TextInputType.multiline,
                              minLines: 1,
                              maxLines: 7,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Message',
                              ),
                              onChanged: (value) {
                                if(value.endsWith('\n')){
                                  tffHeight = 2*tffHeight;
                              }
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 10.0,),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.deepPurpleAccent,
                            border: null,
                            borderRadius: BorderRadius.circular(100.0),
                          ),
                          child: IconButton(
                            onPressed: () {
                              ChatAppCubit.get(context).sendMessage(
                                message: messageController.text,
                                dateTimeForOrder: DateTime.now().toUtc().toString(),
                                receiverID: widget.chatUID,
                              );
                              messageController.text = '';
                            },
                            icon: const Icon(Icons.arrow_forward_ios_rounded),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }
    );
  }

  Widget buildSentMessages(MessageModel messageModel) => Align(
    alignment: AlignmentDirectional.centerEnd,
    child: Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: Container(
        padding: const EdgeInsets.all(15.0),
        decoration: const BoxDecoration(
          borderRadius: BorderRadiusDirectional.only(
            topStart: Radius.circular(10.0),
            topEnd: Radius.circular(10.0),
            bottomStart: Radius.circular(10.0),
          ),
          color: Colors.deepPurpleAccent,
        ),
        child: Text(
          '${messageModel.message}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    ),
  );

  Widget buildReceivedMessages(MessageModel messageModel) => Align(
    alignment: AlignmentDirectional.centerStart,
    child: Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: Container(
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          borderRadius: const BorderRadiusDirectional.only(
            topStart: Radius.circular(10.0),
            topEnd: Radius.circular(10.0),
            bottomEnd: Radius.circular(10.0),
          ),
          color: Colors.grey.shade600,
        ),
        child: Text(
          '${messageModel.message}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    ),
  );
}
