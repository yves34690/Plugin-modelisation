---
description: Calculer le seuil de rentabilite et le point mort d'une activite
argument-hint: "<description-projet>"
---

# Rentabilite

Calculer le seuil de rentabilite (break-even) et le point mort, avec analyse de sensibilite.

## Usage

```
/modelisation-business-plan:rentabilite <description-projet>
```

### Arguments

- `description-projet` — Description du projet ou de l'entreprise

## Workflow

1. Si l'entretien n'a pas ete fait, le lancer d'abord (skill `entretien-business-plan`)
2. Classifier les charges en fixes et variables
3. Calculer le seuil de rentabilite en valeur et en volume
4. Calculer le point mort (mois d'atteinte de la rentabilite)
5. Produire l'analyse de sensibilite (prix, volume, charges)
6. Presenter les resultats pour les 3 scenarios
7. Generer la restitution (graphique du break-even, tableau de sensibilite)
