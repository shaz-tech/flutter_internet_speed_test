import 'package:flutter_internet_speed_test/callbacks_enum.dart';

class TestResult {
  final TestType type;
  final double transferRate;
  final SpeedUnit unit;

  TestResult(this.type, this.transferRate, this.unit);
}
