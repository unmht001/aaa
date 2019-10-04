mixin Dsfw {
  Map _database = {};
  Map get database=>_database;
  Map get data => database["data"] == null ? database["data"] = {} : database["data"];
  set data(Map d) => database["data"] = d;
  Map get state => database["data"] == null ? database["data"] = {} : database["data"];
  set state(Map d) => database["data"] = d;
  Map get fn => database["data"] == null ? database["data"] = {} : database["data"];
  set fn(Map d) => database["data"] = d;
}

