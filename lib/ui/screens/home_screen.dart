import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tadbiroemas_78/data/models/user/user_model.dart';
import 'package:tadbiroemas_78/logic/blocs/todo/event_state.dart';
import 'package:tadbiroemas_78/ui/widgets/my_drawer.dart';
import '../../data/models/event.dart';
import '../../logic/blocs/todo/event_bloc.dart';
import '../../logic/blocs/todo/event_event.dart';
import '../../logic/blocs/user_bloc/user_bloc.dart';
import '../../logic/blocs/user_bloc/user_event.dart';
import '../../logic/blocs/user_bloc/user_state.dart';
import '../widgets/add_event_dialog.dart';
import '../widgets/my_event_full/my_event_full_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<EventModel> _filteredEvents = [];

  @override
  void initState() {
    super.initState();
    _initUser();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  _initUser() {
    if (context.read<UserBloc>().state is UserInitialState) {
      context.read<UserBloc>().add(FetchUserEvent());
    }
  }

  _onSearchChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page".tr()),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateEventScreen()),
              );
              context.read<EventBloc>().add(FetchEvent());
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      drawer: const MyDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by name',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Yaqin 1 hafta ichidagilar",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
            ),
          ),
          CarouselSlider(
            options: CarouselOptions(height: 300.0),
            items: [14, 15, 16, 17, 18].map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.amber,
                        ),
                      ),
                      Positioned(
                        top: 10,
                        left: 20,
                        child: Container(
                          height: 50,
                          width: 45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.green,
                          ),
                          child: Center(
                            child: Text(
                              '$i',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            }).toList(),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Hamm Eventlar",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
            ),
          ),
          Expanded(
            child: BlocBuilder<EventBloc, EventState>(
              builder: (context, state) {
                if (state is EventLoadInProgress) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is EventLoadSuccess) {
                  _filteredEvents = state.events
                      .where((event) => event.name
                      .toLowerCase()
                      .contains(_searchController.text.toLowerCase()))
                      .toList();
                  return ListView.builder(
                    itemCount: _filteredEvents.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EventScreen(
                                  event: _filteredEvents[index],
                                ),
                              ),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                                  color: Colors.blue,
                                ),
                                child: ListTile(
                                  title: Text(_filteredEvents[index].name),
                                  leading: Container(
                                    height: 70,
                                    width: 70,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(15),
                                      ),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          _filteredEvents[index]
                                              .bannerUrl[0]
                                              .toString(),
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _filteredEvents[index].date.toString(),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        _filteredEvents[index].description,
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
                                        icon: Icon(Icons.edit, color: Colors.grey),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          context.read<EventBloc>().add(
                                              DeleteEvent(
                                                  id: _filteredEvents[index].id));
                                        },
                                        icon: Icon(Icons.delete, color: Colors.red),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          context.read<EventBloc>().add(
                                              EditEvent(_filteredEvents[index]));
                                          UserModel userModel =
                                              context.read<UserBloc>().userData;
                                          List<EventModel> eventsUserLike =
                                              userModel.isLike;
                                          eventsUserLike
                                              .add(_filteredEvents[index]);
                                          userModel = userModel.copyWith(
                                            isLike: eventsUserLike,
                                          );
                                          context
                                              .read<UserBloc>()
                                              .add(UserUpdateEvent(userModel));
                                        },
                                        icon: Icon(
                                          _filteredEvents[index].isLiked
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(child: Text("Unexpected state"));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
