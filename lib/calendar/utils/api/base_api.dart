import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mailandcalendaruppa/calendar/param/string_key.dart';
import 'package:mailandcalendaruppa/calendar/models/base_response.dart';
import 'package:mailandcalendaruppa/calendar/models/custom_exception.dart';
import 'package:mailandcalendaruppa/calendar/utils/translations.dart';

const API_URL = "https://myagendaapi.herokuapp.com/api";

abstract class BaseApi {
  BaseApi();

  Future<http.Response> doRequest(Future<http.Response> httpRequest) async {
    try {
      return await httpRequest;
    } catch (_) {
      throw CustomException(
        "error_server_response",
        i18n.text(StrKey.NETWORK_ERROR),
      );
    }
  }

  String getAPIUrl(String route, [Map<String, dynamic> queryParams]) {
    String url = API_URL + route;
    if ((queryParams?.length ?? 0) == 0) return url;

    List<String> params = [];
    queryParams.forEach((key, value) {
      params.add("$key=${Uri.encodeComponent(value)}");
    });
    return url + "?" + params.join("&");
  }

  T getData<T>(http.Response response) {
    CustomException error;
    try {
      final res = BaseResponse<T>.fromJson(json.decode(response.body));
      if (res.error == null) return res.data;
      error = CustomException("error", res.error);
    } catch (e) {
      error = CustomException("error", i18n.text(StrKey.ERROR_JSON_PARSE));
    }
    throw error ?? CustomException("unknown", i18n.text(StrKey.UNKNOWN_ERROR));
  }

  Map<String, dynamic> getDataMap(http.Response response) {
    return getData<Map<String, dynamic>>(response);
  }
}
