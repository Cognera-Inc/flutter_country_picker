import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_country_picker/local_db.dart';
import 'country.dart';

export 'country.dart';


/// The country picker widget exposes an dialog to select a country from a
/// pre defined list, see [Country.all]
class CountryPicker extends FutureBuilder<List<Country>> {
  CountryPicker({
    Key key,
    @required onChanged,
    bool dense = false,
    bool denseList = false,
    bool showFlagOnButton = true,
    bool showFlagOnList = true,
    bool showDialingCode = false,
    bool showName = true,
    bool transparentBackground = false,
    double height = 400.0,
    double borderRadius = 10.0,
    bool showIsoCode = false,
    Country selectedCountry,
  }) :
    super(
      future: LocalAssetsDb.fetchListOfCountries(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return _CountryPickerImplementation(
            key: key,
            countryList: snapshot.data,
            onChanged: onChanged,
            dense: dense,
            denseList: denseList,
            selectedCountry: selectedCountry,
            borderRadius: borderRadius,
            height: height,
            showDialingCode: showDialingCode,
            showFlagOnButton: showFlagOnButton,
            showFlagOnList: showFlagOnList,
            showIsoCode: showIsoCode,
            showName: showName,
            transparentBackground: transparentBackground,
          );
        }
        return Container();
      }
    );
}

class _CountryPickerImplementation extends StatelessWidget {
  const _CountryPickerImplementation
({
    Key key,
    @required this.countryList,
    this.selectedCountry,
    @required this.onChanged,
    this.dense = false,
    this.denseList = false,
    this.showFlagOnButton = true,
    this.showFlagOnList = true,
    this.showDialingCode = false,
    this.showName = true,
    this.transparentBackground = false,
    this.height = 400.0,
    this.borderRadius = 10.0,
    this.showIsoCode = false,
  }) : super(key: key);

  final List<Country> countryList;
  final Country selectedCountry;
  final ValueChanged<Country> onChanged;
  final bool dense;
  final bool showFlagOnButton;
  final bool showFlagOnList;
  final bool showDialingCode;
  final bool showName;
  final bool showIsoCode;
  final bool transparentBackground;
  final double height;
  final double borderRadius;
  final bool denseList;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    Country displayCountry = selectedCountry;

    if (displayCountry == null) {
      displayCountry = Country.findByIsoCode(Localizations.localeOf(context).countryCode, countryList);
    }

    return dense
      ? _renderDenseDisplay(context, displayCountry, countryList)
      : _renderDefaultDisplay(context, displayCountry, countryList);
  }

  _renderDefaultDisplay(BuildContext context, Country displayCountry, List<Country> countryList) {
    return InkWell(
			child: Row(
				mainAxisSize: MainAxisSize.min,
				mainAxisAlignment: MainAxisAlignment.center,  
				children: <Widget>[
					showFlagOnButton
					? Flexible(
						flex: 1,
						child: Container(
							child: Image.asset(
								displayCountry.asset,
								package: "flutter_country_picker",
								height: 32.0,
								fit: BoxFit.fitWidth,
							)
						),
					)
					: Container(),
					showDialingCode
					? Flexible(
						flex: 3,
							child: Container(
							child: Text(
									" (${displayCountry.dialingCode})",
									style: TextStyle(fontSize: 20.0),
								)
							),
					)
					: Container(),
					showName
					? Flexible(
						flex: 7,
						child: Container(
							child: showIsoCode
							? Text(
								" ${displayCountry.isoCode}",
								textAlign: TextAlign.center,
								overflow: TextOverflow.ellipsis,
								maxLines: 1,
								style: TextStyle(fontSize: 22.0),
							)
							: Text(
								" ${displayCountry.name}",
								textAlign: TextAlign.center,
								overflow: TextOverflow.ellipsis,
								maxLines: 1,
								style: TextStyle(fontSize: 22.0),
							)
						),
					)
					: Container(),
					Flexible(
						flex: 1,
						child: Icon(Icons.arrow_drop_down,
							color: Theme.of(context).brightness == Brightness.light
									? Colors.grey.shade700
									: Colors.white70,
						),
					),
				],
			),
			onTap: () {
				_selectCountry(context, countryList);
			},
		);
	}


  _renderDenseDisplay(BuildContext context, Country displayCountry, List<Country> countryList) {
    return InkWell(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Image.asset(
            displayCountry.asset,
            package: "flutter_country_picker",
            height: 24.0,
            fit: BoxFit.fitWidth,
          ),
          Icon(Icons.arrow_drop_down,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.grey.shade700
                  : Colors.white70),
        ],
      ),
      onTap: () {
        _selectCountry(context, countryList);
      },
    );
  }

  Future<Null> _selectCountry(BuildContext context, List<Country> countryList) async {
    final Country picked = await showCountryPicker(
      context: context,
      countryList: countryList,
      transparentBackground: transparentBackground,
      showFlagOnList: showFlagOnList,
      height: height,
      borderRadius: borderRadius,
      denseList: denseList,
    );

    if (picked != null && picked != selectedCountry) onChanged(picked);
  }
}

/// Display an [Dialog] with the country list to selection
/// you can pass and [defaultCountry], see [Country.findByIsoCode]
Future<Country> showCountryPicker({
  BuildContext context,
  List<Country> countryList,
  bool transparentBackground,
  bool showFlagOnList,
  double height,
  double borderRadius,
  bool denseList,
}) async {
  return await showDialog<Country>(
    context: context,
    builder: (BuildContext context) => _CountryPickerDialog(
      countryList: countryList,
      transparentBackground: transparentBackground,
      showFlagOnList: showFlagOnList,
      height: height,
      borderRadius: borderRadius,
      denseList: denseList,
    ),
  );
}

class _CountryPickerDialog extends StatefulWidget {
  const _CountryPickerDialog({
    Key key,
    this.countryList,
    this.transparentBackground,
    this.showFlagOnList,
    this.height,
    this.borderRadius,
    this.denseList,
  }) : super(key: key);

  final bool transparentBackground;
  final bool showFlagOnList;
  final double height;
  final double borderRadius;
  final bool denseList;
  final List<Country> countryList;

  @override
  State<StatefulWidget> createState() => _CountryPickerDialogState(
    transparentBackground: transparentBackground,
    showFlagOnList: showFlagOnList,
    height: height,
    borderRadius: borderRadius,
    denseList: denseList,
    countryList: countryList,
  );
}

class _CountryPickerDialogState extends State<_CountryPickerDialog> {
  final bool transparentBackground;
  final bool showFlagOnList;
  final double height;
  final double borderRadius;
  final bool denseList;
  final List<Country> countryList;

  TextEditingController controller = TextEditingController();
  String filter;
  List<Country> countries;

  _CountryPickerDialogState({
    this.countryList,
    this.denseList,
    this.borderRadius,
    this.height,
    this.showFlagOnList,
    this.transparentBackground,
  });

  @override
  void initState() {
    super.initState();

    controller.addListener(() {
      setState(() {
        filter = controller.text;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return transparentBackground ? 
    _countryListDialog()
    : Material(
      type: MaterialType.canvas,
      child: _countryListDialog(),
    );
  }

  Widget _countryListDialog() {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
      child: Container(
        height: height,
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: MaterialLocalizations.of(context).searchFieldLabel,
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: filter == null || filter == ""
                      ? Container(
                          height: 0.0,
                          width: 0.0,
                        )
                      : InkWell(
                          child: Icon(Icons.clear),
                          onTap: () {
                            controller.clear();
                          },
                        ),
                ),
                controller: controller,
              ),
            ),
            Expanded(
              child: Scrollbar(
                child: ListView.builder(
                  itemCount: countryList.length,
                  itemBuilder: (BuildContext context, int index) {
                    Country country = countryList[index];
                    if (filter == null ||
                        filter == "" ||
                        country.name
                            .toLowerCase()
                            .contains(filter.toLowerCase()) ||
                        country.isoCode.contains(filter)) {
                      return InkWell(
                        child: ListTile(
                          dense: denseList,
                          trailing: Text("${country.dialingCode}"),
                          title: Row(
                            children: <Widget>[
                              showFlagOnList ?
                              Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: Image.asset(
                                  country.asset,
                                  package: "flutter_country_picker",
                                ),

                              )
                              : Container(),
                              Expanded(
                                child: Text(
                                  country.name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context, country);
                        },
                      );
                    }
                    return Container();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
