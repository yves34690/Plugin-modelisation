---
name: previsionnel
description: Construire un compte de resultat previsionnel sur 3 a 5 ans pour une entreprise. Utiliser quand l'utilisateur demande un previsionnel, un compte de resultat projete, des SIG previsionnels, ou une projection de rentabilite.
---

# Compte de resultat previsionnel

**Important** : Ce skill assiste dans la construction du previsionnel mais ne se substitue pas a l'expertise d'un expert-comptable. Les projections doivent etre validees par des professionnels qualifies.

**Prerequis** : L'entretien (skill `entretien-business-plan`) doit avoir ete realise. Les hypotheses doivent etre validees.

## Methodologie

### 1. Recuperer les hypotheses validees

Depuis le skill `entretien-business-plan` ou la base de donnees :
- Modele economique (sources de revenus, prix, volumes)
- Structure de charges (fixes, variables, masse salariale)
- Plan d'investissement et amortissements
- Financement (apport, emprunt, subventions)
- Horizon (3 ou 5 ans)
- 3 jeux d'hypotheses (conservateur, realiste, optimiste)

### 2. Construire le chiffre d'affaires

#### Annee 1 — mois par mois

| Mois | Clients | Panier moyen | CA brut | Remises | CA net |
|------|---------|-------------|---------|---------|--------|
| M1   | X       | X€          | X€      | X%      | X€     |
| ...  | ...     | ...         | ...     | ...     | ...    |
| M12  | X       | X€          | X€      | X%      | X€     |

Prendre en compte :
- Montee en charge progressive (pas de CA a 100% des le mois 1)
- Saisonnalite sectorielle (coefficients mensuels)
- Delai entre lancement et premiers revenus
- Mix produits/services si plusieurs sources de CA

#### Annees 2 a 5 — annuelles

Appliquer les taux de croissance par scenario :

| | Conservateur | Realiste | Optimiste |
|---|---|---|---|
| Croissance an 2 | X% | X% | X% |
| Croissance an 3 | X% | X% | X% |
| Croissance an 4 | X% | X% | X% |
| Croissance an 5 | X% | X% | X% |

### 3. Construire les charges

#### Charges variables (proportionnelles au CA)

| Poste | % du CA | Justification |
|-------|---------|---------------|
| Achats marchandises / matieres | X% | Marge brute secteur : X% |
| Sous-traitance | X% | — |
| Commissions commerciales | X% | — |
| Frais de livraison | X% | — |

#### Charges fixes

| Poste | Montant mensuel | Evolution annuelle | Source |
|-------|----------------|-------------------|--------|
| Loyer + charges | X€ | Indice ILC (~~eurostat HICP ou ~~insee IPC) | Bail / estimation |
| Assurances | X€ | +2-3%/an | Devis |
| Honoraires comptables | X€ | Stable | Devis |
| Telecom / IT | X€ | Stable | — |
| Marketing / communication | X€ | Variable | Budget defini |
| Deplacements | X€ | — | Estimation |
| Fournitures | X€ | — | Estimation |

#### Charges de personnel

| Poste | Brut mensuel | Charges patronales | Date embauche | Cout annuel |
|-------|-------------|-------------------|---------------|-------------|
| Dirigeant | X€ | X% (selon statut) | M1 | X€ |
| Salarie n°1 | X€ | ~45% | MX | X€ |
| Salarie n°2 | X€ | ~45% | MX | X€ |

Attention au statut juridique :
- **SAS/SASU** : president assimile salarie (~75% de charges sur net)
- **SARL** : gerant majoritaire TNS (~45% de charges sur net)
- **EI** : cotisations SSI (~45% du benefice)
- **Micro** : taux forfaitaire sur CA

#### Dotations aux amortissements

| Immobilisation | Montant | Duree | Amortissement annuel |
|----------------|---------|-------|---------------------|
| Amenagements | X€ | 10 ans | X€ |
| Materiel | X€ | 5-7 ans | X€ |
| Vehicule | X€ | 5 ans | X€ |
| Informatique | X€ | 3 ans | X€ |

#### Charges financieres

- Interets d'emprunt (calcul sur tableau d'amortissement)
- Frais bancaires
- Agios (si decouvert prevu)

### 4. Calculer les soldes intermediaires de gestion (SIG)

```
Chiffre d'affaires net (HT)
- Achats consommes + variation de stocks
= MARGE COMMERCIALE ou PRODUCTION DE L'EXERCICE

- Charges externes
= VALEUR AJOUTEE

- Impots et taxes
- Charges de personnel
= EXCEDENT BRUT D'EXPLOITATION (EBE)

+ Autres produits d'exploitation
- Autres charges d'exploitation
= RESULTAT D'EXPLOITATION

+/- Resultat financier (produits - charges financieres)
= RESULTAT COURANT AVANT IMPOTS (RCAI)

+/- Resultat exceptionnel
- Impot sur les societes (ou IR selon statut)
= RESULTAT NET
```

### 5. Ratios cles a presenter

| Ratio | Formule | Benchmark secteur | Alerte si |
|-------|---------|-------------------|-----------|
| Marge brute | (CA - achats) / CA | X% | < X% |
| Taux de VA | VA / CA | X% | < X% |
| Taux EBE | EBE / CA | X% | < 0 |
| Resultat net / CA | RN / CA | X% | < 0 apres an 2 |
| Poids masse salariale | Personnel / CA | X% | > X% |

### 6. Presenter les 3 scenarios

Tableau comparatif des indicateurs cles par scenario :

```
                    Conservateur    Realiste    Optimiste
CA an 1             X€              X€          X€
CA an 3             X€              X€          X€
EBE an 1            X€              X€          X€
EBE an 3            X€              X€          X€
Resultat net an 1   X€              X€          X€
Resultat net an 3   X€              X€          X€
Point mort          mois X          mois X      mois X
```

### 7. Stocker les resultats

Si ~~base de donnees est connectee :
- Inserer les projections dans la table `projections`
- Inserer les SIG dans la table `resultats`
- Mettre a jour le statut du modele

### 8. Restitution

Transmettre au skill `restitution` :
- Compte de resultat mensuel an 1 + annuel an 2-5
- SIG par scenario
- Graphiques : evolution CA, EBE, resultat net (3 scenarios superposes)
- Tableau de sensibilite

## Regles

1. **Normes francaises** — PCG, nomenclature BPI/banque pour la presentation
2. **Coherence** — verifier que la marge brute est cohérente avec le secteur
3. **Prudence** — le scenario conservateur doit etre tenable meme en conditions defavorables
4. **Sources** — chaque benchmark cite doit etre tracable (INSEE Sirene pour la concurrence, Eurostat pour les indices macro, data.gouv.fr pour les ratios sectoriels)
5. **Lisibilite** — l'utilisateur doit pouvoir defendre ces chiffres devant un banquier
6. **Indices macro** — utiliser ~~eurostat (HICP, taux d'interet) et ~~insee (IPC, Melodi) pour calibrer les hypotheses d'evolution plutot que des valeurs arbitraires

## Skills lies

- **entretien-business-plan** — Phase prerequise d'entretien
- **hypotheses** — Moteur de generation des 3 scenarios
- **tresorerie** — Plan de tresorerie mensuel
- **rentabilite** — Seuil de rentabilite et point mort
- **restitution** — Production des livrables Power BI / Excel
