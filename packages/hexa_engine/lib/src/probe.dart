/// Temporary probe for the coverage gate.
int covered(int x) => x + 1;

/// Temporary probe for the coverage gate.
int uncovered(int x) {
  final y = x - 1;
  return y * 2;
}
