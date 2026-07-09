This profile represents **the pregnancy itself** — the *longitudinal clinical episode*: a pregnancy that begins, runs over time and eventually ends. It has an onset, an (estimated) due date, an expected number of children and an actual end date, and a clinical status that moves from active to resolved. Onset and abatement map naturally to the start and end of the pregnancy.

It is one of the two scopes the IG distinguishes:

- **The pregnancy itself** (this profile) — the longitudinal episode, represented as a `Condition`.
- **Pregnancy status** — a point-in-time clinical finding for *administrative sharing*, represented as an `Observation` aligned with the IPS *Pregnancy status* observation. See [BePregnancyStatusObservation](StructureDefinition-be-observation-pregnancy-status.html).

The supporting detail data — expected date of delivery, expected number of children and actual end date — are carried as separate `BeClinicalObservation`s referencing this Condition via `Observation.focus` (the actual end date may alternatively be carried on `Condition.abatementDateTime`). See the [pregnancy status](pregnancy-status.html) page for the full rationale, and the logical model [PregnancyStatusDataSet](StructureDefinition-PregnancyStatusDataSet.html) for the underlying data set.
