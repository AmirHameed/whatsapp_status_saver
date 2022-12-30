import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp_status_saver/common/app_button.dart';
import 'package:whatsapp_status_saver/extension/context_extension.dart';
import 'package:whatsapp_status_saver/ui/preminum/premium_screen_bloc.dart';

import '../../../utils/app_strings.dart';
import '../../../utils/constants.dart';
class PremiumScreen extends StatefulWidget {
  static const String route = 'premium_screen_route';

  const PremiumScreen({Key? key}) : super(key: key);

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  @override
  Widget build(BuildContext context) {
    final size = context.screenSize;
    final bloc = context.read<PremiumScreenBloc>();

    return Scaffold(
        backgroundColor: Constants.colorSurface,
        key: bloc.scaffoldKey,
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
                    icon:const Icon( Icons.arrow_back_ios_new,size: 20,color: Constants.colorOnSurface,)),
              const Text(
                   AppText.PREMIUM,
                    style: TextStyle(
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
                BlocBuilder<PremiumScreenBloc, int>(
                    builder: (_, state) {
                  return PopupMenuButton<int>(
                    color: Constants.colorDrawer,
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
                            AppText.WHATSAPP_STATNDARD,
                            style: TextStyle(
                                fontSize: 14,
                                color: state == 0
                                    ? Constants.colorOnSurface
                                    : Constants.colorSecondary),
                          )),
                      PopupMenuItem<int>(
                          value: 1,
                          child: Text(
                            AppText.WHATS_APP_BUSSINESS,
                            style: TextStyle(
                                fontSize: 14,
                                color: state == 1
                                    ? Constants.colorOnSurface
                                    : Constants.colorSecondary),
                          )),
                      PopupMenuItem<int>(
                          value: 2,
                          child: Text(
                            AppText.GB_WHATSAPP,
                            style: TextStyle(
                                fontSize: 14,
                                color: state == 2
                                    ? Constants.colorOnSurface
                                    : Constants.colorSecondary),
                          )),
                      PopupMenuItem<int>(
                          value: 3,
                          child: Text(
                            AppText.WA_PARALLEL_SPACE,
                            style: TextStyle(
                                fontSize: 14,
                                color: state == 3
                                    ? Constants.colorOnSurface
                                    : Constants.colorSecondary),
                          )),
                      PopupMenuItem<int>(
                          value: 4,
                          child: Text(
                            AppText.WA_PARALLEL_SPACE,
                            style: TextStyle(
                                fontSize: 14,
                                color: state == 4
                                    ? Constants.colorOnSurface
                                    : Constants.colorSecondary),
                          )),
                    ],
                    onSelected: (item) => SelectedItem(context, item, bloc),
                  );
                }),
              ]),
          Expanded(
            child: Container(
              color: Constants.colorSurface,

              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children:   [
                  AvatarGlow(
                    endRadius: 70.0,
                    child: CircleAvatar(
                      backgroundColor:Constants.colorDimendGlow.withOpacity(0.2),
                      backgroundImage: const AssetImage('assets/dimend_glow.png'),
                      radius: 50.0,

                    ),
                  ),

                  const Text(
                    AppText.ENJOYE_ADD_FREE,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Constants.colorOnSurface,
                        fontWeight: FontWeight.w300,
                        fontSize: 20),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: SizedBox(
                        width: size.width,
                        height: 60,
                        child: AppButton(text: AppText.PAY_NOW, onClick: (){},color: Constants.colorSecondaryVariant,textColor: Constants.colorOnSurface,fontSize: 20,)),
                  )
                ],
              ),
            ),
          )
        ]));
  }

  void SelectedItem(BuildContext context, item, PremiumScreenBloc bloc) {
    switch (item) {
      case 0:
        bloc.updateSelectedIndex(0);
        print('sdsdsjhd=================>');
        break;
      case 1:
        print('1 index=======================>');

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
