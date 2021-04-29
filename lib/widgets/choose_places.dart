import 'package:flutter/material.dart';
import 'package:pocket/models/place.dart';
import 'package:pocket/providers/places.dart';
import 'package:pocket/style/colors.dart';
import 'package:pocket/widgets/custom/button.dart';
import 'package:provider/provider.dart';


class ChoosePlaces extends StatefulWidget {
  final String currentPlace;

  ChoosePlaces(this.currentPlace);
  @override
  _ChoosePlacesState createState() => _ChoosePlacesState();

}

class _ChoosePlacesState extends State <ChoosePlaces> {

  int selected = -1;
  String _selectedId = "";


  @override
  void initState() { 
    super.initState();
    
    checkForSelection();
  }

  void checkForSelection(){
    Provider.of<Places>(context,listen:false).places.forEach((element) {
      if(element.id == this.widget.currentPlace){
        this.setState(() {
          this.selected = Provider.of<Places>(context,listen:false).places.indexOf(element);
          this._selectedId = element.id;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer <Places> (
      builder: (ctx, place, _) {
        return SingleChildScrollView(
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 16),

              Center(
                child: Text(
                  "Choose Place",
                  style: TextStyle(
                    fontSize: 24, 
                    fontWeight: FontWeight.bold, 
                    color: mainDarkBlue
                  ),
                )
              ),

              const SizedBox(height: 16),

              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: place.places.length,
                itemBuilder: (ctx, i) {
                  

                  return _choosePlace(
                    place.places[i],
                    i
                  );
                }
              ),

              const SizedBox(height: 16),
              // Spacer(),

              CustomButton(
                onPressed: () {
                  Navigator.of(context).pop(this._selectedId);
                },
                buttonText: "Done",
                color: mainBlue,
                textColor: Colors.white,
              ),

              const SizedBox(height: 16),
            ],
          ),
        );
      }
    );
  }

  Widget _choosePlace(Place place, int idx){
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 32),
      leading: Container(
        margin: EdgeInsets.only(right: 4, bottom: 4),
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: place.color,
          borderRadius: BorderRadius.circular(6)
        ),
      ),
      title: new Text(
        place.name,
        style: const TextStyle(
          // color: Colors.black,
          color: Color(0xFF2F3446),
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 4),

          new Text(
            place.description,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      trailing: IconButton (
        icon: Icon(
          this.selected == idx ? Icons.check_circle : Icons.check_circle_outline,
          color: mainDarkBlue,
          size: 28,
        ),
        onPressed: () {
          print(idx);
          if(this.selected == idx){
            this.setState(() {
              this.selected = -1;
              this._selectedId = "";
            });
          }else{
            this.setState(() {
              this.selected = idx;
              this._selectedId = place.id;
            });
          }
        },
      )
    );
  }

}
