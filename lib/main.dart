import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tadbiroemas_78/core/app.dart';
import 'package:tadbiroemas_78/data/repositories/auth_repository.dart';
import 'package:tadbiroemas_78/logic/blocs/auth/auth_bloc.dart';
import 'package:tadbiroemas_78/logic/blocs/todo/event_event.dart';
import 'package:tadbiroemas_78/services/firebase_auth_service.dart';
import 'package:tadbiroemas_78/services/firebase_event_service.dart';
import 'data/repositories/event_repository.dart';
import 'logic/blocs/todo/event_bloc.dart';
import 'logic/blocs/user_bloc/user_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final firebaseAuthService = FirebaseAuthService();
  final firebaseEventService = FirebaseEventService();
  await EasyLocalization.ensureInitialized();
  runApp(

    EasyLocalization(
    supportedLocales: [
    Locale(
    'en',
  ),
  Locale(
  'uz',
  ),
  Locale(
  'ru',
  ),
  ],
  path: 'assets/translations', // JSON fayllar joylashgan yo'l
  fallbackLocale: Locale('uz'),
  startLocale: Locale('uz'), child: MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (ctx) => AuthRepository(firebaseAuthService: firebaseAuthService),
        ),
        RepositoryProvider(
          create: (ctx) => EventRepository(firebaseEventService: firebaseEventService),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (ctx) => AuthBloc(authRepository: ctx.read<AuthRepository>()),
          ),
          BlocProvider(
            create: (context) => EventBloc(repository: context.read<EventRepository>())..add(FetchEvent()),
          ),
          BlocProvider(
            create: (_) => UserBloc(),
          ),

        ],
        child: const MainApp(),
      ),
    ),
  ),
  );
}
