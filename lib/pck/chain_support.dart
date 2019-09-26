
abstract class AbstractBaseChain<T> {
  T _father;
  T _son;
  T get father;
  set father(T father);
  T get son;
  set son(T son);
}

abstract class AbstractChain<T extends AbstractBaseChain> extends AbstractBaseChain {
  @override
  T get father => _father;
  @override
  T get son => _son;

  @override
  set father(father) {
    this._father = father;
    father._son = this;
  }

  @override
  set son(son) {
    if (son != null) son._father = this;
    this._son = son;
  }

  T get first => _father == null ? this : _father.first;
  T get last => _son == null ? this : _son.son;

  int get genFather => _father == null ? 0 : _father.genFather - 1;
  int get genChildren => _son == null ? 0 : _son.genChildren + 1;

  T exchange(T ch1, T ch2) {
    if (ch2._father != null) ch1.father = ch2.father;
    if (ch2._son != null) ch1.son = ch2.son;
    return ch1;
  }

  T born(T child) {
    if (this.son != null) {
      return this.son;
    } else {
      child.father = this;
      return child;
    }
  }

  T getGen(int x) {
    if (x == 0)
      return this as T;
    else if (x < 0 && this._father != null)
      return _father.getGen(x + 1);
    else if (x > 0 && this._son != null)
      return _son.getGen(x - 1);
    else
      return null;
  }
}
