// ─── Pregnancy status value set ──────────────────────────────────────────────
// Aligned with the IPS "Pregnancy status" value set (SNOMED CT based) so that
// Option B (Observation) can be made IPS-compatible.
ValueSet: BePregnancyStatusVS
Id: be-pregnancy-status-vs
Title: "Pregnancy status value set (BE)"
Description: "Codes describing the current pregnancy status of a woman, aligned with the IPS pregnancy status value set."
* ^status = #draft
* ^copyright = "This value set includes content from SNOMED CT, which is copyright © 2002+ International Health Terminology Standards Development Organisation (IHTSDO); Belgium is a member of IHTSDO. Implementers of SNOMED CT should review usage terms or directly contact SNOMED International: info@snomed.org"
* ^experimental = false
* $SCT#77386006 "Pregnancy (finding)"
* $SCT#60001007 "Not pregnant (finding)"
* $SCT#102874004 "Possible pregnancy (finding)"
