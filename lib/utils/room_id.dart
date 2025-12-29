String buildIdMatching(int myId, int otherId) {
  final ids = [myId, otherId]..sort();
  return '${ids[0]}_${ids[1]}';
}
