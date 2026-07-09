// ═══════════════════════════════════════════════════════════════════════════════
//  Pregnancy Status (administrative) — the model.
//
//  A single pregnancy status Observation (BeClinicalObservation, LOINC 82810-3)
//  that CONTAINS its detail observations and groups them via hasMember. The detail
//  observations are constrained by slicing `contained` by resource type and then by
//  resource.code — there is NO StructureDefinition per detail type; the slicing and
//  profiling live on the contained resources.
//
//  Under a type-pinned contained slice the snapshot generator expands the resource,
//  so each slice fixes its code, value[x] type and prohibits irrelevant elements.
//
//  Scope: pregnancy status is for ADMINISTRATIVE sharing, NOT clinical care. For
//  clinical care the pregnancy is more commonly represented as a Condition.
// ═══════════════════════════════════════════════════════════════════════════════

Alias: $BeClinObs = https://www.ehealth.fgov.be/standards/fhir/core-clinical/StructureDefinition/be-clinical-observation
Alias: $LOINC     = http://loinc.org
Alias: $SCT       = http://snomed.info/sct

Profile:     BePregnancyStatus
Parent:      $BeClinObs
Id:          be-pregnancy-status
Title:       "Pregnancy Status (administrative)"
Description: """
Administrative pregnancy status: a single `BeClinicalObservation` (LOINC `82810-3`,
value `CodeableConcept` as in IPS) that **contains** its detail observations and
groups them via `Observation.hasMember`.

The detail observations — estimated date of delivery (LOINC `11778-8`, `dateTime` as
in IPS), expected number of children (LOINC `11878-6`, `integer`) and actual end of
pregnancy (SNOMED `289251005`, `dateTime`) — are carried as **contained**
resources, constrained by slicing `contained` by type and code. Codes are **fixed
values**, not bindings. `bodySite`, `component`, `specimen`, `referenceRange`,
`device`, `method` and `interpretation` are not used.

There is **no StructureDefinition per detail type**; the slicing and profiling live
on the contained resources. Pregnancy status is for administrative sharing, **not
clinical care**; for clinical care the pregnancy is more commonly represented as a
`Condition` (see [BePregnancyCondition](StructureDefinition-be-pregnancy-condition.html)).
"""

// ── The pregnancy status observation itself ──
* code = $LOINC#82810-3
* value[x] only CodeableConcept
* hasMember only Reference($BeClinObs)
* hasMember MS
// NOTE: hasMember is deliberately NOT sliced. "At most one EDD / fetus-count /
// end-of-pregnancy" is already enforced by the `contained` slicing below
// (each detail slice is 0..1). hasMember could be sliced with a discriminator
// of #pattern on resolve().code, but the per-slice code CANNOT be fixed in the
// differential (you cannot assign through resolve()), so the slices would have
// no discriminating constraint — they'd be unenforceable. A profile-per-detail
// would be required, which this model deliberately avoids.
* bodySite 0..0
* component 0..0
* specimen 0..0
* referenceRange 0..0
* device 0..0
* method 0..0
* interpretation 0..0

// ── Contained detail observations: sliced by type, then by code ──
* contained ^slicing.discriminator[0].type = #type
* contained ^slicing.discriminator[0].path = "$this"
* contained ^slicing.discriminator[1].type = #pattern
* contained ^slicing.discriminator[1].path = "code"
* contained ^slicing.rules = #open
* contained contains
    estimatedDateOfDelivery 0..1 MS and
    expectedNumberOfChildren 0..1 MS and
    endOfPregnancyDate 0..1 MS

* contained[estimatedDateOfDelivery] only $BeClinObs
* contained[estimatedDateOfDelivery].code = $LOINC#11778-8
* contained[estimatedDateOfDelivery].value[x] only dateTime
* contained[estimatedDateOfDelivery].bodySite 0..0
* contained[estimatedDateOfDelivery].component 0..0
* contained[estimatedDateOfDelivery].specimen 0..0
* contained[estimatedDateOfDelivery].referenceRange 0..0
* contained[estimatedDateOfDelivery].device 0..0
* contained[estimatedDateOfDelivery].method 0..0
* contained[estimatedDateOfDelivery].interpretation 0..0

* contained[expectedNumberOfChildren] only $BeClinObs
* contained[expectedNumberOfChildren].code = $LOINC#11878-6
* contained[expectedNumberOfChildren].value[x] only integer
* contained[expectedNumberOfChildren].bodySite 0..0
* contained[expectedNumberOfChildren].component 0..0
* contained[expectedNumberOfChildren].specimen 0..0
* contained[expectedNumberOfChildren].referenceRange 0..0
* contained[expectedNumberOfChildren].device 0..0
* contained[expectedNumberOfChildren].method 0..0
* contained[expectedNumberOfChildren].interpretation 0..0

* contained[endOfPregnancyDate] only $BeClinObs
* contained[endOfPregnancyDate].code = $SCT#289251005
* contained[endOfPregnancyDate].value[x] only dateTime
* contained[endOfPregnancyDate].bodySite 0..0
* contained[endOfPregnancyDate].component 0..0
* contained[endOfPregnancyDate].specimen 0..0
* contained[endOfPregnancyDate].referenceRange 0..0
* contained[endOfPregnancyDate].device 0..0
* contained[endOfPregnancyDate].method 0..0
* contained[endOfPregnancyDate].interpretation 0..0
