import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:pets_weight_graph/data/network/constants/endpoints.dart';

class RestClient {
  // instantiate json decoder for json serialization
  final JsonDecoder _decoder = JsonDecoder();

  // Get
  Future<dynamic> get(Uri uri) async {
    return http
        .get(uri, headers: Endpoints.HEADERS)
        .then(_createResponse)
        .catchError((error) {
      return null;
    });
  }

  // Post
  Future<dynamic> post(Uri uri, {body, encoding}) {
    return http
        .post(
          uri,
          body: body,
          headers: Endpoints.HEADERS,
          encoding: encoding,
        )
        .then(_createResponse);
  }

  // Update
  Future<dynamic> patch(Uri uri, {body, encoding}) {
    return http
        .patch(
          uri,
          body: body,
          headers: Endpoints.HEADERS,
          encoding: encoding,
        )
        .then(_createResponse);
  }

  // Response
  dynamic _createResponse(http.Response response) {
    final String res = response.body;
    if (response.statusCode < 200 || response.statusCode > 400) {
      //throw exception
    }
    return _decoder.convert(res);
  }
}
