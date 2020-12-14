import 'package:flutter/material.dart';
import 'package:pocket/models/category.dart';
import 'package:pocket/providers/categories.dart';
import 'package:pocket/style/colors.dart';
import 'package:pocket/widgets/custom/button.dart';
import 'package:provider/provider.dart';


class ChooseCategories extends StatefulWidget {
  final String currentCategory;

  ChooseCategories(this.currentCategory);
  @override
  _ChooseCategoriesState createState() => _ChooseCategoriesState();

}

class _ChooseCategoriesState extends State <ChooseCategories> {

  int selected = -1;
  String _selectedId = "";


  @override
  void initState() { 
    super.initState();
    
    checkForSelection();
  }

  void checkForSelection(){
    Provider.of<Categories>(context,listen:false).categories.forEach((element) {
      if(element.id == this.widget.currentCategory){
        this.setState(() {
          this.selected = Provider.of<Categories>(context,listen:false).categories.indexOf(element);
          this._selectedId = element.id;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer <Categories> (
      builder: (ctx, category, _) {
        return SingleChildScrollView(
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 16),

              Center(
                child: Text(
                  "Choose Category",
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
                itemCount: category.categories.length,
                itemBuilder: (ctx, i) {
                  

                  return _chooseCategory(
                    category.categories[i],
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

  Widget _chooseCategory(Category category, int idx){
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 32),
      leading: Container(
        margin: EdgeInsets.only(right: 4, bottom: 4),
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: category.color,
          borderRadius: BorderRadius.circular(6)
        ),
      ),
      title: new Text(
        category.title,
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
            category.description,
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
              this._selectedId = category.id;
            });
          }
        },
      )
    );
  }

}
