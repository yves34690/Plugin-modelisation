# Templates de restitution

## Power BI

Les templates Power BI se connectent aux tables PostgreSQL du schema `init.sql` et fournissent des visuels preconfigures.

### Mesures DAX de base

Les mesures suivantes sont a creer dans le modele Power BI connecte a la base PostgreSQL :

#### Mesures communes

```dax
// Chiffre d'affaires par scenario
CA =
CALCULATE(
    SUM(projections[montant]),
    projections[poste] = "ca_net",
    projections[mois] = BLANK()
)

// EBE par scenario
EBE =
CALCULATE(
    SUM(projections[montant]),
    projections[poste] = "ebe",
    projections[mois] = BLANK()
)

// Resultat net par scenario
Resultat Net =
CALCULATE(
    SUM(projections[montant]),
    projections[poste] = "resultat_net",
    projections[mois] = BLANK()
)

// Seuil de rentabilite
Seuil Rentabilite =
CALCULATE(
    SUM(resultats[valeur]),
    resultats[indicateur] = "seuil_rentabilite"
)

// Point mort (mois)
Point Mort =
CALCULATE(
    SUM(resultats[valeur]),
    resultats[indicateur] = "point_mort_mois"
)
```

#### Mesures collectivites

```dax
// Epargne brute
Epargne Brute =
CALCULATE(
    SUM(projections[montant]),
    projections[poste] = "epargne_brute",
    projections[mois] = BLANK()
)

// Taux d'epargne brute
Taux Epargne Brute =
CALCULATE(
    SUM(resultats[valeur]),
    resultats[indicateur] = "taux_epargne_brute"
)

// Capacite de desendettement
Capacite Desendettement =
CALCULATE(
    SUM(resultats[valeur]),
    resultats[indicateur] = "capacite_desendettement"
)
```

#### Mesures tresorerie (business plan)

```dax
// Tresorerie cumulee
Tresorerie Cumulee =
CALCULATE(
    SUM(v_tresorerie_cumulee[tresorerie_cumulee])
)

// Solde mensuel
Solde Mensuel =
CALCULATE(
    SUM(v_tresorerie_cumulee[solde_mensuel])
)
```

### Pages recommandees

#### Business Plan
1. **Synthese** — KPI principaux (CA, EBE, RN, point mort), 3 scenarios cote a cote
2. **Compte de resultat** — Tableau SIG mensuel an 1, annuel an 2-5
3. **Tresorerie** — Courbe de tresorerie cumulee (3 scenarios), encaissements vs decaissements
4. **Rentabilite** — Graphique break-even, tableau de sensibilite
5. **Hypotheses** — Tableau des variables d'entree avec les 3 scenarios

#### Collectivites
1. **Synthese** — KPI (epargne brute/nette, dette, ratios), 3 scenarios
2. **Prospective** — Tableau de prospective format DGFIP
3. **Fiscalite** — Bases, taux, produits, comparaison strate
4. **Investissements** — PPI, plan de financement
5. **Dette** — Encours, annuites, capacite de desendettement

## Excel

Le skill `restitution` genere des classeurs Excel avec :
- Un onglet par scenario
- Un onglet Hypotheses (variables d'entree)
- Des formules natives Excel (pas de valeurs precalculees)
- Des graphiques integres
- Une mise en forme professionnelle (en-tetes, unites, conditionnelle)
