---
name: fiscalite-locale
description: Consulter la fiscalité locale des collectivités françaises (taux, bases, produits, exonérations) via les APIs open data DGFiP. Remplace la consultation manuelle de CCLLoc (impots.gouv.fr). Use when user says "fiscalité locale", "taux TFB", "taxe foncière", "CFE", "TEOM", "taux d'imposition commune", "REI", "bases fiscales", "produit fiscal", "comparer les taux", "pression fiscale", "CCLLoc", "impôts locaux", or asks about local tax rates, bases, or revenues for French municipalities.
license: MIT
metadata:
  author: Agentique
  version: 1.0.0
  category: workflow-automation
  tags: [fiscalite, collectivites, impots, dgfip, open-data, taxe-fonciere, cfe]
---

# Fiscalité locale — Données DGFiP

Skill pour interroger la fiscalité locale des collectivités françaises. Remplace la consultation manuelle de CCLLoc (impots.gouv.fr) par des appels API directs aux portails open data de la DGFiP.

**Aucune authentification requise.** Toutes les APIs sont ouvertes (licence Ouverte v2.0).

## Sources de données

| Source | Dataset | Contenu | Profondeur | Années |
|--------|---------|---------|------------|--------|
| **data.economie.gouv.fr** | `fiscalite-locale-des-particuliers` | Taux globaux TFB, TFNB, TH, TEOM par commune | 1 ligne/commune/an | 2021-2024 |
| **data.economie.gouv.fr** | `fiscalite-locale-des-entreprises` | Taux globaux CFE, TFB, TFNB, TEOM par commune | 1 ligne/commune/an | 2021-2024 |
| **data.ofgl.fr** | `rei` | REI complet (bases, taux, produits, exonérations, par destinataire) | ~700 lignes/commune/an | 2023-2024 |

**Quand utiliser quoi :**
- **Taux synthétiques** (vue rapide, comparaisons) → `data.economie.gouv.fr`
- **Détail complet** (bases imposables, produits, exonérations, ventilation par destinataire) → `data.ofgl.fr` REI

## API — Syntaxe commune (OpenDataSoft v2.1)

### Base URLs

```
https://data.economie.gouv.fr/api/explore/v2.1/catalog/datasets/{dataset_id}/records
https://data.ofgl.fr/api/explore/v2.1/catalog/datasets/{dataset_id}/records
```

### Paramètres de requête

| Paramètre | Description | Exemple |
|-----------|-------------|---------|
| `where` | Filtre ODSQL | `where=insee_com="75056" and exercice="2024"` |
| `select` | Champs / agrégations | `select=libcom,taux_global_tfb` |
| `group_by` | Regroupement | `group_by=exercice` |
| `order_by` | Tri | `order_by=taux_global_tfb desc` |
| `limit` | Max résultats (défaut 10, max 100) | `limit=50` |
| `offset` | Pagination | `offset=100` |

### Opérateurs WHERE

```sql
-- Égalité
insee_com="75056"

-- ET / OU
dep="75" and exercice="2024"
dep="75" or dep="92"

-- Recherche textuelle
libcom like "LYON"

-- Comparaisons
taux_global_tfb > 30
mpoid >= 10000
```

### Fonctions d'agrégation

```sql
select=count(*) as nb
select=avg(taux_global_tfb) as tfb_moyen
select=min(taux_global_tfb) as tfb_min, max(taux_global_tfb) as tfb_max
select=sum(mpoid) as pop_totale
```

## Dataset 1 : Fiscalité locale des particuliers

### Champs principaux

| Champ | Description |
|-------|-------------|
| `exercice` | Année fiscale |
| `insee_com` | Code INSEE commune |
| `libcom` | Nom commune |
| `dep` / `libdep` | Code / nom département |
| `reg` / `libreg` | Code / nom région |
| `sirepci` | SIREN de l'EPCI |
| `optepci` | Régime fiscal EPCI (FPU, FA, etc.) |
| `q03` | Nom du groupement |
| `mpoid` | Population INSEE |
| **Taux globaux** ||
| `taux_global_tfb` | **Taux global taxe foncière bâti** |
| `taux_global_tfnb` | **Taux global taxe foncière non bâti** |
| `taux_global_th` | **Taux global taxe habitation (rés. secondaires)** |
| `taux_plein_teom` | **Taux TEOM** |
| **Détail TFB** ||
| `e12vote` | TFB — taux voté commune |
| `e22` | TFB — taux syndicats |
| `e32vote` | TFB — taux voté GFP/EPCI |
| `e52` | TFB — TSE |
| `e52tasa` | TFB — TASA |
| `e52ggemapi` | TFB — GEMAPI |
| **Détail TH** ||
| `h12vote` | TH — taux voté commune |
| `h32vote` | TH — taux voté GFP/EPCI |
| `ind_majothrs` | Majoration résidences secondaires (OUI/NON) |
| `thsurtaxrstau` | % majoration résidences secondaires |

### curl Patterns

```bash
# Taux fiscaux d'une commune (dernière année)
response=$(curl -s "https://data.economie.gouv.fr/api/explore/v2.1/catalog/datasets/fiscalite-locale-des-particuliers/records?where=insee_com%3D%2275056%22&order_by=exercice%20desc&limit=1") && echo "$response" | jq .

# Évolution sur 4 ans
response=$(curl -s "https://data.economie.gouv.fr/api/explore/v2.1/catalog/datasets/fiscalite-locale-des-particuliers/records?where=insee_com%3D%2275056%22&select=exercice,taux_global_tfb,taux_global_th,taux_plein_teom&order_by=exercice&limit=10") && echo "$response" | jq .

# Top 10 taux TFB les plus élevés d'un département
response=$(curl -s "https://data.economie.gouv.fr/api/explore/v2.1/catalog/datasets/fiscalite-locale-des-particuliers/records?where=dep%3D%2234%22%20and%20exercice%3D%222024%22&select=libcom,insee_com,taux_global_tfb,mpoid&order_by=taux_global_tfb%20desc&limit=10") && echo "$response" | jq .

# Taux moyen TFB d'un département
response=$(curl -s "https://data.economie.gouv.fr/api/explore/v2.1/catalog/datasets/fiscalite-locale-des-particuliers/records?where=dep%3D%2234%22%20and%20exercice%3D%222024%22&select=avg(taux_global_tfb)%20as%20tfb_moyen,avg(taux_global_th)%20as%20th_moyen,avg(taux_plein_teom)%20as%20teom_moyen&limit=1") && echo "$response" | jq .

# Communes avec majoration résidences secondaires
response=$(curl -s "https://data.economie.gouv.fr/api/explore/v2.1/catalog/datasets/fiscalite-locale-des-particuliers/records?where=dep%3D%2275%22%20and%20exercice%3D%222024%22%20and%20ind_majothrs%3D%22OUI%22&select=libcom,thsurtaxrstau,taux_global_th&limit=20") && echo "$response" | jq .
```

## Dataset 2 : Fiscalité locale des entreprises

### Champs spécifiques (en plus des champs communs)

| Champ | Description |
|-------|-------------|
| `taux_global_cfe_hz` | **Taux global CFE hors zone** |
| `taux_global_cfe_zae` | Taux global CFE zone d'activités |
| `taux_global_cfe_eol` | Taux global CFE éoliennes |
| `p12vote` | CFE — taux voté commune |
| `p32_1vote` | CFE — taux voté GFP unique |
| `p32_hz` | CFE — GFP hors zone |
| `p52` | CFE — TSE |
| `p52tasa` | CFE — TASA |
| `p52ggemapi` | CFE — GEMAPI |

### curl Patterns

```bash
# Taux CFE d'une commune
response=$(curl -s "https://data.economie.gouv.fr/api/explore/v2.1/catalog/datasets/fiscalite-locale-des-entreprises/records?where=insee_com%3D%2275056%22%20and%20exercice%3D%222024%22&select=libcom,taux_global_cfe_hz,taux_global_cfe_zae,p12vote,p32_1vote&limit=1") && echo "$response" | jq .

# Comparaison CFE dans un département
response=$(curl -s "https://data.economie.gouv.fr/api/explore/v2.1/catalog/datasets/fiscalite-locale-des-entreprises/records?where=dep%3D%2234%22%20and%20exercice%3D%222024%22&select=libcom,taux_global_cfe_hz,mpoid&order_by=taux_global_cfe_hz%20desc&limit=10") && echo "$response" | jq .
```

## Dataset 3 : REI complet (OFGL)

Le REI donne le détail ligne par ligne : bases imposables, produits, exonérations, compensations, par taxe et par destinataire.

### Champs principaux

| Champ | Description |
|-------|-------------|
| `annee` | Exercice |
| `idcom` | Code INSEE commune |
| `libcom` | Nom commune |
| `strate` | Strate de population (1-10) |
| `z08` | Population INSEE |
| `dispositif_fiscal` | Type d'impôt : `FB`, `FNB`, `TH`, `CFE`, `TEOM-TIEOM`, `GEMAPI-*`, `IFER`, `TASA-*`, `TASCOM`, `TSE-*`, `CHAMBRE-*`, `FSRIF`, `TP-FNGIR` |
| `categorie` | Type de donnée : `Base`, `Taux`, `Produit`, `Exoneration`, `Compensation`, `Degrevement`, `Lissage`, `Abattement`, `Tarif`, `Perequation` |
| `destinataire` | Bénéficiaire : `Commune`, `GFP`, `Etat`, `Syndicats`, `Departement`, `Region`... |
| `var` | Code variable REI |
| `varlib` | Libellé complet de la variable |
| `valeur` | Montant (€) ou taux (%) |
| `secret_statistique` | Masquage statistique (null = OK, `sec_stat` = masqué) |

### curl Patterns

```bash
# Taux FB détaillés par destinataire
response=$(curl -s "https://data.ofgl.fr/api/explore/v2.1/catalog/datasets/rei/records?where=idcom%3D%2275056%22%20and%20annee%3D%222024%22%20and%20dispositif_fiscal%3D%22FB%22%20and%20categorie%3D%22Taux%22&select=varlib,destinataire,valeur&limit=50") && echo "$response" | jq .

# Bases imposables FB
response=$(curl -s "https://data.ofgl.fr/api/explore/v2.1/catalog/datasets/rei/records?where=idcom%3D%2275056%22%20and%20annee%3D%222024%22%20and%20dispositif_fiscal%3D%22FB%22%20and%20categorie%3D%22Base%22&select=varlib,destinataire,valeur&limit=50") && echo "$response" | jq .

# Produits fiscaux (recettes) par impôt
response=$(curl -s "https://data.ofgl.fr/api/explore/v2.1/catalog/datasets/rei/records?where=idcom%3D%2275056%22%20and%20annee%3D%222024%22%20and%20categorie%3D%22Produit%22&select=dispositif_fiscal,varlib,destinataire,valeur&order_by=valeur%20desc&limit=50") && echo "$response" | jq .

# Exonérations FB
response=$(curl -s "https://data.ofgl.fr/api/explore/v2.1/catalog/datasets/rei/records?where=idcom%3D%2275056%22%20and%20annee%3D%222024%22%20and%20dispositif_fiscal%3D%22FB%22%20and%20categorie%3D%22Exoneration%22&select=varlib,destinataire,valeur&limit=50") && echo "$response" | jq .

# Toutes les données d'une commune (paginé)
response=$(curl -s "https://data.ofgl.fr/api/explore/v2.1/catalog/datasets/rei/records?where=idcom%3D%2275056%22%20and%20annee%3D%222024%22&limit=100&offset=0") && echo "$response" | jq .total_count
# Utiliser offset pour paginer si total_count > 100
```

## Business Logic

### Interpréter l'intention

| L'utilisateur dit | Source | Requête |
|---|---|---|
| "taux de la commune X" | economie.gouv.fr particuliers | Filtrer par `insee_com`, dernière année |
| "combien de TFB à X" | economie.gouv.fr particuliers | `taux_global_tfb` |
| "CFE à X" | economie.gouv.fr entreprises | `taux_global_cfe_hz` |
| "comparer les taux du département" | economie.gouv.fr | `order_by=taux_global_tfb desc` par département |
| "bases imposables" | OFGL REI | `categorie="Base"` |
| "produit fiscal" / "recettes fiscales" | OFGL REI | `categorie="Produit"` |
| "exonérations" | OFGL REI | `categorie="Exoneration"` |
| "évolution des taux" | economie.gouv.fr | Même commune, toutes les années |
| "pression fiscale" / "effort fiscal" | economie.gouv.fr + calcul | Comparer taux communal vs moyenne strate/département |
| "majoration résidences secondaires" | economie.gouv.fr | `ind_majothrs`, `thsurtaxrstau` |

### Identifier la commune

Si l'utilisateur donne un nom plutôt qu'un code INSEE, utiliser le skill **INSEE** (API Geo) :
```bash
curl -s "https://geo.api.gouv.fr/communes?nom={nom}&boost=population&fields=nom,code,population,departement"
```
Puis utiliser le `code` retourné comme `insee_com` / `idcom`.

### Affichage

- Toujours afficher le **nom de la commune**, le **code INSEE** et l'**exercice**
- Formater les taux avec 2 décimales et le symbole `%` (ex: `21,19 %`)
- Formater les montants en euros avec séparateur de milliers (ex: `1 234 567 €`)
- Pour les comparaisons : utiliser des tableaux, trier du plus élevé au plus bas
- Toujours mentionner la **source** : "Source : DGFiP, REI {année}" ou "Source : data.economie.gouv.fr"
- Signaler les données sous **secret statistique** (`secret_statistique = "sec_stat"`)

### Strates de population (REI)

| Strate | Population |
|--------|------------|
| 1 | < 500 hab. |
| 2 | 500 à 1 999 |
| 3 | 2 000 à 3 499 |
| 4 | 3 500 à 4 999 |
| 5 | 5 000 à 9 999 |
| 6 | 10 000 à 19 999 |
| 7 | 20 000 à 49 999 |
| 8 | 50 000 à 99 999 |
| 9 | 100 000 à 299 999 |
| 10 | ≥ 300 000 hab. |

## Workflows types

### Fiche fiscale complète d'une commune

1. Identifier le code INSEE (API Geo si nom fourni)
2. Récupérer les taux globaux via `fiscalite-locale-des-particuliers` (dernière année)
3. Récupérer les taux CFE via `fiscalite-locale-des-entreprises`
4. Calculer la moyenne départementale pour comparaison (agrégation `avg`)
5. Présenter :

```
FICHE FISCALE — {Commune} ({code_INSEE}) — Exercice {année}
Population : {mpoid} hab. | EPCI : {q03} ({optepci})

                        Commune     Taux global     Moy. département
TFB                     {e12vote}%  {taux_global}%  {avg_dep}%
TFNB                    {b12vote}%  {taux_global}%  {avg_dep}%
TH (rés. sec.)          {h12vote}%  {taux_global}%  {avg_dep}%
CFE                     {p12vote}%  {taux_global}%  {avg_dep}%
TEOM                    —           {taux_plein}%   {avg_dep}%

Majoration rés. sec. : {ind_majothrs} ({thsurtaxrstau}%)

Source : DGFiP, fichier REI {année}
```

### Simulation d'impact (hausse de taux)

1. Récupérer la base nette via REI (`dispositif_fiscal="FB"`, `categorie="Base"`, chercher la variable de base nette commune)
2. Appliquer la variation de taux : `produit_supplementaire = base_nette × (nouveau_taux - ancien_taux) / 100`
3. Comparer le nouveau taux avec la moyenne de la strate

### Comparaison inter-communale

1. Récupérer toutes les communes d'un département ou EPCI
2. Trier par taux décroissant
3. Calculer moyenne, médiane, quartiles
4. Positionner la commune cible

## Error Handling

| Situation | Cause | Action |
|-----------|-------|--------|
| `total_count: 0` | Code INSEE incorrect ou exercice indisponible | Vérifier le code via API Geo, essayer un autre exercice |
| Valeurs `null` | Pas de données pour cette taxe (ex: pas de zone d'activités) | Signaler "non applicable" |
| `secret_statistique: "sec_stat"` | Commune trop petite, secret statistique | Signaler "donnée masquée (secret statistique)" |
| Réponse tronquée | Plus de 100 résultats | Paginer avec `offset` |

## Safety Rules

- **Lecture seule** : APIs en lecture uniquement, aucun risque de modification
- **Données publiques** : aucune donnée personnelle, uniquement des agrégats communaux
- **Citer la source** : toujours mentionner "DGFiP" et l'exercice
- **Prudence sur les simulations** : ce sont des estimations, les bases définitives sont notifiées par les services fiscaux

## Examples

### Example 1: Taux d'une commune
User says: "quels sont les taux d'imposition de Montpellier ?"
Actions:
1. API Geo : `communes?nom=Montpellier` → code INSEE 34172
2. `fiscalite-locale-des-particuliers?where=insee_com="34172"&order_by=exercice desc&limit=1`
3. `fiscalite-locale-des-entreprises?where=insee_com="34172"&order_by=exercice desc&limit=1`
4. Moyenne département 34 : agrégation `avg(taux_global_tfb)`
5. Afficher fiche fiscale complète avec comparaison
Result: Fiche avec TFB, TFNB, TH, CFE, TEOM + positionnement vs département

### Example 2: Évolution des taux
User says: "évolution de la taxe foncière à Lyon"
Actions:
1. Code INSEE Lyon : 69123
2. `fiscalite-locale-des-particuliers?where=insee_com="69123"&select=exercice,e12vote,taux_global_tfb&order_by=exercice`
3. Afficher tableau d'évolution 2021-2024
Result: Tableau annuel montrant l'évolution du taux voté et du taux global

### Example 3: Classement départemental
User says: "les communes avec la TFB la plus élevée dans l'Hérault"
Actions:
1. `fiscalite-locale-des-particuliers?where=dep="34" and exercice="2024"&select=libcom,insee_com,taux_global_tfb,mpoid&order_by=taux_global_tfb desc&limit=15`
2. Afficher classement avec nom, taux et population
Result: Top 15 communes par taux TFB décroissant

### Example 4: Bases et produits détaillés
User says: "détail des bases imposables et produits FB de Nîmes"
Actions:
1. Code INSEE Nîmes : 30189
2. REI bases : `rei?where=idcom="30189" and annee="2024" and dispositif_fiscal="FB" and categorie="Base"&select=varlib,destinataire,valeur`
3. REI produits : même requête avec `categorie="Produit"`
4. Afficher les deux tableaux
Result: Détail des bases nettes et produits par destinataire (commune, GFP, État)

## Troubleshooting

### Error: Aucun résultat pour un code INSEE
**Cause:** Code incorrect, ou commune nouvelle (fusion).
**Solution:** Vérifier via API Geo (`geo.api.gouv.fr/communes/{code}`). Pour les communes nouvelles, essayer le code de la commune déléguée.

### Error: Données manquantes sur le REI pour une année
**Cause:** Le REI OFGL ne couvre que 2023-2024.
**Solution:** Pour les années antérieures, utiliser `data.economie.gouv.fr` (taux globaux disponibles 2021-2024) ou le dataset REI brut sur data.economie.gouv.fr (depuis 1982, mais format différent).

### Error: Trop de résultats (pagination)
**Cause:** Requête REI sans filtre suffisant (ex: tout un département).
**Solution:** Toujours filtrer par `idcom` + `annee` + `dispositif_fiscal` + `categorie`. Utiliser `offset` pour paginer par tranches de 100.
