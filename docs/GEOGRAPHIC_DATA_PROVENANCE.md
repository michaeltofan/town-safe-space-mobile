# Geographic data provenance and attribution — TOWN

## Purpose

This document records the **approved official** geographic boundary datasets for future TOWN city-access verification.

It is a provenance and attribution register only.

**No boundary geometry files are bundled in this repository yet.**

Do not add GeoJSON, Shapefile, or other boundary assets until source, licence, checksum, date, and internal version are recorded for that version (see [Provenance template](#provenance-template)).

## Current status

| City | Approved dataset | Bundled status |
| --- | --- | --- |
| Milano | Confini Amministrativi del Comune di Milano (DS2841) | **NOT YET BUNDLED** |
| Munich | Official Stadtbezirke, dissolved from the 25 unique districts | **NOT YET BUNDLED** |

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
| Status | **NOT YET BUNDLED** |

### Attribution requirement

CC BY 4.0 requires appropriate credit, a link to the licence, and an indication if changes were made.

When the dataset is shared or redistributed (including as an app asset), credit the Comune di Milano and this dataset, link to CC BY 4.0, and declare any modifications.

### Transformation and simplification

Transformation and geometry simplification are allowed under CC BY 4.0.

If the published GeoJSON is transformed, simplified, or otherwise modified before bundling, those modifications **must be declared** in attribution and in the provenance record for that internal boundary version.

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
| Status | **NOT YET BUNDLED** |

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

### Optional official cross-check (not primary)

Bayerische Vermessungsverwaltung ALKIS® Verwaltungsgebiete — Gemeinde München (AGS 09162000) may be used later as a cross-check only. It is not the primary municipal source for this register.

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
| Geometry bundled | No |
| Code / packages changed by this document | None |
