# Geographic data provenance and attribution — TOWN

## Purpose

This document records the **approved official** geographic boundary datasets used for TOWN city-access verification in **LOCAL ACCESS FOUNDATION V1**.

It is a provenance and attribution register only.
It does **not** certify legal compliance.

Prepared source and derived GeoJSON files are stored under `data/boundaries/` for offline review.

Simplified runtime derivatives used by LOCAL ACCESS FOUNDATION V1 are bundled as Flutter assets:

- `assets/boundaries/milano_boundary_simplified.geojson`
- `assets/boundaries/munich_boundary_simplified.geojson`

declared in `pubspec.yaml`.

## Current status

| City | Approved dataset | Internal boundary version | Bundled status |
| --- | --- | --- | --- |
| Milano | Confini Amministrativi del Comune di Milano (DS2841) | `milano-admin-2024-11-04-v1` | **BUNDLED** (simplified runtime asset) |
| Munich | Official Stadtbezirke, dissolved from the 25 unique districts | `munich-admin-2026-05-27-v1` | **BUNDLED** (simplified runtime asset) |

Prepared geometry files also live under `data/boundaries/` (source + derived).

Checksum register: `data/boundaries/CHECKSUMS.sha256`.

LOCAL ACCESS FOUNDATION V1 uses these boundaries for one-time local offline classification only. Raw coordinates are not retained, transmitted, logged, or displayed.

---

## 1. Milano — whole-city verification

| Field | Value |
| --- | --- |
| Dataset | Confini Amministrativi del Comune di Milano (DS2841) |
| Authority | Comune di Milano |
| Intended use | Whole-city verification |
| Format | GeoJSON |
| CRS | EPSG:4326 |
| Licence | Creative Commons Attribution 4.0 International (CC BY 4.0) |
| Licence URL | https://creativecommons.org/licenses/by/4.0/ |
| Portal licence URI | https://w3id.org/italia/controlled-vocabulary/licences/A21_CCBY40 |
| Official dataset URL | https://dati.comune.milano.it/dataset/ds2841-confini-amministrativi-del-comune-di-milano |
| Official resource / download URL | https://dati.comune.milano.it/dataset/e75d91fa-eca6-4ee5-b96e-08bcdbb8d6f0/resource/f56cb432-83e6-48de-ae30-d39b4be61e85/download/confine_comune_milano_layer_0_confine_comune_milano.geojson |
| Resource metadata page | https://dati.comune.milano.it/dataset/e75d91fa-eca6-4ee5-b96e-08bcdbb8d6f0/resource/f56cb432-83e6-48de-ae30-d39b4be61e85 |
| Status | **BUNDLED** (simplified runtime asset for LOCAL ACCESS FOUNDATION V1) |

### Attribution requirement

CC BY 4.0 requires appropriate credit, a link to the licence, and an indication if changes were made.

When the dataset is shared or redistributed (including as an app asset), credit the Comune di Milano and this dataset, link to CC BY 4.0, and declare any modifications.

### Transformation and simplification

Transformation and geometry simplification are allowed under CC BY 4.0.

If the published GeoJSON is transformed, simplified, or otherwise modified before bundling, those modifications **must be declared** in attribution and in the provenance record for that internal boundary version.

### Provenance record — `milano-admin-2024-11-04-v1`

| Field | Value |
| --- | --- |
| authority | Comune di Milano |
| dataset title | Confini Amministrativi del Comune di Milano (DS2841) |
| dataset URL | https://dati.comune.milano.it/dataset/ds2841-confini-amministrativi-del-comune-di-milano |
| download URL | https://dati.comune.milano.it/dataset/e75d91fa-eca6-4ee5-b96e-08bcdbb8d6f0/resource/f56cb432-83e6-48de-ae30-d39b4be61e85/download/confine_comune_milano_layer_0_confine_comune_milano.geojson |
| licence | Creative Commons Attribution 4.0 International (CC BY 4.0) |
| licence URL | https://creativecommons.org/licenses/by/4.0/ |
| official update date | 2024-11-04 |
| official update date source | CKAN package field `modified` = `04-11-2024`; GeoJSON resource `last_modified` = `2024-11-04T08:00:05.300155`; temporal coverage end = `2024-11-04` |
| download date | 2026-07-10 |
| source file | `data/boundaries/source/milano_ds2841_source.geojson` |
| source SHA-256 checksum | `7417f88f3e584b690e4d3a0426e42fced44a5846175967b19444ca267a0f3ec1` |
| source CRS | EPSG:4326 |
| target CRS | EPSG:4326 (no transform) |
| geometry type | Polygon (1 feature; no holes; no MultiPolygon parts) |
| source feature count | 1 |
| source vertex count | 19553 |
| source approx. area | ≈ 181 763 617 m² (computed in EPSG:32632) |
| source bbox (lon/lat) | `[9.040613060914325, 45.38672482115768, 9.277997093231479, 45.53594676003435]` |
| geometry validity | Valid; non-empty; no repair applied |
| transformation notes | No CRS transform. Official whole-city boundary preserved as a single Polygon. No neighbourhood/NIL/election boundaries used. |
| simplification notes | Full boundary: none. Simplified boundary: `shapely.simplify` (Douglas-Peucker) with `preserve_topology=True`; tolerance **10 m** in EPSG:32632; vertices 19553 → 826; area change ≈ −0.0035%; file size 744 015 → 32 432 bytes. |
| derived full file | `data/boundaries/derived/milano_boundary_full.geojson` |
| derived full SHA-256 | `037e3f7c3363354315dddc564311b6493a289dddbd0669b5028335873b2e4a61` |
| derived simplified file | `data/boundaries/derived/milano_boundary_simplified.geojson` |
| derived simplified SHA-256 | `6f4e7c0b68afad26fe5de137929a4162b2495f9bb402c8876f36eee2a2d18a6b` |
| internal boundary version | `milano-admin-2024-11-04-v1` |
| intended use | city_access (LOCAL ACCESS FOUNDATION V1 whole-city verification) |
| bundled status | **BUNDLED** as `assets/boundaries/milano_boundary_simplified.geojson` |

#### Milano processing record

1. Downloaded official DS2841 GeoJSON (2026-07-10).
2. Validated JSON/GeoJSON, CRS EPSG:4326, 1 feature, valid Polygon, 19553 vertices.
3. Wrote unsimplified derived boundary (geometry preserved; metadata normalised).
4. Wrote topology-preserving simplified boundary at 10 m tolerance.
5. Recorded SHA-256 checksums in `data/boundaries/CHECKSUMS.sha256`.

Attribution for redistribution (declare modifications when using the simplified file):

> Boundary data: Comune di Milano — Confini Amministrativi del Comune di Milano (DS2841), https://dati.comune.milano.it/dataset/ds2841-confini-amministrativi-del-comune-di-milano, CC BY 4.0 (https://creativecommons.org/licenses/by/4.0/). Simplified derivative uses topology-preserving 10 m simplification where applicable.

---

## 2. Munich — whole-city verification

| Field | Value |
| --- | --- |
| Dataset | Official Stadtbezirke dataset, dissolved from the 25 unique districts |
| Authority | Landeshauptstadt München — GeodatenService |
| Intended use | Whole-city verification |
| Source format | Official WFS / GeoJSON |
| Source CRS | EPSG:25832 |
| Target CRS for app use | EPSG:4326 |
| Licence | Datenlizenz Deutschland – Namensnennung – Version 2.0 (dl-de/by-2.0) |
| Licence URL | https://www.govdata.de/dl-de/by-2-0 |
| Official dataset URL | https://opendata.muenchen.de/dataset/vablock_stadtbezirke_opendata |
| Official WFS / resource URL | https://geoportal.muenchen.de/geoserver/gsm_wfs/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=gsm_wfs:vablock_stadtbezirk&outputFormat=application/json |
| Status | **BUNDLED** (simplified runtime asset for LOCAL ACCESS FOUNDATION V1) |

### Required attribution wording

When using this dataset (including a dissolved derivative), the source note must include:

1. Provider (as prescribed by GeodatenService):  
   `Landeshauptstadt München - GeodatenService, www.muenchen.de/rathaus/Stadtverwaltung/Kommunalreferat/geodatenservice`
2. Licence annotation: `Datenlizenz Deutschland – Namensnennung – Version 2.0` or `dl-de/by-2.0`, with link to https://www.govdata.de/dl-de/by-2-0
3. Reference to the dataset URI: https://opendata.muenchen.de/dataset/vablock_stadtbezirke_opendata

### Deduplication before dissolve

The official WFS response may return more than 25 features because districts **18** and **19** can appear twice (low-detail and high-detail copies).

Before dissolving to a whole-city boundary:

- keep **one** feature per `sb_nummer` (01–25);
- prefer the high-detail geometry for districts 18 and 19;
- confirm exactly 25 unique districts.

### Modified derivative

The dissolved whole-city boundary is a **modified derivative** of the official Stadtbezirke dataset.

Under dl-de/by-2.0, changes must be marked in the source note (for example, that the data were dissolved, reprojected to EPSG:4326, and/or simplified).

### Written confirmation recommended

Written confirmation from GeodatenService München is recommended before shipping the dissolved derivative as an asset inside the membership app.

Contact recorded in portal metadata: `geoportal@muenchen.de`.

**Unresolved:** written confirmation from GeodatenService has **not** been obtained for this prepared derivative. Do not ship in the membership app until that confirmation is recorded.

### Optional official cross-check (not primary)

Bayerische Vermessungsverwaltung ALKIS® Verwaltungsgebiete — Gemeinde München (AGS 09162000) may be used later as a cross-check only. It is not the primary municipal source for this register.

### Provenance record — `munich-admin-2026-05-27-v1`

| Field | Value |
| --- | --- |
| authority | Landeshauptstadt München — GeodatenService |
| dataset title | Stadtbezirke (`vablock_stadtbezirke_opendata`) |
| dataset URL | https://opendata.muenchen.de/dataset/vablock_stadtbezirke_opendata |
| download URL | https://geoportal.muenchen.de/geoserver/gsm_wfs/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=gsm_wfs:vablock_stadtbezirk&outputFormat=application/json |
| licence | Datenlizenz Deutschland – Namensnennung – Version 2.0 (dl-de/by-2.0) |
| licence URL | https://www.govdata.de/dl-de/by-2-0 |
| official update date | 2026-05-27 |
| official update date source | CKAN extras `GeoPortal Last Modified Date` = `2026-05-27T14:38:27` |
| download date | 2026-07-10 |
| source file | `data/boundaries/source/munich_stadtbezirke_source.geojson` |
| source SHA-256 checksum | `f3552067a0e06c83efcafa2d01aebbba456385862a0d0b719bb11256fb571e19` |
| source CRS | EPSG:25832 (confirmed from GeoJSON CRS) |
| target CRS | EPSG:4326 |
| district identifier field | `sb_nummer` |
| raw source feature count | 27 |
| district numbers found | 01–25 (all present); duplicates for **18** and **19** |
| duplicate records | District 18: 2 features (8 verts low-detail, 577 verts high-detail). District 19: 2 features (15 verts low-detail, 1007 verts high-detail). |
| duplicate selection method | Prefer higher vertex count (higher-detail geometry); tie-break by larger area in EPSG:25832. Retained district 18 index with 577 verts; district 19 index with 1007 verts. |
| unique districts before dissolve | **25** (exactly 01–25) |
| geometry type (derived) | Polygon (1 feature after dissolve; no holes) |
| dissolve result | `shapely.ops.unary_union` of 25 districts → Polygon. Area difference vs combined district areas in EPSG:25832 ≈ −7.15×10⁻⁷ m² (numerical noise). |
| transformation notes | **Modified derivative:** (1) deduplicate `sb_nummer` 18/19; (2) dissolve 25 Stadtbezirke; (3) reproject EPSG:25832 → EPSG:4326 via geopandas/pyproj. No electoral districts used. |
| simplification notes | Full boundary: none after dissolve+reproject. Simplified: `shapely.simplify` with `preserve_topology=True`; tolerance **10 m** in EPSG:32632; vertices 4146 → 596; area change ≈ −0.0078%; file size 163 182 → 24 854 bytes. |
| derived full file | `data/boundaries/derived/munich_boundary_full.geojson` |
| derived full SHA-256 | `85e1ba80296325eba6a37c2862e4f4089b9d9a65afa1ef64ed695081ea138f40` |
| derived simplified file | `data/boundaries/derived/munich_boundary_simplified.geojson` |
| derived simplified SHA-256 | `b6c0b97cc9979742e45ab19219fcf5fd03bdf7cce6758b1de1b6f2533f0f2918` |
| derived approx. area (EPSG:4326, via EPSG:32632) | ≈ 310 721 370 m² |
| derived bbox (lon/lat) | `[11.360778275906402, 48.06162443606122, 11.722909698518494, 48.24811837376852]` |
| geometry validity | Source districts valid; dissolve valid; reprojected valid; simplified valid. No repair applied. |
| internal boundary version | `munich-admin-2026-05-27-v1` |
| intended use | city_access (LOCAL ACCESS FOUNDATION V1 whole-city verification) |
| bundled status | **BUNDLED** as `assets/boundaries/munich_boundary_simplified.geojson` |
| modified derivative | **Yes** — must be marked in attribution |
| GeodatenService written confirmation | **Not yet obtained** (recommended before membership/production shipping; not a certification of legal compliance) |

#### Munich processing record

1. Downloaded official WFS GeoJSON (2026-07-10); CRS EPSG:25832; 27 features.
2. Identified district field `sb_nummer`; listed duplicates for 18 and 19; selected higher-detail geometries.
3. Confirmed exactly 25 unique districts covering 01–25.
4. Dissolved to one Polygon; reprojected to EPSG:4326; validated area against combined source area.
5. Wrote full and 10 m topology-preserving simplified derived boundaries.
6. Recorded SHA-256 checksums in `data/boundaries/CHECKSUMS.sha256`.

Required attribution text for the modified derivative:

> Landeshauptstadt München - GeodatenService, www.muenchen.de/rathaus/Stadtverwaltung/Kommunalreferat/geodatenservice. Datenlizenz Deutschland – Namensnennung – Version 2.0 (dl-de/by-2.0), https://www.govdata.de/dl-de/by-2-0. Dataset: https://opendata.muenchen.de/dataset/vablock_stadtbezirke_opendata. Modified: deduplicated duplicate Stadtbezirke 18/19 (kept higher-detail geometries), dissolved the 25 unique Stadtbezirke into one whole-city boundary, reprojected from EPSG:25832 to EPSG:4326, and (for the simplified file) applied topology-preserving 10 m simplification.

---

## 3. Later civic and electoral datasets (not bundled)

These datasets are reserved for later work. **Do not add their files yet.** Do not use them for whole-city access verification.

### Milano — later civic-area assignment

| Dataset | Authority | Role | Official URL |
| --- | --- | --- | --- |
| Territorio: superficie dei Municipi (DS379) | Comune di Milano | Municipi (civic sub-areas) | https://dati.comune.milano.it/dataset/ds379-infogeo-municipi-superficie |
| Nuclei d'Identità Locale (NIL) VIGENTI – PGT 2030 (DS964) | Comune di Milano | NIL / neighbourhood-scale civic areas | https://dati.comune.milano.it/dataset/ds964-nil-vigenti-pgt-2030 |

### Munich — later civic-area assignment

| Dataset | Authority | Role | Official URL |
| --- | --- | --- | --- |
| Bezirksteil | Landeshauptstadt München — GeodatenService | Stadtbezirksteile | https://opendata.muenchen.de/dataset/vablock_bezirksteil_opendata |
| Stadtviertel München | Landeshauptstadt München — GeodatenService | Stadtviertel | https://opendata.muenchen.de/dataset/vablock_viertel_opendata |

### Election-specific datasets (keep separate)

Election-related geographic or address datasets **must remain separate** from stable city-access boundaries because electoral divisions may change for each election.

Examples (reference only; not for city-access gating):

| City | Dataset | Official URL |
| --- | --- | --- |
| Munich | Wahlen: Stimm- und Briefwahlbezirke in München | https://opendata.muenchen.de/dataset/wahlen-stimm-und-briefwahlbezirke-in-muenchen |
| Milano | Election-specific sezioni / sedi / civico mappings (per consultation) | e.g. https://dati.comune.milano.it/dataset/ds2920-referendum-abrogativo-2025-sezioni-e-sedi-elettorali |

Tag any future electoral assets with intended use `electoral` and an election identifier. Never mix them into `city_access` boundary files or version channels.

---

## 4. Hard rules

1. **No OSM / community boundary as primary source.** Official municipal, administrative, statistical, or electoral authorities only.
2. **No centre-radius approximation** for city-access verification.
3. **No boundary file enters the app** before source, licence, checksum, date, and internal version are recorded for that version.
4. **Raw coordinates should not be stored** when a derived verification result is sufficient (for example: verification result, verified city identifier, verification timestamp).
5. **City-access boundaries and election-specific boundaries must never be mixed** in the same asset, version channel, or provenance record.

---

## 5. Provenance template

Copy this block for each future bundled boundary version. Fill every field before shipping geometry.

```text
authority:
dataset_title:
dataset_URL:
download_URL:
licence:
licence_URL:
official_update_date:
download_date:
SHA-256_checksum:
CRS:
geometry_type:
transformation_notes:
simplification_notes:
internal_boundary_version:
intended_use:          # city_access | civic | electoral
bundled_status:        # NOT YET BUNDLED | BUNDLED
```

### Blank instance (ready to fill)

| Field | Value |
| --- | --- |
| authority | |
| dataset title | |
| dataset URL | |
| download URL | |
| licence | |
| licence URL | |
| official update date | |
| download date | |
| SHA-256 checksum | |
| CRS | |
| geometry type | |
| transformation notes | |
| simplification notes | |
| internal boundary version | |
| intended use | |
| bundled status | NOT YET BUNDLED |

---

## Related documents

- `docs/LEGAL_CONSTRAINTS.md` — legal and privacy constraints (including location data minimisation)
- `docs/MVP_SCOPE.md` — product scope boundaries

## Document control

| Item | Value |
| --- | --- |
| Document type | Provenance and attribution register |
| Geometry prepared under `data/boundaries/` | Yes (source + derived) |
| Geometry bundled in app runtime | **Yes** — simplified Milano and Munich assets for LOCAL ACCESS FOUNDATION V1 |
| Code / packages changed by this document | None |
| Legal compliance certified | **No** |
