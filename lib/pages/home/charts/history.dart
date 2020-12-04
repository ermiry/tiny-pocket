// import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';

// import 'package:fl_chart/fl_chart.dart';

// class HistoryChart extends StatefulWidget {

//   @override
//   _HistoryChartState createState() => new _HistoryChartState ();

// }

// class _HistoryChartState extends State <HistoryChart> {

//   List<Color> gradientColors = [
//     const Color(0xff23b6e6),
//     const Color(0xff02d39a),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return AspectRatio(
//       aspectRatio: 1.70,
//       child: Container(
//         padding: const EdgeInsets.only(left: 20, right: 20),
//         // decoration: BoxDecoration(
//         //   borderRadius: const BorderRadius.all(const Radius.circular(18)),
//         //   color: const Color(0xff232d37)
//         // ),
//         child: new Material(
//           elevation: 4,
//           borderRadius: const BorderRadius.all(const Radius.circular(18)),
//           child: Container(
//             padding: const EdgeInsets.only(
//                 right: 18.0, left: 12.0, top: 24, bottom: 12),
//             decoration: BoxDecoration(
//               borderRadius: const BorderRadius.all(const Radius.circular(18)),
//               color: const Color(0xff232d37)
//             ),
//             child: LineChart(mainData()),
//           ),
//         ),
//       ),
//     );
//   }

//   LineChartData mainData() {
//     return LineChartData(
//       axisTitleData: new FlAxisTitleData(
//         topTitle: new AxisTitle(
//           showTitle: true, 
//           titleText: "Last week's activity", 
//           margin: 10, 
//           textStyle: const TextStyle(
//             color: Colors.white,
//             // fontWeight: FontWeight.bold,
//             fontSize: 16
//           ),
//         )
//       ),

//       gridData: FlGridData(
//         // show: true,
//         drawHorizontalLine: false,
//         drawVerticalLine: false,
//         getDrawingHorizontalLine: (value) {
//           return const FlLine(
//             color: Color(0xff37434d),
//             strokeWidth: 1,
//           );
//         },
//         getDrawingVerticalLine: (value) {
//           return const FlLine(
//             color: Color(0xff37434d),
//             strokeWidth: 1,
//           );
//         },
//       ),

//       titlesData: FlTitlesData(
//         show: true,
//         bottomTitles: SideTitles(
//           showTitles: true,
//           reservedSize: 22,
//           textStyle: const TextStyle(
//             color: const Color(0xff68737d),
//             fontWeight: FontWeight.bold,
//             fontSize: 16
//           ),
//           getTitles: (value) {
//             switch (value.toInt()) {
//               case 0: return 'M';
//               case 1: return 'T';
//               case 2: return 'W';
//               case 3: return 'T';
//               case 4: return 'F';
//               case 5: return 'S';
//               case 6: return 'S';
//             }
//             return '';
//           },
//           margin: 8,
//         ),

//         leftTitles: SideTitles(
//           showTitles: true,
//           textStyle: TextStyle(
//             color: const Color(0xff67727d),
//             fontWeight: FontWeight.bold,
//             fontSize: 15,
//           ),
//           getTitles: (value) {
//             switch (value.toInt()) {
//               case 20:
//                 return '20';
//               case 40:
//                 return '40';
//               case 60:
//                 return '60';
//             }
//             return '';
//           },
//           reservedSize: 28,
//           margin: 12,
//         ),
//       ),

//       borderData: FlBorderData(
//         show: true,
//         border: Border.all(color: const Color(0xff37434d), width: 1)
//       ),

//       minX: 0,
//       maxX: 6,
//       minY: 0,
//       maxY: 70,

//       lineBarsData: [
//         LineChartBarData(
//           spots: const [
//             FlSpot(0, 30),
//             FlSpot(1, 20),
//             FlSpot(2, 50),
//             FlSpot(3, 32),
//             FlSpot(4, 42),
//             FlSpot(5, 31),
//             FlSpot(6, 39),
//           ],
//           isCurved: true,
//           colors: gradientColors,
//           barWidth: 5,
//           isStrokeCapRound: true,
//           dotData: const FlDotData(
//             show: false,
//           ),
//           belowBarData: BarAreaData(
//             show: true,
//             colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(),
//           ),
//         ),
//       ],
//     );
//   }

// }