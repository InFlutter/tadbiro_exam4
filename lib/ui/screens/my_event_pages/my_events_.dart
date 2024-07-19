import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/event.dart';
import '../../../data/models/user/user_model.dart';
import '../../../logic/blocs/todo/event_bloc.dart';
import '../../../logic/blocs/todo/event_event.dart';
import '../../../logic/blocs/user_bloc/user_bloc.dart';
import '../../../logic/blocs/user_bloc/user_event.dart';

class MyEventss extends StatefulWidget {
  const MyEventss({super.key, required this.events});

  final List<EventModel> events;

  @override
  State<MyEventss> createState() => _MyEventssState();
}

class _MyEventssState extends State<MyEventss> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: widget.events.isEmpty
            ? const Center(
                child: Text("Ma'lumot topilmadi"),
              )
            : ListView.builder(
                itemCount: widget.events.length,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 20, right: 10, left: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Colors.blue,
                          ),
                          child: ListTile(
                            title: Text(widget.events[index].name),
                            leading: Image.asset("assets/images/logo.png"),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.events[index].date.toString(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  widget.events[index].description,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.edit,
                                      color: Colors.grey,
                                    )),
                                IconButton(
                                    onPressed: () {
                                      context.read<EventBloc>().add(DeleteEvent(
                                          id: widget.events[index].id));
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    )),
                                IconButton(
                                  onPressed: () {
                                    context
                                        .read<EventBloc>()
                                        .add(EditEvent(widget.events[index]));
                                    UserModel userModel =
                                        context.read<UserBloc>().userData;
                                    List<EventModel> eventsUserLike =
                                        userModel.isLike;
                                    eventsUserLike.add(widget.events[index]);
                                    userModel = userModel.copyWith(
                                      isLike: eventsUserLike,
                                    );
                                    context
                                        .read<UserBloc>()
                                        .add(UserUpdateEvent(userModel));
                                  },
                                  icon: Icon(widget.events[index].isLiked
                                      ? Icons.favorite
                                      : Icons.favorite_border),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  );
                },
              ));
  }
}
