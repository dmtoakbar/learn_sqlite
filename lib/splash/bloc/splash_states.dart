class SplashStates{
  const SplashStates({
    this.index=0
  });
  final int index;
  SplashStates copyWith({int? index}) {
    return SplashStates(index: index??this.index);
  }
}