import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:mailandcalendaruppa/calendar/param/url.dart';
import 'package:mailandcalendaruppa/calendar/utils/functions.dart';
import 'package:mailandcalendaruppa/calendar/utils/network/http_request.dart';
import 'package:mailandcalendaruppa/calendar/utils/translations.dart';

class ChangeLog extends StatelessWidget {
  Future<String> _fetchData(BuildContext context) async {
    final response = await HttpRequest.get(
      i18n.currentLanguage == "fr" ? Url.changelogFr : Url.changelog,
    );
    if (response.isSuccess) return response.httpResponse.body;
    return "## **NETWORK ERROR**";
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _fetchData(context),
      builder: (_, snapshot) => (snapshot.hasData)
          ? Markdown(
              data: snapshot.data,
              onTapLink: (href) => openLink(null, href, null))
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
