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
  username: 'budi123',
  password: 'password123',
  nama: 'Budi Doremi',
);
