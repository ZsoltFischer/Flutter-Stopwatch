import 'package:bloc/bloc.dart';

/// Process events one at a time by maintaining a queue of added events
/// and processing the events sequentially.
///
/// **Note**: there is no event handler overlap and every event is guaranteed
/// to be handled in the order it was received.
///
///! This file is copied from the official bloc_concurrency
///! package to avoid adding an extra dependency. See: https://pub.dev/packages/bloc_concurrency
///
///! If the package is added as a dependency in the future, this file can be
///! removed but such small functionality does not justify a new dependency
EventTransformer<Event> sequential<Event>() {
  return (events, mapper) => events.asyncExpand(mapper);
}
