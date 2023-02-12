import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:gold_and_silver_classic_ost/src/Providers/player.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:provider/provider.dart';
import 'package:gold_and_silver_classic_ost/src/data/themes.dart';

class SharedAppBar extends StatelessWidget {
  const SharedAppBar(
      {super.key,
      required this.title,
      required this.iconData,
      required this.backAction,
      required this.navTo});

  final String title;
  final IconData iconData;

  final void Function() backAction;
  final void Function() navTo;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        navTo();
      },
      child: PreferredSize(
        preferredSize: AppBar().preferredSize,
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primaryContainer,
              Theme.of(context).colorScheme.secondaryContainer
            ],
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
          )),
          child: AppBar(
              title: Text(title),
              leading: IconButton(
                  onPressed: () {
                    backAction();
                  },
                  icon: Icon(iconData)),
              backgroundColor: Colors.transparent,
              elevation: 0),
        ),
      ),
    );
  }
}
