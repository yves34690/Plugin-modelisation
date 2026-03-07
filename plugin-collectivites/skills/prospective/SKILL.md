---
name: prospective-financiere
description: Construire une prospective financiere pluriannuelle pour une collectivite territoriale. Utiliser quand l'utilisateur demande une projection budgetaire, une analyse de capacite d'autofinancement, ou une simulation de trajectoire financiere.
---

# Prospective financiere

**Important** : Ce skill assiste dans la construction de modeles financiers mais ne se substitue pas a l'expertise d'un directeur financier. Les projections doivent etre validees par des professionnels qualifies.

## Methodologie

### 1. Identifier la collectivite

Demander a l'utilisateur :
- Nom et type de collectivite (commune, EPCI, departement, region)
- Code INSEE ou SIREN
- Population (si non trouvee via ~~donnees publiques)

### 2. Collecter les donnees historiques

Si ~~donnees publiques est connecte :
- Rechercher les budgets de la collectivite sur data.gouv.fr (`search_datasets` avec mots-cles : budget, collectivite, nom)
- Recuperer les comptes administratifs des 3-5 derniers exercices
- Recuperer les donnees fiscales (bases, taux, produits)
- Recuperer les donnees demographiques

Si aucune source connectee :
> Connectez ~~donnees publiques pour recuperer automatiquement les budgets et donnees fiscales. Vous pouvez aussi fournir les comptes administratifs en fichier Excel/CSV.

### 3. Construire la section de fonctionnement

#### Recettes de fonctionnement
| Poste | Source de donnees | Hypothese type |
|-------|-------------------|----------------|
| Produit fiscal (TF, TH residuelle, CFE, CVAE) | Bases x taux historiques | Evolution des bases + decision de taux |
| Dotations (DGF, DSU, DSR, DNP) | Historique + loi de finances | Tendance nationale + strate |
| Attributions de compensation (AC) | EPCI / Commune | Stable sauf decision CLECT |
| Autres recettes (tarifs, redevances) | Historique | Inflation ou decision politique |

#### Depenses de fonctionnement
| Poste | Source de donnees | Hypothese type |
|-------|-------------------|----------------|
| Charges de personnel | Historique | GVT + mesures nationales + politique RH |
| Charges a caractere general | Historique | Inflation + decisions |
| Charges financieres (interets dette) | Tableau d'amortissement | Echeancier + nouveaux emprunts |
| Subventions versees | Historique | Politique locale |
| Autres charges | Historique | Tendance |

### 4. Calculer les soldes intermediaires

```
Recettes reelles de fonctionnement (RRF)
- Depenses reelles de fonctionnement (DRF)
= EPARGNE BRUTE (ou autofinancement brut)

Epargne brute
- Remboursement en capital de la dette
= EPARGNE NETTE (ou autofinancement net)
```

**Ratios cles :**
- Taux d'epargne brute = Epargne brute / RRF (alerte si < 7-8%)
- Taux d'epargne nette = Epargne nette / RRF (alerte si < 0%)
- Capacite de desendettement = Encours de dette / Epargne brute (alerte si > 12 ans)

### 5. Construire la section d'investissement

| Poste | Source | Hypothese |
|-------|--------|-----------|
| Depenses d'equipement | PPI si existant | Programme defini par l'elu |
| Subventions recues (FCTVA, DETR, DSIL, Region, Dept) | Taux moyens historiques | % des depenses eligibles |
| Emprunts | Calcul en equilibre | Besoin residuel apres autofinancement et subventions |
| Autofinancement (epargne nette) | Calcul | Resultat de la section fonctionnement |

### 6. Generer les 3 scenarios

Pour chaque variable, definir 3 hypotheses :

| Variable | Conservateur | Realiste | Optimiste |
|----------|-------------|----------|-----------|
| Evolution bases fiscales | +0.5%/an | +1.5%/an | +2.5%/an |
| Evolution DGF | -1%/an | Stable | +0.5%/an |
| Inflation (charges generales) | +3%/an | +2%/an | +1.5%/an |
| GVT + mesures salariales | +3%/an | +2.5%/an | +2%/an |
| Taux d'interet nouveaux emprunts | 4.5% | 3.5% | 2.5% |

> Ces valeurs par defaut doivent etre calibrees avec les donnees de reference de ~~donnees publiques et adaptees a la strate de la collectivite.

### 7. Stocker les resultats

Si ~~base de donnees est connectee :
- Inserer les variables dans la table `hypotheses`
- Inserer les projections annuelles dans la table `projections`
- Inserer les ratios dans la table `ratios`

### 8. Restitution

Si ~~restitution est connectee :
- Generer le tableau de prospective (format standard DGFIP)
- Graphiques : evolution epargne brute/nette, trajectoire de dette, capacite de desendettement
- Comparaison des 3 scenarios sur un meme graphique

Sinon :
- Generer un fichier Excel avec onglets par scenario
- Inclure les graphiques dans Excel
