---
description: Lancer un business plan complet pour un projet d'entreprise
argument-hint: "<description-projet>"
---

# Business Plan

Construire un business plan financier complet pour le projet decrit.

## Usage

```
/modelisation-business-plan:business-plan <description-projet>
```

### Arguments

- `description-projet` — Description courte du projet (activite, secteur, stade)

## Workflow

1. Lancer l'entretien structure (skill `entretien-business-plan`) pour qualifier le besoin
2. Rechercher les benchmarks sectoriels et donnees de reference
3. Produire le diagnostic de faisabilite
4. Proposer les hypotheses pour les 3 scenarios (conservateur, realiste, optimiste)
5. Demander validation/ajustement des hypotheses a l'utilisateur
6. Construire le compte de resultat previsionnel (skill `previsionnel`)
7. Construire le plan de tresorerie (skill `tresorerie`)
8. Calculer le seuil de rentabilite (skill `rentabilite`)
9. Generer la restitution (Power BI, Excel, ou tableau formate)
