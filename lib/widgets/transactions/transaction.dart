

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:pocket/models/category.dart';
import 'package:pocket/models/transaction.dart';
import 'package:pocket/providers/categories.dart';
import 'package:pocket/providers/keyboard.dart';
import 'package:pocket/providers/transactions.dart';
import 'package:pocket/screens/trans.dart';
import 'package:pocket/style/colors.dart';
import 'package:provider/provider.dart';

class _CategoryItem extends StatelessWidget {
  final Category category;

  _CategoryItem ( this.category);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(right: 4, bottom: 4),
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: category.color,
            borderRadius: BorderRadius.circular(6)
          ),
        ),

        Text(category.title, style:TextStyle(fontSize: 14, color: accountFirstColor)),
      ],
    );
  }
}

class TransactionItem extends StatefulWidget {
  @override
  _TransactionItemState createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {

  final DateFormat _dateFormatter = DateFormat('HH:mm - dd MMM');

  void _reviewTransaction(Transaction transaction) {
    showModalBottomSheet<dynamic>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext bc) {
        return ChangeNotifierProvider.value(
          value: transaction,
          child: new ReviewTransaction (),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer <Transaction> (
      builder: (ctx, transaction, _){ 
        return Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            GestureDetector(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16.0),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFFEFF4F6),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          transaction.title,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.start,
                        ),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "\$" + transaction.amount.abs().toString(),
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Icon(
                              transaction.amount >= 0 
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down, 
                              color:transaction.amount >= 0 ? Colors.green : Colors.red
                            ),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: 12.0),

                    SizedBox(height: 16.0),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * 0.46,
                          child: new _CategoryItem(
                            Provider.of<Categories>(context,listen:false).getById(transaction.category)
                          )
                          
                        ),

                        // date
                        Container(
                          width: MediaQuery.of(context).size.width * 0.36,
                          child: Text(
                            _dateFormatter.format(transaction.date),
                            style: TextStyle(
                              color: Color(0xFFAFB4C6),
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              onTap: () => _reviewTransaction(transaction),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01)
          ],
        );
      },
    );
  }
}

class ReviewTransaction extends StatefulWidget {
  @override
  _ReviewTransactionState createState() => _ReviewTransactionState();
}

class _ReviewTransactionState extends State<ReviewTransaction> {

  final DateFormat _dateFormatter = DateFormat("HH:mm - dd MMM");

  void _confirmDelete(Transaction transaction) {
    showDialog(
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
              'Do you want to delete this transaction?',
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                FlatButton(
                  child: Text ('No', style: const TextStyle(color: mainBlue, fontSize: 18, fontWeight: FontWeight.bold)),
                  onPressed: () {
                    Navigator.of(ctx).pop(false);
                  },
                ),
                FlatButton(
                  child: Text ('Okay', style: const TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold)),
                  onPressed: () async {
                    Navigator.of(ctx).pop(true);
                  },
                )
              ],
            )
          ],
        ),
      )
    ).then((value) {
      if (value) {
        Navigator.of(context).pop('delete');
      }
    });
  }
  
  Widget _deleteButton(Transaction transaction) {
    return new Container(
      decoration: ShapeDecoration(
        shape: CircleBorder (),
        color: deleteColor
      ),
      child: IconButton(
        color: Colors.white,
        icon: Icon(
          Icons.delete,
        ),
        onPressed: () {
          this._confirmDelete(transaction);
        },
      ),
    );
  }

  Widget _editButton(Transaction transaction) {
    return new Container(
      decoration: ShapeDecoration(
        shape: CircleBorder (),
        color: mainBlue
      ),
      child: IconButton(
        color: Colors.white,
        icon: Icon(
          Icons.edit,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) {
                try{

                Provider.of<Keyboard>(context,listen:false).setValue(transaction.amount.toString(), discrete: true);
                }catch(error){
                  print("hola");
                }

                return ChangeNotifierProvider.value(
                  value: transaction,
                  child: new TransScreen (transaction)
                );
              }
            ),
          ).then((value) {
            if (value != null) {
              if (value == 'delete') {
                Navigator.of(context).pop('delete');
              }
            }
          });
        },
      ),
    );
  }

  Widget _buttonRow(Transaction transaction){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        _deleteButton(transaction),
        _editButton(transaction),
      ],
    );
  }

  
  @override
  Widget build(BuildContext context) {
    return Consumer <Transaction> (
      builder: (ctx, transaction, _) {
        return Wrap(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                // height: 300.0,
                decoration: BoxDecoration(
                  // color: Colors.white,
                  color: Color(0xFFEFF4F6),
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Container (
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // title
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            transaction.title,
                            style: TextStyle(
                              // color: Colors.black,
                              color: Color(0xFF2F3446),
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.start,
                          ),

                        ],
                      ),

                     
                      Column (
                        children: <Widget>[
                          SizedBox(height: 12.0),

                          // description
                          Text(
                            "\$" + transaction.amount.toString(),
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 24.0),

                      // labels
                      Container(
                        width: MediaQuery.of(context).size.width * 0.64,
                        child: _CategoryItem(
                          Provider.of<Categories>(context,listen:false).getById(
                            transaction.category
                          )
                        )
                      ),

                      SizedBox(height: 16.0),

                      // date
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            _dateFormatter.format(transaction.date),
                            style: TextStyle(
                              color: Color(0xFFAFB4C6),
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),

                      // buttons
                      SizedBox(height: 24.0),

                      _buttonRow(transaction)
                    ],
                  ),
                )
              ),
            ),
          ],
        );
      }
    );
  }
}