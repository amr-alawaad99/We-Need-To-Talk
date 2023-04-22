import 'package:flutter/material.dart';

import '../../layout/cubit/cubit.dart';
import '../drawer_screen/drawer_screen.dart';

class CallsScreen extends StatelessWidget {
  const CallsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = ChatAppCubit.get(context);
    return Scaffold(
      drawer: DrawerScreen(),
      appBar: AppBar(
        title: Text(
          cubit.titles[cubit.currentIndex],
        ),
      ),
      body: Column(
        children: [
          Text('Calls Screen'),
        ],
      ),
    );
  }
}
