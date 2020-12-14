import 'package:flutter/material.dart';
import 'package:pocket/providers/keyboard.dart';
import 'package:pocket/style/colors.dart';
import 'package:provider/provider.dart';

class NumPad extends StatefulWidget {
  @override
  _NumPadState createState() => _NumPadState();
}

class _NumPadState extends State<NumPad> {
  String value = "";

  @override
  void initState() { 
    super.initState();
    this.setState(() {
      
      value = Provider.of<Keyboard>(context,listen: false).value;
    });
  }


  Widget _num(String text, double height) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        setState(() {
          this.value += text;
          
        });
        Provider.of<Keyboard>(context,listen:false).setValue(value);

      },
      child: Container(
        height: height,
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 40,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.35,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Row(
            children: [
              InkWell(
                child: Container(
                  width: MediaQuery.of(context).size.width*0.5,
                  height: MediaQuery.of(context).size.height * 0.05,
                  color: mainBlue,
                  child: Center(
                    child: Text("Income", style:TextStyle(color: Colors.white, fontSize: 14)),
                  ),
                ),
                onTap: (){
                  if(this.value[0] == "-"){
                    this.setState(() {
                      this.value = this.value.substring(1);
                    });

                    Provider.of<Keyboard>(context,listen:false).setValue(this.value);
                  }
                  
                },
              ),
              InkWell(
                child: Container(
                  width: MediaQuery.of(context).size.width*0.5,
                  height: MediaQuery.of(context).size.height * 0.05,
                  color: mainRed,
                  child: Center(
                    child: Text("Expense", style:TextStyle(color: Colors.white, fontSize: 14)),
                  ),
                ),
                onTap: () {
                  if(this.value[0] != "-"){
                    this.setState(() {
                      this.value = "-" + this.value;
                    });

                    Provider.of<Keyboard>(context,listen:false).setValue(this.value);

                  }
                },
              ),
            ],
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                var height = constraints.biggest.height / 4;

                return Table(
                  border: TableBorder.all(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                  children: [
                    TableRow(children: [
                      _num("1", height),
                      _num("2", height),
                      _num("3", height),
                    ]),
                    TableRow(children: [
                      _num("4", height),
                      _num("5", height),
                      _num("6", height),
                    ]),
                    TableRow(children: [
                      _num("7", height),
                      _num("8", height),
                      _num("9", height),
                    ]),
                    TableRow(children: [
                      _num(".", height),
                      _num("0", height),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            value= value.substring(0, value.length-1);
                          });
                          Provider.of<Keyboard>(context,listen:false).setValue(value);
                        },
                        child: Container(
                          height: height,
                          child: Center(
                            child: Icon(
                              Icons.backspace,
                              color: Colors.grey,
                              size: 40,
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ],
                );
              }
            ),
          ),
        ],
      ),
    );
  }
}