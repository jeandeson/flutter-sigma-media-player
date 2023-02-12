import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:gold_and_silver_classic_ost/src/Providers/player.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../components/musicList.dart';
import '../components/shared/appBar.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  const Home({super.key, required this.navTo});
  final void Function() navTo;
  @override
  Widget build(BuildContext context) {
    final song = context.select((PlayerModel p) => p.song);

    return Column(
      children: [
        PreferredSize(
            preferredSize: AppBar().preferredSize,
            child: SharedAppBar(
                title: song != null ? song.title : 'Sigma Audio Player',
                navTo: navTo,
                backAction: () {
                  Scaffold.of(context).openDrawer();
                },
                iconData: Icons.menu)),
        Expanded(child: MusicList())
      ],
    );
  }
}
