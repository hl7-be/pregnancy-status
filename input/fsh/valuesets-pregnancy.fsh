// ─── Pregnancy status value set ──────────────────────────────────────────────
// Aligned with the IPS "Pregnancy status" value set (SNOMED CT based) so that
// Option B (Observation) can be made IPS-compatible.
ValueSet: BePregnancyStatusVS
Id: be-pregnancy-status-vs
Title: "Pregnancy status value set (BE)"
Description: "Codes describing the current pregnancy status of a woman, aligned with the IPS pregnancy status value set."
* ^status = #draft
* ^copyright = "This value set includes content from SNOMED CT, which is copyright © 2002+ International Health Terminology Standards Development Organisation (IHTSDO), and distributed by agreement between IHTSDO and HL7. Implementer use of SNOMED CT is not covered by this agreement"
* ^experimental = false
* $SCT#77386006 "Pregnancy (finding)"
* $SCT#60001007 "Not pregnant (finding)"
* $SCT#102874004 "Possible pregnancy (finding)"
