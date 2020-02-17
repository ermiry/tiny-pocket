import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:provider/provider.dart';
import 'package:pocket/providers/transactions.dart';

import 'package:fl_chart/fl_chart.dart';

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
    return List.generate(Provider.of<Transactions>(context, listen: true).transTypes.length, (i) {
      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 25 : 16;
      final double radius = isTouched ? 60 : 50;
      
      TransactionType transType = Provider.of<Transactions>(context, listen: true).transTypes.elementAt(i);
      double value = Provider.of<Transactions>(context, listen: true).getTransTypePercentage(transType.type);

      return PieChartSectionData(
        color: transType.color,
        value: value,
        title: '${value.toStringAsFixed (2)}%',
        radius: radius,
        titleStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
      );
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