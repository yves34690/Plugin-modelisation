---
description: Simuler l'impact de decisions fiscales sur les recettes d'une collectivite
argument-hint: "<nom-collectivite>"
---

# Simulation fiscale

Simuler les effets d'une modification de taux ou de bases sur le produit fiscal.

## Usage

```
/modelisation-collectivites:simulation-fiscale <nom-collectivite>
```

### Arguments

- `nom-collectivite` — Nom de la collectivite

## Workflow

1. Recuperer les donnees fiscales actuelles (bases, taux, produits)
2. Comparer avec la strate demographique
3. Proposer des scenarios de variation de taux
4. Calculer l'impact sur les recettes
5. Presenter les resultats avec comparaison strate
