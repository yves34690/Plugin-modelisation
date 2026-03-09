---
name: tresorerie
description: Construire un plan de tresorerie mensuel sur 12 a 18 mois. Utiliser quand l'utilisateur demande un plan de tresorerie, un budget de tresorerie, une prevision de cash, ou veut anticiper ses besoins de financement court terme.
---

# Plan de tresorerie

**Important** : Ce skill assiste dans la construction du plan de tresorerie mais ne se substitue pas a l'expertise d'un expert-comptable. Les projections doivent etre validees par des professionnels qualifies.

**Prerequis** : Le compte de resultat previsionnel (skill `previsionnel`) doit etre construit, ou a minima les hypotheses de CA et charges doivent etre validees.

## Methodologie

### 1. Comprendre la difference resultat / tresorerie

> Le resultat est une opinion, la tresorerie est un fait.

Le plan de tresorerie traduit le previsionnel en flux reels d'encaissements et de decaissements, en tenant compte :
- Des **decalages de paiement** (delais clients, fournisseurs, TVA)
- Des **flux non comptables** (emprunts, apports, remboursements capital)
- De la **TVA** (collectee, deductible, a decaisser)
- Des **investissements** (sorties de tresorerie, pas dans le resultat)

### 2. Parametrer les decalages

| Parametre | Usuel secteur | Valeur retenue | Impact |
|-----------|---------------|----------------|--------|
| Delai paiement clients | X jours | X jours | Retarde les encaissements |
| Delai paiement fournisseurs | X jours | X jours | Retarde les decaissements |
| Rotation stocks | X jours | X jours | Immobilise du cash |
| TVA | Regime | Mensuel/Trimestriel | Decalage de tresorerie |
| Charges sociales | Mensuel/Trimestriel | Selon statut | Decalage |
| Impot (IS/IR) | Acomptes trimestriels | Selon regime | Decalage |

**Regles par statut :**
- **Micro-entreprise** : pas de TVA (franchise en base si < seuils), cotisations mensuelles/trimestrielles
- **EI/EURL au reel** : TVA mensuelle ou trimestrielle, acomptes IS ou IR
- **SAS/SARL** : TVA mensuelle ou trimestrielle, IS avec acomptes

### 3. Construire le tableau mois par mois

```
PLAN DE TRESORERIE — [Nom du projet] — Scenario [X]

                        M1      M2      M3      ...     M12     TOTAL
─────────────────────────────────────────────────────────────────────
ENCAISSEMENTS
  CA TTC encaisse        X€      X€      X€              X€      X€
  Apport personnel       X€      —       —               —       X€
  Emprunt bancaire       X€      —       —               —       X€
  Subventions            —       —       X€              —       X€
  Autres encaissements   —       —       —               —       —
─────────────────────────────────────────────────────────────────────
TOTAL ENCAISSEMENTS     X€      X€      X€              X€      X€

DECAISSEMENTS
  Achats TTC             X€      X€      X€              X€      X€
  Loyer + charges        X€      X€      X€              X€      X€
  Salaires nets          X€      X€      X€              X€      X€
  Charges sociales       —       X€      —               X€      X€
  Remuneration dirigeant X€      X€      X€              X€      X€
  Cotisations dirigeant  —       X€      —               X€      X€
  Assurances             X€      X€      X€              X€      X€
  Honoraires             X€      X€      X€              X€      X€
  Marketing              X€      X€      X€              X€      X€
  Autres charges         X€      X€      X€              X€      X€
  TVA a decaisser        —       —       X€              X€      X€
  Investissements TTC    X€      —       —               —       X€
  Remboursement emprunt  —       X€      X€              X€      X€
  Impot (IS/IR)          —       —       —               X€      X€
─────────────────────────────────────────────────────────────────────
TOTAL DECAISSEMENTS     X€      X€      X€              X€      X€

SOLDE MENSUEL           X€      X€      X€              X€      X€
TRESORERIE CUMULEE      X€      X€      X€              X€      X€
```

### 4. Gestion de la TVA

#### Calcul mensuel

```
TVA collectee (sur ventes TTC du mois)
- TVA deductible sur achats (achats TTC du mois)
- TVA deductible sur immobilisations (investissements du mois)
= TVA a decaisser (si positif) ou credit de TVA (si negatif)
```

#### Regimes de TVA

| Regime | Seuil CA | Periodicite | Decalage |
|--------|----------|------------|----------|
| Franchise en base | < 36 800€ (services) / 91 900€ (ventes) | — | Pas de TVA |
| Reel simplifie | < 789 000€ (services) / 840 000€ (ventes) | 2 acomptes + regularisation | Semestriel |
| Reel normal | Au-dessus | Mensuel | M+1 |

### 5. Indicateurs cles

| Indicateur | Formule | Seuil d'alerte |
|------------|---------|----------------|
| Tresorerie minimale | Min des soldes cumules | < 0 |
| Mois critique | Premier mois a solde cumule negatif | — |
| BFR | Creances clients + stocks - dettes fournisseurs | En croissance > CA |
| Variation BFR | BFR fin de periode - BFR debut | Forte hausse = besoin de financement |
| Couverture charges fixes | Tresorerie / charges fixes mensuelles | < 2 mois |

### 6. Alertes automatiques

Signaler systematiquement :
- **Solde cumule negatif** → besoin de financement court terme (decouvert, affacturage, Dailly)
- **BFR en forte croissance** → le CA croit mais le cash ne suit pas
- **TVA : gros credit en debut d'activite** → investissements lourds = credit de TVA a recuperer
- **Saisonnalite** → mois creux identifies, provisions necessaires
- **Concentration risque client** → un gros client qui paie en retard = trou de tresorerie

### 7. Optimisations a proposer

Si la tresorerie est tendue, proposer :
- Negocier des delais fournisseurs plus longs
- Facturer des acomptes clients
- Lisser les investissements dans le temps
- Chercher des financements court terme (BPI, garantie, affacturage)
- Demander le remboursement accelere du credit de TVA

### 8. Stocker les resultats

Si ~~base de donnees est connectee :
- Inserer les flux mensuels dans la table `tresorerie`
- Inserer les indicateurs dans la table `resultats`

### 9. Restitution

Transmettre au skill `restitution` :
- Tableau de tresorerie mensuel (3 scenarios)
- Graphique d'evolution de la tresorerie cumulee (3 courbes)
- Graphique encaissements vs decaissements
- Tableau BFR et variation

## Regles

1. **Tout est TTC** — la tresorerie travaille en TTC, pas en HT (sauf si franchise TVA)
2. **Les decalages sont critiques** — un CA de 100K€ ne sert a rien si les clients paient a 90 jours et les charges sont a 30 jours
3. **Mois par mois** — jamais de moyenne annualisee, la tresorerie est un flux temporel
4. **Prudence sur les encaissements** — les subventions arrivent souvent en retard, les clients aussi
5. **Inclure les flux non-resultat** — emprunts, apports, remboursements capital, investissements

## Skills lies

- **entretien-business-plan** — Phase prerequise d'entretien
- **previsionnel** — Compte de resultat (base pour les flux)
- **rentabilite** — Seuil de rentabilite et point mort
- **bilan-previsionnel** — Bilan previsionnel (utilise le solde de tresorerie cumule et le BFR)
- **plan-financement** — Plan de financement (utilise la variation de tresorerie et le BFR)
- **hypotheses** — Moteur de generation des 3 scenarios
- **restitution** — Production des livrables Power BI / Excel
