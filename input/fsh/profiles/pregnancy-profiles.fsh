// Profiles derived from the PregnancyStatusDataSet logical model.
//
// Shape:
//   - N Observation profiles, each parented on BeClinicalObservation
//     (hl7.fhir.be.core-clinical).
//   - The BePregnancyStatusObservation hasMember slice references the
//     BeEstimatedDateOfDeliveryObservation (per IPS Pregnancy Status pattern).
//   - Observations may be tied to a pregnancy via Observation.focus — either a
//     reference to a BePregnancyCondition or a logical reference (a unique
//     pregnancy identifier). See pregnancy-status.html.
//
// IPS references:
//   - http://hl7.org/fhir/uv/ips/StructureDefinition/Observation-pregnancy-status-uv-ips
//   - http://hl7.org/fhir/uv/ips/StructureDefinition/Observation-pregnancy-edd-uv-ips
//   - http://hl7.org/fhir/uv/ips/StructureDefinition/Observation-pregnancy-outcome-uv-ips
//
// ═══════════════════════════════════════════════════════════════════════════════
//  ⚠ PARENT = base Observation (NOT be-clinical-observation) — deliberate, and
//    intended to be TEMPORARY.
//
//  Why: be-clinical-observation requires Observation.performer 1..*. Base FHIR
//  does not (performer is 0..*). We do NOT want to force a performer on these
//  pregnancy observations, so for now they are profiled on base Observation —
//  which means they DO NOT claim be-clinical-observation conformance and lose its
//  other BE constraints (e.g. identifier 1..*, BE bindings).
//
//  OPEN QUESTION for BE core: should be-clinical-observation relax performer to
//  0..*? If yes, re-parent all profiles below back onto be-clinical-observation
//  ($BeClinObs) to regain BE alignment — no other change needed.
// ═══════════════════════════════════════════════════════════════════════════════

Alias: $BeClinObs   = https://www.ehealth.fgov.be/standards/fhir/core-clinical/StructureDefinition/be-clinical-observation
Alias: $BePatient   = https://www.ehealth.fgov.be/standards/fhir/core/StructureDefinition/be-patient
Alias: $BePract     = https://www.ehealth.fgov.be/standards/fhir/core/StructureDefinition/be-practitioner
Alias: $BeRecorder  = https://www.ehealth.fgov.be/standards/fhir/core/StructureDefinition/be-ext-recorder
Alias: $LOINC       = http://loinc.org
Alias: $SCT         = http://snomed.info/sct
Alias: $UCUM        = http://unitsofmeasure.org
Alias: $IpsEddVS    = http://hl7.org/fhir/uv/ips/ValueSet/edd-method-uv-ips
Alias: $IpsPsVS     = http://hl7.org/fhir/uv/ips/ValueSet/pregnancy-status-uv-ips


// ═══════════════════════════════════════════════════════════════════════════════
//  DISABLED (2026-07-09): the six illustrative per-detail Observation profiles
//  below are superseded by the single contained model BePregnancyStatus
//  (pregnancy-status-contained.fsh) — the approach agreed 2026-06-23. They are
//  commented out (not deleted) so the history stays visible. The consolidated
//  example is Observation-ex-pregnancy-status-contained.json.
// ═══════════════════════════════════════════════════════════════════════════════
/*

// ─── Observation: pregnancy status ──────────────────────────────────────────

Profile:     BePregnancyStatusObservation
Parent:      Observation
Id:          be-observation-pregnancy-status
Title:       "Pregnancy Status (Observation)"
Description: "> **Demonstrative, temporary profile.**
>
> The model is the [Pregnancy Status profile](StructureDefinition-be-pregnancy-status.html) — a pregnancy status Observation that **contains** its detail observations, keyed by `.code`. Profiles like this one are **illustrative only** and are expected to be **removed in the federal guidance**.
>
> A federal layer cannot publish one profile per type of observation: there are far too many `.code` values, spread across many clinical domains, to maintain a StructureDefinition for each. Instead it standardises the generic `BeClinicalObservation` and lets the **container plus the codes** carry the specific meaning.

Current pregnancy status of a woman (e.g. pregnant, not pregnant).
Aligned with IPS `Observation-pregnancy-status-uv-ips`. May be tied to a
pregnancy via `Observation.focus`. Per the IPS
pattern, `hasMember` references the related EDD observation."

* code = $LOINC#82810-3 "Pregnancy status"

* subject 1..1
* subject only Reference($BePatient)

// The practitioner responsible for declaring the pregnancy status is carried in
// the be-ext-recorder extension. Observation.performer is not constrained here
// (optional, as on base Observation).
* extension contains
  $BeRecorder named recorder 1..1
* extension[recorder] MS

* effective[x] 1..1
* effective[x] only dateTime

* value[x] 1..1
* value[x] only CodeableConcept
* valueCodeableConcept from $IpsPsVS (preferred)

* hasMember ^slicing.discriminator.type = #profile
* hasMember ^slicing.discriminator.path = "resolve()"
* hasMember ^slicing.rules = #open
* hasMember contains
    edd 0..1 MS
* hasMember[edd] only Reference(BeEstimatedDateOfDeliveryObservation)


// ─── Observation: estimated date of delivery ────────────────────────────────

Profile:     BeEstimatedDateOfDeliveryObservation
Parent:      Observation
Id:          be-observation-pregnancy-edd
Title:       "Estimated Date of Delivery (Observation)"
Description: "> **Demonstrative, temporary profile.**
>
> The model is the [Pregnancy Status profile](StructureDefinition-be-pregnancy-status.html) — a pregnancy status Observation that **contains** its detail observations, keyed by `.code`. Profiles like this one are **illustrative only** and are expected to be **removed in the federal guidance**.
>
> A federal layer cannot publish one profile per type of observation: there are far too many `.code` values, spread across many clinical domains, to maintain a StructureDefinition for each. Instead it standardises the generic `BeClinicalObservation` and lets the **container plus the codes** carry the specific meaning.

Expected delivery date for a pregnancy, usually estimated from
ultrasound. Aligned with IPS `Observation-pregnancy-edd-uv-ips`. May be tied to
a pregnancy via `Observation.focus`."

// IPS binds Observation.code to the EDD method value set (required).
// TODO: add the IPS package (hl7.fhir.uv.ips) as a dependency in sushi-config.yaml
//       so $IpsEddVS (edd-method-uv-ips) resolves and the binding can be validated.
* code from $IpsEddVS (required)

* subject 1..1
* subject only Reference($BePatient)

* effective[x] 1..1
* effective[x] only dateTime

* value[x] 1..1
* value[x] only dateTime


// ─── Observation: end of pregnancy date ─────────────────────────────────────

Profile:     BeEndOfPregnancyDateObservation
Parent:      Observation
Id:          be-observation-pregnancy-end-date
Title:       "End of Pregnancy Date (Observation)"
Description: "> **Demonstrative, temporary profile.**
>
> The model is the [Pregnancy Status profile](StructureDefinition-be-pregnancy-status.html) — a pregnancy status Observation that **contains** its detail observations, keyed by `.code`. Profiles like this one are **illustrative only** and are expected to be **removed in the federal guidance**.
>
> A federal layer cannot publish one profile per type of observation: there are far too many `.code` values, spread across many clinical domains, to maintain a StructureDefinition for each. Instead it standardises the generic `BeClinicalObservation` and lets the **container plus the codes** carry the specific meaning.

Actual end date of a pregnancy. May be tied to a pregnancy via
`Observation.focus`."

// TODO: bind Observation.code to a Belgian/SNOMED value set for the
// "end of pregnancy" concept once the terminology expert confirms it.
* code 1..1

* subject 1..1
* subject only Reference($BePatient)

* effective[x] 1..1
* effective[x] only dateTime

* value[x] 1..1
* value[x] only dateTime


// ─── Observation: expected number of children ──────────────────────────────

Profile:     BeExpectedNumberOfChildrenObservation
Parent:      Observation
Id:          be-observation-pregnancy-fetus-count
Title:       "Expected Number of Children (Observation)"
Description: "> **Demonstrative, temporary profile.**
>
> The model is the [Pregnancy Status profile](StructureDefinition-be-pregnancy-status.html) — a pregnancy status Observation that **contains** its detail observations, keyed by `.code`. Profiles like this one are **illustrative only** and are expected to be **removed in the federal guidance**.
>
> A federal layer cannot publish one profile per type of observation: there are far too many `.code` values, spread across many clinical domains, to maintain a StructureDefinition for each. Instead it standardises the generic `BeClinicalObservation` and lets the **container plus the codes** carry the specific meaning.

Expected number of children for a pregnancy (number of fetuses,
usually determined by ultrasound). May be tied to a pregnancy via
`Observation.focus`."

* code = $LOINC#11878-6 "Number of fetuses by US"

* subject 1..1
* subject only Reference($BePatient)

* effective[x] 1..1
* effective[x] only dateTime

* value[x] 1..1
* value[x] only Quantity
* valueQuantity.value 1..1
* valueQuantity.system = $UCUM
* valueQuantity.code = #1


// ─── Observation: number of silent births (this delivery) ──────────────────

Profile:     BeNumberOfSilentBirthsObservation
Parent:      Observation
Id:          be-observation-pregnancy-silent-births
Title:       "Number of Silent Births (Observation)"
Description: "> **Demonstrative, temporary profile.**
>
> The model is the [Pregnancy Status profile](StructureDefinition-be-pregnancy-status.html) — a pregnancy status Observation that **contains** its detail observations, keyed by `.code`. Profiles like this one are **illustrative only** and are expected to be **removed in the federal guidance**.
>
> A federal layer cannot publish one profile per type of observation: there are far too many `.code` values, spread across many clinical domains, to maintain a StructureDefinition for each. Instead it standardises the generic `BeClinicalObservation` and lets the **container plus the codes** carry the specific meaning.

Number of fetal deaths in this delivery. Obligatory when the
pregnancy has ended. May be tied to a pregnancy via
`Observation.focus`."

// TODO: confirm code with the terminology expert. Note that IPS pregnancy
// outcome codes (e.g. LOINC 11636-8 "Pregnancy losses --in mother") are
// lifetime totals; this element is per-delivery, so a different code or VS
// will likely be needed.
* code 1..1

* subject 1..1
* subject only Reference($BePatient)

* effective[x] 1..1
* effective[x] only dateTime

* value[x] 1..1
* value[x] only Quantity
* valueQuantity.value 1..1
* valueQuantity.system = $UCUM
* valueQuantity.code = #1


// ─── Observation: number of live births (this delivery) ────────────────────

Profile:     BeNumberOfLiveBirthsObservation
Parent:      Observation
Id:          be-observation-pregnancy-live-births
Title:       "Number of Live Births (Observation)"
Description: "> **Demonstrative, temporary profile.**
>
> The model is the [Pregnancy Status profile](StructureDefinition-be-pregnancy-status.html) — a pregnancy status Observation that **contains** its detail observations, keyed by `.code`. Profiles like this one are **illustrative only** and are expected to be **removed in the federal guidance**.
>
> A federal layer cannot publish one profile per type of observation: there are far too many `.code` values, spread across many clinical domains, to maintain a StructureDefinition for each. Instead it standardises the generic `BeClinicalObservation` and lets the **container plus the codes** carry the specific meaning.

Number of alive births in this delivery. Obligatory when the
pregnancy has ended. May be tied to a pregnancy via
`Observation.focus`. **Out of scope of this iteration.**"

// TODO: confirm code (per-delivery, not lifetime) with the terminology expert.
* code 1..1

* subject 1..1
* subject only Reference($BePatient)

* effective[x] 1..1
* effective[x] only dateTime

* value[x] 1..1
* value[x] only Quantity
* valueQuantity.value 1..1
* valueQuantity.system = $UCUM
* valueQuantity.code = #1

*/
