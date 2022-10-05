class HrAverageIntermediate {
  int _total;
  int _count = 1;

  HrAverageIntermediate(int hr) : _total = hr;

  void add(int value) {
    _total += value;
    _count++;
  }

  double get average => _total / _count;
}
