import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import '../data/audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlayerModel extends ChangeNotifier {
  final AudioPlayer audioPlayer =
      AudioPlayer(playerId: 'main', mode: PlayerMode.MEDIA_PLAYER);
  final OnAudioQuery _audioQuery = OnAudioQuery();
  bool listeners = false;
  List<SongModel> audioData = [];
  SongModel? song;
  Timer timer = Timer(Duration.zero, () => {});

  PlayerModel() {
    initData();
    activePlayerListeners();
  }

  initData() async {
    final permissionStatus = await _audioQuery.permissionsRequest();
    if (permissionStatus) {
      queryAllSongs();
    }
  }

  void queryAllSongs() async {
    final songList = await _audioQuery.querySongs();

    changeSongList(songList);
  }

  void changeSongList(List<SongModel> songList) {
    audioData = songList;

    notifyListeners();
  }

  void setCurrentAudio(int index) async {
    final newSong = audioData.elementAt(index);
    if (song?.id != newSong.id) {
      await audioPlayer.stop();
      song = newSong;
    }
    play();
    notifyListeners();
  }

  void queryFromPlayList(int id, String name) async {
    final queuedSongs =
        await _audioQuery.queryAudiosFrom(AudiosFromType.PLAYLIST, name);
    audioData = queuedSongs;

    notifyListeners();
  }

  void onSliderChange(Duration position) {
    audioPlayer.seek(position);
  }

  void play() async {
    if (song != null) {
      await audioPlayer.play(song!.data, isLocal: true);
      notifyListeners();
    }
  }

  void pause() async {
    await audioPlayer.pause();
    notifyListeners();
  }

  void next() async {
    final nextIndex =
        audioData.indexWhere((element) => element.data == song!.data) + 1;
    if (song != null && nextIndex <= audioData.length) {
      song = audioData.elementAt(nextIndex);
      play();
    }
  }

  void resume() async {
    await audioPlayer.resume();
    notifyListeners();
  }

  onPlayTaped() async {
    switch (audioPlayer.state) {
      case PlayerState.STOPPED:
        play();
        break;
      case PlayerState.PLAYING:
        pause();
        break;
      case PlayerState.PAUSED:
        resume();
        break;
      case PlayerState.COMPLETED:
        play();
        break;
      default:
        resume();
    }
  }

  void setTimerToPause(Duration duration) {
    timer.cancel();
    timer = Timer(duration, () => pause());
  }

  void activePlayerListeners() {
    audioPlayer.onDurationChanged.listen((event) {
      notifyListeners();
    });

    audioPlayer.onPlayerCompletion.listen((event) {
      next();
      notifyListeners();
    });
  }
}
