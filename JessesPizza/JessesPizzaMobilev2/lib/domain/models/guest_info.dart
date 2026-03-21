import 'package:equatable/equatable.dart';

class GuestInfo extends Equatable {
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String addressLine1;
  final String city;
  final String zipCode;

  const GuestInfo({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.addressLine1,
    required this.city,
    required this.zipCode,
  });

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phoneNumber': phoneNumber,
        'addressLine1': addressLine1,
        'city': city,
        'zipCode': zipCode,
      };

  @override
  List<Object?> get props =>
      [firstName, lastName, email, phoneNumber, addressLine1, city, zipCode];
}
