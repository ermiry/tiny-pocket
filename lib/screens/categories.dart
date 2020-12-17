import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pocket/providers/categories.dart';
import 'package:pocket/style/colors.dart';
import 'package:pocket/widgets/categories.dart';
import 'package:provider/provider.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {

  final GlobalKey <ScaffoldState> _scaffoldKey = new GlobalKey <ScaffoldState>();

  
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
          SingleChildScrollView(
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
                    'Categories',
                    style: TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2F3446)
                    ),
                  )
                ),

                SizedBox(height: MediaQuery.of(context).size.height * 0.02),

                new CategoriesDisplay (true),

                SizedBox(height: MediaQuery.of(context).size.height * 0.02),

                Consumer <Categories> (
                  builder: (ctx, categories, _) {
                    return categories.categories.length > 0 ? Padding(
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
                            categories.categories[categories.selectedCategoryIdx].description,
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ) : Container();
                  }
                ),

                SizedBox(height: MediaQuery.of(context).size.height * 0.02),

                Padding(
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
                ),

                SizedBox(height: MediaQuery.of(context).size.height * 0.02),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Consumer<Categories>(
                    builder: (ctx, categories, _) {
                      return categories.categories.length > 0 ? Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: categories.categories[categories.selectedCategoryIdx].color,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ) : Container();
                    },
                  ),
                )
                // SizedBox(height: MediaQuery.of(context).size.height * 0.02),

              ],
            ),
          ),

          // edit selected category
          // this._showEditCategory(),

          // add a new label
          // Positioned(
          //   bottom: MediaQuery.of(context).size.width * 0.05,
          //   left: MediaQuery.of(context).size.width * 0.83,
          //   child: Container(
          //     decoration: ShapeDecoration(
          //       shape: CircleBorder (),
          //       color: mainBlue
          //     ),
          //     child: IconButton(
          //       hoverColor: Colors.transparent,
          //       splashColor: Colors.transparent,
          //       focusColor: Colors.transparent,
          //       highlightColor: Colors.transparent,
          //       color: Colors.white,
          //       icon: Icon(Icons.label),
          //       onPressed: this._addLabelDialog,
          //       iconSize: 42
          //     )
          //   ),
          // ),
        ],
      ),
    );
  }


}