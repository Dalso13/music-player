
abstract interface class ShuffleChange {
  Future<bool> execute({required bool isShuffleModeEnabled});
}