class FetchDataResult<K, T> {
  final K nextPageKey;
  final List<T> elements;
  FetchDataResult({
    required this.nextPageKey,
    required this.elements,
  });
}
