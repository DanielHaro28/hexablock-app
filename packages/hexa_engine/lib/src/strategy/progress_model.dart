/// Which of two attempts is better: the criterion of a variant's progress, a
/// Strategy (D-35, D-99).
///
/// Progress only improves (RN-COM-83): the best attempt is kept whole,
/// never mixed with another, and each variant decides what "better" means
/// (for example, more stars, then less time). The same criterion orders a
/// ranking, so [compare] is a `Comparator`: `attempts.sort(model.compare)`
/// leaves the best one first.
///
/// The shape of the progress (a record or one best attempt per level,
/// D-45) is not here: the `ILevelBased` capability says which one a game
/// has (D-33).
///
/// `TAttempt` has no constraint: each variant defines what an attempt
/// records (ARQ-02 §4.3).
abstract interface class IProgressModel<TAttempt> {
  /// Negative if [a] is better than [b], positive if it is worse, and 0 if
  /// neither is better.
  int compare(TAttempt a, TAttempt b);
}
