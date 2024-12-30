class CalculationUtils {
  static double fixPrecision(double value, int precision) {
    return double.parse(value.toStringAsFixed(precision));
  }
}