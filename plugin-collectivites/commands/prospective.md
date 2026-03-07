---
description: Lancer une prospective financiere pluriannuelle pour une collectivite
argument-hint: "<nom-collectivite> <horizon-annees>"
---

# Prospective financiere

Construire une prospective financiere pluriannuelle pour la collectivite indiquee.

## Usage

```
/modelisation-collectivites:prospective <nom-collectivite> <horizon>
```

### Arguments

- `nom-collectivite` — Nom de la commune, EPCI, departement ou region
- `horizon` — Nombre d'annees de projection (defaut : 5)

## Workflow

1. Rechercher la collectivite sur data.gouv.fr et recuperer ses donnees budgetaires et fiscales
2. Analyser les tendances historiques (3-5 ans)
3. Proposer les hypotheses pour les 3 scenarios (conservateur, realiste, optimiste)
4. Demander validation/ajustement des hypotheses a l'utilisateur
5. Calculer les projections et les ratios
6. Generer la restitution (Power BI, Excel, ou tableau formate)
