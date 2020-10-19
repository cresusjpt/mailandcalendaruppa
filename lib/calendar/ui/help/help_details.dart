import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:mailandcalendaruppa/calendar/param/string_key.dart';
import 'package:mailandcalendaruppa/calendar/models/help_item.dart';
import 'package:mailandcalendaruppa/calendar/ui/appbar_screen.dart';
import 'package:mailandcalendaruppa/calendar/utils/analytics.dart';
import 'package:mailandcalendaruppa/calendar/utils/api/api.dart';
import 'package:mailandcalendaruppa/calendar/utils/translations.dart';
import 'package:mailandcalendaruppa/calendar/widgets/ui/message/no_result_help.dart';

class HelpDetailsScreen extends StatelessWidget {
  final HelpItem helpItem;

  const HelpDetailsScreen({Key key, @required this.helpItem})
      : assert(helpItem != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    AnalyticsProvider.setScreen(this);

    return AppbarPage(
      title: i18n.text(StrKey.HELP_FEEDBACK),
      body: FutureBuilder<String>(
        future: Api().getHelp(helpItem.filename),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Markdown(
              data: snapshot.data,
              styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)),
            );
          }
          if (snapshot.hasError) return const NoResultHelp();

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
