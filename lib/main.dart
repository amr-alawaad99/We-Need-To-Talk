import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_need_to_talk/layout/cubit/cubit.dart';
import 'package:we_need_to_talk/layout/main_screen.dart';
import 'package:we_need_to_talk/module/login_screen/login_screen.dart';
import 'package:we_need_to_talk/shared/bloc_observer.dart';
import 'package:we_need_to_talk/shared/components/constants.dart';
import 'package:we_need_to_talk/shared/local/cache_helper.dart';
import 'package:we_need_to_talk/shared/main_cubit.dart';
import 'package:we_need_to_talk/shared/main_cubit_states.dart';
import 'package:we_need_to_talk/styles/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.getInitialMessage();
  await CacheHelper.init();

  Bloc.observer = MyBlocObserver();

  uid = CacheHelper.getData(key: 'uid') ?? '';
  print('uid is $uid');

  Widget widget;

  if (uid == '') {
    widget = const LoginScreen();
  } else {
    widget = const MainScreen();
  }
  runApp(MyApp(widget));
}

class MyApp extends StatelessWidget {
  final Widget startWidget;

  const MyApp(this.startWidget, {super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => MainCubit(),),
        BlocProvider(create: (context) => ChatAppCubit()..getUserData(),),
      ],
      child: BlocConsumer<MainCubit, MainCubitStates>(
        listener: (context, state) {},
        builder: (context, state) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: lightThem(),
          home: startWidget,
        ),
      ),
    );
  }
}
