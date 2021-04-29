import 'package:favicon/favicon.dart' as fv;
import 'package:flutter/material.dart';
import 'package:pocket/providers/auth.dart';
import 'package:pocket/providers/places.dart';
import 'package:pocket/widgets/add_place.dart';

import 'package:provider/provider.dart';
import 'package:pocket/style/colors.dart';

import 'package:animated_dialog/AnimatedDialog.dart';

class PlacesDisplay extends StatefulWidget {

  final bool add;

  PlacesDisplay (this.add);

  @override
  _PlacesDisplayState createState() => _PlacesDisplayState();
  
}

class _PlacesDisplayState extends State <PlacesDisplay> {

  void _addPlaceDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return new AnimatedDialog(
          changeToDialog: true,
          borderRadius: BorderRadius.all(Radius.circular(12)),
          child: new AddPlace(null)

        );

      }
    ).then((value) async{
      if (value != null) {
        if (value == 'add') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              content: Text(
                'Created a new place!',
                textAlign: TextAlign.center,
              )
            )
          );

          await Provider.of<Places>(context,listen: false).fetch(
            Provider.of<Auth>(context,listen:false).token
          );
        }
      }
    });
  }

  Widget _create() {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.only(
          top: 16,
          bottom: 16,
          right: 6,
          left: 16
        ),
        height: 240.0,
        width: 160.0,
        decoration: BoxDecoration(
          color: Color(0xFFEFF4F6),
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(color: Colors.transparent),
          ],
        ),
        child: Center(
          child: Icon(
            Icons.add,
            color: mainBlue,
            size: 84,
          ),
        ) 
      ),
      onTap: this._addPlaceDialog
    );
  }

  Widget _place(int index, double left, String name, int count, fv.Icon icon) {
    int selectedIdx = Provider.of<Places>(context,listen:false).selectedPlaceIdx;
    return GestureDetector(
      onTap: () {
        Provider.of<Places>(context, listen: false).selectedPlaceIdx = index;
      },
      child: Container(
        margin: EdgeInsets.only(
          top: 16,
          bottom: 16,
          right: 8,
          left: left
        ),
        height: 240.0,
        width: 160.0,
        decoration: BoxDecoration(
          color: selectedIdx == index
            ? mainBlue
            : Color(0xFFEFF4F6),
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            selectedIdx == index
              ? BoxShadow(
                  color: Colors.black26,
                  offset: Offset(0, 2),
                  blurRadius: 10.0
                )
              : BoxShadow(color: Colors.transparent),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                name,
                style: TextStyle(
                  color: selectedIdx == index
                    ? Colors.white
                    : Color(0xFFAFB4C6),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: icon != null ?  Image(
                image: NetworkImage(icon.url),
                fit: BoxFit.cover,
                width: 48,
                height: 48,
              ) : Container()
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer <Places> (
      builder: (ctx, places, _) {
        return Container(
          // padding: EdgeInsets.symmetric(horizontal: 16),
          height: 240.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: this.widget.add ? places.places.length + 1 : places.places.length,
            itemBuilder: (BuildContext context, int index) {
              int idx = this.widget.add ? index - 1 : index;

              if (this.widget.add) {
                if (index == 0) {
                  return this._create();
                }
              }

              return this._place(
                idx,
                index == 0 ? 16 : 6,
                places.places[idx].name,
                0,
                places.places[idx].iconLogo
              );
            },
          ),
        );
      }
    );
  }

}