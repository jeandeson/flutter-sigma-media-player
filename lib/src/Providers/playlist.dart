import 'package:flutter/cupertino.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:collection/collection.dart';

class PlayListModel extends ChangeNotifier {
  OnAudioQuery onAudioQuery = OnAudioQuery();
  List<PlaylistModel> playLists = [];
  String currentPlayListName = 'unknown';
  int playListCount = 0;
  int selectedListLength = 0;
  List<SongModel> selectedPlayList = [];
  List<List<SongModel>> playlistsData = [];

  PlayListModel() {
    queryPlayLists();
  }

  void queryPlayLists() async {
    playLists = await onAudioQuery.queryPlaylists();
    playLists.map((e) async {
      final result = await onAudioQuery.queryAudiosFrom(
          AudiosFromType.PLAYLIST, e.playlist);
      playlistsData.add(result);
    });

    playListCount = playLists.length;
    notifyListeners();
  }

  setCurrentPlayListName(String name) {
    currentPlayListName = name;
  }

  void createPlayList(String name) async {
    final created = await onAudioQuery.createPlaylist(name);
    if (created) {
      queryPlayLists();
    }
  }

  void deletePlayList(int id) async {
    final deleted = await onAudioQuery.removePlaylist(id);
    if (deleted) {
      queryPlayLists();
    }
  }

  void addToPlayList(int playlistId, int audioId) async {
    await onAudioQuery.addToPlaylist(playlistId, audioId);
    queryPlayLists();
    final playlist =
        playLists.firstWhereOrNull((element) => element.id == playlistId);
    if (playlist != null) {
      queryFromPlayList(playlistId, playlist.playlist);
    }
  }

  void removeFromPlayList(int playlistId, int audioId) async {
    OnAudioQuery onAudioQuery = OnAudioQuery();
    bool result = await onAudioQuery.removeFromPlaylist(playlistId, audioId);
    queryPlayLists();
    final playlist =
        playLists.firstWhereOrNull((element) => element.id == playlistId);
    if (playlist != null) {
      queryFromPlayList(playlistId, playlist.playlist);
    }
  }

  void addToFavorites(SongModel? song) async {
    if (song == null) return;

    final playlistsNames = playLists.map((e) => e.playlist);
    if (!playlistsNames.contains('Favorites')) {
      await onAudioQuery.createPlaylist('Favorites');
    }
    final playlists = await onAudioQuery.queryPlaylists();
    final favoritesPlaylist = playlists
        .firstWhereOrNull((element) => element.playlist == 'Favorites');

    if (favoritesPlaylist != null) {
      addToPlayList(favoritesPlaylist.id, song.id);
    }
  }

  void removeFromFavorites(SongModel? song) async {
    if (song == null) return;

    final favoritesPlaylist = playLists
        .firstWhereOrNull((element) => element.playlist == 'Favorites');

    if (favoritesPlaylist != null) {
      print('aaaa');
      await onAudioQuery.removeFromPlaylist(favoritesPlaylist.id, song.id);
    }
  }

  void queryFromPlayList(int id, String name) async {
    final queriedPlayList =
        await onAudioQuery.queryAudiosFrom(AudiosFromType.PLAYLIST, name);
    selectedPlayList = queriedPlayList;
    selectedListLength = queriedPlayList.length;
    currentPlayListName = name;
    notifyListeners();
  }
}
