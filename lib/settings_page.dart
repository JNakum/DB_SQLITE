import 'package:db_sqlite/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Settings"),
        ),
        body: Consumer<ThemeProvider>(builder: (ctx, provider, __) {
          return SwitchListTile.adaptive(
              title: Text("Dark Mode"),
              subtitle: Text("Change Theme Mode Here....!!"),
              value: provider.getThemeValue(),
              onChanged: (value) {
                provider.updateTheme(value: value);
              });
        }));
  }
}
