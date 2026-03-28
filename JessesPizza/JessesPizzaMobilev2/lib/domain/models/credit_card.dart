import 'package:freezed_annotation/freezed_annotation.dart';

part 'credit_card.freezed.dart';
part 'credit_card.g.dart';

@freezed
abstract class CreditCard with _$CreditCard {
  const factory CreditCard({
    required String id,
    @JsonKey(name: 'cardNumber') required String maskedCardNumber,
    required String expirationDate,
  }) = _CreditCard;

  factory CreditCard.fromJson(Map<String, dynamic> json) => _$CreditCardFromJson(json);
}
