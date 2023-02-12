import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:gold_and_silver_classic_ost/src/Providers/playlist.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../../Providers/player.dart';
import 'package:collection/collection.dart';

class ActionsBar extends StatefulWidget {
  const ActionsBar({super.key});

  @override
  State<ActionsBar> createState() => _ActionsBarState();
}

class _ActionsBarState extends State<ActionsBar> {
  @override
  Widget build(BuildContext context) {
    final song = context.select((PlayerModel p) => p.song);
    final playlists = context.select((PlayListModel p) => p.playLists);
    final add = context.read<PlayListModel>().addToPlayList;
    final remove = context.read<PlayListModel>().removeFromPlayList;

    void toggleToPlaylist(index) async {
      if (song == null) return;
      final songs = await context
          .read<PlayListModel>()
          .onAudioQuery
          .queryAudiosFrom(
              AudiosFromType.PLAYLIST, playlists.elementAt(index).playlist);
      if (songs.firstWhereOrNull((element) => element.data == song.data) !=
          null) {
        remove(playlists.elementAt(index).id, song.id);
      } else {
        add(playlists.elementAt(index).id, song.id);
      }
    }

    return IconTheme(
        data: IconThemeData(color: Colors.white, size: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) => Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 0.0),
                          child: ListView.builder(
                            itemCount:
                                context.watch<PlayListModel>().playListCount,
                            itemBuilder: (context, index) => ListTile(
                              onTap: () {
                                toggleToPlaylist(index);
                              },
                              title: Text(context
                                  .watch<PlayListModel>()
                                  .playLists
                                  .elementAt(index)
                                  .playlist),
                            ),
                          )));
                },
                icon: Icon(Icons.playlist_add)),
            IconButton(
                color: Theme.of(context).colorScheme.onBackground,
                onPressed: () async {
                  TimeOfDay now = TimeOfDay.now();
                  final TimeOfDay? newTime = await showTimePicker(
                    helpText: 'Automatic pause timer',
                    context: context,
                    initialTime: TimeOfDay(
                      hour: now.hour,
                      minute: now.minute,
                    ),
                  );
                  if (newTime != null) {
                    var difHours = (newTime.hour - now.hour).abs();
                    var difMins = (newTime.minute - now.minute).abs();

                    var duration =
                        Duration(seconds: 0, hours: difHours, minutes: difMins);

                    context.read<PlayerModel>().setTimerToPause(duration);
                  }
                },
                icon: Icon(Icons.access_alarms)),
            IconButton(onPressed: () => {}, icon: Icon(Icons.playlist_play)),
          ],
        ));
  }
}
