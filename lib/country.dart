import 'package:flutter/foundation.dart';

/// A country definition with image asset, dialing code and localized name.
class Country {
  /// the flag image asset name
  final String asset;

  /// the dialing code
  final String dialingCode;

  /// the 2-letter ISO code
  final String isoCode;

  /// the localized / English country name
  final String name;

  /// Instantiates an [Country] with the specified [asset], [dialingCode] and [isoCode]
  const Country({
    this.asset,
    @required this.dialingCode,
    @required this.isoCode,
    this.name = "",
  });

  /// returns an country with the specified [isoCode] or ```null``` if
  /// none or more than 1 are found
  static findByIsoCode(String isoCode, List<Country> list) {
    return list.singleWhere(
      (item) => item.isoCode == isoCode,
    );
  }

  @override
  bool operator ==(o) =>
      o is Country &&
      o.dialingCode == this.dialingCode &&
      o.isoCode == this.isoCode &&
      o.asset == this.asset &&
      o.name == this.name;

  int get hashCode {
    int hash = 7;
    hash = 31 * hash + this.dialingCode.hashCode;
    hash = 31 * hash + this.asset.hashCode;
    hash = 31 * hash + this.name.hashCode;
    hash = 31 * hash + this.isoCode.hashCode;
    return hash;
  }



  /// Creates a copy with modified values
  Country copyWith({
    String name,
    String isoCode,
    String dialingCode,
  }) {
    return Country(
      name: name ?? this.name,
      isoCode: isoCode ?? this.isoCode,
      dialingCode: dialingCode ?? this.dialingCode,
      asset: asset ?? this.asset,
    );
  }
}
