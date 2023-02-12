import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:gold_and_silver_classic_ost/src/Providers/player.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:rive/rive.dart';
import 'package:provider/provider.dart';

class MusicListTile extends StatefulWidget {
  const MusicListTile({
    super.key,
    required this.playerState,
    required this.setCurrentAudio,
    required this.isActive,
    required this.title,
  });
  final PlayerState playerState;

  final String title;
  final bool isActive;
  final void Function() setCurrentAudio;
  @override
  State<MusicListTile> createState() => _MusicListTileState();
}

class _MusicListTileState extends State<MusicListTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(20),
      leading: const Icon(Icons.music_note),
      trailing: widget.isActive && widget.playerState == PlayerState.PLAYING
          ? const SizedBox(
              width: 60,
              height: 60,
              child: RiveAnimation.asset(
                'assets/animations/sound-wave.riv',
                fit: BoxFit.cover,
              ))
          : null,
      title: replacedTitle(widget.title, widget.isActive),
      onTap: (() => {widget.setCurrentAudio()}),
    );
  }
}

Text replacedTitle(String text, bool highlight) {
  return Text(
    text
        .replaceFirst(RegExp(r'(assets/audios/)'), '')
        .replaceAll(RegExp(r'([-])'), ' ')
        .replaceAll(RegExp(r'.mp3'), ''),
    overflow: TextOverflow.ellipsis,
    maxLines: 1,
    softWrap: true,
    style: TextStyle(
        color: highlight ? Colors.orange : Colors.white,
        fontWeight: FontWeight.bold),
  );
}
