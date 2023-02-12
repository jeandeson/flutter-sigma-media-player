import 'package:flutter/material.dart';
import 'package:gold_and_silver_classic_ost/src/Providers/player.dart';
import 'package:gold_and_silver_classic_ost/src/components/bottomBar.dart';
import 'package:gold_and_silver_classic_ost/src/components/themeBottomSheet.dart';
import 'package:gold_and_silver_classic_ost/src/data/themes.dart';
import 'package:gold_and_silver_classic_ost/src/pages/details.dart';
import 'package:gold_and_silver_classic_ost/src/pages/home.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../playList.dart';
import 'package:provider/provider.dart';

class MainLayout extends StatelessWidget {
  const MainLayout({super.key});
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    final PageController controller = PageController();
    List<Widget> pages = <Widget>[
      Home(
        navTo: () => {
          controller.animateToPage(1,
              duration: Duration(milliseconds: 300), curve: Curves.linear)
        },
      ),
      Details(
        backAction: () => {controller.jumpToPage(0)},
      ),
      PlayList(
        navTo: () => {controller.jumpToPage(3)},
        backAction: () => {controller.jumpToPage(0)},
      ),
      PlayListView(backAction: () => {controller.jumpToPage(2)}),
    ];
    return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primaryContainer,
            Theme.of(context).colorScheme.secondaryContainer
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomRight,
        )),
        child: Scaffold(
          key: _scaffoldKey,
          drawer: Drawer(
            child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primaryContainer,
                    Theme.of(context).colorScheme.secondaryContainer
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomRight,
                )),
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    DrawerHeader(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.primaryContainer,
                          Theme.of(context).colorScheme.secondaryContainer
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topRight,
                      )),
                      child: Image(
                          fit: BoxFit.contain,
                          image: AssetImage('assets/images/logo.png')),
                    ),
                    ListTile(
                      title: const Text(
                        'Playlists',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        controller.jumpToPage(2);
                      },
                    ),
                    ListTile(
                      title: const Text(
                        'Theme',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => ThemeBottomSheet(),
                        );
                      },
                    ),
                  ],
                )),
          ),
          extendBodyBehindAppBar: false,
          backgroundColor: Colors.transparent,
          body: PageView(
              controller: controller,
              physics: const NeverScrollableScrollPhysics(),
              children: pages),
          bottomNavigationBar: const BottomBar(),
        ));
  }
}
