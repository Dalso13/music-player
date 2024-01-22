abstract interface class ShuffleChange {
  Future<void> execute({required bool isShuffleModeEnabled});
}