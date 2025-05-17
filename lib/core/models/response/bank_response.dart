// bank_response.dart
import 'package:dewa_wo_app/core/models/bank_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bank_response.freezed.dart';
part 'bank_response.g.dart';

@freezed
abstract class BankResponse with _$BankResponse {
  const factory BankResponse({
    required String status,
    required String message,
    List<BankModel>? data,
  }) = _BankResponse;

  factory BankResponse.fromJson(Map<String, dynamic> json) =>
      _$BankResponseFromJson(json);
}
