import 'package:flutter/material.dart';
import 'package:mailandcalendaruppa/calendar/models/help_item.dart';
import 'package:mailandcalendaruppa/calendar/param/string_key.dart';
import 'package:mailandcalendaruppa/calendar/ui/appbar_screen.dart';
import 'package:mailandcalendaruppa/calendar/ui/help/help_details.dart';
import 'package:mailandcalendaruppa/calendar/utils/analytics.dart';
import 'package:mailandcalendaruppa/calendar/utils/api/api.dart';
import 'package:mailandcalendaruppa/calendar/utils/custom_route.dart';
import 'package:mailandcalendaruppa/calendar/utils/translations.dart';
import 'package:mailandcalendaruppa/calendar/widgets/ui/button/large_rounded_button.dart';
import 'package:mailandcalendaruppa/calendar/widgets/ui/message/no_result_help.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpScreen extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void _sendFeedback(BuildContext context) async {
    var url = 'mailto:jeancharles.msse@gmail.com?subject=Feedback UnivAgenda';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      _scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(i18n.text(StrKey.NO_EMAIL_APP)),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    AnalyticsProvider.setScreen(this);

    return AppbarPage(
      scaffoldKey: _scaffoldKey,
      title: i18n.text(StrKey.HELP_FEEDBACK),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<HelpItem>>(
              future: Api().getHelps(),
              builder: (context, snapshot) {
                if (snapshot.hasError) return const NoResultHelp();

                if (snapshot.hasData) {
                  return ListView.separated(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      final item = snapshot.data[index];
                      return InkWell(
                        child: ListTile(title: Text(item.title)),
                        onTap: () {
                          Navigator.of(context).push(
                            CustomRoute(
                              builder: (_) => HelpDetailsScreen(helpItem: item),
                              fullscreenDialog: true,
                            ),
                          );
                        },
                      );
                    },
                    separatorBuilder: (_, __) => const Divider(height: 0),
                  );
                }

                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
          Hero(
            tag: "fabBtn",
            child: LargeRoundedButton(
              onPressed: () => _sendFeedback(context),
              text: i18n.text(StrKey.SEND_FEEDBACK),
            ),
          ),
        ],
      ),
    );
  }
}
