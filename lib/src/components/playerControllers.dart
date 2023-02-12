import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:gold_and_silver_classic_ost/src/components/bottomBar.dart';

class PlayerControls extends StatefulWidget {
  const PlayerControls(
      {super.key,
      required this.positionListener,
      required this.durationListener,
      required this.onSlider});
  final StreamSubscription<Duration> Function(void Function(Duration)?,
      {bool? cancelOnError,
      void Function()? onDone,
      Function? onError}) positionListener;
  final StreamSubscription<Duration> Function(void Function(Duration)?,
      {bool? cancelOnError,
      void Function()? onDone,
      Function? onError}) durationListener;

  final void Function(Duration) onSlider;

  @override
  State<PlayerControls> createState() => _PlayerControlsState();
}

class _PlayerControlsState extends State<PlayerControls> {
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  void attPositionState(Duration duration) {
    if (mounted) {
      setState(() {
        _position = duration;
      });
    }
  }

  void attDurationState(Duration duration) {
    if (mounted) {
      setState(() {
        _duration = duration;
      });
    }
  }

  @override
  initState() {
    super.initState();
    widget.positionListener((d) => attPositionState(d));
    widget.durationListener((d) => attDurationState(d));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              width: 50,
              alignment: Alignment.centerRight,
              child: Text(_printDuration(_position),
                  style: TextStyle(color: Colors.white))),
          Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Container(
                  child: BottomBarSlider(
                currentDuration: _duration,
                currentPosition: _position,
                onSliderChange: widget.onSlider,
              ))),
          Container(
              width: 50,
              alignment: Alignment.centerLeft,
              child: Text(_printDuration(_duration),
                  style: TextStyle(color: Colors.white)))
        ]);
  }
}

String _printDuration(Duration duration) {
  String oneDigit(int n) => n.toString().padLeft(1, "0");
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = oneDigit(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds"
      .replaceFirst(RegExp(r'00:|0'), '');
}
