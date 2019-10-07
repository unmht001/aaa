class MyAbstractMap<R, T, C> {
  Map<T, C> get _box; //overrride

  R _instance;//override

  R get instance => _getInstance();

  R _getInstance() => _instance = (_instance ?? new Object() as R); //override

  C operator [](T key) => key == null ? null : (_box[key] ?? (_box[key] = new Object() as C));
  operator []=(T key, C value) => key == null ? null : _box[key] = value;

  Iterable<MapEntry> get entries => _box.entries;
  Iterable get keys => _box.keys;
  int get length => _box.length;
  Iterable get values => _box.values;

  void addAll(Map other) => _box.addAll(other);
  void addEntries(Iterable<MapEntry> newEntries) => _box.addEntries(newEntries);
  void clear() => _box.clear();
  void updateAll(C Function(Object key, Object value) update) => _box.updateAll(update);
  void removeWhere(bool Function(Object key, Object value) predicate) => _box.removeWhere(predicate);
  void forEach(void Function(Object key, Object value) f) => _box.forEach(f);

  bool containsKey(Object key) => _box.containsKey(key);
  bool containsValue(Object value) => _box.containsValue(value);
  bool isEmpty() => _box.isEmpty;
  bool isNotEmpty() => _box.isNotEmpty;

  Map<K2, V2> map<K2, V2>(MapEntry<K2, V2> Function(Object key, Object value) f) => map(f);
  Map<RK, RV> cast<RK, RV>() => _box.cast();

  putIfAbsent(key, Function() ifAbsent) => _box.putIfAbsent(key, ifAbsent);
  remove(Object key) => _box.remove(key);
  update(key, C Function(Object value) update, {Function() ifAbsent}) => _box.update(key, update, ifAbsent: ifAbsent);

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MyMapBase<R, T, C> extends MyAbstractMap<R, T, C> {
  static Map __box = new Map();
  static Object _inst;

  @override
  get _box => __box;

  @override
  get _instance=>_inst;

  @override
  R _getInstance()=> _inst==null? _inst=new Object() as R : _inst ;
  

}

