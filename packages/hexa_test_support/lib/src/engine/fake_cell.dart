/// A cell content for the engine tests (D-56, enunciado §3.6).
///
/// The engine is tested with this type instead of a variant's content, so a
/// passing test shows that the engine does not depend on any variant (RNF-02).
final class FakeCell {
  const FakeCell(this.label);

  /// What the test put in the cell.
  final String label;

  @override
  bool operator ==(Object other) => other is FakeCell && other.label == label;

  @override
  int get hashCode => label.hashCode;

  @override
  String toString() => 'FakeCell($label)';
}
