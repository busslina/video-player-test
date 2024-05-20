import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rearch/flutter_rearch.dart';
import 'package:rearch/rearch.dart';

void main() {
  runApp(const RearchBootstrapper(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: _Home(),
      ),
    );
  }
}

class _Home extends RearchConsumer {
  const _Home();

  static const _sampleVideoUrl = 'https://busslina.com/public/sample-30s.mp4';

  @override
  Widget build(BuildContext context, WidgetHandle use) {
    final initialized = use.data(false);

    final videoController = use.disposable(
        () => CachedVideoPlayerController.network(_sampleVideoUrl),
        (controller) => controller.dispose());

    final customVideoController =
        use.callonce(() => CustomVideoPlayerWebController(
                webVideoPlayerSettings: const CustomVideoPlayerWebSettings(
              src: _sampleVideoUrl,
            )));

    final initCancelableOperation = use.callonce(() =>
        CancelableOperation.fromFuture(videoController.initialize())
          ..value.then((_) => initialized.value = true));

    // Cancelling init operation on dispose
    use.effect(
      () {
        return () {
          initCancelableOperation.cancel();
        };
      },
      [],
    );

    return CustomVideoPlayerWeb(
        customVideoPlayerWebController: customVideoController);
  }
}
