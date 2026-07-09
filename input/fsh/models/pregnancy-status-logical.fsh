Logical: PregnancyStatusDataSet
Id: PregnancyStatusDataSet
Title: "Pregnancy Status Model"
Description: """
Logical model for the pregnancy-status data.

This is the minimal data set for the pregnancy status (consumed, for example, via
Vitalink FHIR / MAGDA / VUTG / mijnburgerprofiel.be / mijngezondheid.be /
caregivers).
"""
Characteristics: #can-be-target

// ─── MUST HAVE (in scope of this iteration) ──────────────────────────────────

* pregnancy 1..1 Base "Pregnancy Episode" "Pregnancy Episode"

  * patient 1..1 Reference(Patient) "Patient (pregnant woman)" "The patient who is pregnant. The reference may identify the patient by pseudonymised SSIN, depending on the implementation."
  * author 1..1 Reference(Practitioner) "The healthcare professional who takes responsibility for the recording of the pregnancy information"
  * updateDate 1..1 date "Last update date" "The last date on which the pregnant woman was observed by her gynaecologist or midwife during the pregnancy."
  * firstRecordedDate 1..1 date "Recorded date of pregnancy" "The date the pregnancy was first registered in the system. This is not the date the pregnancy was observed, but the date it was entered in the system for the first time."


// from https://build.fhir.org/ig/HL7/fhir-ips/en/StructureDefinition-Observation-pregnancy-status-uv-ips.html
  * pregnancyStatus 1..1 Base "Pregnancy status (observation)" "Observation conveying the current pregnancy status of the woman at the date of observation (e.g. pregnant, not pregnant). Bound to SNOMED CT, EHDS Patient Summary aligned."
    * value 1..1 CodeableConcept "The actual value" "Coded pregnancy status (e.g. pregnant, not pregnant)."
//    * patient 1..1 Reference(Patient) "Patient (pregnant woman)" "The patient who is pregnant. In the pilot, the reference identifies the patient by pseudonymised SSIN."
    * author 1..1 Reference(Practitioner) "Practitioner who recorded the pregnancy status"
//    * observationDate 1..1 date "Observation date" "The date on which the pregnancy status was observed."
//    * estimatedDateOfDelivery 0..1 Reference(Observation) "Estimated date of delivery (reference)" "Reference to the sibling `estimatedDateOfDelivery` observation that carries the EDD value for this pregnancy status."


  // Date the pregnancy started (project data dictionary; no dedicated IPS profile)
    * pregnancyStartDate 1..1 Base "Date the pregnancy started" "The date the pregnancy began, usually estimated as the first day of the last menstrual period (LMP) or from an early ultrasound."
      * value 1..1 date "The actual value"
//      * patient 1..1 Reference(Patient) "Patient (pregnant woman)" "The patient who is pregnant. In the pilot, the reference identifies the patient by pseudonymised SSIN."
//      * practitioner 1..1 Reference(Practitioner) "Practitioner responsible for the pregnancy"
//      * observationDate 1..1 date "Recorded date of pregnancy" "The date the pregnancy was first registered in the system. This is not the date the pregnancy was observed, but the date it was entered in the system for the first time."


  // https://build.fhir.org/ig/HL7/fhir-ips/en/StructureDefinition-Observation-pregnancy-edd-uv-ips.html
    * estimatedDateOfDelivery 1..1 Base "Estimated date of delivery" "The date the practitioner expects the delivery, usually etimated from the ultrasound. It normally does not change after the initial etimation; the actual delivery date is typically within ±2 weeks."
      * value 1..1 date "The actual value"
//      * patient 1..1 Reference(Patient) "Patient (pregnant woman)" "The patient who is pregnant. In the pilot, the reference identifies the patient by pseudonymised SSIN."
//      * practitioner 1..1 Reference(Practitioner) "Practitioner responsible for the pregnancy"
//      * observationDate 1..1 date "Recorded date of pregnancy" "The date the pregnancy was first registered in the system. This is not the date the pregnancy was observed, but the date it was entered in the system for the first time."


    * dateOfEndOfPregnancy 0..1 Base "Date of end of pregnancy" "The actual end date of the pregnancy."
      * value 1..1 date "The actual value"
//      * patient 1..1 Reference(Patient) "Patient (pregnant woman)" "The patient who is pregnant. In the pilot, the reference identifies the patient by pseudonymised SSIN."
//      * practitioner 1..1 Reference(Practitioner) "Practitioner responsible for the pregnancy"
//      * observationDate 1..1 date "Recorded date of pregnancy" "The date the pregnancy was first registered in the system. This is not the date the pregnancy was observed, but the date it was entered in the system for the first time."

    * expectedNumberOfChildren 1..1 Base "Expected number of children" "The number of births the practitioner expects in the delivery, usually estimated from the ultrasound."
      * value 1..1 integer "The actual value"
//      * patient 1..1 Reference(Patient) "Patient (pregnant woman)" "The patient who is pregnant. In the pilot, the reference identifies the patient by pseudonymised SSIN."
//      * practitioner 1..1 Reference(Practitioner) "Practitioner responsible for the pregnancy"
//      * observationDate 1..1 date "Recorded date of pregnancy" "The date the pregnancy was first registered in the system. This is not the date the pregnancy was observed, but the date it was entered in the system for the first time."




//     * numberOfSilentBirths 0..1 Base "Number of silent births" "The number of fetal deaths in this delivery. Obligatory when `dateOfEndOfPregnancy` is filled in."
//       * value 1..1 integer "The actual value"
// //      * patient 1..1 Reference(Patient) "Patient (pregnant woman)" "The patient who is pregnant. In the pilot, the reference identifies the patient by pseudonymised SSIN."
// //      * practitioner 1..1 Reference(Practitioner) "Practitioner responsible for the pregnancy"
// //      * observationDate 1..1 date "Recorded date of pregnancy" "The date the pregnancy was first registered in the system. This is not the date the pregnancy was observed, but the date it was entered in the system for the first time."


//     * numberOfAliveBirths 0..1 Base "Number of alive births" "The number of alive births in this delivery. Obligatory when `dateOfEndOfPregnancy` is filled in."
//       * value 1..1 integer "The actual value"
// //      * patient 1..1 Reference(Patient) "Patient (pregnant woman)" "The patient who is pregnant. In the pilot, the reference identifies the patient by pseudonymised SSIN."
// ///      * practitioner 1..1 Reference(Practitioner) "Practitioner responsible for the pregnancy"
// //      * observationDate 1..1 date "Recorded date of pregnancy" "The date the pregnancy was first registered in the system. This is not the date the pregnancy was observed, but the date it was entered in the system for the first time."
