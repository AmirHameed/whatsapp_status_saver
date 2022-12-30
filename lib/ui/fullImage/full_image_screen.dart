import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_scanner/media_scanner.dart';
import 'package:share_plus/share_plus.dart';
import 'package:speed_dial_fab/speed_dial_fab.dart';
import 'package:whatsapp_status_saver/extension/context_extension.dart';
import 'package:whatsapp_status_saver/ui/fullImage/full_image_screen_bloc.dart';
import 'package:whatsapp_share2/whatsapp_share2.dart';
import '../../../utils/constants.dart';
import '../../translation/locale_keys.g.dart';

class FullImageScreen extends StatefulWidget {
  static const String route = 'full_image_screen_route';
  final String imagePath;
  final bool isSaved;

  const FullImageScreen(
      {Key? key, required this.imagePath, this.isSaved = false})
      : super(key: key);

  @override
  State<FullImageScreen> createState() => _FullImageScreenState();
}

class _FullImageScreenState extends State<FullImageScreen> {
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
                              style: const TextStyle(fontSize: 16.0, color: Constants.colorSecondaryVariant,)),
                          const Padding(
                            padding: EdgeInsets.all(10.0),
                          ),
                          MaterialButton(
                            color: Constants.colorSecondaryVariant,
                            textColor: Colors.white,
                            onPressed: () {
                              Navigator.pop(context);
                            },
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
    final size = context.screenSize;
    final bloc = context.read<FullImageScreenBloc>();

    return Scaffold(
        backgroundColor: Constants.colorSurface,
        key: bloc.scaffoldKey,
        floatingActionButton: widget.isSaved
            ? const SizedBox()
            : SpeedDialFabWidget(
                secondaryIconsList: const [
                  Icons.sd_storage,
                  Icons.share,
                  Icons.call_missed,
                ],
                secondaryIconsText: [
                  LocaleKeys.SAVE.tr(),
                  LocaleKeys.SHARE.tr(),
                  LocaleKeys.REPOST.tr(),
                ],
                secondaryIconsOnPress: [
                  () async {
                    _onLoading(true, '');
                    final originalImageFile = File(widget.imagePath);

                    if (!Directory('/storage/emulated/0/StatusSaver')
                        .existsSync()) {
                      Directory('/storage/emulated/0/StatusSaver')
                          .createSync(recursive: true);
                    }
                    final newFileName = '/storage/emulated/0/StatusSaver/PICTURES-${originalImageFile.path.split('/').last}';
                    await originalImageFile.copy(newFileName);
                    MediaScanner.loadMedia(path: newFileName);
                    _onLoading(false, LocaleKeys.IF_IMAGE_NOT_AVAILABLE_IN_GALLERY.tr());
                  },
                  () => Share.shareFiles([(widget.imagePath)],
                      text: 'https://linktr.ee/istatussaver'),
                  () async => await WhatsappShare.shareFile(
                        phone: '917974704221',
                        text: 'https://linktr.ee/istatussaver',
                        filePath: [(widget.imagePath)],
                      ),
                ],
                secondaryBackgroundColor: Constants.colorSecondaryVariant,
                secondaryForegroundColor: Constants.colorOnSurface,
                primaryBackgroundColor: Constants.colorSecondaryVariant,
                primaryForegroundColor: Constants.colorOnSurface,
                primaryIconCollapse: Icons.clear,
                primaryIconExpand: Icons.dashboard_sharp,
              ),
        body: Column(children: [
          const SizedBox(
            height: 40,
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      size: 20,
                      color: Constants.colorOnSurface,
                    )),
                Text(
                  LocaleKeys.Image.tr(),
                  style: const TextStyle(
                      color: Constants.colorOnSurface,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
                const Spacer(),
                Image.asset(
                  'assets/uper_whatsapp.png',
                  width: 20,
                  height: 20,
                ),
                const SizedBox(
                  width: 10,
                ),
                Image.asset(
                  'assets/uper_dimend.png',
                  width: 20,
                  height: 20,
                ),
                BlocBuilder<FullImageScreenBloc, int>(builder: (_, state) {
                  return PopupMenuButton<int>(
                    color: Constants.colorOnSurface,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 10,
                    icon: const Icon(
                      Icons.more_vert_rounded,
                      color: Constants.colorOnSurface,
                    ),
                    itemBuilder: (context) => [
                      PopupMenuItem<int>(
                          value: 0,
                          child: Text(
                            LocaleKeys.WHATSAPP_STATNDARD.tr(),
                            style: TextStyle(
                                fontSize: 14,
                                color: state == 0
                                    ? Constants.colorOnSecondary
                                    : Constants.colorTextLight2),
                          )),
                      PopupMenuItem<int>(
                          value: 1,
                          child: Text(
                            LocaleKeys.WHATS_APP_BUSSINESS.tr(),
                            style: TextStyle(
                                fontSize: 14,
                                color: state == 1
                                    ? Constants.colorOnSecondary
                                    : Constants.colorTextLight2),
                          )),
                      // PopupMenuItem<int>(
                      //     value: 2,
                      //     child: Text(
                      //       LocaleKeys.GB_WHATSAPP.tr(),
                      //       style: TextStyle(
                      //           fontSize: 14,
                      //           color: state == 2
                      //               ? Constants.colorOnSurface
                      //               : Constants.colorSecondary),
                      //     )),
                      // PopupMenuItem<int>(
                      //     value: 3,
                      //     child: Text(
                      //       LocaleKeys.WA_PARALLEL_SPACE.tr(),
                      //       style: TextStyle(
                      //           fontSize: 14,
                      //           color: state == 3
                      //               ? Constants.colorOnSurface
                      //               : Constants.colorSecondary),
                      //     )),
                      // PopupMenuItem<int>(
                      //     value: 4,
                      //     child: Text(
                      //       LocaleKeys.WAB_PARALLET_SPACE.tr(),
                      //       style: TextStyle(
                      //           fontSize: 14,
                      //           color: state == 4
                      //               ? Constants.colorOnSurface
                      //               : Constants.colorSecondary),
                      //     )),
                    ],
                    onSelected: (item) => SelectedItem(context, item, bloc),
                  );
                }),
              ]),
          Expanded(
            child: SizedBox(
              width: size.width,
              height: size.height,
              child: Center(
                child: Image.file(
                  File(widget.imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          )
        ]));
  }

  void SelectedItem(BuildContext context, item, FullImageScreenBloc bloc) {
    switch (item) {
      case 0:
        bloc.updateSelectedIndex(0);
        break;
      case 1:
        bloc.updateSelectedIndex(1);
        break;
      case 2:
        bloc.updateSelectedIndex(2);
        break;
      case 3:
        bloc.updateSelectedIndex(3);
        break;
      case 4:
        bloc.updateSelectedIndex(4);
        break;
    }
  }
}
