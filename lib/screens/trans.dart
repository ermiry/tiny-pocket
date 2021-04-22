import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pocket/providers/auth.dart';
import 'package:pocket/providers/keyboard.dart';
import 'package:pocket/providers/transactions.dart';
import 'package:pocket/style/style.dart';
import 'package:pocket/widgets/adaptive/flatButton.dart';
import 'package:pocket/widgets/choose_categories.dart';
import 'package:pocket/widgets/choose_places.dart';
import 'package:pocket/widgets/custom/numpad.dart';

import 'package:provider/provider.dart';
// import 'package:pocket/providers/transactions.dart';

import 'package:pocket/models/transaction.dart';

import 'package:pocket/style/colors.dart';

class TransScreen extends StatefulWidget {

  final Transaction baseTrans;

  TransScreen(this.baseTrans);

  @override
  _TransScreenState createState() => _TransScreenState();
  
}

class _TransScreenState extends State <TransScreen> {

  final TextEditingController _titleEditingController = TextEditingController();
  final TextEditingController _amountEditingController = TextEditingController();

  final FocusNode _titleFocusNode = new FocusNode ();

  bool _start = true;
  bool _edit = false;
  bool _first = true;
  bool _numpad = false;
  bool _loading = false;
  DateTime _selectedDate = new DateTime.now();
  TimeOfDay _selectedHour = new TimeOfDay.now();
  String _category = "";
  String _place = "";

  @override
  void initState() { 
    super.initState();

  }

  void unfocusIfNeeded(){
    if(_titleFocusNode.hasPrimaryFocus){
      this._titleFocusNode.unfocus();
    }

    if(this._numpad){
      this.setState(() {
        this._numpad = false;
      });
    }
  }

  void _categorySelect() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return new AnimatedDialog(
        //   changeToDialog: true,
        //   borderRadius: BorderRadius.all(Radius.circular(12)),
        //   child: new ChooseLabels()
        // );

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12))
          ),
          child: new ChooseCategories(this._category)
        );
      }
    ).then((val){
        print(val);
      if(val != null){
        this.setState(() {
          this._category = val;
        });
      }
    });
  }

  void _placeSelect() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12))
          ),
          child: new ChoosePlaces(this._place)
        );
      }
    ).then((val){
        print(val);
      if(val != null){
        this.setState(() {
          this._place = val;
        });
      }
    });
  }


  @override
  void dispose() {
    this._titleEditingController.dispose();

    this._amountEditingController.dispose();

    this._titleFocusNode.dispose();

    super.dispose();
  }

    void _showErrorDialog(String message) {
    showDialog(
      context: context, 
      builder: (ctx) => AlertDialog (
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0))
        ),
        title: Text (
          'Error!', 
          style: const TextStyle(color: Colors.red, fontSize: 28),
          textAlign: TextAlign.center,
        ),
        content: Text (
          message,
          style: const TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          TextButton(
            child: Text ('Okay', style: const TextStyle(color: mainBlue, fontSize: 18, fontWeight: FontWeight.bold)),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      )
    );
  }

  Future <bool> _confirmExit(String description) async {
    // show confirm dialog
    return await showDialog(
      context: context,
      builder: (ctx) => AlertDialog (
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0))
        ),
        title: Text (
          'Are you sure?', 
          style: const TextStyle(color: mainDarkBlue, fontSize: 28),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text (
              description,
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextButton(
                  child: Text ('No', style: const TextStyle(color: mainBlue, fontSize: 18, fontWeight: FontWeight.bold)),
                  onPressed: () {
                    Navigator.of(ctx).pop(false);
                  },
                ),
                TextButton(
                  child: Text ('Okay', style: const TextStyle(color: mainRed, fontSize: 18, fontWeight: FontWeight.bold)),
                  onPressed: () async {
                    Navigator.of(ctx).pop(true);
                  },
                )
              ],
            )
          ],
        ),
      )
    );
  }

  Future <bool> _onWillPop() async {
    bool retval = true;

    if(this._numpad){
      this.setState(() {
        this._numpad = false;
      });
      return false;
    }

    if (this._titleEditingController.text.isNotEmpty || this._amountEditingController.text.isNotEmpty || this._category.isNotEmpty) {
      bool value = false;

      if (this.widget.baseTrans != null) {
        if (this._edit) {
          value = await this._confirmExit('Changes to your current transaction won\'t be saved');
        }

        else {
          value = true;
        }
      }

      else {
        value = await this._confirmExit('This action will delete the current transaction');
      }

      if (value) {
        FocusScope.of(context).requestFocus(FocusNode());
        return retval = true;
      }

      else retval = false;
    }

    // if (retval) {
    //   var transactions = Provider.of<Transaction>(context, listen: false);
    //   transactions.selectedLabels = [];
    // }

    return new Future.value(retval);
  }

  Widget _actions(Transaction trans) {
    return Container(
      color: Colors.white,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // add to favorites / importants
              // IconButton(
              //   icon: Icon(trans.star ? Icons.star : Icons.star_border,),
              //   onPressed: () {
              //     trans.toggleStar();
              //   },
              // ),

              // // select label
              // IconButton(
              //   icon: Icon(Provider.of<Things>(context, listen: false).selectedLabels.length > 0 ? Icons.label : Icons.label_outline),
              //   onPressed: this._labelSelect
              // ),

              // add
              Container(
                decoration: ShapeDecoration(
                  shape: CircleBorder (),
                  color: mainBlue
                ),
                child: IconButton(
                  color: Colors.white,
                  icon: Icon(
                    this.widget.baseTrans != null ? Icons.check : Icons.add,
                  ),
                  onPressed: () async {
                    // FIXME: add transaction

                    // var transactions = Provider.of<Transactions>(context, listen: false);

                    // if (this.widget.baseTrans != null) {
                    //   transactions.updateThing(
                    //     this.widget.baseTrans, 
                    //     this._titleEditingController.text, 
                    //     this._textEditingController.text
                    //   );
                    // }

                    // else {
                    //   await transactions.addThing(
                    //     transactions.categories[transactions.selectedCategoryIdx],
                    //     this._titleEditingController.text, 
                    //     this._textEditingController.text,
                    //     trans.star
                    //   );
                    // }

                    // return to home screen
                    if(this.widget.baseTrans == null){
                      print("New");
                      try{
                        if(this._category != "" &&
                          this._amountEditingController.text != "" && 
                          this._titleEditingController.text != ""
                        ) {
                          await Provider.of<Transactions>(context, listen: false).add(
                            this._titleEditingController.text,
                            double.parse(this._amountEditingController.text.substring(1)),
                            this._selectedDate,
                            this._selectedHour,
                            this._category,
                            Provider.of<Auth>(context,listen: false).token
                          );

                          FocusScope.of(context).requestFocus(FocusNode());
                          Navigator.of(context).pop("add");
                        }
                        
                        else {
                          _showErrorDialog(
                            "Please fill all fields and select a category"
                          );

                        }
                      }catch(error){
                        _showErrorDialog(error.toString());
                      }
                    }else{
                      try {
                        if(this._category != "" && this._amountEditingController.text != "" &&
                          this._titleEditingController.text != ""
                        ){
                          await Provider.of<Transactions>(context,listen:false).update(
                            this.widget.baseTrans.id,
                            this._titleEditingController.text,
                            double.parse(this._amountEditingController.text.substring(1)),
                            this._selectedDate,
                            this._selectedHour,
                            this._category,
                            Provider.of<Auth>(context,listen: false).token,
                            place: this._place
                          );

                          FocusScope.of(context).requestFocus(FocusNode());
                          Navigator.of(context).pop("update");
                        }else {
                          _showErrorDialog("Please fill all fields and select a category");
                        }
                       
                      }catch(error) {
                        _showErrorDialog(error.toString());
                      }
                    }
                    
                  },
                ),
              ),

              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Provider.of<Transaction>(context, listen: false).category != null
                      || this._category != "" ? Icons.label : Icons.label_outline),
                    onPressed: this._categorySelect
                  ),
                  IconButton(
                    icon: Icon(
                      Provider.of<Transaction>(context, listen: false).place != null
                      || this._place != "" ? Icons.location_on : Icons.location_on_outlined),
                    onPressed: this._placeSelect
                  ),
                ], 
              ),

              // delete
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () async {
                  if (this._titleEditingController.text.isNotEmpty) {
                    this._confirmExit('This action will delete the current transaction').then((value) {
                      if (value) {
                        FocusScope.of(context).requestFocus(FocusNode());
                        this._titleEditingController.clear();
                        // this._textEditingController.clear();

                        // var transactions = Provider.of<Things>(context, listen: false);
                        // transactions.selectedLabels = [];

                        if (this.widget.baseTrans != null) {
                          Navigator.pop(context, 'delete');
                        }

                        else {
                          Navigator.pop(context);
                        }
                      }
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _chooseTime() {
    unfocusIfNeeded();
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now()
    ).then((pickedHour) {
      if(pickedHour != null) {
        setState(() {
          this._selectedHour = pickedHour;
        });
      }
    });
  }

  void _chooseDate() {
    unfocusIfNeeded();
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime (2019),
      lastDate: DateTime.now()
    ).then((pickedDate) {
      if (pickedDate != null) {
        setState(() {
          _selectedDate = pickedDate;
        });
      } 
    });
  }

  Widget _body() {
    return Column(
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
              bool value = await this._onWillPop();
              if (value) {
                // var transactions = Provider.of<Things>(context, listen: false);
                // transactions.selectedLabels = [];

                FocusScope.of(context).requestFocus(FocusNode());
                Navigator.pop(context);
              } 
            },
          ),
        ),

        // title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          child: TextField(
            onTap: (){
              this.setState(() {
                this._numpad = false;
              });
            },
            focusNode: this._titleFocusNode,
            textCapitalization: TextCapitalization.sentences,
            controller: this._titleEditingController,
            maxLength: 128,
            maxLines: null,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            style: TextStyle(
              fontSize: 36,
              color: mainDarkBlue,
              fontWeight: FontWeight.bold
            ),
            decoration: InputDecoration(
              hintText: 'Title', border: InputBorder.none
            ),
            onSubmitted: (value) {
              // note.title = value;
            },
            onChanged: (value) {
              if (this.widget.baseTrans != null) {
                // this.setState(() { this._edit = true; });
                this._edit = true;
              }
            },
            onEditingComplete: () {
              if (this.widget.baseTrans != null) {
                // this.setState(() { this._edit = true; });
                this._edit = true;
              }
            },
          ),
        ),
        Consumer<Keyboard>(
          builder: (context,keyboard, snapshot) {
            if(!this._start){
              this._amountEditingController.clear();
              if(keyboard.value != "")
                this._amountEditingController.text = "\$" + keyboard.value;
            }
            

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              child: TextField(
                readOnly: true,
                onTap: () {
                  this.unfocusIfNeeded();

                  this.setState(() {
                    this._numpad = true;
                  });
                },
                showCursor: false,
                textCapitalization: TextCapitalization.sentences,
                controller: this._amountEditingController,
                maxLines: null,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                style: TextStyle(
                  fontSize: 36,
                  color: mainDarkBlue,
                  fontWeight: FontWeight.bold
                ),
                decoration: InputDecoration(
                  hintText: 'Amount', border: InputBorder.none
                ),
              ),
            );
          }
        ),
        Container (
          margin: EdgeInsets.only(top: 24),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          child: Row (
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: Text (
                  _selectedDate == null ? 'No date chosen!'
                  : '${DateFormat.yMMMd().format(_selectedDate)}',
                  style: _selectedDate == null ? hoursPlayedLabelTextStyle : hoursPlayedTextStyle
                ),
              ),
              AdaptiveFlatButton (
                'Choose Date', 
                this._loading ? null : _chooseDate
              )
            ],
          ),
        ),
        Container (
          margin: EdgeInsets.only(top: 24),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          child: Row (
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: Text (
                  _selectedHour == null ? 'No hour chosen!'
                  : '${_selectedHour.format(context)}',
                  style: _selectedHour == null ? hoursPlayedLabelTextStyle : hoursPlayedTextStyle
                ),
              ),
              AdaptiveFlatButton (
                'Choose Hour', 
                this._loading ? null : _chooseTime
              )
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      // DeviceOrientation.portraitDown,
    ]);

    if (this._start) {
      // var transactions = Provider.of<Transactions>(context, listen: false);
      if (this.widget.baseTrans != null) {
        this._titleEditingController.text = this.widget.baseTrans.title;
        this._amountEditingController.text = this.widget.baseTrans.amount.toString();
        this._category = this.widget.baseTrans.category;
        // transactions.selectedLabels = this.widget.baseTrans.labels;
      
        
      }

      // else {
      //   transactions.selectedLabels = [];
      // }

      this._start = false;
    }

    if (this._first) {
      FocusScope.of(context).requestFocus(this._titleFocusNode);
      this.setState(() => this._first = false);
    }

    return GestureDetector(
      onTap: (){
        unfocusIfNeeded();
      },
      child: WillPopScope(
        onWillPop: this._onWillPop,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Consumer <Transaction> (
            builder: (ctx, trans, _) {
              return Stack(
                children: <Widget>[
                  Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: this._body()
                  ),
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 150),
                    bottom: !this._numpad ? MediaQuery.of(context).size.height * -1 : 0,
                    left: 0,
                    child: NumPad(),
                  ),
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 150),
                    curve: Curves.easeIn,
                    bottom: 
                      this._numpad 
                        ?  MediaQuery.of(context).size.height * 0.35
                        : 0,
                    left: 0,
                    right: 0,
                    child: this._actions(trans)
                  )
                ],
              );
            }
          )
        ),
      ),
    );
  }

}