import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pocket/providers/keyboard.dart';

import 'package:provider/provider.dart';
import 'package:pocket/providers/ui.dart';
import 'package:pocket/providers/auth.dart';
import 'package:pocket/providers/categories.dart';
import 'package:pocket/providers/transactions.dart';
import 'package:pocket/providers/settings.dart';

import 'package:pocket/screens/trans.dart';

import 'package:pocket/models/transaction.dart';

import 'package:pocket/widgets/transactions/list.dart';
// import 'package:pocket/widgets/transactions/add.dart';

import 'package:pocket/style/colors.dart';
import 'package:pocket/style/style.dart';

import '../pages/home/charts/bars.dart';
import '../pages/home/charts/expenses.dart';
import '../pages/home/charts/history.dart';
import '../providers/categories.dart';

class HomeScreen extends StatefulWidget {

	@override
	_HomeScreenState createState () => _HomeScreenState ();

}

class _HomeScreenState extends State <HomeScreen> {

  bool _loading = false;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) {
      this._fetchData();
    });

    super.initState();
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
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text (
              message,
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                FlatButton(
                  child: Text (
                    'Okay',
                    style: const TextStyle(
                      color: mainRed,
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    )
                  ),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                )
              ],
            )
          ],
        )
      )
    );
  }

  Future <void> _fetchData() async {
    try {
      setState(() {
        this._loading = true;
      });

      var token = Provider.of<Auth>(context, listen: false).token;
      await Provider.of<Categories>(context, listen: false).fetch(token);
      await Provider.of<Transactions>(context, listen: false).fetch(token);
    }

    catch (error) {
      _showErrorDialog('Failed to fetch transactions info!');
    }
    
    finally {
      this.setState(() {
        this._loading = false;
      });
    }
  }

  Widget _body() {
    return Consumer <Settings> (
      builder: (ctx, settings, _) {
        return Column (
          children: [
            settings.showBarsChart ? 
              new Container (
                height: (MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top) * 0.2,
                child: BarsChart (Provider.of<Transactions>(context, listen: true).recentTransactions)) :
              new Container(),

            Provider.of<Categories>(context, listen: true).categories.length > 0 ? 
              settings.showExpensesChart ? 
              new ExpensesChart () : new Container() : 
              new Container(),
            settings.showHistoryChart ? new HistoryChart () : new Container(),

            // stats
            Text("Transactions",textAlign: TextAlign.start, style:TextStyle(fontSize: 28, color: accountFirstColorDark,  fontWeight: FontWeight.bold)),
            Container(
              padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  
                  Text(
                    "Total: ",
                    style: hoursPlayedLabelTextStyle,
                  ),
                  Text(
                    "\$${Provider.of<Transactions>(context, listen: true).getTotal.toStringAsFixed (2)}",
                    style: hoursPlayedTextStyle,
                  ),
                  Text(
                    "from",
                    style: hoursPlayedLabelTextStyle,
                  ),
                  Text(
                    "${Provider.of<Transactions>(context, listen: true).transactions.length}",
                    style: hoursPlayedTextStyle,
                  ),
                  Text(
                    "transactions",
                    style: hoursPlayedLabelTextStyle,
                  ),
                ],
              ),
            ),

            new TransactionList ()
          ],
        );
      }
    );
  }

  Widget _content() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: ListView(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),

          Consumer <UI> (
            builder: (ctx, ui, _) => Row (
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ui.isDrawerOpen ? IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    // setState(() {
                    //   xOffset = 0;
                    //   yOffset = 0;
                    //   scaleFactor = 1;
                    //   isDrawerOpen = false;
                    // });
                  },
                )

                :

                IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () {
                    if (!ui.isDrawerOpen) {
                      ui.openDrawer();
                    }
                  }
                ),
              ],
            ),
          ),

          this._body(),

          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
        ],
      ),
    );
  }

	@override
	Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      // DeviceOrientation.portraitDown,
    ]);

    return Stack (
      children: [
        this._loading ? Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Center(child: new CircularProgressIndicator(
            backgroundColor: Colors.white,
            valueColor: new AlwaysStoppedAnimation <Color> (mainBlue),
          ))
        ) : this._content (),

        Positioned(
          bottom: MediaQuery.of(context).size.width * 0.1,
          left: MediaQuery.of(context).size.width * 0.83,
          child: Container(
            decoration: ShapeDecoration(
              shape: CircleBorder (),
              color: mainBlue
            ),
            child: IconButton(
              hoverColor: Colors.transparent,
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              highlightColor: Colors.transparent,
              color: Colors.white,
              icon: Icon(Icons.add),
              onPressed: () {
                Provider.of<Keyboard>(context,listen: false).setValue("", discrete: true);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) {
                      return ChangeNotifierProvider.value(
                        value: new Transaction(id: null, title: null, amount: 0, date: null, category: null),
                        child: new TransScreen (null)
                      );
                    }
                  ),
                ).then((_){
                  await this._fetchData();
                });
              },
              iconSize: 42
            )
          ),
        ),
      ],
    );

	}

}