/// Fast digital clock style formatter for [Duration].
extension DurationDigitalFormat on Duration {
  /// Fast digital clock style formatter: "hh:mm:ss.mmm" for [Duration].
  String toDigital() {
    final hours = inHours.toString().padLeft(2, '0');
    final minutes = inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = inSeconds.remainder(60).toString().padLeft(2, '0');
    final ms = inMilliseconds.remainder(1000).toString().padLeft(3, '0');

    return '$hours:$minutes:$seconds.$ms';
  }
}
