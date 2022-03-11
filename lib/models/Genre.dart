class Genre {
  late int id;
  late String title;

  Genre.fromMap(var map){
    this.id = map['id'];
    this.title = map['name'];
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is Genre && other.id == this.id;
  }

  @override
  int get hashCode {
    return this.id.hashCode;
  }
}
