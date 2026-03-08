---
description: Construire un compte de resultat previsionnel pour une entreprise
argument-hint: "<description-projet> <horizon-annees>"
---

# Previsionnel

Construire un compte de resultat previsionnel avec les soldes intermediaires de gestion.

## Usage

```
/modelisation-business-plan:previsionnel <description-projet> <horizon>
```

### Arguments

- `description-projet` — Description du projet ou de l'entreprise
- `horizon` — Nombre d'annees de projection (defaut : 3)

## Workflow

1. Si l'entretien n'a pas ete fait, le lancer d'abord (skill `entretien-business-plan`)
2. Valider les hypotheses de CA, charges et investissements
3. Construire le compte de resultat mois par mois (an 1) puis annuel (an 2+)
4. Calculer les SIG (marge brute, VA, EBE, resultat d'exploitation, resultat net)
5. Presenter les 3 scenarios en parallele
6. Generer la restitution
