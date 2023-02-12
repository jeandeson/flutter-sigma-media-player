import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:gold_and_silver_classic_ost/src/data/themes.dart';
import 'package:provider/provider.dart';

class ThemeBottomSheet extends StatelessWidget {
  const ThemeBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            Themes().themeOne.colorScheme.primaryContainer,
            Themes().themeOne.colorScheme.secondaryContainer
          ])),
          child: ListTile(
              textColor: Colors.white,
              title: Text("Primary Theme"),
              trailing: Icon(Icons.palette),
              onTap: () => {
                    context.read<ThemesModel>().changeTheme(Themes().themeOne),
                    Navigator.pop(context)
                  }),
        ),
        Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            Themes().themeTwo.colorScheme.primaryContainer,
            Themes().themeTwo.colorScheme.secondaryContainer
          ])),
          child: ListTile(
              trailing: Icon(Icons.palette),
              textColor: Colors.white,
              title: Text("Secondary theme"),
              onTap: () => {
                    context.read<ThemesModel>().changeTheme(Themes().themeTwo),
                    Navigator.pop(context)
                  }),
        )
      ],
    );
  }
}
