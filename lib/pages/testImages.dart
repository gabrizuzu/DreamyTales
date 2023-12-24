import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



class Api{
  static final url = Uri.parse('https://api.openai.com/v1/images/generations');

  static final headers = {
    'Authorization':
    'Bearer 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',
    'Content-Type': 'application/json',
  };

  static generateImages(String text) async{
    var res = await http.post(
        url,
        headers: headers,
        body: jsonEncode({
          "prompt": "text",
          "n": 1,
          "model": "dall-e-2",
          "size": "1024x1024",
          "quality": "standard"
        }),

    );

    print('Response status: ${res.statusCode}');
    print('Response body: ${res.body}');

    if (res.statusCode == 200) {
      var jsonResponse = jsonDecode(res.body);
      print(jsonResponse);
      return jsonResponse['data'][0]['url'];
    } else {
      print('Request failed with status: ${res.statusCode}.');
    }
  }
}
