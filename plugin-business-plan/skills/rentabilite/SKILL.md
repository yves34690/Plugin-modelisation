---
name: rentabilite
description: Calculer le seuil de rentabilite (point mort) et analyser la sensibilite du modele economique. Utiliser quand l'utilisateur demande un seuil de rentabilite, un point mort, un break-even, une analyse de sensibilite, ou veut savoir quand son activite sera rentable.
---

# Seuil de rentabilite et point mort

**Important** : Ce skill assiste dans le calcul du seuil de rentabilite mais ne se substitue pas a l'expertise d'un expert-comptable.

**Prerequis** : Le compte de resultat previsionnel (skill `previsionnel`) doit etre construit, ou a minima la structure de charges doit etre qualifiee (fixes vs variables).

## Methodologie

### 1. Classifier les charges

Toute charge de l'entreprise doit etre classee :

| Classification | Definition | Exemples |
|---------------|-----------|----------|
| **Charges variables** | Proportionnelles au CA | Achats matieres, sous-traitance, commissions, frais de livraison |
| **Charges fixes** | Independantes du niveau d'activite | Loyer, salaires fixes, assurances, amortissements, abonnements |
| **Charges semi-variables** | Part fixe + part variable | Telephonie (forfait + conso), electricite, commerciaux (fixe + variable) |

Pour les charges semi-variables : decomposer en part fixe et part variable.

### 2. Calculer le seuil de rentabilite en valeur

```
Taux de marge sur couts variables = (CA - Charges variables) / CA

Seuil de rentabilite (€) = Charges fixes / Taux de marge sur couts variables
```

**Exemple :**
- CA prevu : 200 000€
- Charges variables : 80 000€ (40% du CA)
- Charges fixes : 90 000€
- Taux de marge sur CV = (200 000 - 80 000) / 200 000 = 60%
- Seuil de rentabilite = 90 000 / 0,60 = **150 000€**

### 3. Calculer le point mort en jours/mois

```
Point mort (jours) = Seuil de rentabilite / CA annuel x 365

Point mort (mois) = Seuil de rentabilite / CA annuel x 12
```

En tenant compte de la montee en charge :
- Cumuler le CA mois par mois
- Le point mort = mois ou le CA cumule depasse le seuil de rentabilite

### 4. Calculer le seuil en volume

Si l'activite se mesure en unites :

```
Marge sur cout variable unitaire = Prix de vente unitaire - Cout variable unitaire

Seuil de rentabilite (unites) = Charges fixes / Marge sur cout variable unitaire
```

Pour les activites multi-produits : calculer un seuil par produit ou un seuil global pondere.

### 5. Presenter les 3 scenarios

| Indicateur | Conservateur | Realiste | Optimiste |
|------------|-------------|----------|-----------|
| CA annuel prevu | X€ | X€ | X€ |
| Charges variables | X€ (X%) | X€ (X%) | X€ (X%) |
| Marge sur CV | X€ (X%) | X€ (X%) | X€ (X%) |
| Charges fixes | X€ | X€ | X€ |
| **Seuil de rentabilite** | **X€** | **X€** | **X€** |
| **Point mort** | **mois X** | **mois X** | **mois X** |
| Marge de securite | X% | X% | X% |
| Indice de securite | X | X | X |

### 6. Marge de securite et indice de securite

```
Marge de securite (€) = CA prevu - Seuil de rentabilite
Marge de securite (%) = (CA prevu - Seuil) / CA prevu x 100
Indice de securite = CA prevu / Seuil de rentabilite
```

| Indice de securite | Interpretation |
|-------------------|----------------|
| < 1 | L'entreprise ne couvre pas ses charges fixes |
| 1,0 - 1,1 | Rentabilite fragile, tres peu de marge |
| 1,1 - 1,3 | Situation correcte |
| > 1,3 | Bonne marge de securite |

### 7. Analyse de sensibilite

Montrer l'impact de variations sur le seuil de rentabilite :

#### Sensibilite au prix

| Variation prix | Nouveau seuil | Ecart | Impact |
|---------------|---------------|-------|--------|
| -10% | X€ | +X€ | Point mort recule de X mois |
| -5% | X€ | +X€ | — |
| Base | X€ | — | — |
| +5% | X€ | -X€ | — |
| +10% | X€ | -X€ | Point mort avance de X mois |

#### Sensibilite aux charges fixes

| Variation CF | Nouveau seuil | Ecart |
|-------------|---------------|-------|
| +1 salarie | X€ | +X€ |
| +local plus grand | X€ | +X€ |
| Reduction 10% | X€ | -X€ |

#### Sensibilite au cout variable

| Variation CV | Nouvelle marge | Nouveau seuil |
|-------------|----------------|---------------|
| Fournisseur +10% | X% | X€ |
| Fournisseur -10% | X% | X€ |
| Internalisation | X% | X€ |

### 8. Graphique du seuil de rentabilite

Generer un graphique classique :
- Axe X : chiffre d'affaires (ou volume)
- Courbe 1 : CA (droite lineaire)
- Courbe 2 : charges totales (charges fixes + charges variables)
- Intersection : seuil de rentabilite
- Zone verte : benefice (au-dessus de l'intersection)
- Zone rouge : perte (en dessous)

### 9. Alertes et recommandations

Signaler :
- **Seuil > 80% du CA prevu** → risque eleve, peu de marge de manoeuvre
- **Point mort > 18 mois** → le porteur doit pouvoir financer cette periode
- **Charges fixes > 70% des charges totales** → structure rigide, levier faible
- **Marge sur CV < 30%** → business model a fort volume, sensible aux variations de cout

Recommandations selon le diagnostic :
- Reduire les charges fixes si le seuil est trop eleve
- Augmenter le prix si la marge sur CV est faible (et le marche le permet)
- Mixer activites forte marge + volume pour equilibrer
- Prevoir un financement suffisant pour couvrir la periode pre-rentabilite

### 10. Stocker les resultats

Si ~~base de donnees est connectee :
- Inserer le seuil de rentabilite et le point mort dans la table `resultats`
- Inserer l'analyse de sensibilite dans la table `sensibilite`

### 11. Restitution

Transmettre au skill `restitution` :
- Tableau de synthese seuil / point mort (3 scenarios)
- Graphique du seuil de rentabilite
- Tableau de sensibilite
- Graphique radar multi-criteres (sensibilite prix, volume, charges)

## Regles

1. **Simplifier sans trahir** — le point mort doit etre comprehensible par un non-financier
2. **Charges mixtes** — toujours decomposer, ne jamais les ignorer
3. **Prudence** — en cas de doute sur la classification d'une charge, la mettre en fixe (plus prudent)
4. **Multi-produits** — calculer un seuil par ligne de produit si possible
5. **Temporalite** — le point mort en mois est plus parlant que le seuil en euros pour un createur

## Skills lies

- **entretien-business-plan** — Phase prerequise d'entretien
- **previsionnel** — Compte de resultat previsionnel
- **tresorerie** — Plan de tresorerie mensuel
- **hypotheses** — Moteur de generation des 3 scenarios
- **restitution** — Production des livrables Power BI / Excel
