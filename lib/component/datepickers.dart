import 'package:flutter/material.dart';

Future<DateTime?> selectDate(
    {required BuildContext context, DateTime? date}) async {
  date = date;
  final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: date ?? DateTime.now(),
      firstDate: DateTime.parse('2000-01-01'),
      lastDate: DateTime.now());
  if (picked != null && picked != date) {
    return picked;
  }
  return date;
}

Future<DateTimeRange> selectDateRange(
    {required BuildContext context, DateTimeRange? date}) async {
  date = date ?? DateTimeRange(start: DateTime.now(), end: DateTime.now());
  final DateTimeRange? picked = await showDateRangePicker(
      initialEntryMode: DatePickerEntryMode.input,
      context: context,
      initialDateRange:
          DateTimeRange(start: DateTime.now(), end: DateTime.now()),
      firstDate: DateTime.parse('2000-01-01'),
      lastDate: DateTime.now());
  if (picked != null) {
    return picked;
  }
  return date;
}
