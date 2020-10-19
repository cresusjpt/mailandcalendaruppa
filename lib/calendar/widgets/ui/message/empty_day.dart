import 'package:flutter/material.dart';
import 'package:mailandcalendaruppa/calendar/param/string_key.dart';
import 'package:mailandcalendaruppa/calendar/utils/translations.dart';

class EmptyDay extends StatelessWidget {
  final EdgeInsets padding;
  final String textKey;

  const EmptyDay({Key key, this.padding, this.textKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ??
          const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 8.0,
          ),
      child: Text(
        textKey == null ? i18n.text(StrKey.NO_EVENTS) :  i18n.text(StrKey.NO_EVENTS),
        style: Theme.of(context).textTheme.subtitle1,
        textAlign: TextAlign.justify,
      ),
    );
  }
}
