import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:mailandcalendaruppa/calendar/models/courses/course.dart';
import 'package:mailandcalendaruppa/calendar/models/help_item.dart';
import 'package:mailandcalendaruppa/calendar/models/ical/ical.dart';
import 'package:mailandcalendaruppa/calendar/utils/api/base_api.dart';
import 'package:mailandcalendaruppa/calendar/utils/ical_api.dart';
import 'package:mailandcalendaruppa/calendar/utils/translations.dart';

class Api extends BaseApi {
  Api() : super();

  Future<List<Course>> getCoursesCustomIcal(String icalUrl) async {
    final response = await doRequest(http.get(
      getAPIUrl("/parseCustomIcal", {'url': icalUrl}),
      headers: {HttpHeaders.acceptLanguageHeader: i18n.currentLanguage},
    ));

    return IcalAPI.icalToCourses(Ical.fromJson(getDataMap(response)));
  }

  Future<List<HelpItem>> getHelps() async {
    final response = await doRequest(http.get(
      getAPIUrl("/helps"),
      headers: {HttpHeaders.acceptLanguageHeader: i18n.currentLanguage},
    ));

    return List<HelpItem>.from(getData(response).map(
      (x) => HelpItem.fromJson(x),
    ));
  }

  Future<String> getHelp(String filename) async {
    final response = await doRequest(http.get(
      getAPIUrl("/helps/$filename"),
      headers: {HttpHeaders.acceptLanguageHeader: i18n.currentLanguage},
    ));

    return getData<String>(response);
  }
}
