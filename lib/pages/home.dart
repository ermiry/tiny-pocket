import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:fl_chart/fl_chart.dart';

import 'package:pocket/sidebar/navigation_bloc.dart';
import 'package:pocket/style/colors.dart';

import 'package:pocket/widgets/transactions/list.dart';
import 'package:pocket/widgets/transactions/add.dart';
import 'package:pocket/widgets/chart/chart.dart';

import 'package:pocket/models/transaction.dart';

class HomePage extends StatefulWidget with NavigationStates {

	@override
	_HomePageState createState () => _HomePageState ();

}

class _HomePageState extends State <HomePage> {

	final List <Transaction> _transactions = [
		// Transaction (id: 't1', title: 'New Shoes', amount: 69.99, date: DateTime.now ()),
		// Transaction (id: 't2', title: 'Weekly Groceries', amount: 20.99, date: DateTime.now ())
	];

  bool _showChart = true;

  List <Transaction> get _recentTransactions {
    return _transactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(Duration (days: 7)));
    }).toList();
  }

	void _addTransaction (String title, double amount, DateTime date) {

		final newTx = Transaction (title: title, amount: amount, 
			date: date, id: DateTime.now().toString());

		setState(() {
			_transactions.add(newTx);
		});

	}

  void _deleteTransaction (String id) {

    setState(() {
      _transactions.removeWhere((tx) => tx.id == id);
    });

  }

	@override
	Widget build(BuildContext context) {

    final mediaQuery = MediaQuery.of(context);

    // final PreferredSizeWidget appBar = Platform.isAndroid ? AppBar (
		// 		title: Text (
    //       'Tiny Pocket',
    //       // style: TextStyle (fontFamily: 'Open Sans'),
    //       ),
		// 		actions: <Widget>[
		// 			IconButton (
		// 				icon: Icon (Icons.add),
		// 				onPressed: () {
		// 					showModalBottomSheet (
		// 						context: context, 
		// 						builder: (bCtx) { return AddTransaction (_addTransaction); }
		// 					);
		// 				},
		// 			)
		// 		],
		// 	)
    //   : CupertinoNavigationBar (
    //     middle: Text ('Tiny Pocket'),
    //     trailing: Row (
    //       mainAxisSize: MainAxisSize.min,
    //       children: <Widget>[
    //       GestureDetector (
    //         child: Icon (CupertinoIcons.add),
    //         onTap: () {
    //           showModalBottomSheet (
		// 						context: context, 
		// 						builder: (bCtx) { return AddTransaction (_addTransaction); }
		// 					);
    //         },
    //       )
    //     ]),
    //   );

    final appBody = Container (
      color: Colors.white,
      child: ListView (
				children: <Widget>[
          // Row (
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: <Widget>[
          //   Text ('Show chart'),
          //   Switch.adaptive (
          //     // activeColor: Theme.of(context).accentColor,
          //     value: _showChart,
          //     onChanged: (val) { 
          //       setState(() {
          //         _showChart = val;
          //       });
          //     },)
          // ],),

          // day chart
          _showChart ? Container (
            height: (mediaQuery.size.height - 
              // appBar.preferredSize.height -
              mediaQuery.padding.top) * 0.3,
            child: Chart (_recentTransactions),
          ) : Container (),

          new ExpensesChart (),

          Container (
            height: (mediaQuery.size.height -
              // appBar.preferredSize.height -
              mediaQuery.padding.top) * 0.7,
            child: TransactionList (_transactions, _deleteTransaction),
            // Expanded (child: TransactionList (_transactions, _deleteTransaction))
          )
        ]
			)
    );

		return (Platform.isAndroid ? Scaffold (
      backgroundColor: mainBlue,
			// appBar: appBar,
			body: appBody,

			floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
			floatingActionButton: Platform.isIOS ? Container () : FloatingActionButton (
        backgroundColor: mainBlue,
				child: Icon (Icons.add),
				onPressed: () {
					showModalBottomSheet (
						context: context, 
						builder: (bCtx) { return AddTransaction (_addTransaction); }
					);
				},
			),
		) :
    CupertinoPageScaffold (
      // navigationBar: appBar,
      child: appBody,
    )
		);

	}

}

class Indicator extends StatelessWidget {

  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;

  const Indicator({
    Key key,
    this.color,
    this.text,
    this.isSquare,
    this.size = 16,
    this.textColor = const Color(0xff505050),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),

        const SizedBox(width: 4),

        Text(
          text,
          style: new TextStyle(
            fontSize: 16, 
            fontWeight: FontWeight.bold, 
            color: textColor
          ),
        )
      ],
    );
  }

}

class ExpensesChart extends StatefulWidget {

  @override
  State <StatefulWidget> createState() => new _ExpensesChartState ();

}

class _ExpensesChartState extends State <ExpensesChart> {

  int touchedIndex;

  List <PieChartSectionData> showingSections() {
    return List.generate(4, (i) {
      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 25 : 16;
      final double radius = isTouched ? 60 : 50;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color(0xff0293ee),
            value: 40,
            title: '40%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xfff8b250),
            value: 30,
            title: '30%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
          );
        case 2:
          return PieChartSectionData(
            color: const Color(0xff845bef),
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
          );
        case 3:
          return PieChartSectionData(
            color: const Color(0xff13d38e),
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
          );
        default:
          return null;
      }
    });
  }

  @override
  Widget build(BuildContext context){
    return AspectRatio(
      aspectRatio: 1.3,
      child: Container(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        child: new Material (
          elevation: 4,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          child: Container (
            // padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 32),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                // const SizedBox(height: 10),

                Expanded(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: PieChart(
                      PieChartData(
                        pieTouchData: PieTouchData(touchCallback: (pieTouchResponse) {
                          setState(() {
                            if (pieTouchResponse.touchInput is FlLongPressEnd ||
                                pieTouchResponse.touchInput is FlPanEnd) {
                              touchedIndex = -1;
                            } else {
                              touchedIndex = pieTouchResponse.touchedSectionIndex;
                            }
                          });
                        }),
                        borderData: FlBorderData(
                          show: false,
                        ),
                        sectionsSpace: 0,
                        centerSpaceRadius: 40,
                        sections: showingSections())
                    ),
                  ),
                ),

                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const <Widget>[
                    const Indicator(
                      color: const Color(0xff0293ee),
                      text: 'Food',
                      isSquare: true,
                    ),
                    const SizedBox(height: 4),
                    const Indicator(
                      color: const Color(0xfff8b250),
                      text: 'Transportation',
                      isSquare: true,
                    ),
                    const SizedBox(height: 4),
                    const Indicator(
                      color: const Color(0xff845bef),
                      text: 'Work',
                      isSquare: true,
                    ),
                    const SizedBox(height: 4),
                    const Indicator(
                      color: const Color(0xff13d38e),
                      text: 'Fun',
                      isSquare: true,
                    ),

                    const SizedBox(height: 18),
                  ],
                ),

                const SizedBox(width: 20),
              ],
            ),
          ),
        )
      ),
    );
  }

}

class HistoryChart extends StatefulWidget {

  @override
  _HistoryChartState createState() => new _HistoryChartState ();

}

class _HistoryChartState extends State <HistoryChart> {

  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.70,
      child: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        // decoration: BoxDecoration(
        //   borderRadius: const BorderRadius.all(const Radius.circular(18)),
        //   color: const Color(0xff232d37)
        // ),
        child: new Material(
          elevation: 4,
          borderRadius: const BorderRadius.all(const Radius.circular(18)),
          child: Container(
            padding: const EdgeInsets.only(
                right: 18.0, left: 12.0, top: 24, bottom: 12),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(const Radius.circular(18)),
              color: const Color(0xff232d37)
            ),
            child: LineChart(mainData()),
          ),
        ),
      ),
    );
  }

  LineChartData mainData() {
    return LineChartData(
      axisTitleData: new FlAxisTitleData(
        topTitle: new AxisTitle(
          showTitle: true, 
          titleText: "Last week's activity", 
          margin: 10, 
          textStyle: const TextStyle(
            color: Colors.white,
            // fontWeight: FontWeight.bold,
            fontSize: 16
          ),
        )
      ),

      gridData: FlGridData(
        // show: true,
        drawHorizontalLine: false,
        drawVerticalLine: false,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),

      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          textStyle: const TextStyle(
            color: const Color(0xff68737d),
            fontWeight: FontWeight.bold,
            fontSize: 16
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 0: return 'M';
              case 1: return 'T';
              case 2: return 'W';
              case 3: return 'T';
              case 4: return 'F';
              case 5: return 'S';
              case 6: return 'S';
            }
            return '';
          },
          margin: 8,
        ),

        leftTitles: SideTitles(
          showTitles: true,
          textStyle: TextStyle(
            color: const Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 20:
                return '20';
              case 40:
                return '40';
              case 60:
                return '60';
            }
            return '';
          },
          reservedSize: 28,
          margin: 12,
        ),
      ),

      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d), width: 1)
      ),

      minX: 0,
      maxX: 6,
      minY: 0,
      maxY: 70,

      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 30),
            FlSpot(1, 20),
            FlSpot(2, 50),
            FlSpot(3, 32),
            FlSpot(4, 42),
            FlSpot(5, 31),
            FlSpot(6, 39),
          ],
          isCurved: true,
          colors: gradientColors,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }

}