class Animal {
  final String name;
  final String age;

  Animal({
    required this.name,
    required this.age,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
    };
  }

  @override
  String toString() {
    return 'Animal{name: $name, age: $age}';
  }
}