import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gmt_planter/constant/constant.dart';
import 'package:gmt_planter/helper/ui_helper.dart';
import 'package:gmt_planter/ui/screens/dashboard/pages/home/page_home.dart';
import 'package:gmt_planter/ui/screens/dashboard/pages/inbox/page_inbox.dart';
import 'package:gmt_planter/ui/screens/dashboard/pages/story/page_story.dart';

class ScreenDashboard extends HookWidget {
  static const id = 'dashboard';

  @override
  Widget build(BuildContext context) {
    const _iconSize = 30.0;
    final _pageController = useStreamController<int>();

    final _pages = [PageHome(), PageStory(), PageInbox()];
    final _titles = ['Home', 'Project Story', 'Inbox'];

    return StreamBuilder<int>(
      stream: _pageController.stream,
      initialData: 0,
      builder: (context, snapshot) {
        return Scaffold(
          appBar: customAppbar(title: _titles[snapshot.data]),
          body: _pages[snapshot.data],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: snapshot.data,
            onTap: (index) => _pageController.add(index),
            items: kArrayDashboardBottomNavigationItems(iconSize: _iconSize),
          ),
        );
      },
    );
  }
}
