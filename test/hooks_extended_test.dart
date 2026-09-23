import 'dart:convert';

import 'package:fhir_cds_hooks/fhir_cds_hooks.dart';
import 'package:test/test.dart';

void main() {
  group('PatientViewContext extended', () {
    test('full JSON encode/decode cycle', () {
      final ctx = PatientViewContext(
        userId: 'Practitioner/doc-1',
        patientId: 'p-abc',
        encounterId: 'enc-xyz',
      );
      final encoded = jsonEncode(ctx.toJson());
      final decoded = PatientViewContext.fromJson(
        jsonDecode(encoded) as Map<String, dynamic>,
      );
      expect(decoded.userId, 'Practitioner/doc-1');
      expect(decoded.patientId, 'p-abc');
      expect(decoded.encounterId, 'enc-xyz');
      expect(decoded.hookName, 'patient-view');
    });

    test('is a CdsHookContext', () {
      final ctx = PatientViewContext(
        userId: 'Practitioner/1',
        patientId: 'p1',
      );
      expect(ctx, isA<CdsHookContext>());
    });
  });

  group('OrderSelectContext extended', () {
    test('with encounterId', () {
      final ctx = OrderSelectContext(
        userId: 'Practitioner/1',
        patientId: 'p1',
        selections: ['MedicationRequest/m1', 'MedicationRequest/m2'],
        draftOrders: const <String, dynamic>{
          'resourceType': 'Bundle',
          'type': 'collection',
        },
        encounterId: 'enc-1',
      );
      final json = ctx.toJson();
      expect(json['encounterId'], 'enc-1');
      expect((json['selections'] as List).length, 2);

      final decoded = OrderSelectContext.fromJson(json);
      expect(decoded.encounterId, 'enc-1');
      expect(decoded.selections.length, 2);
    });

    test('without encounterId', () {
      final ctx = OrderSelectContext(
        userId: 'Practitioner/1',
        patientId: 'p1',
        selections: ['ServiceRequest/s1'],
        draftOrders: const <String, dynamic>{
          'resourceType': 'Bundle',
          'type': 'collection',
        },
      );
      final json = ctx.toJson();
      expect(json.containsKey('encounterId'), isFalse);
    });

    test('full JSON encode/decode with bundle entries', () {
      final ctx = OrderSelectContext(
        userId: 'Practitioner/1',
        patientId: 'p1',
        selections: ['MedicationRequest/m1'],
        draftOrders: <String, dynamic>{
          'resourceType': 'Bundle',
          'type': 'collection',
          'entry': [
            <String, dynamic>{
              'resource': <String, dynamic>{
                'resourceType': 'Patient',
                'id': 'order-patient',
              },
            },
          ],
        },
      );
      final encoded = jsonEncode(ctx.toJson());
      final decoded = OrderSelectContext.fromJson(
        jsonDecode(encoded) as Map<String, dynamic>,
      );
      expect((decoded.draftOrders['entry'] as List<dynamic>).length, 1);
      expect(
        ((decoded.draftOrders['entry'] as List<dynamic>).first
            as Map<String, dynamic>)['resource'],
        isA<Map<String, dynamic>>(),
      );
    });
  });

  group('OrderSignContext extended', () {
    test('with encounterId', () {
      final ctx = OrderSignContext(
        userId: 'Practitioner/1',
        patientId: 'p1',
        draftOrders: const <String, dynamic>{
          'resourceType': 'Bundle',
          'type': 'collection',
        },
        encounterId: 'enc-1',
      );
      final json = ctx.toJson();
      expect(json['encounterId'], 'enc-1');

      final decoded = OrderSignContext.fromJson(json);
      expect(decoded.encounterId, 'enc-1');
    });

    test('without encounterId', () {
      final ctx = OrderSignContext(
        userId: 'Practitioner/1',
        patientId: 'p1',
        draftOrders: const <String, dynamic>{
          'resourceType': 'Bundle',
          'type': 'collection',
        },
      );
      expect(ctx.toJson().containsKey('encounterId'), isFalse);
    });
  });

  group('OrderDispatchContext extended', () {
    test('with fulfillmentTasks bundle', () {
      final ctx = OrderDispatchContext(
        patientId: 'p1',
        dispatchedOrders: ['ServiceRequest/s1'],
        performer: 'Organization/o1',
        fulfillmentTasks: <String, dynamic>{
          'resourceType': 'Bundle',
          'type': 'collection',
          'entry': [
            <String, dynamic>{
              'resource': <String, dynamic>{
                'resourceType': 'Task',
                'status': 'requested',
                'intent': 'order',
              },
            },
          ],
        },
      );
      final encoded = jsonEncode(ctx.toJson());
      final decoded = OrderDispatchContext.fromJson(
        jsonDecode(encoded) as Map<String, dynamic>,
      );
      expect(decoded.fulfillmentTasks, isNotNull);
      expect((decoded.fulfillmentTasks!['entry'] as List<dynamic>).length, 1);
      expect(
        ((decoded.fulfillmentTasks!['entry'] as List<dynamic>).first
            as Map<String, dynamic>)['resource'],
        isA<Map<String, dynamic>>(),
      );
    });

    test('with multiple dispatched orders', () {
      final ctx = OrderDispatchContext(
        patientId: 'p1',
        dispatchedOrders: [
          'ServiceRequest/s1',
          'ServiceRequest/s2',
          'ServiceRequest/s3',
        ],
        performer: 'Practitioner/prac-1',
      );
      final encoded = jsonEncode(ctx.toJson());
      final decoded = OrderDispatchContext.fromJson(
        jsonDecode(encoded) as Map<String, dynamic>,
      );
      expect(decoded.dispatchedOrders.length, 3);
      expect(decoded.performer, 'Practitioner/prac-1');
    });
  });

  group('EncounterStartContext extended', () {
    test('full JSON encode/decode cycle', () {
      final ctx = EncounterStartContext(
        userId: 'Practitioner/doc-1',
        patientId: 'p-abc',
        encounterId: 'enc-xyz',
      );
      final encoded = jsonEncode(ctx.toJson());
      final decoded = EncounterStartContext.fromJson(
        jsonDecode(encoded) as Map<String, dynamic>,
      );
      expect(decoded.userId, 'Practitioner/doc-1');
      expect(decoded.patientId, 'p-abc');
      expect(decoded.encounterId, 'enc-xyz');
      expect(decoded.hookName, 'encounter-start');
    });
  });

  group('EncounterDischargeContext extended', () {
    test('full JSON encode/decode cycle', () {
      final ctx = EncounterDischargeContext(
        userId: 'Practitioner/doc-2',
        patientId: 'p-def',
        encounterId: 'enc-456',
      );
      final encoded = jsonEncode(ctx.toJson());
      final decoded = EncounterDischargeContext.fromJson(
        jsonDecode(encoded) as Map<String, dynamic>,
      );
      expect(decoded.userId, 'Practitioner/doc-2');
      expect(decoded.patientId, 'p-def');
      expect(decoded.encounterId, 'enc-456');
      expect(decoded.hookName, 'encounter-discharge');
    });
  });

  group('AppointmentBookContext extended', () {
    test('with encounterId', () {
      final ctx = AppointmentBookContext(
        userId: 'Practitioner/1',
        patientId: 'p1',
        appointments: const <String, dynamic>{
          'resourceType': 'Bundle',
          'type': 'collection',
        },
        encounterId: 'enc-1',
      );
      final json = ctx.toJson();
      expect(json['encounterId'], 'enc-1');

      final decoded = AppointmentBookContext.fromJson(json);
      expect(decoded.encounterId, 'enc-1');
    });

    test('without encounterId', () {
      final ctx = AppointmentBookContext(
        userId: 'Practitioner/1',
        patientId: 'p1',
        appointments: const <String, dynamic>{
          'resourceType': 'Bundle',
          'type': 'collection',
        },
      );
      expect(ctx.toJson().containsKey('encounterId'), isFalse);
    });

    test('full encode/decode with appointment entries', () {
      final ctx = AppointmentBookContext(
        userId: 'Practitioner/1',
        patientId: 'p1',
        appointments: <String, dynamic>{
          'resourceType': 'Bundle',
          'type': 'collection',
          'entry': [
            <String, dynamic>{
              'resource': <String, dynamic>{
                'resourceType': 'Appointment',
                'status': 'proposed',
                'participant': [
                  <String, dynamic>{
                    'actor': <String, dynamic>{'reference': 'Patient/p1'},
                    'status': 'accepted',
                  },
                ],
              },
            },
          ],
        },
      );
      final encoded = jsonEncode(ctx.toJson());
      final decoded = AppointmentBookContext.fromJson(
        jsonDecode(encoded) as Map<String, dynamic>,
      );
      expect((decoded.appointments['entry'] as List<dynamic>).length, 1);
      expect(
        ((decoded.appointments['entry'] as List<dynamic>).first
            as Map<String, dynamic>)['resource'],
        isA<Map<String, dynamic>>(),
      );
    });
  });

  group('AllergyintoleranceCreateContext extended', () {
    test('with encounterId', () {
      final ctx = AllergyintoleranceCreateContext(
        userId: 'Practitioner/1',
        patientId: 'p1',
        allergyIntolerance: <String, dynamic>{
          'resourceType': 'AllergyIntolerance',
          'patient': <String, dynamic>{'reference': 'Patient/p1'},
        },
        encounterId: 'enc-1',
      );
      final json = ctx.toJson();
      expect(json['encounterId'], 'enc-1');

      final decoded = AllergyintoleranceCreateContext.fromJson(json);
      expect(decoded.encounterId, 'enc-1');
    });

    test('without encounterId', () {
      final ctx = AllergyintoleranceCreateContext(
        userId: 'Practitioner/1',
        patientId: 'p1',
        allergyIntolerance: <String, dynamic>{
          'resourceType': 'AllergyIntolerance',
          'patient': <String, dynamic>{'reference': 'Patient/p1'},
        },
      );
      expect(ctx.toJson().containsKey('encounterId'), isFalse);
    });

    test('full encode/decode with detailed allergy', () {
      final ctx = AllergyintoleranceCreateContext(
        userId: 'Practitioner/1',
        patientId: 'p1',
        allergyIntolerance: <String, dynamic>{
          'resourceType': 'AllergyIntolerance',
          'patient': <String, dynamic>{'reference': 'Patient/p1'},
          'clinicalStatus': <String, dynamic>{
            'coding': [
              <String, dynamic>{
                'system':
                    'http://terminology.hl7.org/CodeSystem/allergyintolerance-clinical',
                'code': 'active',
              },
            ],
          },
          'code': <String, dynamic>{'text': 'Penicillin'},
          'type': 'allergy',
        },
      );
      final encoded = jsonEncode(ctx.toJson());
      final decoded = AllergyintoleranceCreateContext.fromJson(
        jsonDecode(encoded) as Map<String, dynamic>,
      );
      expect(
        (decoded.allergyIntolerance['code'] as Map<String, dynamic>)['text'],
        'Penicillin',
      );
      expect(decoded.allergyIntolerance['type'], 'allergy');
    });
  });

  group('MedicationRefillContext extended', () {
    test('with encounterId', () {
      final ctx = MedicationRefillContext(
        patientId: 'p1',
        medications: const <String, dynamic>{
          'resourceType': 'Bundle',
          'type': 'collection',
        },
        userId: 'Practitioner/1',
        encounterId: 'enc-1',
      );
      final json = ctx.toJson();
      expect(json['encounterId'], 'enc-1');

      final decoded = MedicationRefillContext.fromJson(json);
      expect(decoded.encounterId, 'enc-1');
    });

    test('without userId and encounterId', () {
      final ctx = MedicationRefillContext(
        patientId: 'p1',
        medications: const <String, dynamic>{
          'resourceType': 'Bundle',
          'type': 'collection',
        },
      );
      final json = ctx.toJson();
      expect(json.containsKey('userId'), isFalse);
      expect(json.containsKey('encounterId'), isFalse);
    });
  });

  group('ProblemListItemCreateContext extended', () {
    test('with encounterId', () {
      final ctx = ProblemListItemCreateContext(
        userId: 'Practitioner/1',
        patientId: 'p1',
        conditions: const <String, dynamic>{
          'resourceType': 'Bundle',
          'type': 'collection',
        },
        encounterId: 'enc-1',
      );
      final json = ctx.toJson();
      expect(json['encounterId'], 'enc-1');

      final decoded = ProblemListItemCreateContext.fromJson(json);
      expect(decoded.encounterId, 'enc-1');
    });

    test('without encounterId', () {
      final ctx = ProblemListItemCreateContext(
        userId: 'Practitioner/1',
        patientId: 'p1',
        conditions: const <String, dynamic>{
          'resourceType': 'Bundle',
          'type': 'collection',
        },
      );
      expect(ctx.toJson().containsKey('encounterId'), isFalse);
    });

    test('full encode/decode with condition entries', () {
      final ctx = ProblemListItemCreateContext(
        userId: 'Practitioner/1',
        patientId: 'p1',
        conditions: <String, dynamic>{
          'resourceType': 'Bundle',
          'type': 'collection',
          'entry': [
            <String, dynamic>{
              'resource': <String, dynamic>{
                'resourceType': 'Condition',
                'subject': <String, dynamic>{'reference': 'Patient/p1'},
                'code': <String, dynamic>{'text': 'Hypertension'},
              },
            },
          ],
        },
      );
      final encoded = jsonEncode(ctx.toJson());
      final decoded = ProblemListItemCreateContext.fromJson(
        jsonDecode(encoded) as Map<String, dynamic>,
      );
      expect((decoded.conditions['entry'] as List<dynamic>).length, 1);
      expect(
        ((decoded.conditions['entry'] as List<dynamic>).first
            as Map<String, dynamic>)['resource'],
        isA<Map<String, dynamic>>(),
      );
    });
  });

  group('Hook context used in CdsRequest', () {
    test('PatientViewContext toJson used as CdsRequest context', () {
      final hookCtx = PatientViewContext(
        userId: 'Practitioner/123',
        patientId: 'p1',
        encounterId: 'enc-1',
      );
      final request = CdsRequest(
        hook: hookCtx.hookName,
        hookInstance: 'inst-1',
        context: hookCtx.toJson(),
      );
      expect(request.hook, 'patient-view');
      expect(request.context['userId'], 'Practitioner/123');
      expect(request.context['patientId'], 'p1');
      expect(request.context['encounterId'], 'enc-1');
    });

    test('OrderSelectContext toJson used as CdsRequest context', () {
      final hookCtx = OrderSelectContext(
        userId: 'Practitioner/1',
        patientId: 'p1',
        selections: ['MedicationRequest/m1'],
        draftOrders: const <String, dynamic>{
          'resourceType': 'Bundle',
          'type': 'collection',
        },
      );
      final request = CdsRequest(
        hook: hookCtx.hookName,
        hookInstance: 'inst-2',
        context: hookCtx.toJson(),
      );
      expect(request.hook, 'order-select');
      expect(
        (request.context['selections'] as List).first,
        'MedicationRequest/m1',
      );
    });
  });
}
