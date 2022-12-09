import 'package:flutter_internet_speed_test/src/callbacks_enum.dart';

class TestResult {
  final TestType type;
  final double transferRate;
  final SpeedUnit unit;
  final int durationInMillis; //Duration to complete

  TestResult(this.type, this.transferRate, this.unit,
      {int durationInMillis = 0})
      : durationInMillis = durationInMillis - (durationInMillis % 1000);
}
