import 'package:flutter/material.dart';
import 'package:mailandcalendaruppa/calendar/utils/preferences.dart';

abstract class BaseState<T extends StatefulWidget> extends State<T> {
  PreferencesProviderState prefs;
  ThemeData theme;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    prefs = PreferencesProvider.of(context);
    theme = Theme.of(context);
  }
}
