import 'package:flutter/material.dart';

import '../utils/app_strings.dart';
import '../utils/constants.dart';

class ErrorTryAgain extends StatelessWidget {
  final EdgeInsets margin;
  final VoidCallback positiveClickListener;

  const ErrorTryAgain({required this.margin, required this.positiveClickListener});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: margin,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(AppText.LIMITED_NETWORK_CONNECTION, style: TextStyle(fontFamily: Constants.poppinsMedium, fontSize: 20, color: Constants.colorOnSurface))),
          const SizedBox(height: 10),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(AppText.LIMITED_NETWORK_CONNECTION_CONTENT,
                  textAlign: TextAlign.center, style: TextStyle(color: Constants.colorOnSurface.withOpacity(0.5), fontSize: 14, fontFamily: Constants.poppinsRegular))),
          const SizedBox(height: 30),
          Divider(thickness: 0.8, color: Constants.colorOnSurface.withOpacity(0.1), height: 0),
          SizedBox(
            width: size.width - margin.left + margin.right,
            child: InkWell(
              onTap: positiveClickListener,
              child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  child:
                      Text(AppText.TRY_AGAIN.toUpperCase(), textAlign: TextAlign.center, style: const TextStyle(color: Constants.colorOnSurface, fontSize: 14, fontFamily: Constants.poppinsRegular))),
            ),
          )
        ],
      ),
    );
  }
}
