This profile represents the **pregnancy status** — a *point-in-time clinical finding* answering the question "is this person pregnant, and what is the status (pregnant / not pregnant / possibly pregnant) as of the observation date?". This is the question an ER physician or an automated entitlement check needs answered "as of now".

It is one of the two scopes the IG distinguishes:

- **Pregnancy status** (this profile) — a point-in-time `Observation`, aligned with the international IPS *Pregnancy status* observation (LOINC `82810-3`, SNOMED-coded value), so the data can flow into an IPS composition unchanged.
- **The pregnancy itself** — the longitudinal clinical episode, represented as a `Condition`. See [BePregnancyCondition](StructureDefinition-be-pregnancy-condition.html).

The supporting detail data — expected date of delivery, expected number of children and actual end date — are carried as separate `BeClinicalObservation`s, grouped under this Observation via `Observation.hasMember`. See the [pregnancy status](pregnancy-status.html) page for the full rationale, and the logical model [PregnancyStatusDataSet](StructureDefinition-PregnancyStatusDataSet.html) for the underlying data set.
