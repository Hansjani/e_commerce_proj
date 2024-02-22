import 'package:e_commerce_ui_1/Theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: const SettingsBody(),
    );
  }
}

class SettingsBody extends StatefulWidget {
  const SettingsBody({super.key});

  @override
  State<SettingsBody> createState() => _SettingsBodyState();
}

class _SettingsBodyState extends State<SettingsBody> {

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context,listen: false);
    return SingleChildScrollView(
      child: Column(
        children: [
          SettingsList(
            lightTheme: SettingsThemeData(
              settingsListBackground: Theme.of(context).canvasColor,
            ),
            darkTheme: SettingsThemeData(
              settingsListBackground: Theme.of(context).canvasColor,
            ),
            shrinkWrap: true,
            sections: [
              SettingsSection(
                title: const Text('Themes'),
                tiles: [
                  SettingsTile.switchTile(
                    initialValue: themeProvider.isDarkMode,
                    onToggle: (bool value) {
                      setState(() {
                        themeProvider.toggleTheme(value);
                      });
                    },
                    leading: themeProvider.isDarkMode ? const Icon(Icons.nightlight) : const Icon(Icons.nightlight_outlined),
                    title: const Text('Dark Mode'),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
