import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whatsapp_status_saver/common/app_button.dart';
import 'package:whatsapp_status_saver/extension/context_extension.dart';
import 'package:whatsapp_status_saver/ui/fullImage/full_image_screen.dart';
import 'package:whatsapp_status_saver/ui/mainScreen/main_screen_bloc.dart';
import 'package:whatsapp_status_saver/ui/play_status.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../../translation/locale_keys.g.dart';
import '../../utils/constants.dart';
import 'main_screen_state.dart';

Directory _photoDir = Directory('/storage/emulated/0/Android/media/com.whatsapp/WhatsApp/Media/.Statuses');

class MainScreen extends StatefulWidget {
  static const String route = 'main_screen_route';
  const MainScreen({Key? key}) : super(key: key);
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int? _storagePermissionCheck;
  Future<int>? _storagePermissionChecker;
  int? androidSDK;

  Future<int> _loadPermission() async {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    setState(() {
      androidSDK = androidInfo.version.sdkInt;
    });
    if (androidSDK! >= 30) {
      final _currentStatusManaged = await Permission.storage.status;
      if (_currentStatusManaged.isGranted) {
        return 1;
      } else {
        return 0;
      }
    } else {
      final _currentStatusStorage = await Permission.storage.status;
      if (_currentStatusStorage.isGranted) {
        return 1;
      } else {
        return 0;
      }
    }
  }

  Future<int> requestPermission() async {
    if (androidSDK! >= 30) {
      final _requestStatusManaged = await Permission.storage.request();
      if (_requestStatusManaged.isGranted) {
        return 1;
      } else {
        return 0;
      }
    } else {
      final _requestStatusStorage = await Permission.storage.request();
      if (_requestStatusStorage.isGranted) {
        return 1;
      } else {
        return 0;
      }
    }
  }

  Future<int> requestStoragePermission() async {
    final result = await [Permission.storage].request();
    setState(() {});
    if (result[Permission.storage]!.isDenied) {
      return 0;
    } else if (result[Permission.storage]!.isGranted) {
      return 1;
    } else {
      return 0;
    }
  }

  @override
  void initState() {
    super.initState();
    _storagePermissionChecker = (() async {
      int storagePermissionCheckInt;
      int finalPermission;

      if (_storagePermissionCheck == null || _storagePermissionCheck == 0) {
        _storagePermissionCheck = await _loadPermission();
      } else {
        _storagePermissionCheck = 1;
      }
      if (_storagePermissionCheck == 1) {
        storagePermissionCheckInt = 1;
      } else {
        storagePermissionCheckInt = 0;
      }

      if (storagePermissionCheckInt == 1) {
        finalPermission = 1;
      } else {
        finalPermission = 0;
      }
      return finalPermission;
    })();
  }

  @override
  Widget build(BuildContext context) {
    final size = context.screenSize;

    return FutureBuilder(
        future: _storagePermissionChecker,
        builder: (context, status) {
          if (status.connectionState == ConnectionState.done) {
            if (status.hasData) {
              if (status.data == 1) {
                return const HomeScreen();
              } else {
                return Scaffold(
                  backgroundColor: Constants.colorSurface.withOpacity(0.5),
                  body: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 80),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Constants.colorOnSurface,
                    ),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        Image.asset(
                          'assets/user-data-in-folder.png',
                          width: 200,
                          height: 200,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            LocaleKeys.STORAGE_AND_MEDIA.tr(),
                            style: const TextStyle(
                                fontSize: 25.0,
                                color: Constants.colorOnSecondary,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            LocaleKeys.WE_NEED_PERMISSION.tr(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 14.0,
                                color:
                                    Constants.colorTextLight2),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          child: SizedBox(
                            width: size.width,
                            height: 60,
                            child: AppButton(
                              text: LocaleKeys.ALLOW_PERMISSION.tr(),
                              onClick: () {
                                _storagePermissionChecker = requestPermission();
                                setState(() {});
                              },
                              textColor: Constants.colorOnPrimary,
                              color: Constants.colorSecondaryVariant,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }
            }
            else {
              return Scaffold(
                body: Container(
                  color: Constants.colorSurface,
                  child: const Center(
                    child: Text(
                      'Something went wrong \nPlease uninstall and Install Again...',
                      style: TextStyle(
                          fontSize: 20.0, color: Constants.colorOnSurface),
                    ),
                  ),
                ),
              );
            }
          } else {
            return const Scaffold(
              body: SizedBox(
                child: Center(
                  child: CircularProgressIndicator(
                      color: Constants.colorOnSurface),
                ),
              ),
            );
          }
        });
  }
}

Widget exitDialog(BuildContext context) {
  return Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
    child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(LocaleKeys.CONFIRMATION.tr(),
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Colors.black)),
            const SizedBox(height: 5),
            Text(LocaleKeys.ARE_YOU_SURE.tr(),
                style: const TextStyle(fontSize: 12, color: Colors.black)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Constants.colorSecondaryVariant,
                      elevation: 8,
                      shadowColor: Constants.colorOnBorder,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                  child: Center(
                      child: Text(LocaleKeys.YES.tr(),
                          style: const TextStyle(fontSize: 14, color: Colors.white))),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      elevation: 8,
                      shadowColor: Constants.colorOnBorder,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Center(
                      child: Text(LocaleKeys.NO.tr(),
                          style: const TextStyle(fontSize: 14, color: Colors.black))),
                )
              ],
            )
          ],
        )),
  );
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

Future<String?> _getImage(videoPathUrl) async {
  print('getImage');
  final thumb = await VideoThumbnail.thumbnailFile(
    video: videoPathUrl,
    imageFormat: ImageFormat.PNG,
    maxWidth: 128,
    quality: 25,
  );
  print('thumb$thumb');
  return thumb;
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    final size = context.screenSize;
    final bloc = context.read<MainScreenBloc>();
    final Directory _saveDir = Directory('/storage/emulated/0/StatusSaver');
    List<String> saveList = [];
    if (!Directory(_photoDir.path).existsSync()) {
      _photoDir = Directory('/storage/emulated/0/WhatsApp/Media/.Statuses');
    }
    if (!Directory(_saveDir.path).existsSync()) {
      saveList = [];
    } else {
      saveList = _saveDir.listSync().
      map((item) => item.path).
      where((item) => !item.endsWith ('.png')).
      toList(growable: false);
    }
    return Scaffold(
        backgroundColor: Constants.colorSurface,
        key: bloc.scaffoldKey,
        drawer: const DrawerWidget(),
        body: WillPopScope(
          onWillPop: () async {
            showDialog(context: context, builder: (context) => exitDialog(context));
            return false;
          },
          child: Column(children: [
            const SizedBox(
              height: 40,
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () {
                        if (bloc.textFieldContext != null) {
                          FocusScope.of(bloc.textFieldContext!)
                              .requestFocus(FocusNode());
                        }
                        bloc.scaffoldKey.currentState?.openDrawer();
                      },
                      icon: Image.asset(
                        'assets/drawer.png',
                        color: Constants.colorOnSurface,
                        width: 20,
                        height: 20,
                      )),
                  BlocBuilder<MainScreenBloc, MainScreenState>(
                      builder: (_, state) {
                    return Text(
                      state.bottomIndex == 0
                          ? LocaleKeys.WELCOME.tr()
                          : LocaleKeys.MESSAGE_RECOVERY.tr(),
                      style: const TextStyle(
                          color: Constants.colorOnSurface,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    );
                  }),
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
                  BlocBuilder<MainScreenBloc, MainScreenState>(
                      builder: (_, state) {
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
                                  color: state.selectedItem == 0
                                      ? Constants.colorOnSecondary
                                      : Constants.colorTextLight2),
                            )),
                        PopupMenuItem<int>(
                            value: 1,
                            child: Text(
                              LocaleKeys.WHATS_APP_BUSSINESS.tr(),
                              style: TextStyle(
                                  fontSize: 14,
                                  color: state.selectedItem == 1
                                      ? Constants.colorOnSecondary
                                      : Constants.colorTextLight2),
                            )),
                        // PopupMenuItem<int>(
                        //     value: 2,
                        //     child: Text(
                        //       LocaleKeys.GB_WHATSAPP.tr(),
                        //       style: TextStyle(
                        //           fontSize: 14,
                        //           color: state.selectedItem == 2
                        //               ? Constants.colorOnSurface
                        //               : Constants.colorSecondary),
                        //     )),
                        // PopupMenuItem<int>(
                        //     value: 3,
                        //     child: Text(
                        //       LocaleKeys.WA_PARALLEL_SPACE.tr(),
                        //       style: TextStyle(
                        //           fontSize: 14,
                        //           color: state.selectedItem == 3
                        //               ? Constants.colorOnSurface
                        //               : Constants.colorSecondary),
                        //     )),
                        // PopupMenuItem<int>(
                        //     value: 4,
                        //     child: Text(
                        //       LocaleKeys.WAB_PARALLET_SPACE.tr(),
                        //       style: TextStyle(
                        //           fontSize: 14,
                        //           color: state.selectedItem == 4
                        //               ? Constants.colorOnSurface
                        //               : Constants.colorSecondary),
                        //     )),
                      ],
                      onSelected: (item) => SelectedItem(context, item, bloc),
                    );
                  }),
                ]),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 40),
              BlocBuilder<MainScreenBloc, MainScreenState>(
                  builder: (context, state) {
                return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  bloc.updateIndex(0);
                                  _pageController.jumpToPage(0);
                                },
                                child: Text(LocaleKeys.IMAGES.tr(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: Constants.poppinsMedium,
                                        color: state.index == 0
                                            ? Constants.colorOnSurface
                                            : Constants.colorSecondary))),
                            GestureDetector(
                                onTap: () {
                                  bloc.updateIndex(1);
                                  _pageController.jumpToPage(1);
                                },
                                child: Text(LocaleKeys.VIDEOS.tr(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: Constants.poppinsMedium,
                                        color: state.index == 1
                                            ? Constants.colorOnSurface
                                            : Constants.colorSecondary))),
                            GestureDetector(
                                onTap: () {
                                  bloc.updateIndex(2);
                                  _pageController.jumpToPage(2);
                                  setState(() {});
                                },
                                child: Text(LocaleKeys.SAVED.tr(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: Constants.poppinsMedium,
                                        color: state.index == 2
                                            ? Constants.colorOnSurface
                                            : Constants.colorSecondary)))
                          ]),
                      Container(
                          margin: const EdgeInsets.only(top: 10),
                          height: 4,
                          width: size.width,
                          decoration: BoxDecoration(
                              color: Constants.colorSurface,
                              borderRadius: BorderRadius.circular(6)),
                          child: Row(children: [
                            Expanded(
                                child: Container(
                                    alignment: Alignment.centerLeft,
                                    height: 3,
                                    decoration: BoxDecoration(
                                        color: state.index == 0
                                            ? Constants.colorSecondaryVariant
                                            : Constants.colorSurface))),
                            Expanded(
                                child: Container(
                                    alignment: Alignment.centerRight,
                                    height: 3,
                                    decoration: BoxDecoration(
                                      color: state.index == 1
                                          ? Constants.colorSecondaryVariant
                                          : Constants.colorSurface,
                                    ))),
                            Expanded(
                                child: Container(
                                    alignment: Alignment.centerRight,
                                    height: 3,
                                    decoration: BoxDecoration(
                                        color: state.index == 2
                                            ? Constants.colorSecondaryVariant
                                            : Constants.colorSurface)))
                          ]))
                    ]);
              }),
            ]),

            ///Pagig Showings===============>
            (!Directory(_photoDir.path).existsSync())
                ? Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          LocaleKeys.INSTALL_WHATSAPP.tr(),
                          style: const TextStyle(fontSize: 18.0),
                        )
                      ],
                    ),
                  )
                : Expanded(
                    child: PageView(
                        controller: _pageController,
                        onPageChanged: (int? index) {
                          if (index == null) return;
                          bloc.updateIndex(index);
                        },
                        scrollDirection: Axis.horizontal,
                        children: [
                          ImageScreen(),
                          VideoScreen(),
                          Container(
                            color: Constants.colorOnError,
                            child:  saveList.isNotEmpty
                                    ? Container(
                                        margin: const EdgeInsets.all(0.0),
                                        child: GridView.builder(
                                            itemCount: saveList.length,
                                            shrinkWrap: true,
                                            padding: const EdgeInsets.all(0),
                                            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                                    mainAxisExtent: 150,
                                                    maxCrossAxisExtent: 150),
                                            itemBuilder: (_, index) {
                                              print('i am out side of your work $index');
                                              final item = saveList[index];

                                              if (item.endsWith('.mp4')) {
                                                print('its me and my index$index');
                                                print(item);
                                                return GestureDetector(
                                                  onTap: () {
                                                    Navigator.pushNamed(context,
                                                        PlayStatus.route,
                                                        arguments: [
                                                          item,
                                                          true
                                                        ]);
                                                  },
                                                  child: Container(
                                                    color: Constants
                                                        .colorOnPrimary,
                                                    child: FutureBuilder(
                                                        future: _getImage(saveList[index]),
                                                        builder: (context,
                                                            snapshot) {
                                                          if (snapshot
                                                                  .connectionState ==
                                                              ConnectionState
                                                                  .done) {
                                                            if (snapshot
                                                                .hasData) {
                                                              return Hero(
                                                                  tag: saveList[
                                                                      index],
                                                                  child: Image.file(
                                                                      File(snapshot
                                                                              .data
                                                                          as String),
                                                                      fit: BoxFit
                                                                          .cover));
                                                            } else {
                                                              return const Center(
                                                                child:
                                                                    CircularProgressIndicator(),
                                                              );
                                                            }
                                                          } else {
                                                            return Hero(
                                                              tag: saveList[
                                                                  index],
                                                              child: SizedBox(
                                                                height: 280.0,
                                                                child: Image.asset(
                                                                    'assets/video_loader.gif'),
                                                              ),
                                                            );
                                                          }
                                                        }),
                                                    //new cod
                                                  ),
                                                );
                                              }
                                              else {
                                                return GestureDetector(
                                                    onTap: () {
                                                      Navigator.pushNamed(
                                                          context,
                                                          FullImageScreen.route,
                                                          arguments: [
                                                            item,
                                                            true
                                                          ]);
                                                    },
                                                    child: Image.file(
                                                      File(item),
                                                      fit: BoxFit.cover,
                                                    ));
                                              }
                                            }))
                                    : Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        width: double.infinity,
                                        color: Constants.colorOnSurface,
                                        alignment: Alignment.center,
                                        child: Center(
                                          child: Text(
                                            LocaleKeys.SAVE_YOUR_IMAGE_VEDIO
                                                .tr(),
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                fontSize: 18.0,
                                                color: Constants
                                                    .colorSecondaryVariant),
                                          ),
                                        ),
                                      )
                          )

                          // BlocBuilder<MainScreenBloc, MainScreenState>(
                          //     buildWhen: (previous, current) => previous.index != current.index,
                          //     builder: (_, state) {
                          //       return state.index == 0
                          //           ? const ImageScreen()
                          //           : state.index == 1
                          //               ? const VedioScreen()
                          //               : (!Directory(_saveDir.path).existsSync())
                          //                   ? Container(
                          //                       padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          //                       width: double.infinity,
                          //                       color: Constants.colorOnSurface,
                          //                       alignment: Alignment.center,
                          //                       child: const Center(
                          //                         child: Text(
                          //                           'Please save your status videos/images then show your save images/videos here....!',
                          //                           textAlign: TextAlign.center,
                          //                           style: TextStyle(fontSize: 18.0,color: Constants.colorSecondaryVariant),
                          //                         ),
                          //                       ),
                          //                     )
                          //                   : Container(
                          //                       color: Constants.colorOnError,
                          //                       child: saveList != null
                          //                           ? saveList.isNotEmpty
                          //                               ? Container(
                          //                                   margin:
                          //                                       const EdgeInsets.all(
                          //                                           0.0),
                          //                                   child: GridView.builder(
                          //                                       itemCount:
                          //                                           saveList.length,
                          //                                       shrinkWrap: true,
                          //                                       padding:
                          //                                           const EdgeInsets
                          //                                               .all(0),
                          //                                       gridDelegate:
                          //                                           const SliverGridDelegateWithMaxCrossAxisExtent(
                          //                                               mainAxisExtent:
                          //                                                   150,
                          //                                               maxCrossAxisExtent:
                          //                                                   150),
                          //                                       itemBuilder:
                          //                                           (_, index) {
                          //                                         final imgPath =
                          //                                             saveList[index];
                          //                                         if (imgPath
                          //                                             .endsWith(
                          //                                                 '.mp4')) {
                          //                                           return GestureDetector(
                          //                                             onTap: () {
                          //                                               Navigator.pushNamed(
                          //                                                   context,
                          //                                                   PlayStatus
                          //                                                       .route,
                          //                                                   arguments: [
                          //                                                     imgPath,
                          //                                                     true
                          //                                                   ]);
                          //                                             },
                          //                                             child:
                          //                                                 Container(
                          //                                               color: Constants
                          //                                                   .colorOnPrimary,
                          //                                               child: FutureBuilder(
                          //                                                   future: _getImage(saveList[index]),
                          //                                                   builder: (context, snapshot) {
                          //                                                     if (snapshot.connectionState ==
                          //                                                         ConnectionState.done) {
                          //                                                       if (snapshot
                          //                                                           .hasData) {
                          //                                                         return Image.file(
                          //                                                           File(snapshot.data as String),
                          //                                                           fit: BoxFit.cover,
                          //                                                         );
                          //                                                       } else {
                          //                                                         return const Center(
                          //                                                           child: CircularProgressIndicator(),
                          //                                                         );
                          //                                                       }
                          //                                                     } else {
                          //                                                       return SizedBox(
                          //                                                         height:
                          //                                                             280.0,
                          //                                                         child:
                          //                                                             Image.asset('assets/images/video_loader.gif'),
                          //                                                       );
                          //                                                     }
                          //                                                   }),
                          //                                               //new cod
                          //                                             ),
                          //                                           );
                          //                                         } else {
                          //                                           return GestureDetector(
                          //                                               onTap: () {
                          //                                                 Navigator.pushNamed(
                          //                                                     context,
                          //                                                     FullImageScreen
                          //                                                         .route,
                          //                                                     arguments: [
                          //                                                       imgPath,
                          //                                                       true
                          //                                                     ]);
                          //                                               },
                          //                                               child: Image
                          //                                                   .file(
                          //                                                 File(
                          //                                                     imgPath),
                          //                                                 fit: BoxFit
                          //                                                     .cover,
                          //                                               ));
                          //                                         }
                          //                                       }))
                          //                               : Container(
                          //                         padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          //                         width: double.infinity,
                          //                         color: Constants.colorOnSurface,
                          //                         alignment: Alignment.center,
                          //                         child: const Center(
                          //                           child: Text(
                          //                             'Please save your status videos/images then show your save images/videos here....!',
                          //                             textAlign: TextAlign.center,
                          //                             style: TextStyle(fontSize: 18.0,color: Constants.colorSecondaryVariant),
                          //                           ),
                          //                         ),
                          //                       )
                          //                           : const Center(
                          //                               child:
                          //                                   CircularProgressIndicator(),
                          //                             ),
                          //                     );
                          //     }),
                          //
                        ]),
                  ),
            // SizedBox(
            //   height: 60,
            //   child: Stack(
            //     children: [
            //       Positioned(
            //         bottom: 0,
            //         left: 20,
            //         right: 20,
            //         top: 0,
            //         child: BlocBuilder<MainScreenBloc,
            //             MainScreenState>(builder: (context, state) {
            //           return Row(
            //             mainAxisAlignment:
            //                 MainAxisAlignment.spaceBetween,
            //             crossAxisAlignment:
            //                 CrossAxisAlignment.center,
            //             children: [
            //               GestureDetector(
            //                 onTap: () => bloc.updateBottomIndex(0),
            //                 child: Column(
            //                     mainAxisAlignment:
            //                         MainAxisAlignment.center,
            //                     crossAxisAlignment:
            //                         CrossAxisAlignment.center,
            //                     children: [
            //                       Image(
            //                         image: const AssetImage(
            //                             'assets/splash.png'),
            //                         width: 20,
            //                         height: 20,
            //                         color: state.bottomIndex == 0
            //                             ? Constants
            //                                 .colorSecondaryVariant
            //                             : Constants.colorSecondary,
            //                       ),
            //                       Text(AppText.SAVE_STATUS,
            //                           textAlign: TextAlign.center,
            //                           style: TextStyle(
            //                               fontSize: 14,
            //                               fontWeight:
            //                                   FontWeight.w500,
            //                               fontFamily: Constants
            //                                   .poppinsMedium,
            //                               color: state.bottomIndex ==
            //                                       0
            //                                   ? Constants
            //                                       .colorSecondaryVariant
            //                                   : Constants
            //                                       .colorSecondary)),
            //                     ]),
            //               ),
            //               GestureDetector(
            //                 onTap: () => bloc.updateBottomIndex(1),
            //                 child: Column(
            //                     mainAxisAlignment:
            //                         MainAxisAlignment.center,
            //                     crossAxisAlignment:
            //                         CrossAxisAlignment.center,
            //                     children: [
            //                       Image(
            //                         image: const AssetImage(
            //                           'assets/message_recovery.png',
            //                         ),
            //                         width: 20,
            //                         height: 20,
            //                         color: state.bottomIndex == 1
            //                             ? Constants
            //                                 .colorSecondaryVariant
            //                             : Constants.colorSecondary,
            //                       ),
            //                       Text(AppText.MESSAGE_RECOVERY,
            //                           textAlign: TextAlign.center,
            //                           style: TextStyle(
            //                               fontSize: 14,
            //                               fontWeight:
            //                                   FontWeight.w500,
            //                               fontFamily: Constants
            //                                   .poppinsMedium,
            //                               color: state.bottomIndex ==
            //                                       1
            //                                   ? Constants
            //                                       .colorSecondaryVariant
            //                                   : Constants
            //                                       .colorSecondary)),
            //                     ]),
            //               ),
            //             ],
            //           );
            //         }),
            //       ),
            //     ],
            //   ),
            // )
          ]),
        ));
  }

  void SelectedItem(BuildContext context, item, MainScreenBloc bloc) {
    switch (item) {
      case 0:
        bloc.updateSelectedIndex(0);
        _photoDir=Directory('/storage/emulated/0/Android/media/com.whatsapp/WhatsApp/Media/.Statuses');
        if (!Directory(_photoDir.path).existsSync()) {
          _photoDir = Directory('/storage/emulated/0/WhatsApp/Media/.Statuses');
        }
        setState(() {});
        break;
      case 1:
        bloc.updateSelectedIndex(1);
        _photoDir=Directory('/storage/emulated/0/Android/media/com.whatsapp.w4b/WhatsApp Business/Media/.Statuses');
        if (!Directory(_photoDir.path).existsSync()) {
          _photoDir = Directory('/storage/emulated/0/WhatsApp Business/Media/.Statuses');
        }
        setState(() {});
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

class ImageScreen extends StatelessWidget {
  ImageScreen({Key? key}) : super(key: key);
  final imageList = _photoDir
      .listSync()
      .map((item) => item.path)
      .where((item) => item.endsWith('.jpg'))
      .toList(growable: false);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Constants.colorOnSurface,
        child: imageList.isNotEmpty
            ? Container(
                margin: const EdgeInsets.all(0.0),
                child: GridView.builder(
                    itemCount: imageList.length,
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(0),
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                            mainAxisExtent: 150, maxCrossAxisExtent: 150),
                    itemBuilder: (_, index) {
                      final imgPath = imageList[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, FullImageScreen.route,
                              arguments: [imgPath, false]);
                        },
                        child: Image.file(
                          File(imgPath),
                          fit: BoxFit.cover,
                        ),
                      );
                    }))
            : Container(
                padding: const EdgeInsets.only(bottom: 60.0),
                width: double.infinity,
                alignment: Alignment.center,
                child: Text(
                  LocaleKeys.WATCH_YOUR_IMAGE.tr(),
                  style: const TextStyle(
                      fontSize: 20.0, color: Constants.colorSecondaryVariant),
                )));
  }
}

class VideoScreen extends StatelessWidget {
  VideoScreen({Key? key}) : super(key: key);

  final videoList = _photoDir
      .listSync()
      .map((item) => item.path)
      .where((item) => item.endsWith('.mp4'))
      .toList(growable: false);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Constants.colorOnSurface,
        child: videoList != null
            ? (videoList.isNotEmpty)
                ? Container(
                    margin: const EdgeInsets.all(0.0),
                    child: GridView.builder(
                        itemCount: videoList.length,
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(0),
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                                mainAxisExtent: 150, maxCrossAxisExtent: 150),
                        itemBuilder: (_, index) {
                          final imgPath = videoList[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, PlayStatus.route,
                                  arguments: [imgPath, false]);
                            },
                            child: Container(
                              color: Constants.colorOnPrimary,
                              child: FutureBuilder(
                                  future: _getImage(videoList[index]),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      if (snapshot.hasData) {
                                        return Hero(
                                          tag: videoList[index],
                                          child: Image.file(
                                            File(snapshot.data as String),
                                            fit: BoxFit.cover,
                                          ),
                                        );
                                      } else {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                    } else {
                                      return Hero(
                                        tag: videoList[index],
                                        child: SizedBox(
                                          height: 280.0,
                                          child: Image.asset(
                                              'assets/video_loader.gif'),
                                        ),
                                      );
                                    }
                                  }),
                              //new cod
                            ),
                          );
                        }))
                : Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Text(
                      LocaleKeys.WATCH_YOUR_VIDEO.tr(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 18.0,
                          color: Constants.colorSecondaryVariant),
                    ))
            : const Center(
                child: CircularProgressIndicator(),
              ));
  }
}

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: Constants.colorOnSurface,
        child: Container(
          decoration: const BoxDecoration(),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                DrawerHeader(
                    decoration: const BoxDecoration(color: Constants.colorSurface),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                context
                                    .read<MainScreenBloc>()
                                    .scaffoldKey
                                    .currentState!
                                    .openEndDrawer();
                              });
                            },
                            child: const Icon(
                              Icons.clear,
                              color: Constants.colorSecondary,
                              size: 18,
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            Image.asset(
                              'assets/splash.png',
                              width: 70,
                              height: 70,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              LocaleKeys.SAVE_STATUS.tr(),
                              style: const TextStyle(
                                  color: Constants.colorOnSurface,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            )
                          ],
                        )
                      ],
                    )),
                ListTile(
                    minLeadingWidth: 5,
                    leading: const Icon(Icons.cached_sharp,
                        color: Constants.colorSecondaryVariant),
                    title: Text(LocaleKeys.RESTART_SERVICE.tr(),
                        style: const TextStyle(
                            fontFamily: Constants.poppinsRegular,
                            fontSize: 14,
                            color: Constants.colorTextLight2)),
                    onTap: () {
                      Navigator.pop(context);
                    }),
                ListTile(
                    minLeadingWidth: 5,
                    leading: const Icon(Icons.language_sharp,
                        color: Constants.colorSecondaryVariant),
                    title: Text(LocaleKeys.LANGUAGE.tr(),
                        style: const TextStyle(
                            fontFamily: Constants.poppinsRegular,
                            fontSize: 14,
                            color: Constants.colorTextLight2)),
                    onTap: () {
                      Navigator.pop(context);
                    }),
                ListTile(
                    minLeadingWidth: 5,
                    leading: const Icon(Icons.share,
                        color: Constants.colorSecondaryVariant),
                    title: Text(LocaleKeys.SHARE_APP.tr(),
                        style: const TextStyle(
                            fontFamily: Constants.poppinsRegular,
                            fontSize: 14,
                            color: Constants.colorTextLight2)),
                    onTap: () {
                      Navigator.pop(context);
                    }),
                ListTile(
                    minLeadingWidth: 5,
                    leading: const Icon(Icons.error,
                        color: Constants.colorSecondaryVariant),
                    title: Text(LocaleKeys.ABOUT.tr(),
                        style: const TextStyle(
                            fontFamily: Constants.poppinsRegular,
                            fontSize: 14,
                            color: Constants.colorTextLight2)),
                    onTap: () {
                      Navigator.pop(context);
                    }),
                ListTile(
                    minLeadingWidth: 5,
                    leading: const Icon(Icons.privacy_tip_outlined,
                        color: Constants.colorSecondaryVariant),
                    title: Text(LocaleKeys.PRIVACY_POLICY.tr(),
                        style: const TextStyle(
                            fontFamily: Constants.poppinsRegular,
                            fontSize: 14,
                            color: Constants.colorTextLight2)),
                    onTap: () {
                      Navigator.pop(context);
                    }),
                const SizedBox(height: 20)
              ]),
        ));
  }
}
