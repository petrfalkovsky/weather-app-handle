import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class AninmatedEarthFLRWidget extends StatelessWidget {
  const AninmatedEarthFLRWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 400,
      width: 400,
      child: FlareActor(
        "assets/images/WorldSpin.flr",
        fit: BoxFit.contain,
        animation: "roll",
      ),
    );
  }
}
