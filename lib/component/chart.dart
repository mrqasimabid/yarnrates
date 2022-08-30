import 'package:charts_flutter/flutter.dart' as charts;

/// Sample time series data type.
class TimeSeriesSales {
  final DateTime time;
  final int sales;

  TimeSeriesSales(this.time, this.sales);
}

List<charts.Series<TimeSeriesSales, DateTime>> createSampleData(rates) {
  List<dynamic> rate = rates;
  List<TimeSeriesSales> data = [];
  for (var element in rate) {
    data.add(
      TimeSeriesSales(DateTime.parse(element['dated']), element['rate_lbs']),
    );
  }

  return [
    charts.Series<TimeSeriesSales, DateTime>(
      id: 'Prices',
      domainFn: (TimeSeriesSales sales, _) => sales.time,
      measureFn: (TimeSeriesSales sales, _) => sales.sales,
      data: data,
    )
  ];
}
