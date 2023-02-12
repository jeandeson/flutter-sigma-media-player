import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/material/animated_icons.dart';
import 'package:flutter/src/material/icons.dart';
import 'package:gold_and_silver_classic_ost/src/Providers/player.dart';
import 'package:gold_and_silver_classic_ost/src/data/themes.dart';
import 'package:provider/provider.dart';

class SongIconAnimation extends StatefulWidget {
  const SongIconAnimation({super.key, required this.playerState});

  final PlayerState playerState;
  @override
  State<SongIconAnimation> createState() => _SongIconAnimationState();
}

class _SongIconAnimationState extends State<SongIconAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 240));

    animation = Tween<double>(begin: 0.0, end: 1.0).animate(controller);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget.playerState == PlayerState.PLAYING
        ? controller.forward()
        : controller.reverse();
    return AnimatedIcon(
      color: Theme.of(context).colorScheme.onPrimary,
      icon: AnimatedIcons.play_pause,
      progress: animation,
      // size: 72,
    );
  }
}
