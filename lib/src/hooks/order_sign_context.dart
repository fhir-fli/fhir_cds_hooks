import 'package:fhir_cds_hooks/src/hooks/cds_hook_context.dart';

/// Context for the `order-sign` hook.
class OrderSignContext extends CdsHookContext {
  /// Creates an [OrderSignContext].
  OrderSignContext({
    required this.userId,
    required this.patientId,
    required this.draftOrders,
    this.encounterId,
  });

  /// Creates an [OrderSignContext] from a JSON map.
  factory OrderSignContext.fromJson(Map<String, dynamic> json) {
    return OrderSignContext(
      userId: json['userId'] as String,
      patientId: json['patientId'] as String,
      draftOrders: json['draftOrders'] as Map<String, dynamic>,
      encounterId: json['encounterId'] as String?,
    );
  }

  /// The FHIR resource URI of the current user.
  final String userId;

  /// The FHIR id of the patient.
  final String patientId;

  /// A Bundle of draft orders being signed.
  /// A Bundle, as JSON (the CDS Hooks wire form).
  final Map<String, dynamic> draftOrders;

  /// The FHIR id of the current encounter, if applicable.
  final String? encounterId;

  @override
  String get hookName => 'order-sign';

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
    'userId': userId,
    'patientId': patientId,
    'draftOrders': draftOrders,
    if (encounterId != null) 'encounterId': encounterId,
  };
}
