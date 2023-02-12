import 'package:flutter/material.dart';
import 'package:gold_and_silver_classic_ost/src/Providers/player.dart';
import 'package:gold_and_silver_classic_ost/src/Providers/playlist.dart';
import 'package:gold_and_silver_classic_ost/src/components/musicList.dart';
import 'package:gold_and_silver_classic_ost/src/components/shared/appBar.dart';
import 'package:gold_and_silver_classic_ost/src/data/themes.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class PlayList extends StatelessWidget {
  const PlayList({super.key, required this.navTo, required this.backAction});
  final void Function() navTo;
  final void Function() backAction;

  @override
  Widget build(BuildContext context) {
    context.read<PlayerModel>().queryAllSongs();
    final playLists = context.select((PlayListModel p) => p.playLists);
    final playListsLength =
        context.select((PlayListModel p) => p.playListCount);
    final selectedPlayList =
        context.select((PlayListModel p) => p.selectedPlayList);

    if (playListsLength > 0) {
      return Column(
        children: [
          SharedAppBar(
              title: 'PlayLists',
              iconData: Icons.arrow_back,
              backAction: () => backAction(),
              navTo: () => {}),
          Flexible(
              child: ListView.builder(
            itemCount: playListsLength,
            itemBuilder: (context, index) => ListTile(
              contentPadding: const EdgeInsets.all(20),
              leading: const Icon(Icons.playlist_play),
              trailing: const Icon(Icons.arrow_right),
              title: playLists.isNotEmpty
                  ? replacedTitle(playLists.elementAt(index).playlist)
                  : null,
              onTap: (() => {
                    context
                        .read<PlayerModel>()
                        .changeSongList(selectedPlayList),
                    context.read<PlayerModel>().queryFromPlayList(
                        playLists.elementAt(index).id,
                        playLists.elementAt(index).playlist),
                    context
                        .read<PlayerModel>()
                        .changeSongList(selectedPlayList),
                    context.read<PlayListModel>().setCurrentPlayListName(
                        playLists.elementAt(index).playlist),
                    navTo()
                  }),
              onLongPress: () {
                context.read<PlayListModel>().queryFromPlayList(
                    playLists.elementAt(index).id,
                    playLists.elementAt(index).playlist);
                showModalBottomSheet<void>(
                    context: context,
                    backgroundColor: Color(0xff03a9f4).withRed(150),
                    builder: (context) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            title: replacedTitle('Delete playlist'),
                            onTap: () {
                              context.read<PlayListModel>().deletePlayList(
                                  playLists.elementAt(index).id);
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            title: replacedTitle('Add to playlist'),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddToPlayList(
                                            playListId:
                                                playLists.elementAt(index).id,
                                            playListName: playLists
                                                .elementAt(index)
                                                .playlist,
                                          )));
                            },
                          ),
                          ListTile(
                            title: replacedTitle('Remove from playlist'),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RemoveFromPlayList(
                                            playListId:
                                                playLists.elementAt(index).id,
                                            playListName: playLists
                                                .elementAt(index)
                                                .playlist,
                                          )));
                            },
                          ),
                        ],
                      );
                    });
              },
            ),
          )),
          const CreatePlayListModal()
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          replacedTitle("No playlists found"),
          const CreatePlayListModal()
        ],
      );
    }
  }
}

class AddToPlayList extends StatelessWidget {
  const AddToPlayList(
      {super.key, required this.playListId, required this.playListName});
  final int playListId;
  final String playListName;
  @override
  Widget build(BuildContext context) {
    final audioData = context.select((PlayerModel p) => p.audioData);
    final selectedPlaylist =
        context.select((PlayListModel p) => p.selectedPlayList);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SharedAppBar(
              title: context.watch<PlayListModel>().currentPlayListName,
              iconData: Icons.arrow_back,
              backAction: () => Navigator.pop(context),
              navTo: () => {}),
          Flexible(
              child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primaryContainer,
                      Theme.of(context).colorScheme.secondaryContainer
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topRight,
                  )),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: audioData.length,
                    itemBuilder: (context, index) => ListTile(
                        onTap: () {
                          context.read<PlayListModel>().addToPlayList(
                              playListId, audioData.elementAt(index).id);
                        },
                        enabled: selectedPlaylist.indexWhere((element) =>
                                element.data ==
                                audioData.elementAt(index).data) ==
                            -1,
                        title: Text(
                          audioData.elementAt(index).title,
                          style: TextStyle(
                              color: selectedPlaylist.indexWhere((element) =>
                                          element.data ==
                                          audioData.elementAt(index).data) !=
                                      -1
                                  ? Theme.of(context)
                                      .colorScheme
                                      .surface
                                      .withAlpha(100)
                                  : Theme.of(context).colorScheme.surface),
                        ),
                        trailing: selectedPlaylist.indexWhere((element) =>
                                    element.data ==
                                    audioData.elementAt(index).data) !=
                                -1
                            ? Icon(Icons.bookmark_added)
                            : null,
                        tileColor: Colors.transparent),
                  ))),
        ],
      ),
    );
  }
}

class RemoveFromPlayList extends StatelessWidget {
  const RemoveFromPlayList(
      {super.key, required this.playListId, required this.playListName});
  final int playListId;
  final String playListName;
  @override
  Widget build(BuildContext context) {
    final selectedPlaylist =
        context.select((PlayListModel p) => p.selectedPlayList);

    return Scaffold(
        body: Column(
      children: [
        SharedAppBar(
            title: 'Remove song from playlist',
            iconData: Icons.arrow_back,
            backAction: () => Navigator.pop(context),
            navTo: () => {}),
        Flexible(
            child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primaryContainer,
              Theme.of(context).colorScheme.secondaryContainer
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topRight,
          )),
          child: ListView.builder(
            itemCount: selectedPlaylist.length,
            itemBuilder: (context, index) => ListTile(
                onTap: () {
                  context.read<PlayListModel>().removeFromPlayList(
                      playListId, selectedPlaylist.elementAt(index).id);
                },
                title: replacedTitle(selectedPlaylist.elementAt(index).title),
                trailing: selectedPlaylist.indexWhere((element) =>
                            element.data ==
                            selectedPlaylist.elementAt(index).data) !=
                        -1
                    ? Icon(Icons.bookmark_remove)
                    : null,
                tileColor: Colors.blue),
          ),
        ))
      ],
    ));
  }
}

class CreatePlayListModal extends StatelessWidget {
  const CreatePlayListModal({super.key});
  @override
  Widget build(BuildContext context) {
    final createPlaylist = context.read<PlayListModel>().createPlayList;
    String inputText = '';
    return Padding(
      padding: EdgeInsets.all(8),
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
                Theme.of(context).colorScheme.secondary)),
        child: const Text('Create new playlist'),
        onPressed: () {
          showModalBottomSheet<void>(
            isScrollControlled: true,
            context: context,
            backgroundColor: Colors.transparent,
            builder: (BuildContext context) {
              return Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
                    child: Container(
                      color: Theme.of(context).colorScheme.background,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            'Playlist name',
                            style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onBackground),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 0.0),
                                child: TextFormField(
                                  key: const Key('Playlist Name'),
                                  autofillHints: [AutofillHints.name],
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Theme.of(context)
                                          .colorScheme
                                          .onBackground),
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .onSurface),
                                  onChanged: (value) {
                                    inputText = value;
                                  },
                                ),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                child: const Text('Create'),
                                onPressed: () => {
                                  Navigator.pop(context),
                                  createPlaylist(inputText)
                                },
                              ),
                              ElevatedButton(
                                child: const Text('Cancel'),
                                onPressed: () {
                                  Navigator.pop(context);
                                  inputText = '';
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ));
            },
          );
        },
      ),
    );
  }
}

Text replacedTitle(String? text) {
  return Text(
    text != null ? text : 'unknow',
    overflow: TextOverflow.ellipsis,
    maxLines: 1,
    softWrap: true,
    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
  );
}

class PlayListView extends StatelessWidget {
  const PlayListView({super.key, required this.backAction});
  final void Function() backAction;
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SharedAppBar(
          title: context
              .select((PlayListModel value) => value.currentPlayListName),
          iconData: Icons.arrow_back,
          backAction: backAction,
          navTo: () => {}),
      Flexible(child: MusicList())
    ]);
  }
}
