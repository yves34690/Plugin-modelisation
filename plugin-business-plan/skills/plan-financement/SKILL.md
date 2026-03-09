---
name: plan-financement
description: Construire un plan de financement initial et pluriannuel (3-5 ans) pour une entreprise. Utiliser quand l'utilisateur demande un plan de financement, un tableau emplois-ressources, veut verifier l'equilibre financier de son projet, ou cherche a calibrer ses besoins de financement.
---

# Plan de financement

**Important** : Ce skill assiste dans la construction du plan de financement mais ne se substitue pas a l'expertise d'un expert-comptable. Les projections doivent etre validees par des professionnels qualifies.

**Prerequis** : Le compte de resultat previsionnel (skill `previsionnel`) et le plan de tresorerie (skill `tresorerie`) doivent etre construits.

## Methodologie

### 1. Plan de financement initial (annee 0)

Le plan de financement initial repond a la question : **de combien ai-je besoin pour demarrer, et comment je le finance ?**

#### Besoins durables (emplois)

| Poste | Montant HT | Source |
|-------|-----------|--------|
| Frais d'etablissement | X€ | Devis (statuts, immatriculation, etc.) |
| Acquisitions immobilieres | X€ | Compromis / estimation |
| Amenagements / travaux | X€ | Devis |
| Materiel et outillage | X€ | Devis |
| Materiel informatique | X€ | Devis |
| Vehicules | X€ | Devis |
| Droit au bail / pas-de-porte | X€ | Contrat |
| Stock initial | X€ | Estimation sectorielle |
| BFR initial | X€ | Calcul (creances clients - dettes fournisseurs a J0) |
| Depot de garantie | X€ | 1 a 3 mois de loyer |
| Tresorerie de demarrage | X€ | Reserve de securite (2-3 mois de charges fixes) |
| **TOTAL BESOINS** | **X€** | |

#### Ressources durables

| Poste | Montant | Conditions |
|-------|---------|------------|
| Apports en capital | X€ | Apport personnel + associes |
| Comptes courants d'associes | X€ | Remboursable, convention |
| Emprunts bancaires | X€ | Duree X ans, taux X% |
| Prets d'honneur | X€ | Taux 0%, duree X ans |
| Subventions d'investissement | X€ | Organisme, conditions |
| Crowdfunding / love money | X€ | — |
| Credit-bail (valeur du bien) | X€ | Loyer mensuel X€ |
| **TOTAL RESSOURCES** | **X€** | |

#### Equilibre

```
Solde = TOTAL RESSOURCES - TOTAL BESOINS

Si solde >= 0 : le financement est equilibre (solde = tresorerie initiale)
Si solde < 0 : il manque du financement → chercher des ressources supplementaires
```

> **Regle** : les apports en capital doivent representer au minimum 20-30% du total des besoins (exigence usuelle des banques). Un ratio apport/emprunt de 1:2 a 1:3 est courant.

### 2. Plan de financement pluriannuel (3-5 ans)

Le plan de financement pluriannuel montre comment l'entreprise equilibre ses besoins et ses ressources dans le temps.

#### Ressources

| Poste | An 1 | An 2 | An 3 |
|-------|------|------|------|
| CAF (capacite d'autofinancement) | X€ | X€ | X€ |
| Apports complementaires en capital | X€ | — | — |
| Nouveaux emprunts | — | X€ | — |
| Subventions | X€ | — | — |
| Cessions d'actifs | — | — | X€ |
| **Total ressources** | **X€** | **X€** | **X€** |

**CAF** = Resultat net + Dotations aux amortissements + Provisions nettes
(depuis le skill `previsionnel`)

#### Emplois

| Poste | An 1 | An 2 | An 3 |
|-------|------|------|------|
| Investissements (CAPEX) | X€ | X€ | X€ |
| Remboursement capital emprunts | X€ | X€ | X€ |
| Variation BFR | X€ | X€ | X€ |
| Distributions de dividendes | — | — | X€ |
| **Total emplois** | **X€** | **X€** | **X€** |

**Variation BFR** = BFR annee N - BFR annee N-1
- Positive si le BFR augmente (le CA croit → besoin supplementaire)
- Negative si le BFR diminue (liberation de cash)

#### Solde et tresorerie cumulee

```
Variation de tresorerie = Total ressources - Total emplois
Tresorerie cumulee = Tresorerie N-1 + Variation de tresorerie N
```

| | An 0 | An 1 | An 2 | An 3 |
|---|------|------|------|------|
| Ressources | — | X€ | X€ | X€ |
| Emplois | — | X€ | X€ | X€ |
| Variation tresorerie | X€ (solde initial) | X€ | X€ | X€ |
| **Tresorerie cumulee** | **X€** | **X€** | **X€** | **X€** |

> **Verification** : la tresorerie cumulee du plan de financement doit correspondre a la tresorerie du bilan previsionnel et au solde cumule du plan de tresorerie. Ecart = erreur de modele.

### 3. Ratios cles

| Ratio | Formule | Seuil | Interpretation |
|-------|---------|-------|----------------|
| Couverture des emplois | Ressources / Emplois | > 1 | L'entreprise genere assez pour couvrir ses besoins |
| Taux d'autofinancement | CAF / Investissements | > 50% | L'activite finance au moins la moitie des investissements |
| Levier financier | Dettes financieres / CAF | < 3-4 | Capacite a rembourser la dette |
| Part des subventions | Subventions / Total ressources | < 30% | Independance vis-a-vis des aides |
| Ratio apport/endettement | Capitaux propres / Dettes MLT | > 0.3 | Structure financiere saine |

### 4. Alertes automatiques

Signaler systematiquement :
- **Tresorerie cumulee negative** → l'entreprise est en cessation de paiement theorique, il faut trouver du financement
- **CAF negative sur plus d'un exercice** → l'activite detruit de la valeur, modele economique a revoir
- **Ratio d'endettement > 4 ans de CAF** → surendettement, refinancement necessaire
- **Variation BFR superieure a la CAF** → la croissance consomme plus de cash qu'elle n'en genere
- **Dependance subventions > 50%** → modele fragile si les aides sont supprimees

### 5. Presenter les 3 scenarios

Tableau comparatif :

```
                            Conservateur    Realiste    Optimiste
CAF an 1                    X€              X€          X€
CAF an 3                    X€              X€          X€
Tresorerie cumulee an 3     X€              X€          X€
Couverture emplois an 3     X.X             X.X         X.X
Autofinancement an 3        X%              X%          X%
```

### 6. Stocker les resultats

Si ~~base de donnees est connectee :
- Inserer les flux dans la table `plan_financement`
- Inserer les ratios dans la table `resultats`

### 7. Restitution

Transmettre au skill `restitution` :
- Plan de financement initial (tableau besoins/ressources)
- Plan de financement pluriannuel (3 scenarios)
- Graphique tresorerie cumulee (3 courbes)
- Graphique structure ressources (CAF vs emprunts vs subventions)
- Tableau des ratios

## Regles

1. **Le plan de financement initial est la base** — sans equilibre au demarrage, le reste est caduc
2. **La CAF est reine** — c'est la seule ressource durable auto-generee. Si elle est negative, il faut repenser le modele, pas chercher plus de financement
3. **Coherence avec les autres skills** — tresorerie cumulee = bilan = plan de financement. Toute divergence est une erreur
4. **Normes bancaires** — presenter dans le format attendu par les banques (format BPI / Guide du createur)
5. **Prudence sur les subventions** — ne les compter que si l'eligibilite est confirmee et le versement cadence realiste

## Skills lies

- **entretien-business-plan** — Phase prerequise d'entretien
- **previsionnel** — Compte de resultat (fournit la CAF, les amortissements)
- **tresorerie** — Plan de tresorerie (fournit le BFR, la tresorerie cumulee)
- **rentabilite** — Seuil de rentabilite et point mort
- **bilan-previsionnel** — Bilan previsionnel (coherence tresorerie/capitaux)
- **restitution** — Production des livrables Power BI / Excel
