class Player {
  const Player({required this.name, required this.hp});

  final String name;
  final int hp;

  Player copyWith({String? name, int? hp}) {
    return Player(name: name ?? this.name, hp: hp ?? this.hp);
  }
}
