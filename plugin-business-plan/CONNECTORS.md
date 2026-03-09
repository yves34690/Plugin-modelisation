# Connecteurs

## Fonctionnement des references aux outils

Les fichiers du plugin utilisent `~~categorie` comme placeholder pour l'outil connecte par l'utilisateur dans cette categorie. Par exemple, `~~donnees publiques` designe datagouv ou tout autre serveur MCP equivalent.

## Connecteurs de ce plugin

| Categorie | Placeholder | Serveur inclus | Autres options |
|-----------|-------------|----------------|----------------|
| Donnees publiques | `~~donnees publiques` | datagouv (data.gouv.fr) | — |
| Entreprises & territoires | `~~insee` | Skill INSEE (Sirene, Melodi, Geo, Adresse) | — |
| Statistiques europeennes | `~~eurostat` | Skill Eurostat (API Statistics) | — |
| Donnees mondiales | `~~datacommons` | MCP Data Commons (Google) | — |
| Base de donnees | `~~base de donnees` | — (PostgreSQL a configurer) | Supabase, SQLite |
| Restitution / BI | `~~restitution` | — (Power BI a configurer) | Excel, Metabase |
| Suite bureautique | `~~bureautique` | Microsoft 365 | Google Workspace |
| Aides et subventions | `~~aides` | Skill aides-territoires (aides-territoires.beta.gouv.fr) | — |
| Recherche web | `~~recherche` | — (web search natif Cowork) | — |

## Sources de donnees par usage

| Besoin | Source prioritaire | Fallback |
|--------|-------------------|----------|
| Identifier une entreprise (SIREN, SIRET, NAF, adresse) | `~~insee` (API Sirene) | `~~donnees publiques` |
| Compter les entreprises d'un secteur/zone | `~~insee` (API Sirene, comptage par NAF + commune) | — |
| Zone de chalandise (population, communes, EPCI) | `~~insee` (API Geo) | `~~datacommons` |
| Demographie locale (revenus, CSP, age) | `~~insee` (API Melodi) | `~~donnees publiques` |
| Benchmarks sectoriels (ratios financiers, taux de survie) | `~~donnees publiques` + `~~recherche` | — |
| Inflation, indices des prix (IPC, IPCH) | `~~eurostat` (HICP) ou `~~insee` (Melodi IPC) | `~~datacommons` |
| Taux d'interet bancaires | `~~eurostat` (taux court terme) | Banque de France (web) |
| PIB, croissance economique | `~~eurostat` (nama_10_gdp) | `~~datacommons` |
| Chomage local/national | `~~insee` (Melodi) ou `~~eurostat` (une_rt_m) | `~~datacommons` |
| Geocodage adresse du projet | `~~insee` (API Adresse) | — |
| Aides creation/reprise, subventions | `~~aides` (aides-territoires) | `~~recherche` |
