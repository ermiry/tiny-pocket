import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pocket/providers/places.dart';
import 'package:pocket/style/colors.dart';
import 'package:pocket/widgets/places.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';


class PlacesScreen extends StatefulWidget {
  @override
  _PlacesScreenState createState() => _PlacesScreenState();
}

class _PlacesScreenState extends State<PlacesScreen> {

  final GlobalKey <ScaffoldState> _scaffoldKey = new GlobalKey <ScaffoldState>();
  bool _loading = false;
  
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      // DeviceOrientation.portraitDown,
    ]);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Consumer<Places>(
            builder: (context, places, snapshot) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: MediaQuery.of(context).size.height * 0.04),

                    ListTile(
                      leading: IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: mainDarkBlue,
                          size: 36,
                        ),
                        onPressed: () async {
                          FocusScope.of(context).requestFocus(FocusNode());
                          Navigator.pop(context);
                        },
                      ),
                      title: Text(
                        'Places and Sites',
                        style: TextStyle(
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2F3446)
                        ),
                      )
                    ),

                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),

                    new PlacesDisplay (true),

                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),

                    places.places.isEmpty ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        "You don't have any places, add one to start",
                        style: TextStyle(
                          fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2F3446)
                          ),
                        textAlign: TextAlign.start,
                      ),
                    ): Container(),

                    places.places.length > 0 ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Description',
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2F3446)
                            ),
                            textAlign: TextAlign.start,
                          ),

                          const SizedBox(height: 16),

                          Text(
                            places.places[places.selectedPlaceIdx].description,
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ) : Container(),
                      
                    

                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),

                    places.places.length > 0 ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        'Color',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2F3446)
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ) : Container(),

                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: places.places.length > 0 ? Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: places.places[places.selectedPlaceIdx].color,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ) : Container()
                    ),

                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),

                    places.places.length > 0 ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Type',
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2F3446)
                            ),
                            textAlign: TextAlign.start,
                          ),

                          const SizedBox(height: 16),

                          Text(
                            places.places[places.selectedPlaceIdx].type,
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ) : Container(),

                    places.places.length > 0  && places.places[places.selectedPlaceIdx].link != null ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Link',
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2F3446)
                            ),
                            textAlign: TextAlign.start,
                          ),

                          const SizedBox(height: 16),

                          InkWell(
                            onTap: () async {
                              this.setState(() {
                                this._loading = true;
                              });

                              await launch(places.places[places.selectedPlaceIdx].link);

                              this.setState(() {
                                this._loading = false;                           
                              });
                            },
                            child: !this._loading ? Text(
                              places.places[places.selectedPlaceIdx].link,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54
                              ),
                              textAlign: TextAlign.start,
                            ) : CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(mainDarkBlue),
                            ),
                          ),
                        ],
                      ),
                    ) : Container()
                  ],
                ),
              );
            }
          ),
        ],
      ),
    );
  }
}