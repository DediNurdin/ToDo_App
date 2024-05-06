// ignore_for_file: deprecated_member_use

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:todo_list/constant/constant_screen.dart';
import 'package:todo_list/layout/home_layout.dart';
import 'constant/bloc_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalizeAndTranslate.init(
    assetLoader: const AssetLoaderRootBundleJson('assets/langs/'),
    supportedLanguageCodes: <String>['ar', 'en'],
  );
  BlocOverrides.runZoned(
    () {
      runApp(const LocalizedApp(
        child: MyApp(),
      ));
    },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return LocalizedApp(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: themeData(),
        home: HomeLayout(),
        locale: context.locale,
        localizationsDelegates: context.delegates,
        supportedLocales: context.supportedLocales,
      ),
    );
  }
}
