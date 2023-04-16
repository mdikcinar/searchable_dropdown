class MockCallback {
  int _callCounter = 0;
  void call() {
    _callCounter += 1;
  }

  bool called(int expected) => _callCounter == expected;
  void reset() {
    _callCounter = 0;
  }
}
