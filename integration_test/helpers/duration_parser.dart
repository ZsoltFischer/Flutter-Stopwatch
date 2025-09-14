/// Helper to parse duration strings in the format "HH:MM:SS.mmm"
/// e.g. "00:01:23.456" -> Duration of 1 minute, 23 seconds, and 456 milliseconds.
Duration parseDuration(String text) {
  // Assumes format: HH:MM:SS.mmm
  final regex = RegExp(r'^(\d{2}):(\d{2}):(\d{2})\.(\d{3})$');
  final match = regex.firstMatch(text);
  if (match == null) return Duration.zero;
  final hours = int.parse(match.group(1)!);
  final minutes = int.parse(match.group(2)!);
  final seconds = int.parse(match.group(3)!);
  final milliseconds = int.parse(match.group(4)!);
  return Duration(
    hours: hours,
    minutes: minutes,
    seconds: seconds,
    milliseconds: milliseconds,
  );
}
