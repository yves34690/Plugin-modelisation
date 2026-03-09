---
name: bilan-previsionnel
description: Construire un bilan previsionnel sur 3 a 5 ans pour une entreprise. Utiliser quand l'utilisateur demande un bilan previsionnel, un bilan simplifie, l'evolution de la structure financiere, ou les ratios bilantiels (fonds de roulement, BFR, endettement).
---

# Bilan previsionnel

**Important** : Ce skill assiste dans la construction du bilan previsionnel mais ne se substitue pas a l'expertise d'un expert-comptable. Les projections doivent etre validees par des professionnels qualifies.

**Prerequis** : Le compte de resultat previsionnel (skill `previsionnel`) doit etre construit. Le plan de tresorerie (skill `tresorerie`) est recommande pour la coherence de la tresorerie.

## Methodologie

### 1. Recuperer les donnees des skills amont

Depuis les skills `previsionnel` et `tresorerie` :
- Resultat net par annee et par scenario
- Dotations aux amortissements
- Plan d'investissement (immobilisations, durees, amortissements)
- Tableau d'amortissement des emprunts (capital restant du)
- Apport en capital
- BFR et variation BFR (delais clients, fournisseurs, stocks)
- Solde de tresorerie cumule

### 2. Construire l'actif

#### Actif immobilise

| Poste | An 0 | An 1 | An 2 | An 3 |
|-------|------|------|------|------|
| Immobilisations incorporelles brutes | X€ | X€ | X€ | X€ |
| Immobilisations corporelles brutes | X€ | X€ | X€ | X€ |
| Total immobilisations brutes | X€ | X€ | X€ | X€ |
| Amortissements cumules | X€ | X€ | X€ | X€ |
| **Immobilisations nettes** | **X€** | **X€** | **X€** | **X€** |

Immobilisations brutes = investissements cumules depuis la creation :
- Annee N = immobilisations N-1 + nouveaux investissements N - cessions N

Amortissements cumules = somme des dotations depuis la creation :
- Annee N = amortissements N-1 + dotation N - amortissements des biens cedes

#### Actif circulant

| Poste | Formule | An 1 | An 2 | An 3 |
|-------|---------|------|------|------|
| Stocks | Stock moyen du secteur (si applicable) | X€ | X€ | X€ |
| Creances clients | CA TTC x delai paiement clients / 365 | X€ | X€ | X€ |
| Autres creances (TVA, CIR, etc.) | Estimation | X€ | X€ | X€ |
| **Tresorerie** | Depuis skill tresorerie (solde cumule) | **X€** | **X€** | **X€** |

### 3. Construire le passif

#### Capitaux propres

| Poste | An 0 | An 1 | An 2 | An 3 |
|-------|------|------|------|------|
| Capital social | X€ | X€ | X€ | X€ |
| Report a nouveau | 0€ | X€ | X€ | X€ |
| Resultat net de l'exercice | — | X€ | X€ | X€ |
| **Total capitaux propres** | **X€** | **X€** | **X€** | **X€** |

Report a nouveau = somme des resultats nets des exercices precedents (non distribues) :
- An 1 : 0€
- An 2 : resultat net an 1
- An 3 : resultat net an 1 + resultat net an 2

#### Dettes

| Poste | Formule | An 1 | An 2 | An 3 |
|-------|---------|------|------|------|
| Emprunts bancaires | Capital restant du (tableau d'amortissement) | X€ | X€ | X€ |
| Comptes courants d'associes | Apports non incorpores au capital | X€ | X€ | X€ |
| Dettes fournisseurs | Achats TTC x delai paiement fournisseurs / 365 | X€ | X€ | X€ |
| Dettes fiscales et sociales | Charges sociales M12 + TVA a payer | X€ | X€ | X€ |
| **Total dettes** | — | **X€** | **X€** | **X€** |

### 4. Verification de l'equilibre

```
TOTAL ACTIF = Immobilisations nettes + Actif circulant + Tresorerie
TOTAL PASSIF = Capitaux propres + Dettes

Verification : TOTAL ACTIF == TOTAL PASSIF
```

Si desequilibre :
- Verifier la coherence des creances/dettes avec les hypotheses du previsionnel
- Ajuster la tresorerie comme variable d'equilibre (elle absorbe l'ecart)
- En pratique, si le modele est bien construit, la tresorerie issue du plan de tresorerie equilibre automatiquement le bilan

### 5. Ratios bilantiels

| Ratio | Formule | Seuil | Interpretation |
|-------|---------|-------|----------------|
| Fonds de roulement (FR) | Capitaux permanents - Actif immobilise net | > 0 | Les ressources stables financent les immobilisations |
| Besoin en fonds de roulement (BFR) | Actif circulant hors tresorerie - Dettes CT | — | Besoin de financement du cycle d'exploitation |
| Tresorerie nette | FR - BFR | > 0 | L'entreprise dispose de liquidites |
| Taux d'endettement | Dettes financieres / Capitaux propres | < 1 | Autonomie financiere correcte |
| Autonomie financiere | Capitaux propres / Total bilan | > 20% | Solidite de la structure |
| Ratio de liquidite generale | Actif circulant / Dettes CT | > 1 | Capacite a faire face aux echeances |

### 6. Presenter les 3 scenarios

Tableau comparatif des ratios cles par scenario et par annee :

```
                        Conservateur    Realiste    Optimiste
FR an 3                 X€              X€          X€
BFR an 3                X€              X€          X€
Tresorerie nette an 3   X€              X€          X€
Endettement an 3        X.X             X.X         X.X
Autonomie an 3          X%              X%          X%
```

### 7. Stocker les resultats

Si ~~base de donnees est connectee :
- Inserer les postes du bilan dans la table `bilan_previsionnel`
- Inserer les ratios dans la table `resultats`

### 8. Restitution

Transmettre au skill `restitution` :
- Bilan simplifie annuel (3 scenarios)
- Graphique evolution actif/passif
- Graphique evolution FR/BFR/tresorerie nette
- Tableau des ratios bilantiels

## Regles

1. **Normes francaises** — presentation PCG simplifiee, adaptee a un bilan previsionnel (pas un bilan comptable complet)
2. **Equilibre obligatoire** — l'actif doit toujours etre egal au passif. Si ce n'est pas le cas, le modele a une erreur
3. **Coherence** — la tresorerie du bilan doit correspondre au solde cumule du plan de tresorerie
4. **Capitaux propres negatifs** — signaler comme alerte critique si les capitaux propres deviennent negatifs (pertes cumulees > capital)
5. **Simplification** — pour une creation, un bilan simplifie est suffisant. Ne pas detailler 50 postes comptables

## Skills lies

- **entretien-business-plan** — Phase prerequise d'entretien
- **previsionnel** — Compte de resultat (fournit le resultat net, les amortissements)
- **tresorerie** — Plan de tresorerie (fournit le solde cumule, le BFR)
- **rentabilite** — Seuil de rentabilite et point mort
- **plan-financement** — Plan de financement (coherence investissements/financement)
- **restitution** — Production des livrables Power BI / Excel
