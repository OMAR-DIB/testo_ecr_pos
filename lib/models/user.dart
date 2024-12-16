import 'package:objectbox/objectbox.dart';

@Entity()
class User {
  @Id()
  int id;
  String firstName;
  String lastName;
  String role;

  User(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.role});
}
