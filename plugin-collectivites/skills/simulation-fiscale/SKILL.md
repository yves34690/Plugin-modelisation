---
name: simulation-fiscale
description: Simuler l'impact de decisions fiscales (taux, bases, exonerations) sur les recettes d'une collectivite. Utiliser quand l'utilisateur demande une simulation de taux, une estimation de produit fiscal, ou une comparaison avec la strate.
---

# Simulation fiscale

**Important** : Les simulations fiscales sont des estimations. Les bases definitives sont notifiees par les services fiscaux et peuvent differer des projections.

## Methodologie

### 1. Collecter les donnees fiscales

**Identification de la collectivite (~~insee)** :
- API Geo : `https://geo.api.gouv.fr/communes?nom={nom}&fields=nom,code,population,departement,epci`
- API Sirene : recherche par denomination + categorie juridique pour obtenir le SIREN

**Donnees fiscales (~~donnees publiques)** :
- Rechercher les etats fiscaux (etats 1259/1253) sur data.gouv.fr
- Recuperer : bases nettes, taux votes, produits, compensations
- Recuperer les donnees de la strate (moyennes nationales par taille)

Donnees necessaires par impot :
- **Taxe fonciere (TFPB)** : base nette, taux communal, taux intercommunal
- **CFE** : base nette, taux intercommunal
- **CVAE** : produit percu (allocation)
- **TH residuelle** (residences secondaires si applicable) : base, taux

### 2. Simuler les scenarios

#### Scenario 1 : Evolution des bases a taux constant
- Projeter les bases avec l'hypothese d'evolution physique (constructions neuves) et la revalorisation forfaitaire (loi de finances)
- Calculer le produit resultant a taux constant

#### Scenario 2 : Variation de taux
- Simuler l'impact d'une hausse/baisse de X points de taux
- Calculer le produit supplementaire ou la perte
- Comparer les nouveaux taux avec la strate (moyenne, mediane, quartiles)

#### Scenario 3 : Impact des exonerations
- Lister les exonerations en vigueur (ZRR, QPV, logement social, etc.)
- Simuler l'impact de leur maintien ou suppression
- Distinguer exonerations compensees et non compensees

### 3. Presentation des resultats

```
SIMULATION FISCALE — [Nom de la collectivite]

                        Base nette    Taux      Produit     Taux strate   Ecart
                        ----------    -----     --------    -----------   -----
TFPB                    XX XXX K€     XX.XX%    X XXX K€    XX.XX%        +/-X.XX
CFE                     XX XXX K€     XX.XX%    X XXX K€    XX.XX%        +/-X.XX
TH (res. sec.)          XX XXX K€     XX.XX%    X XXX K€    XX.XX%        +/-X.XX

PRODUIT FISCAL TOTAL                            X XXX K€

Simulation hausse TFPB +1 point :               +XXX K€
Simulation hausse CFE +0.5 point :               +XXX K€
```

### 4. Ratios et alertes

- **Effort fiscal** : produit 4 taxes / potentiel fiscal
- **Coefficient de mobilisation du potentiel fiscal (CMPF)**
- Alerte si les taux depassent significativement la strate
- Alerte si la pression fiscale par habitant est dans le quartile superieur
