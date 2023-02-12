import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:gold_and_silver_classic_ost/src/Providers/player.dart';
import 'package:gold_and_silver_classic_ost/src/components/shared/musicListTile.dart';
import 'package:gold_and_silver_classic_ost/src/pages/details.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart' hide LinearGradient;

class MusicList extends StatefulWidget {
  const MusicList({super.key});

  @override
  State<MusicList> createState() => _MusicListState();
}

class _MusicListState extends State<MusicList>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  int? activeIndex;

  void toggleActiveIndex(int index) {
    setState(() {
      activeIndex = index;
    });
  }

  @protected
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final playerState = context.select((PlayerModel p) => p.audioPlayer.state);
    final song = context.select((PlayerModel p) => p.song);
    final setCurrentAudio = context.read<PlayerModel>().setCurrentAudio;
    final audioData = context.select((PlayerModel p) => p.audioData);

    bool checkActiveIndex(SongModel listSong) {
      // bool isActive = false;
      // if (song != null && activeIndex != null) {
      //   if (listSong.id == song.id) isActive = true;
      // }
      return song != null && listSong.id == song.id;
    }

    return ListView.builder(
      itemCount: audioData.length,
      itemBuilder: (context, index) => MusicListTile(
          title: audioData.elementAt(index).title,
          isActive: checkActiveIndex(audioData.elementAt(index)),
          playerState: playerState,
          setCurrentAudio: () => {
                toggleActiveIndex(index),
                setCurrentAudio(index),
              }),
    );
  }
}

// class MusicList extends StatelessWidget {
//   const MusicList({
//     super.key,
//     required this.disableDetails,
//   });
//   final bool disableDetails;
//   @override
//   Widget build(BuildContext context) {
//     final currentAudioPath =
//         context.select((PlayerModel p) => p.currentAudioPath);
//     final currentAudioIndex =
//         context.select((PlayerModel p) => p.currentAudioIndex);
//     final playerState = context.select((PlayerModel p) => p.audioPlayer.state);
//     final setCurrentAudio = context.read<PlayerModel>().setCurrentAudio;
//     final audioData = context.select((PlayerModel p) => p.audioData);
//     final audioDataLength =
//         context.select((PlayerModel p) => p.audioDataLength);

//     return ListView.builder(
//       itemCount: audioDataLength,
//       itemBuilder: (context, index) => MusicListTile(
//           title: audioData.elementAt(index).title,
//           isActive: audioData.isNotEmpty &&
//               currentAudioIndex == index &&
//               audioData.elementAt(index).data == currentAudioPath,
//           playerState: playerState,
//           setCurrentAudio: () => {setCurrentAudio(index)}),
//     );
//   }
// }

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
