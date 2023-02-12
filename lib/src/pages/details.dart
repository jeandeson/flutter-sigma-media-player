import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gold_and_silver_classic_ost/src/Providers/player.dart';
import 'package:gold_and_silver_classic_ost/src/components/details/actionsBar.dart';
import 'package:gold_and_silver_classic_ost/src/components/shared/appBar.dart';
import 'package:marquee/marquee.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class Details extends StatefulWidget {
  const Details({super.key, required this.backAction});
  final void Function() backAction;
  @override
  State<Details> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Details> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    SongModel? song = context.select((PlayerModel p) => p.song);
    List<SongModel> audioData = context.select((PlayerModel p) => p.audioData);
    super.build(context);
    return Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      SharedAppBar(
        backAction: () => widget.backAction(),
        iconData: Icons.arrow_back,
        navTo: () => {},
        title: song != null ? song.title : 'unknow',
      ),
      Flexible(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width,
            child: QueryArtworkWidget(
              id: song != null ? song.id : 0,
              type: ArtworkType.AUDIO,
              nullArtworkWidget: Icon(Icons.library_music),
            )),
      )),
      Container(
          height: 40,
          width: MediaQuery.of(context).size.width,
          child: Marquee(
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 30),
              blankSpace: 100,
              text: song != null ? song.displayName : 'unknow')),
      ActionsBar()
    ]);
  }
}
