Pregnancy and birth involve a broad set of administrative and clinical data,
contributed and consumed by many initiatives and stakeholders over the full course
of care — from the first confirmation of a pregnancy, through follow-up and
screening, to birth and post-natal follow-up of mother and child (eBirth, RIZIV,
Born in Belgium, Zoet Zwanger, PALS, the *moeder/kind boekje*, ...).

The **pregnancy status** is a minimal, well-bounded data set, sufficient to support
business cases such as entitlement to the *Groeipakket*, the on-line pregnancy
certificate, and consultation by the woman and her caregivers. The rest of the
broader pregnancy care set is **out of scope of this iteration**, but the
information model is designed so that it can be added later without redesign. See
the [home page](index.html) for the full scope and roadmap.

### The model: a pregnancy status Observation containing its details

Pregnancy status here is for **administrative sharing**, *not* clinical care. (For
clinical care, the pregnancy is more commonly represented as a `Condition`.)

The model is a single **pregnancy status `Observation`** (a `BeClinicalObservation`,
LOINC `82810-3`) that **contains** its detail observations and groups them via
`Observation.hasMember` — the
[Pregnancy Status profile](StructureDefinition-be-pregnancy-status.html). The
contained details — estimated date of delivery (`11778-8`, `dateTime`), expected
number of children (`11878-6`, `integer`) and an optional end-of-pregnancy date
(`289251005`, `dateTime`) — are constrained directly on the container by slicing
`contained` by type and then by code, each with a **fixed code** and value type.

**The container is the conformance target.** The contained observations are
distinguished by code, not by a profile per observation type.

> **Demonstrative, temporary profiles.**
>
> The per-code Observation profiles in this IG are **illustrative only** and are
> expected to be **removed in the federal guidance**.
>
> A federal layer cannot publish one profile per type of observation: there are far
> too many `.code` values, spread across many clinical domains, to maintain a
> StructureDefinition for each. Instead it standardises the generic
> `BeClinicalObservation` and lets the **container plus the codes** carry the
> specific meaning.

### The information model

Within the pregnancy-status scope, the IG distinguishes two related but different
concepts, each represented by a different FHIR resource type:

- **Pregnancy status** — a *point-in-time clinical finding* ("is this person
  pregnant, and what is the status as of the observation date?"). Represented as an
  `Observation`, aligned with the IPS *Pregnancy status* observation. See
  [BePregnancyStatusObservation](StructureDefinition-be-observation-pregnancy-status.html).
- **The pregnancy itself** — the *longitudinal clinical episode* with an onset and
  actual end date. Represented as a `Condition`. The detail observations (due date,
  expected number of children, etc.) reference it — it is the observations that
  point to the `Condition`, not the reverse. See
  [BePregnancyCondition](StructureDefinition-be-pregnancy-condition.html).

In both cases the supporting detail elements (expected date of delivery, expected
number of children, actual end date) are carried as separate
`BeClinicalObservation`s. The shared, scope-independent information model is the
logical model
[PregnancyStatusDataSet](StructureDefinition-PregnancyStatusDataSet.html).

### A robust core, with two framings over it

The **detail observations are the robust core** of the data — they carry the actual
values and stay unchanged regardless of how the pregnancy as a whole is represented.
The `PregnancyStatus` Observation and the `Pregnancy` `Condition` are then two
**framings** over that core:

- the **`PregnancyStatus` Observation** asserts the coded finding (pregnant / not
  pregnant) and groups the details — the IPS-aligned summary;
- the **`Pregnancy` `Condition`** represents the clinical episode (onset, status,
  end).

Whichever framing you do not currently use is an **optional add-on** that can be
added later, derived from the same core, without touching the details:

- With **no `Condition`** (the current scope), the `PregnancyStatus` Observation is
  the anchor — it is the only resource asserting the finding and grouping the
  details. The `Condition` is the future add-on.
- Once a **`Condition`** exists, it already asserts "pregnant" and anchors the
  details (via `focus`); the `PregnancyStatus` Observation then becomes an optional,
  IPS-compatible **summary** projected over the same data.

The diagram below shows these two framings and how the design is **incremental**: a
project can start with the `PregnancyStatus` Observation and its member
observations, and add the `Pregnancy` Condition later with no redesign of the
existing observations.

The two links are independent and serve different purposes:

- `Observation.hasMember` groups the member observations under the `PregnancyStatus`
  Observation (parent → children). This is internal to the observations and has
  **nothing to do with the `Condition`**.
- `Observation.focus` is how an observation is tied to the pregnancy `Condition`.
  **Both** the `PregnancyStatus` Observation and its member observations point to
  the `Condition` this way, so any observation that is part of a pregnancy is known.
  This `focus` can be a **literal reference** to a `Condition` resource **or a
  logical reference** (`Reference.identifier`) — that is, **a unique identifier of
  the pregnancy**.

> **Note.** While there is no `BePregnancyCondition` resource to point at, the
> `focus` can already carry a **logical reference — a unique pregnancy identifier**.
> That identifier groups all the observations that belong to the same pregnancy,
> without any `Condition` resource being exchanged. Later, when a `Condition`
> resource does exist, the very same `focus` simply resolves to it (a literal
> reference) — the observations themselves do not need to change.

<figure>
  {% include pregnancystatus.svg %}
</figure>

### Fetching the data

Because the pregnancy status `Observation` **contains** its detail observations,
fetching the status returns the details **inline** — no `_include` is needed for
them.

**Given a patient** — fetch the pregnancy status (the EDD, number of children and
end date come contained within it):

```
GET [base]/Observation?subject=Patient/123&code=http://loinc.org|82810-3
```

To list the pregnancy observations *about* a patient from the other direction:

```
GET [base]/Patient/123?_revinclude=Observation:subject
```

> **Note.** When the pregnancy is also represented as a `Condition` (clinical-care
> scope), the observations link to it via `Observation.focus` — a literal reference
> or a logical reference (a unique pregnancy identifier). See the framing discussion
> above. The recorder is carried in the `be-ext-recorder` extension.