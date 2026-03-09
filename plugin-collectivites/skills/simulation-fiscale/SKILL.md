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

**Données fiscales (~~fiscalite)** :

Taux globaux (vue rapide) :
```bash
# Taux synthétiques via data.economie.gouv.fr
curl -s "https://data.economie.gouv.fr/api/explore/v2.1/catalog/datasets/fiscalite-locale-des-particuliers/records?where=insee_com%3D%22{code}%22&order_by=exercice%20desc&limit=1"

# Taux CFE via dataset entreprises
curl -s "https://data.economie.gouv.fr/api/explore/v2.1/catalog/datasets/fiscalite-locale-des-entreprises/records?where=insee_com%3D%22{code}%22&order_by=exercice%20desc&limit=1"
```

Détail REI (bases, produits, exonérations) :
```bash
# Bases nettes FB
curl -s "https://data.ofgl.fr/api/explore/v2.1/catalog/datasets/rei/records?where=idcom%3D%22{code}%22%20and%20annee%3D%222024%22%20and%20dispositif_fiscal%3D%22FB%22%20and%20categorie%3D%22Base%22&select=varlib,destinataire,valeur&limit=50"

# Produits fiscaux
curl -s "https://data.ofgl.fr/api/explore/v2.1/catalog/datasets/rei/records?where=idcom%3D%22{code}%22%20and%20annee%3D%222024%22%20and%20categorie%3D%22Produit%22&select=dispositif_fiscal,varlib,destinataire,valeur&order_by=valeur%20desc&limit=50"

# Exonérations
curl -s "https://data.ofgl.fr/api/explore/v2.1/catalog/datasets/rei/records?where=idcom%3D%22{code}%22%20and%20annee%3D%222024%22%20and%20categorie%3D%22Exoneration%22&select=dispositif_fiscal,varlib,valeur&limit=50"
```

Moyenne de la strate / département pour comparaison :
```bash
# Moyenne départementale TFB
curl -s "https://data.economie.gouv.fr/api/explore/v2.1/catalog/datasets/fiscalite-locale-des-particuliers/records?where=dep%3D%22{dep}%22%20and%20exercice%3D%222024%22&select=avg(taux_global_tfb)%20as%20tfb_moyen,avg(taux_global_th)%20as%20th_moyen&limit=1"
```

Données nécessaires par impôt :
- **Taxe fonciere (TFPB)** : base nette, taux communal, taux intercommunal → REI `dispositif_fiscal="FB"`
- **CFE** : base nette, taux intercommunal → REI `dispositif_fiscal="CFE"`
- **CVAE** : produit percu (allocation) → REI `dispositif_fiscal` correspondant
- **TH residuelle** (residences secondaires si applicable) : base, taux → REI `dispositif_fiscal="TH"`

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
