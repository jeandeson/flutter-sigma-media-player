import 'package:flutter/material.dart';
import 'package:gold_and_silver_classic_ost/src/Providers/playlist.dart';
import 'package:gold_and_silver_classic_ost/src/components/shared/mainLayout.dart';
import 'package:gold_and_silver_classic_ost/src/stack/routes.dart';
import 'package:provider/provider.dart';
import './src/data/themes.dart';
import 'src/Providers/player.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => ThemesModel()),
    ChangeNotifierProvider(create: (context) => PlayerModel()),
    ChangeNotifierProvider(create: (context) => PlayListModel()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemesModel>(
        builder: (context, theme, child) => MaterialApp(
              theme: context.watch<ThemesModel>().currentTheme,
              routes: {'/MainLayout': (context) => MainLayout()},
              initialRoute: '/MainLayout',
            ));
  }
}
