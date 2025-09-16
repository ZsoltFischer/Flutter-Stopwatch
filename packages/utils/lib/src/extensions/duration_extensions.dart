/// Fast digital clock style formatter for [Duration].
///
/// * No control over the format, always "hh:mm:ss.mmm".
/// Hours, minutes, seconds are zero-padded to 2 digits,
/// milliseconds to 3 digits.
///
/// Examples:
/// ```dart
/// Duration.zero.toDigitalClock() // "00:00:00.000"
/// Duration(milliseconds: 1).toDigitalClock() // "00:00:00.001"
/// ```
extension DurationDigitalFormat on Duration {
  /// Fast digital clock style formatter: "hh:mm:ss.mmm" for [Duration].
  String toDigitalClock() {
    final hours = inHours.toString().padLeft(2, '0');
    final minutes = inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = inSeconds.remainder(60).toString().padLeft(2, '0');
    final ms = inMilliseconds.remainder(1000).toString().padLeft(3, '0');

    return '$hours:$minutes:$seconds.$ms';
  }
}
