import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:provider/provider.dart';
import 'package:pocket/providers/transactions.dart';

import 'package:fl_chart/fl_chart.dart';

import '../../../models/category.dart';
import '../../../providers/categories.dart';


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
    List<PieChartSectionData> sections = [];

    for (Category category in Provider.of<Categories>(context, listen: true).categories) {
      Category transType = category;

      double value = Provider.of<Transactions>(context,listen:true).getPercentageByCategory(
        category
      );
      if(value != 0) {
        sections.add(PieChartSectionData(
            color: transType.color,
            value: value,
            title: value >= 100 ? '100%' : '${value.toStringAsFixed (2)}%',
            radius: 50,
            titleStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
        ));
      }
    }

    return sections;
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
            padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 32),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 10),
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: PieChart(
                      PieChartData(
                        borderData: FlBorderData(
                          show: false,
                        ),
                        sectionsSpace: 0,
                        centerSpaceRadius: 40,
                        sections: showingSections()
                      )
                    ),
                  ),
                ),

                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: categories()
                ),

                const SizedBox(width: 20),
              ],
            ),
          ),
        )
      ),
    );
  }

  List<Widget> categories(){
    List<Widget> widgets = [];

    Provider.of<Categories>(context,listen:false).categories.forEach((cat) {
      widgets.add( Indicator(
        color: cat.color,
        text: cat.title,
        isSquare: true,
      ));
      widgets.add(SizedBox(height: 4,));
    });
    widgets.add(SizedBox(height:18));

    return widgets;
  }

}