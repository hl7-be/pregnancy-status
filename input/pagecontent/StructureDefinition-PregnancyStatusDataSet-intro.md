This logical model captures the **scope-independent** information of the pregnancy-status data set. It describes *what* data is exchanged, independently of *how* it is represented in FHIR resources.

When this data set is mapped onto FHIR, the IG distinguishes two related but different concepts, each with its own scope and each represented by a different resource type:

- **Pregnancy status** — a *point-in-time clinical finding* ("is this person pregnant, and what is the status as of the observation date?"). Represented as an `Observation`, aligned with the IPS *Pregnancy status* observation. See [BePregnancyStatusObservation](StructureDefinition-be-observation-pregnancy-status.html).
- **The pregnancy itself** — the *longitudinal clinical episode* with an onset, due date, expected number of children and an end. Represented as a `Condition`. See [BePregnancyCondition](StructureDefinition-be-pregnancy-condition.html).

In both cases the supporting detail elements (expected date of delivery, expected number of children, actual end date) are carried as separate `BeClinicalObservation`s. See the [Information model — two scopes, two resources](index.html) section of the home page for the full rationale.
