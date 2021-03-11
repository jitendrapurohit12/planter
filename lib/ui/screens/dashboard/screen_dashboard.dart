import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gmt_planter/constant/constant.dart';
import 'package:gmt_planter/controllers/unconfirmed_funds_controller.dart';
import 'package:gmt_planter/helper/method_helper.dart';
import 'package:gmt_planter/helper/ui_helper.dart';
import 'package:gmt_planter/models/enums/notifier_state.dart';
import 'package:gmt_planter/router/router.dart';
import 'package:gmt_planter/ui/screens/dashboard/pages/home/page_home.dart';
import 'package:gmt_planter/ui/screens/dashboard/pages/inbox/page_inbox.dart';
import 'package:gmt_planter/ui/screens/dashboard/pages/story/page_story.dart';
import 'package:gmt_planter/ui/screens/dashboard/unconfirmed_dialog/unconfirmed_dialog.dart';
import 'package:provider/provider.dart';

class ScreenDashboard extends HookWidget {
  static const id = 'dashboard';

  @override
  Widget build(BuildContext context) {
    final _pages = [PageHome(), PageStory(), PageInbox()];
    final _titles = ['Home', 'Project Story', 'Inbox'];

    return Consumer<UnconfirmedFundsController>(builder: (_, notifier, __) {
      return Scaffold(
        appBar: customAppbar(title: _titles[notifier.selectedpage], actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => launchProfile(context: context),
          ),
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () => launchLanguage(context: context),
          ),
          Builder(
            builder: (ctx) {
              return IconButton(
                icon: const Icon(Icons.login_outlined),
                onPressed: () => logout(
                  context,
                  (e) => showSnackbar(context: ctx, message: e.message),
                ),
              );
            },
          )
        ]),
        body: Builder(builder: (_) {
          if (notifier.state == NotifierState.initial) {
            notifier.getUnconfirmedFunds(context: context);
          } else if (notifier.state == NotifierState.loaded &&
              notifier.model.data.isNotEmpty &&
              !notifier.isListShown) {
            performAfterDelay(
              callback: () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  isDismissible: false,
                  enableDrag: false,
                  backgroundColor: Colors.black.withOpacity(0.3),
                  context: context,
                  builder: (_) => UnconfirmedDialog(() {
                    if (Navigator.canPop(context)) Navigator.pop(context);
                    notifier.changeListShown(value: true);
                  }),
                );
              },
            );
          }
          return _pages[notifier.selectedpage];
        }),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: notifier.selectedpage,
          onTap: (index) => notifier.changePage(index),
          items: kArrayDashboardBottomNavigationItems(),
        ),
      );
    });
  }
}
