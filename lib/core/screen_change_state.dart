enum ScreenChangeState {
  home(idx : 0),
  playList(idx : 1);

  final int idx;

  const ScreenChangeState({
    required this.idx
  });
}