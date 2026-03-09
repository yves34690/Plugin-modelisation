# Connecteurs

## Fonctionnement des references aux outils

Les fichiers du plugin utilisent `~~categorie` comme placeholder pour l'outil connecte par l'utilisateur dans cette categorie. Par exemple, `~~donnees publiques` designe datagouv ou tout autre serveur MCP equivalent.

## Connecteurs de ce plugin

| Categorie | Placeholder | Serveur inclus | Autres options |
|-----------|-------------|----------------|----------------|
| Donnees publiques | `~~donnees publiques` | datagouv (data.gouv.fr) | — |
| Fiscalite locale | `~~fiscalite` | Skill fiscalite-locale (APIs DGFiP open data) | — |
| Entreprises & territoires | `~~insee` | Skill INSEE (Sirene, Melodi, Geo, Adresse) | API Banatic |
| Statistiques europeennes | `~~eurostat` | Skill Eurostat (API Statistics) | — |
| Donnees mondiales | `~~datacommons` | MCP Data Commons (Google) | — |
| Base de donnees | `~~base de donnees` | — (PostgreSQL a configurer) | Supabase, SQLite |
| Restitution / BI | `~~restitution` | — (Power BI a configurer) | Excel, Metabase |
| Suite bureautique | `~~bureautique` | Microsoft 365 | Google Workspace |

## Sources de donnees par usage

| Besoin | Source prioritaire | Fallback |
|--------|-------------------|----------|
| Identifier une collectivite (code INSEE, SIREN, population, EPCI) | `~~insee` (API Geo + Sirene) | `~~donnees publiques` |
| Demographie, population legale, projections | `~~insee` (API Melodi) | `~~datacommons` |
| Budgets collectivites, balances comptables | `~~donnees publiques` (data.gouv.fr) | — |
| Fiscalite locale — taux globaux (TFB, TH, CFE, TEOM) | `~~fiscalite` (data.economie.gouv.fr) | `~~donnees publiques` |
| Fiscalite locale — detail (bases, produits, exonerations) | `~~fiscalite` (data.ofgl.fr REI) | — |
| Comparaison strate / departement (taux moyens) | `~~fiscalite` (agregation avg) | — |
| Dotations (DGF, FCTVA, DETR, DSIL) | `~~donnees publiques` (data.gouv.fr) | — |
| Inflation, indices des prix (IPC, IPCH) | `~~eurostat` (HICP) ou `~~insee` (Melodi IPC) | `~~datacommons` |
| Taux d'interet de reference | `~~eurostat` (taux court terme) | Banque de France (web) |
| Comparaison internationale (dette, pression fiscale) | `~~eurostat` | `~~datacommons` |
| Geocodage, contours communes | `~~insee` (API Geo + Adresse) | — |
