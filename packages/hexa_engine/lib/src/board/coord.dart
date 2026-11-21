/// The identifier of one cell in some grid topology (D-07, glosario).
///
/// Each topology brings its own coordinate type: `(q, r)` for hexagons,
/// `(x, y)` for squares and triangles, `(x, y, z)` for cubes. The engine only
/// ever sees the type parameter `C extends Coord`, so it never learns which
/// cell shape is being played (RNF-04).
///
/// **Why the `C extends Coord` constraint exists (ARQ-02 §4.3):** a board and
/// a shape store coordinates as map keys and set members, so every coordinate
/// must compare by value. Subclasses must therefore override `==` and
/// `hashCode`; Dart cannot enforce it (an abstract redeclaration still
/// inherits `Object`'s identity), so the topology tests check it.
///
/// It is `base` so that a coordinate is always a real subclass, never a type
/// that merely `implements` the interface and skips the value semantics.
abstract base class Coord {
  const Coord();
}
