import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:media_scanner/media_scanner.dart';
import 'package:share_plus/share_plus.dart';
import 'package:speed_dial_fab/speed_dial_fab.dart';
import 'package:whatsapp_status_saver/ui/vedio_controller.dart';
import 'package:video_player/video_player.dart';
import 'package:whatsapp_share2/whatsapp_share2.dart';
import '../translation/locale_keys.g.dart';
import '../utils/constants.dart';

class PlayStatus extends StatefulWidget {
  static const String route = 'player_status_screen_route';

  final String videoFile;
  final bool isSaved;

  const PlayStatus({super.key, required this.videoFile, this.isSaved = false});

  @override
  _PlayStatusState createState() => _PlayStatusState();
}

class _PlayStatusState extends State<PlayStatus> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onLoading(bool t, String str) {
    if (t) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return SimpleDialog(
              children: <Widget>[
                Center(
                  child: Container(
                      padding: const EdgeInsets.all(10.0),
                      child: const CircularProgressIndicator()),
                ),
              ],
            );
          });
    } else {
      Navigator.pop(context);
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SimpleDialog(
                children: <Widget>[
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: <Widget>[
                           Text(
                            LocaleKeys.GREATE_SAVE_IN_GALLARY.tr(),
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(10.0),
                          ),
                          Text(str,
                              style: const TextStyle(
                                fontSize: 16.0,
                              )),
                          const Padding(
                            padding: EdgeInsets.all(10.0),
                          ),
                          Text(LocaleKeys.FILE_MANAGER.tr(),
                              style: const TextStyle(
                                  fontSize: 16.0, color: Colors.teal)),
                          const Padding(
                            padding: EdgeInsets.all(10.0),
                          ),
                          MaterialButton(
                            color: Colors.teal,
                            textColor: Colors.white,
                            onPressed: () => Navigator.pop(context),
                            child: Text(LocaleKeys.CLOSE.tr()),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.videoFile);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          color: Colors.white,
          icon: const Icon(
            Icons.close,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: StatusVideo(
        videoPlayerController: VideoPlayerController.file(File(widget.videoFile)),
        looping: true,
        videoSrc: widget.videoFile,
      ),
      // ),
      floatingActionButton: widget.isSaved
          ? const SizedBox()
          : SpeedDialFabWidget(
              secondaryIconsList: const [
                Icons.sd_storage,
                Icons.share,
                Icons.call_missed,
              ],
              secondaryIconsText:  [
                LocaleKeys.SAVE.tr(),
                LocaleKeys.SHARE.tr(),
                LocaleKeys.REPOST.tr(),
              ],
              secondaryIconsOnPress: [
                () async {
                  _onLoading(true, '');
                  final originalVideoFile = File(widget.videoFile);
                  if (!Directory('/storage/emulated/0/StatusSaver').existsSync()) {
                    Directory('/storage/emulated/0/StatusSaver').createSync(recursive: true);
                  }
                  if(originalVideoFile.path.endsWith('.mp4')){
                    final newFileName = '/storage/emulated/0/StatusSaver/VIDEO-${originalVideoFile.path.split('/').last}';
                    await originalVideoFile.copy(newFileName);
                    MediaScanner.loadMedia(path: newFileName);
                    _onLoading(false, LocaleKeys.IF_VEDIO_NOT_AVAILABLE_IN_GALLERY.tr());
                  }
                  else{
                    _onLoading(false, 'No Save File');
                  }
                },
                () => Share.shareFiles([(widget.videoFile)],
                    text: 'https://linktr.ee/istatussaver'),
                () async => await WhatsappShare.shareFile(
                      phone: '917974704221',
                      text: 'https://linktr.ee/istatussaver',
                      filePath: [(widget.videoFile)],
                    ),
              ],
              secondaryBackgroundColor: Constants.colorSecondaryVariant,
              secondaryForegroundColor: Constants.colorOnSurface,
              primaryBackgroundColor: Constants.colorSecondaryVariant,
              primaryForegroundColor: Constants.colorOnSurface,
              primaryIconCollapse: Icons.clear,
              primaryIconExpand: Icons.dashboard_sharp,
            ),
    );
  }
}
