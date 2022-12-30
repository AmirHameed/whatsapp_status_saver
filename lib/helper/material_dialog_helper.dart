import 'package:flutter/material.dart';
import 'package:whatsapp_status_saver/common/app_button.dart';

import '../data/material_dailog_content.dart';
import '../utils/constants.dart';

class MaterialDialogHelper {
  static MaterialDialogHelper? _instance;

  MaterialDialogHelper._();

  static MaterialDialogHelper instance() {
    _instance ??= MaterialDialogHelper._();
    return _instance!;
  }

  BuildContext? _context;

  void injectContext(BuildContext context) => _context = context;

  void dismissProgress() {
    final context = _context;
    if (context == null) return;
    Navigator.pop(context);
  }

  void showProgressDialog(String text) {
    final context = _context;
    if (context == null) return;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
              child: Dialog(
                  backgroundColor: Constants.colorBackground,
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
                  child: Padding(
                      padding: const EdgeInsets.only(top: 15, bottom: 15, left: 25, right: 25),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        const CircularProgressIndicator(backgroundColor: Constants.colorOnPrimary, strokeWidth: 3),
                        const SizedBox(width: 10),
                        Flexible(child: Text(text, style: const TextStyle(color: Constants.colorOnPrimary, fontFamily: Constants.poppinsMedium, fontSize: 14)))
                      ]))),
              onWillPop: () async => false);
        });
  }

  void showMaterialDialogWithContent(MaterialDialogContent content, Function positiveClickListener, {Function? negativeClickListener}) {
    final context = _context;
    if (context == null) return;
    showDialog(
        context: context,
        builder: (_) {
          return WillPopScope(
              child: AlertDialog(
                  insetPadding: const EdgeInsets.symmetric(horizontal: 25),
                  contentPadding: const EdgeInsets.only(bottom: 0),
                  backgroundColor: Constants.colorOnCard,
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
                  content: Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), border: Border.all(color: Constants.colorSecondary)),
                    child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const SizedBox(height: 20),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(content.title, textAlign: TextAlign.center, style: const TextStyle(fontFamily: Constants.poppinsMedium, fontSize: 22, color: Constants.colorOnSurface))),
                      const SizedBox(height: 10),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(content.message, style: TextStyle(color: Constants.colorOnSurface.withOpacity(0.7), fontSize: 14, fontFamily: Constants.poppinsRegular))),
                      const SizedBox(height: 20),
                      IntrinsicHeight(
                          child: Row(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                        SizedBox(
                            height: 35,
                            width: 100,
                            child: AppButton(
                                onClick: () => Navigator.pop(context),
                                text: content.negativeText,
                                fontFamily: Constants.poppinsRegular,
                                textColor: Constants.colorPrimaryVariant,
                                borderRadius: 10.0,
                                fontSize: 16,
                                color: Constants.colorOnSurface)),
                        const SizedBox(width: 20),
                        SizedBox(
                            height: 35,
                            width: 100,
                            child: AppButton(
                                onClick: () {
                                  Navigator.pop(context);
                                  positiveClickListener.call();
                                },
                                text: content.positiveText,
                                fontFamily: Constants.poppinsRegular,
                                textColor: Constants.colorOnSurface,
                                borderRadius: 10.0,
                                fontSize: 16,
                                color: Constants.colorPrimaryVariant))
                      ])),
                      const SizedBox(height: 25)
                    ]),
                  )),
              onWillPop: () async => false);
        });
  }

  void showMaterialDialogWithImageContent(String imagePath, String buttonText, MaterialDialogContent content, Function positiveClickListener, {Function? negativeClickListener, Widget? richText}) {
    final context = _context;
    if (context == null) return;
    showDialog(
        context: context,
        builder: (_) {
          return WillPopScope(
              child: AlertDialog(
                  insetPadding: const EdgeInsets.symmetric(horizontal: 25),
                  contentPadding: const EdgeInsets.only(bottom: 0),
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
                  content: Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
                    child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.center, children: [
                      const SizedBox(height: 30),
                      Image(image: AssetImage(imagePath), width: MediaQuery.of(context).size.width - 150),
                      const SizedBox(height: 20),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(content.title, textAlign: TextAlign.center, style: const TextStyle(fontFamily: Constants.poppinsMedium, fontSize: 18, color: Constants.colorPrimary))),
                      const SizedBox(height: 10),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 45),
                          child: richText ?? Text(content.message, textAlign: TextAlign.center, style: const TextStyle(color: Constants.colorSurface, fontSize: 16, fontFamily: Constants.poppinsLight))),
                      const SizedBox(height: 20),
                      IntrinsicHeight(
                          child: Row(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                        SizedBox(
                            height: 35,
                            width: 100,
                            child: AppButton(
                                onClick: () {
                                  Navigator.pop(context);
                                  positiveClickListener.call();
                                },
                                text: buttonText,
                                fontFamily: Constants.poppinsRegular,
                                textColor: Constants.colorOnSurface,
                                borderRadius: 10.0,
                                fontSize: 16,
                                color: Constants.colorPrimary))
                      ])),
                      const SizedBox(height: 25)
                    ]),
                  )),
              onWillPop: () async => false);
        });
  }
}
