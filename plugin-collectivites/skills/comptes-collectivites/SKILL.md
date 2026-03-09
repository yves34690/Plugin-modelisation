---
name: comptes-collectivites
description: Consulter les comptes de gestion des collectivites territoriales francaises (agregats financiers, epargne, dette, recettes/depenses) via l'API OFGL (data.ofgl.fr). Utiliser quand l'utilisateur demande les comptes d'une commune, les donnees financieres d'une collectivite, l'epargne brute, la dette, le fonds de roulement, ou toute donnee financiere agrege d'une collectivite.
---

# Comptes de gestion des collectivites — OFGL

**Source** : Observatoire des Finances et de la Gestion publique Locale (data.ofgl.fr)
**API** : OpenDataSoft v2.1 — meme pattern que le skill fiscalite-locale (data.ofgl.fr REI)
**Authentification** : aucune requise

## Datasets disponibles

### Par type de collectivite

| Type | Dataset | Description |
|------|---------|-------------|
| Communes | `ofgl-base-communes-consolidee` | 49 agregats financiers consolides BP+BA (2017-2024) |
| GFP (groupements a fiscalite propre) | `ofgl-base-gfp-consolidee` | Agregats financiers des EPCI |
| Departements | `ofgl-base-departements` | Agregats financiers departementaux |
| Departements (fonctionnel) | `ofgl-base-departements-fonctionnelle` | Par fonction budgetaire |
| Regions | `ofgl-base-regions-consolidee` | Agregats financiers regionaux |
| Ensembles intercommunaux | `ofgl-base-ei` | Agregats des ensembles intercommunaux |

### Dotations detaillees

| Dataset | Description |
|---------|-------------|
| `dotations-gfp` | Dotations detaillees des GFP (DGF, potentiel fiscal, etc.) |
| `dotations-regions` | Dotations detaillees des regions |

## Champs de filtrage

| Champ | Description | Exemple |
|-------|-------------|---------|
| `com_code` | Code INSEE commune (5 chiffres) | `13055` (Marseille) |
| `siren` | SIREN de la collectivite | `211300553` |
| `year(exer)` | Annee d'exercice | `2023` |
| `tranche_population` | Strate demographique | `10 000 a 19 999 hab` |
| `dep_code` | Code departement | `13` |
| `reg_code` | Code region | `93` (PACA) |

## Structure des donnees

**Important** : chaque record contient UN SEUL agregat (pas un record avec 50 colonnes). Pour une collectivite et une annee donnees, il y a ~50 records, un par agregat financier.

### Champs de chaque record

| Champ | Description |
|-------|-------------|
| `agregat` | Libelle de l'agregat financier (ex: "Epargne brute") |
| `montant` | Montant en euros |
| `montant_bp` | Montant budget principal |
| `montant_ba` | Montant budgets annexes |
| `montant_en_millions` | Montant en millions d'euros |
| `euros_par_habitant` | Montant par habitant |
| `com_code` / `com_name` | Code INSEE et nom de la commune |
| `dep_code` / `dep_name` | Code et nom du departement |
| `reg_code` / `reg_name` | Code et nom de la region |
| `epci_code` / `epci_name` | Code et nom de l'EPCI |
| `siren` | SIREN de la collectivite |
| `exer` | Annee d'exercice |
| `ptot` | Population totale |
| `tranche_population` | Code de strate demographique |

### Les 50 agregats financiers (valeurs du champ `agregat`)

**Recettes** :
- Recettes totales / Recettes totales hors emprunts
- Recettes de fonctionnement
- Impots et taxes / Impots locaux / Autres impots et taxes / TVA
- Concours de l'Etat / Dotation globale de fonctionnement
- Fiscalite reversee / Perequations et compensations fiscales
- Autres dotations de fonctionnement / Autres dotations et subventions
- Ventes de biens et services / Autres recettes de fonctionnement
- Recettes d'investissement / Recettes d'investissement hors emprunts
- Subventions recues et participations / FCTVA / Emprunts hors GAD
- Autres recettes d'investissement / Produit des cessions d'immobilisations

**Depenses** :
- Depenses totales / Depenses totales hors remb
- Depenses de fonctionnement
- Frais de personnel / Achats et charges externes
- Depenses d'intervention / Subventions aux personnes de droit prive
- Charges financieres / Autres depenses de fonctionnement
- Depenses d'investissement / Depenses d'investissement hors remb
- Depenses d'equipement / Subventions d'equipement versees
- Remboursements d'emprunts hors GAD / Autres depenses d'investissement
- Annuite de la dette

**Epargne** :
- Epargne de gestion / Epargne brute / Epargne nette

**Equilibre** :
- Fonds de roulement / Variation du fonds de roulement
- Capacite ou besoin de financement / Flux net de dette

**Dette** :
- Encours de dette / Encours de dette - Dettes bancaires et assimilees
- Encours de dette - Depots et cautionnements recus
- Depots au Tresor / Credits de tresorerie

## Patterns API

### Fiche financiere complete (1 collectivite, 1 annee)

```bash
# Commune par code INSEE — tous les agregats (limit=60 car ~50 records par commune/annee)
curl -s "https://data.ofgl.fr/api/explore/v2.1/catalog/datasets/ofgl-base-communes-consolidee/records?where=com_code%3D%22{code_insee}%22%20and%20year(exer)%3D{annee}&select=agregat,montant,euros_par_habitant&limit=60"

# Exemple : Marseille 2023
curl -s "https://data.ofgl.fr/api/explore/v2.1/catalog/datasets/ofgl-base-communes-consolidee/records?where=com_code%3D%2213055%22%20and%20year(exer)%3D2023&select=agregat,montant,euros_par_habitant&limit=60"
```

### Agregats specifiques (filtrer par nom)

```bash
# Epargne brute et nette uniquement
curl -s "https://data.ofgl.fr/api/explore/v2.1/catalog/datasets/ofgl-base-communes-consolidee/records?where=com_code%3D%22{code_insee}%22%20and%20year(exer)%3D{annee}%20and%20(agregat%3D%22Epargne%20brute%22%20or%20agregat%3D%22Epargne%20nette%22)&select=agregat,montant,euros_par_habitant&limit=10"
```

### Historique pluriannuel (1 collectivite, N annees, 1 agregat)

```bash
# Evolution epargne brute sur 5 ans
curl -s "https://data.ofgl.fr/api/explore/v2.1/catalog/datasets/ofgl-base-communes-consolidee/records?where=com_code%3D%22{code_insee}%22%20and%20year(exer)%3E%3D2019%20and%20agregat%3D%22Epargne%20brute%22&select=exer,montant,euros_par_habitant&order_by=exer%20asc&limit=10"

# Plusieurs agregats cles sur 5 ans
curl -s "https://data.ofgl.fr/api/explore/v2.1/catalog/datasets/ofgl-base-communes-consolidee/records?where=com_code%3D%22{code_insee}%22%20and%20year(exer)%3E%3D2019%20and%20agregat%20in%20(%22Epargne%20brute%22,%22Epargne%20nette%22,%22Encours%20de%20dette%22,%22Depenses%20d%27equipement%22,%22Frais%20de%20personnel%22)&select=exer,agregat,montant&order_by=exer%20asc&limit=50"
```

### Comparaison strate (agregation par tranche de population)

```bash
# Moyenne de la strate pour un agregat
curl -s "https://data.ofgl.fr/api/explore/v2.1/catalog/datasets/ofgl-base-communes-consolidee/records?where=tranche_population%3D{strate}%20and%20year(exer)%3D{annee}%20and%20agregat%3D%22Epargne%20brute%22&select=avg(euros_par_habitant)%20as%20moy_par_hab,count(*)%20as%20nb_communes&limit=1"

# Par departement — epargne brute moyenne par habitant
curl -s "https://data.ofgl.fr/api/explore/v2.1/catalog/datasets/ofgl-base-communes-consolidee/records?where=dep_code%3D%22{dep}%22%20and%20year(exer)%3D{annee}%20and%20agregat%3D%22Epargne%20brute%22&select=avg(euros_par_habitant)%20as%20moy_par_hab&limit=1"
```

### GFP (EPCI)

```bash
# Par SIREN de l'EPCI
curl -s "https://data.ofgl.fr/api/explore/v2.1/catalog/datasets/ofgl-base-gfp-consolidee/records?where=siren%3D%22{siren}%22%20and%20year(exer)%3D{annee}&limit=1"
```

### Departements

```bash
curl -s "https://data.ofgl.fr/api/explore/v2.1/catalog/datasets/ofgl-base-departements/records?where=dep_code%3D%22{dep_code}%22%20and%20year(exer)%3D{annee}&limit=1"
```

### Regions

```bash
curl -s "https://data.ofgl.fr/api/explore/v2.1/catalog/datasets/ofgl-base-regions-consolidee/records?where=reg_code%3D%22{reg_code}%22%20and%20year(exer)%3D{annee}&limit=1"
```

### Dotations GFP

```bash
curl -s "https://data.ofgl.fr/api/explore/v2.1/catalog/datasets/dotations-gfp/records?where=siren%3D%22{siren}%22%20and%20year(exer)%3D{annee}&limit=1"
```

## Regles

1. **Consolide BP+BA** — les datasets `-consolidee` incluent budget principal + budgets annexes. Preferer ces datasets sauf besoin specifique.
2. **Annee N-1** — les comptes de gestion sont disponibles avec ~1 an de decalage. L'annee la plus recente est generalement N-1.
3. **Code INSEE vs SIREN** — utiliser `com_code` pour les communes, `siren` pour les EPCI et autres.
4. **Strate** — les valeurs de `tranche_population` sont des libelles textuels (ex: "10 000 a 19 999 hab"). Verifier les valeurs exactes via un appel sans filtre de strate d'abord.
5. **Noms de champs** — les noms exacts des agregats peuvent varier selon le dataset. En cas de doute, faire un appel sans `select` pour voir tous les champs disponibles.

## Skills lies

- **fiscalite-locale** — Detail des taux, bases et produits fiscaux (REI)
- **entretien-collectivite** — Phase prerequise d'entretien
- **prospective** — Projection pluriannuelle (utilise les agregats OFGL comme base historique)
- **simulation-fiscale** — Simulation d'impact fiscal
