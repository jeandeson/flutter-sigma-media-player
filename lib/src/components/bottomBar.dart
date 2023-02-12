import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:gold_and_silver_classic_ost/src/Providers/player.dart';
import 'package:gold_and_silver_classic_ost/src/components/playerControllers.dart';
import 'package:gold_and_silver_classic_ost/src/components/shared/actionButton.dart';
import 'package:gold_and_silver_classic_ost/src/data/themes.dart';
import 'package:gold_and_silver_classic_ost/src/pages/details.dart';
import 'package:provider/provider.dart';

class BottomBarSlider extends StatelessWidget {
  const BottomBarSlider(
      {super.key,
      required this.currentDuration,
      required this.currentPosition,
      required this.onSliderChange});

  final Duration currentDuration;
  final Duration currentPosition;
  final void Function(Duration) onSliderChange;

  double getSliderValue() {
    return currentPosition.inSeconds.toDouble() <=
            currentDuration.inSeconds.toDouble()
        ? currentPosition.inSeconds.toDouble()
        : 0;
  }

  @override
  Widget build(BuildContext context) {
    return Slider(
        thumbColor: Colors.orange,
        activeColor: Colors.orange,
        inactiveColor: Colors.orange[400],
        min: 0,
        max: currentDuration.inSeconds.toDouble(),
        value: getSliderValue(),
        onChanged: ((value) =>
            {onSliderChange(Duration(seconds: value.round()))}));
  }
}

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    final onSlider = context.read<PlayerModel>().onSliderChange;
    final onAudioPositionChanged =
        context.read<PlayerModel>().audioPlayer.onAudioPositionChanged;
    final onDurationChanged =
        context.read<PlayerModel>().audioPlayer.onDurationChanged;

    return BottomAppBar(
        color: Colors.transparent,
        elevation: 0,
        shape: CircularNotchedRectangle(),
        child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: [
                Colors.transparent,
                Theme.of(context).colorScheme.secondaryContainer
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      IconButton(
                        color: Colors.white,
                        tooltip: 'back',
                        icon: const Icon(Icons.skip_previous),
                        onPressed: () {},
                        iconSize: 50,
                      ),
                      const SharedActionButton(),
                      IconButton(
                        color: Colors.white,
                        tooltip: 'next',
                        icon: const Icon(Icons.skip_next),
                        onPressed: () {},
                        iconSize: 50,
                      ),
                    ]),
                PlayerControls(
                    positionListener: onAudioPositionChanged.listen,
                    durationListener: onDurationChanged.listen,
                    onSlider: onSlider)
              ],
            )));
  }
}
