import 'package:flutter/material.dart';
import 'package:gmt_planter/controllers/language_controller.dart';
import 'package:gmt_planter/helper/ui_helper.dart';
import 'package:gmt_planter/models/language_model.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class ScreenLanguage extends StatelessWidget {
  static const id = 'language';
  @override
  Widget build(BuildContext context) {
    final ph = context.percentHeight;
    return Scaffold(
      appBar: customAppbar(title: 'Select Language'),
      body: Consumer<LanguageNotifier>(
        builder: (_, notifier, __) => VStack([
          (ph * 4).heightBox,
          'Select the language'.text.xl3.make().px16(),
          (ph * 4).heightBox,
          for (int i = 0; i < languageList.length; i++)
            HStack([
              RadioListTile<Locale>(
                value: languageList[i].locale,
                groupValue: notifier.appLocale,
                title: languageList[i].title.text.xl.make(),
                subtitle: 'Change language to ${languageList[i].title}'.text.sm.gray500.make(),
                onChanged: (s) => notifier.changeLanguage(context, s),
              ).expand(),
              VxBox(
                      child: VxCard(getImage(path: languageList[i].path))
                          .roundedSM
                          .clip(Clip.antiAlias)
                          .elevation(0)
                          .p1
                          .make())
                  .width(70)
                  .height(45)
                  .border(color: Colors.grey.shade400)
                  .roundedSM
                  .make(),
              12.widthBox,
            ])
        ]),
      ),
    );
  }
}
