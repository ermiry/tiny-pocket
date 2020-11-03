import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:pocket/providers/ui.dart';
import 'package:pocket/providers/transactions.dart';
import 'package:pocket/providers/settings.dart';

import 'package:pocket/widgets/transactions/list.dart';
import 'package:pocket/widgets/transactions/add.dart';

import 'package:pocket/style/colors.dart';
import 'package:pocket/style/style.dart';

class HomeScreen extends StatefulWidget {

	@override
	_HomeScreenState createState () => _HomeScreenState ();

}

class _HomeScreenState extends State <HomeScreen> {

	@override
	Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      // DeviceOrientation.portraitDown,
    ]);

    final mediaQuery = MediaQuery.of(context);

    return Consumer <Settings> (
      builder: (ctx, settings, _) {
        return Stack (
          children: [
            Container(
              width: mediaQuery.size.width,
              height: mediaQuery.size.height,
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

                  // settings.showBarsChart ? 
                  //   new Container (
                  //     height: (mediaQuery.size.height - mediaQuery.padding.top) * 0.2,
                  //     child: BarsChart (Provider.of<Transactions>(context, listen: true).recentTransactions)) :
                  //   new Container(),

                  // Provider.of<Transactions>(context, listen: true).usedTransTypes.length > 0 ? 
                  //   settings.showExpensesChart ? 
                  //   new ExpensesChart () : new Container() : 
                  //   new Container(),

                  // settings.showHistoryChart ? new HistoryChart () : new Container(),

                  // stats
                  Container(
                    // height: (mediaQuery.size.height - mediaQuery.padding.top) * 0.12,
                    padding: EdgeInsets.only(left: 16, right: 16, top: 16),
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

                  new TransactionList (),

                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                ],
              ),
            ),

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
                    showModalBottomSheet(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      context: context, 
                      builder: (bCtx) => new AddTransaction ()
                    );
                  },
                  iconSize: 42
                )
              ),
            ),
          ],
        );
      }
    );

    // return Scaffold (
    //   backgroundColor: Colors.white,
		// 	body: body,

		// 	floatingActionButtonLocation: Provider.of<Settings>(context, listen: false).centerAddButton ? 
    //     FloatingActionButtonLocation.centerFloat : FloatingActionButtonLocation.endFloat,
		// 	floatingActionButton: FloatingActionButton (
    //     backgroundColor: mainBlue,
		// 		child: Icon (Icons.add),
		// 		onPressed: () {
    //       showModalBottomSheet(
    //         shape: RoundedRectangleBorder(
    //           borderRadius: BorderRadius.circular(20.0),
    //         ),
    //         context: context, 
    //         builder: (bCtx) => new AddTransaction ()
    //       );
		// 		},
		// 	),
		// );

	}

}