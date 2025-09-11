import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sliver_tools/sliver_tools.dart';

/// A section with a pinned header
class SliverPinnedHeaderSection extends StatelessWidget {
  /// Creates a new [SliverPinnedHeaderSection].
  const SliverPinnedHeaderSection._({
    required this.title,
    required this.delegate,
    this.childrenCount,
    this.children,
    this.itemBuilder,
    super.key,
  });

  /// Use this constructor if the children list is short and the performance
  /// loss from passing pre-build widgets as a list is negligible
  ///
  /// Example:
  /// ```dart
  /// SliverPinnedHeaderSection.fromChildren(
  ///   title: 'Favorites',
  ///   children: const [
  ///     ListTile(title: Text('Apple')),
  ///     ListTile(title: Text('Banana')),
  ///   ],
  /// );
  /// ```

  factory SliverPinnedHeaderSection.fixed({
    required String title,
    required List<Widget> children,
    Key? key,
  }) => SliverPinnedHeaderSection._(
    key: key,
    title: title,
    delegate: SliverChildBuilderDelegate(
      (context, index) => children[index],
      childCount: children.length,
    ),
    children: children,
  );

  /// Use this constructor if the children list is long and the performance
  /// gains from dynamic item building is important
  ///
  /// Example:
  /// ```dart
  /// SliverPinnedHeaderSection.fromBuilder(
  ///  title: 'Contacts',
  ///  childrenCount: 1000,
  ///  itemBuilder: (context, index) => ListTile(title: Text('Number $index'))
  /// );
  /// ```
  factory SliverPinnedHeaderSection.builder({
    required String title,
    required IndexedWidgetBuilder itemBuilder,
    required int childrenCount,
    Key? key,
  }) => SliverPinnedHeaderSection._(
    key: key,
    title: title,
    itemBuilder: itemBuilder,
    childrenCount: childrenCount,
    delegate: SliverChildBuilderDelegate(
      itemBuilder,
      childCount: childrenCount,
    ),
  );

  /// The delegate that supplies the children to the sliver
  final SliverChildDelegate delegate;

  /// The title of the section.
  final String title;

  /// A fixed list of children widgets
  final List<Widget>? children;

  /// Lenght of the list built by the item builder
  final int? childrenCount;

  /// The builder for each item. Use in case of many children
  /// to optimize performance and to avoid having to pass
  /// pre-built children widgets
  final IndexedWidgetBuilder? itemBuilder;

  @override
  Widget build(BuildContext context) {
    return MultiSliver(
      pushPinnedChildren: true,
      children: [
        SliverPinnedHeader(
          child: Container(
            decoration: const BoxDecoration(
              color: CupertinoColors.systemGroupedBackground,
              border: Border(
                bottom: BorderSide(
                  color: CupertinoColors.systemGrey,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),
        ),

        SliverList(delegate: delegate),
      ],
    );
  }
}
