// ═══════════════════════════════════════════════════════════════════════════════
//  Examples for the pregnancy IG.
//
//  The administrative model is BePregnancyStatus — a pregnancy status Observation
//  that CONTAINS its detail observations (EDD, expected number of children, …),
//  each a generic be-clinical-observation distinguished only by its code. The
//  single consolidated example is provided as predefined JSON:
//    input/examples/Observation-ex-pregnancy-status-contained.json
//  (SUSHI cannot build an inline-instance example whose contained resources are
//  sliced by code, so it lives as a predefined resource.)
//
//  Active here: the shared actors (Patient, Practitioner) referenced by that
//  contained instance, plus one Condition example (the episode framing).
//
//  DISABLED below (block comment): the nine standalone Observation examples that
//  demonstrated the earlier per-detail-profile framing. They are superseded by the
//  contained instance, which carries the same detail values inline. Kept as a
//  comment (not deleted) alongside the disabled profiles in pregnancy-profiles.fsh.
// ═══════════════════════════════════════════════════════════════════════════════

Alias: $CondClinical = http://terminology.hl7.org/CodeSystem/condition-clinical
Alias: $PregnancyId  = https://www.ehealth.fgov.be/standards/fhir/pregnancy/sid/pregnancy
Alias: $ObsId        = https://www.ehealth.fgov.be/standards/fhir/pregnancy/sid/observation


// ─── Shared actors ───────────────────────────────────────────────────────────

Instance:   ex-pregnant-woman
InstanceOf: Patient
Usage:      #example
Title:      "Example pregnant woman"
Description: "Patient used by all pregnancy-status examples."
* name.family = "Peeters"
* name.given = "Jana"
* gender = #female

Instance:   ex-gynaecologist
InstanceOf: Practitioner
Usage:      #example
Title:      "Example gynaecologist"
Description: "Practitioner who records the pregnancy data in all examples."
* name.family = "De Vries"
* name.given = "Anke"


// ─── Pregnancy as a Condition (episode framing) ──────────────────────────────
//  The pregnancy modelled as a longitudinal Condition. Detail observations may
//  reference it via Observation.focus (literal or logical reference).

Instance:   ex-pregnancy-condition
InstanceOf: BePregnancyCondition
Usage:      #example
Title:      "Pregnancy as a Condition (clinical episode)"
Description: "Episode framing: the pregnancy modelled as a longitudinal Condition, with onset and clinical status. The detail observations reference it via focus."
* clinicalStatus = $CondClinical#active
* subject = Reference(ex-pregnant-woman)
* recorder = Reference(ex-gynaecologist)
* recordedDate = "2026-02-10"
* onsetDateTime = "2026-01-05"


// ═══════════════════════════════════════════════════════════════════════════════
//  DISABLED (2026-07-09): standalone Observation examples for the earlier
//  per-detail-profile framing. Superseded by the contained instance
//  (Observation-ex-pregnancy-status-contained.json), which carries the same detail
//  values inline. These depend on the disabled profiles in pregnancy-profiles.fsh.
// ═══════════════════════════════════════════════════════════════════════════════
/*

// ─── The robust core: detail observations ─────────────────────────────────────

Instance:   ex-edd
InstanceOf: BeEstimatedDateOfDeliveryObservation
Usage:      #example
Title:      "Expected date of delivery (core detail observation)"
Description: "Estimated date of delivery. Part of the robust core: identical under every framing."
* identifier.system = $ObsId
* identifier.value = "edd-core"
* status = #final
* code = $LOINC#11778-8 "Delivery date Estimated"
* subject = Reference(ex-pregnant-woman)
* performer = Reference(ex-gynaecologist)
* effectiveDateTime = "2026-02-10"
* valueDateTime = "2026-09-15"

Instance:   ex-children
InstanceOf: BeExpectedNumberOfChildrenObservation
Usage:      #example
Title:      "Expected number of children (core detail observation)"
Description: "Expected number of children. Part of the robust core: identical under every framing."
* identifier.system = $ObsId
* identifier.value = "enc-core"
* status = #final
* subject = Reference(ex-pregnant-woman)
* performer = Reference(ex-gynaecologist)
* effectiveDateTime = "2026-02-10"
* valueQuantity.value = 1


// ─── Summary framing: pregnancy status as an Observation (no Condition) ───────

Instance:   ex-pregnancy-status
InstanceOf: BePregnancyStatusObservation
Usage:      #example
Title:      "Pregnancy status as a summary Observation (no Condition)"
Description: "Summary framing: pregnancy status as a point-in-time Observation that asserts the finding and groups the core detail observations via hasMember. IPS-aligned."
* identifier.system = $ObsId
* identifier.value = "status-summary"
* status = #final
* subject = Reference(ex-pregnant-woman)
* extension[recorder].valueReference = Reference(ex-gynaecologist)
* effectiveDateTime = "2026-02-10"
* valueCodeableConcept = $SCT#77386006 "Pregnant (finding)"
* hasMember[edd] = Reference(ex-edd)
* hasMember[+] = Reference(ex-children)


// ─── Episode framing: detail observations referencing the Condition ──────────

Instance:   ex-edd-linked
InstanceOf: BeEstimatedDateOfDeliveryObservation
Usage:      #example
Title:      "Expected date of delivery, referencing the Condition"
Description: "The core EDD observation (ex-edd) with the single addition of focus -> the pregnancy Condition."
* identifier.system = $ObsId
* identifier.value = "edd-linked"
* status = #final
* code = $LOINC#11778-8 "Delivery date Estimated"
* subject = Reference(ex-pregnant-woman)
* performer = Reference(ex-gynaecologist)
* effectiveDateTime = "2026-02-10"
* valueDateTime = "2026-09-15"
* focus = Reference(ex-pregnancy-condition) // the only difference vs ex-edd

Instance:   ex-children-linked
InstanceOf: BeExpectedNumberOfChildrenObservation
Usage:      #example
Title:      "Expected number of children, referencing the Condition"
Description: "The core expected-number-of-children observation (ex-children) with the single addition of focus -> the pregnancy Condition."
* identifier.system = $ObsId
* identifier.value = "enc-linked"
* status = #final
* subject = Reference(ex-pregnant-woman)
* performer = Reference(ex-gynaecologist)
* effectiveDateTime = "2026-02-10"
* valueQuantity.value = 1
* focus = Reference(ex-pregnancy-condition) // the only difference vs ex-children


// ─── Both framings together: summary Observation over a Condition ────────────

Instance:   ex-pregnancy-status-with-condition
InstanceOf: BePregnancyStatusObservation
Usage:      #example
Title:      "Summary Observation over a Condition (both framings)"
Description: "Both framings together: the same summary Observation, grouping the core observations via hasMember, and — like its members — referencing the pregnancy Condition via focus."
* identifier.system = $ObsId
* identifier.value = "status-both"
* status = #final
* subject = Reference(ex-pregnant-woman)
* extension[recorder].valueReference = Reference(ex-gynaecologist)
* effectiveDateTime = "2026-02-10"
* valueCodeableConcept = $SCT#77386006 "Pregnant (finding)"
* hasMember[edd] = Reference(ex-edd-linked)
* hasMember[+] = Reference(ex-children-linked)
* focus = Reference(ex-pregnancy-condition) // the summary points to the Condition too


// ─── Usable today: focus as a logical reference (a pregnancy identifier) ─────

Instance:   ex-edd-by-id
InstanceOf: BeEstimatedDateOfDeliveryObservation
Usage:      #example
Title:      "Expected date of delivery, tied to a pregnancy by identifier"
Description: "The core EDD observation with focus as a LOGICAL reference (a unique pregnancy identifier) — usable today, with no Condition resource."
* identifier.system = $ObsId
* identifier.value = "edd-by-id"
* status = #final
* code = $LOINC#11778-8 "Delivery date Estimated"
* subject = Reference(ex-pregnant-woman)
* performer = Reference(ex-gynaecologist)
* effectiveDateTime = "2026-02-10"
* valueDateTime = "2026-09-15"
* focus.identifier.system = $PregnancyId
* focus.identifier.value = "PREG-2026-0001"

Instance:   ex-children-by-id
InstanceOf: BeExpectedNumberOfChildrenObservation
Usage:      #example
Title:      "Expected number of children, tied to a pregnancy by identifier"
Description: "The core expected-number-of-children observation with focus as a LOGICAL reference (the same unique pregnancy identifier) — usable today, with no Condition resource."
* identifier.system = $ObsId
* identifier.value = "enc-by-id"
* status = #final
* subject = Reference(ex-pregnant-woman)
* performer = Reference(ex-gynaecologist)
* effectiveDateTime = "2026-02-10"
* valueQuantity.value = 1
* focus.identifier.system = $PregnancyId
* focus.identifier.value = "PREG-2026-0001"

Instance:   ex-pregnancy-status-by-id
InstanceOf: BePregnancyStatusObservation
Usage:      #example
Title:      "Pregnancy status tied to a pregnancy by identifier"
Description: "Summary Observation grouping its members via hasMember and tied to the pregnancy by the same logical reference (unique pregnancy identifier) on focus — usable today, with no Condition resource."
* identifier.system = $ObsId
* identifier.value = "status-by-id"
* status = #final
* subject = Reference(ex-pregnant-woman)
* extension[recorder].valueReference = Reference(ex-gynaecologist)
* effectiveDateTime = "2026-02-10"
* valueCodeableConcept = $SCT#77386006 "Pregnant (finding)"
* hasMember[edd] = Reference(ex-edd-by-id)
* hasMember[+] = Reference(ex-children-by-id)
* focus.identifier.system = $PregnancyId
* focus.identifier.value = "PREG-2026-0001"

*/
