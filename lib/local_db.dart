import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_country_picker/country.dart';

class LocalAssetsDb {

  static Future<List<Country>> fetchListOfCountries () async {
    await Future.delayed(Duration(seconds: 2));
    var rawData = await rootBundle.loadString('packages/flutter_country_picker/assets/country_code.json');
    List<dynamic> itemMapList = json.decode(rawData);
    return itemMapList.map((e) => Country(
          asset: "assets/flags/${e['code'].toString().toLowerCase()}_flag.png",
          dialingCode: e['dial_code'],
          isoCode: e['code'],
          name: e['name']
        )).toList();
  }
}