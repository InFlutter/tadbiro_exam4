import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ChangeLanguageScreen extends StatefulWidget {
  @override
  _ChangeLanguageScreenState createState() => _ChangeLanguageScreenState();
}

class _ChangeLanguageScreenState extends State<ChangeLanguageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login here').tr(),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                context.setLocale(Locale(
                  'en',
                ),);

              },
              child: Text('English'),
            ),
            ElevatedButton(
              onPressed: () {
                context.setLocale(Locale(
                  'uz',
                ),);
              },
              child: Text('O\'zbekcha'),
            ),
            ElevatedButton(
              onPressed: () {
                context.setLocale(Locale(
                  'rus',
                ),);
              },
              child: Text('Ruscha'),
            ),
          ],
        ),
      ),
    );
  }
}