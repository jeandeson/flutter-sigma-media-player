import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../../Providers/player.dart';
import '../songIconAnimation.dart';

class SharedActionButton extends StatelessWidget {
  const SharedActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    final playerState = context.select((PlayerModel p) => p.audioPlayer.state);
    return SizedBox(
        width: 60,
        height: 60,
        child: FloatingActionButton(
          backgroundColor: Colors.orange,
          child: SongIconAnimation(playerState: playerState),
          onPressed: () => {context.read<PlayerModel>().onPlayTaped()},
        ));
  }
}
