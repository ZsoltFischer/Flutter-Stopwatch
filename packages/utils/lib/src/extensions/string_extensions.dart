/// Returns the hardcoded string itself.
///
/// This extension should be used as a shorthand for quick development
/// in projects where localisation is not an immediate priority.
///
/// The shorthand provides easy search access to all not-yet localised
/// strings in the repo that
///
/// * Important: This extension should only be used temporarily
/// * because it disables constant instances of [String]s.
/// * All widgets that use it can not be declared as `const`.
/// * Remove all usages of this extension before releasing the app!
extension HardCodedStrings on String {
  /// Returns the hardcoded string itself.
  String get hardcoded => this;
}
