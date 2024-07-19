import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tadbiroemas_78/ui/screens/my_event_pages/myEvnetPage.dart';
import 'package:tadbiroemas_78/ui/widgets/my_drowerts_screens/localizations.dart';
import '../../logic/blocs/auth/auth_bloc.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              return UserAccountsDrawerHeader(
                currentAccountPicture: const CircleAvatar(
                  backgroundColor: Colors.amber,
                ),
                accountName: Text(state is LoggedInState
                    ? state.user.displayName ?? "Ism va Familiya"
                    : "Unknown User"),
                accountEmail: Text(state is LoggedInState
                    ? state.user.email ?? "Email"
                    : "Unknown Email"),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.event),
            title: Text("My Event".tr()),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyEvents()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.event),
            title: Text("languages".tr()),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChangeLanguageScreen()),
              );
            },
          ),
          const Spacer(),
          ListTile(
            contentPadding: const EdgeInsets.all(20),
            leading: const Icon(Icons.logout),
            title: Text("logout".tr()),
            onTap: () {
              context.read<AuthBloc>().add(LogoutEvent());
            },
          ),
        ],
      ),
    );
  }
}
