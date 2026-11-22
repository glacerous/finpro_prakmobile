class User {
  final String username;
  final String password;
  final String nama;

  const User({
    required this.username,
    required this.password,
    required this.nama,
  });
}

const User user1 = User(
  username: 'a',
  password: 'a',
  nama: 'admin',
);
