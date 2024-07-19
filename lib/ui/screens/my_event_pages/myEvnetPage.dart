import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tadbiroemas_78/logic/blocs/todo/event_bloc.dart';
import 'package:tadbiroemas_78/ui/screens/my_event_pages/my_events_.dart';
import '../../../logic/blocs/user_bloc/user_bloc.dart';
import '../../../logic/blocs/user_bloc/user_state.dart';

class MyEvents extends StatelessWidget {
  const MyEvents({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Events'),
          bottom: TabBar(
            tabs: [
              Tab(text: "My Event".tr()),
              Tab(text: 'near'),
              Tab(text: 'islike'),
              Tab(text: 'shot'),
            ],
          ),
        ),
        body: BlocBuilder<UserBloc, UserState>(
          builder: (BuildContext context, UserState state){
            if(state is UserSuccessState){
              return TabBarView(
                children: [
                  MyEventss(
                    events: state.userData.yesEvent,
                  ),
                  MyEventss(
                    events: context.read<EventBloc>().eventsData,
                  ),
                  MyEventss(
                    events: state.userData.isLike,
                  ),
                  MyEventss(
                    events: state.userData.noEvent,
                  ),

                ],
              );
            }
            if(state is UserErrorState){
              return Center(
                child: Text('Error: ${state.errorMessage}'),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          } ,
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            // Navigator.push(
            //   context,
            //   CupertinoPageRoute(builder: (ctx) =>  AddEvents()),
            // );
          },
        ),
      ),
    );
  }
}