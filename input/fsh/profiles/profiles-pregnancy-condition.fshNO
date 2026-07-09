// ═══════════════════════════════════════════════════════════════════════════════
//  OPTION A — "pregnancy" overall element modelled as a Condition.
//
//  The pregnancy itself is a Condition; the detail data (EDD, expected number of
//  children, end date) are separate BeClinicalObservations (see
//  profiles-pregnancy-observations-common.fsh) linked back to this Condition.
//
//  Pros: a pregnancy is arguably a clinical condition/episode; onset & abatement
//        map naturally to start/end of pregnancy; clinicalStatus tracks
//        active/resolved.
//  Cons: NOT aligned with IPS, where pregnancy status is an Observation. The
//        coded "status" lives in Condition.clinicalStatus + Condition.code
//        rather than in an Observation.value, so cross-IG reuse is harder.
//
//  Element -> mapping (logical model PregnancyStatusDataSet1):
//    * patient                    -> Condition.subject
//    * practitioner (recorder)    -> Condition.recorder
//    * recordedDateOfPregnancy    -> Condition.recordedDate
//    * pregnancyStatus            -> Condition.clinicalStatus + Condition.code
//    * actualDateOfEndOfPregnancy -> Condition.abatementDateTime (or BePregnancyEndDate)
// ═══════════════════════════════════════════════════════════════════════════════

Profile: BePregnancyCondition
Parent: Condition
Id: be-pregnancy-condition
Title: "Pregnancy (Condition)"
Description: "Option A: the pregnancy modelled as a Condition. The detail data (EDD, expected number of children, end date) are carried in separate BeClinicalObservations."
* clinicalStatus 1..1
* subject 1..1
* subject only Reference(Patient)
* recorder 1..1
* recorder only Reference(Practitioner)
* recordedDate 1..1
* code 1..1
* code = $SCT#77386006 "Pregnant (finding)"
* abatement[x] only dateTime
