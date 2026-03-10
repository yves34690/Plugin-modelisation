# Plugins Modélisation & Business Plan pour Claude Cowork

Plugins open-source pour [Claude Cowork](https://claude.com/product/cowork) permettant de réaliser des **modélisations financières** et des **prévisionnels** en langage naturel, avec restitution automatique dans Power BI ou Excel.

## Pourquoi ?

Les modèles financiers (prospective de collectivité, business plan de startup, programmation économique) dépendent de dizaines de variables contextuelles. L'IA excelle à **construire le modèle adapté au contexte** plutôt qu'à appliquer un template rigide.

Mais aujourd'hui, quand on demande à une IA de faire un prévisionnel, elle produit un livrable figé — un tableau dans le chat. **C'est une erreur.** L'IA devrait construire la *structure* du modèle, pas le remplacer.

### Notre approche : séparer les couches

| Couche | Rôle | Outil |
|---|---|---|
| **Dialogue** | Comprendre le contexte, calibrer les hypothèses | Agent Claude (langage naturel) |
| **Variables** | Paramètres du modèle (CAPEX, taux, croissance...) | PostgreSQL |
| **Données de référence** | Benchmarks, ratios sectoriels, données publiques | APIs ouvertes (voir ci-dessous) |
| **Moteur de calcul** | Formules, projections, 3 scénarios | SQL / DAX |
| **Restitution** | KPI, tableaux, graphiques | Power BI / Excel |

L'utilisateur dialogue en langage naturel. L'agent construit le modèle, le stocke dans une base structurée, et produit les visuels. Tout est auditable, itérable, et reproductible.

## Plugins disponibles

### 1. Plugin Collectivités (`plugin-collectivites/`)

Modélisation financière pour les collectivités territoriales françaises :
- Prospective financière pluriannuelle
- Programmation pluriannuelle des investissements (PPI)
- Simulation fiscale (bases, taux, produits, exonérations)
- Comptes de gestion (49 agrégats financiers par collectivité)
- Recherche d'aides et subventions publiques (DETR, DSIL, fonds vert...)
- Capacité d'autofinancement et gestion de la dette

**Skills :**

| Skill | Description |
|-------|-------------|
| `entretien` | Entretien structuré de qualification du besoin |
| `prospective` | Projection financière pluriannuelle |
| `simulation-fiscale` | Simulation d'impact fiscal (taux, bases, produits) |
| `comptes-collectivites` | Agrégats financiers OFGL (épargne, dette, équipement...) |
| `fiscalite-locale` | Taux, bases et produits fiscaux (DGFiP / OFGL REI) |
| `aides-territoires` | Recherche d'aides publiques (3 000+ dispositifs) |
| `veille-ao` | Veille sur les appels d'offres |
| `analyse-dce` | Analyse de dossiers de consultation |

**Sources de données :**
- [OFGL](https://data.ofgl.fr) — Comptes de gestion consolidés, dotations détaillées
- [DGFiP / OFGL REI](https://data.economie.gouv.fr) — Fiscalité locale (taux, bases, produits, exonérations)
- [Aides-territoires](https://aides-territoires.beta.gouv.fr) — Subventions et aides publiques
- [INSEE](https://api.insee.fr) — Sirene, Melodi, Geo, Adresse
- [Eurostat](https://ec.europa.eu/eurostat) — Inflation, taux d'intérêt, comparaisons européennes
- [data.gouv.fr](https://data.gouv.fr) — Budgets, balances comptables, données socio-économiques
- [Data Commons](https://datacommons.org) — Données mondiales complémentaires

### 2. Plugin Business Plan (`plugin-business-plan/`)

Prévisionnel financier pour entrepreneurs et TPE/PME :
- Compte de résultat prévisionnel (3-5 ans, mensuel puis annuel)
- Plan de trésorerie mensuel
- Bilan prévisionnel sur 3 ans
- Plan de financement initial + pluriannuel (3-5 ans)
- Seuil de rentabilité et point mort
- Analyse de sensibilité (3 scénarios)

**Skills :**

| Skill | Description |
|-------|-------------|
| `entretien` | Entretien structuré de qualification du besoin |
| `previsionnel` | Compte de résultat prévisionnel et SIG |
| `tresorerie` | Plan de trésorerie mensuel (encaissements / décaissements) |
| `bilan-previsionnel` | Bilan prévisionnel (actif/passif, ratios bilantiels) |
| `plan-financement` | Plan de financement initial + pluriannuel (CAF, emplois/ressources) |
| `rentabilite` | Seuil de rentabilité, point mort, analyse de sensibilité |

**Sources de données :**
- [INSEE](https://api.insee.fr) — Sirene (concurrence), Melodi (démographie), Geo (zone de chalandise)
- [Eurostat](https://ec.europa.eu/eurostat) — Inflation, taux d'intérêt, croissance PIB
- [Aides-territoires](https://aides-territoires.beta.gouv.fr) — Aides création/reprise d'entreprise
- [data.gouv.fr](https://data.gouv.fr) — Ratios sectoriels, données économiques locales
- [Data Commons](https://datacommons.org) — Données mondiales complémentaires

## Architecture

```
Plugin-modelisation/
├── core/                          # Socle commun
│   ├── skills/                    # Skills partagés (hypothèses, restitution)
│   ├── schema/                    # Schéma PostgreSQL (projets, hypothèses, projections,
│   │                              #   bilan_previsionnel, plan_financement, trésorerie...)
│   └── templates/                 # Templates Power BI / Excel
│
├── plugin-collectivites/          # Plugin Cowork - Collectivités
│   ├── .claude-plugin/plugin.json
│   ├── CONNECTORS.md              # Table des connecteurs (~~comptes, ~~fiscalite, ~~aides...)
│   └── skills/                    # 8 skills (prospective, fiscalité, comptes OFGL, aides...)
│
├── plugin-business-plan/          # Plugin Cowork - Business Plan
│   ├── .claude-plugin/plugin.json
│   ├── CONNECTORS.md              # Table des connecteurs (~~insee, ~~eurostat, ~~aides...)
│   └── skills/                    # 6 skills (prévi, trésorerie, bilan, plan financement...)
│
└── docs/                          # Documentation et guides
    └── vision.md                  # Vision produit et roadmap
```

## Prérequis

- [Claude Desktop](https://claude.com/download) avec mode Cowork (plan Pro, Max ou Team)
- [Docker](https://docs.docker.com/get-docker/) (pour PostgreSQL)
- [Power BI Desktop](https://powerbi.microsoft.com/) (optionnel, pour la restitution avancée)

## Installation

```bash
# Cloner le repo
git clone https://github.com/yves34690/Plugin-modelisation.git

# Installer le plugin dans Cowork
# → Claude Desktop > Cowork > Settings > Plugins > Add local plugin
# → Pointer vers plugin-collectivites/ ou plugin-business-plan/
```

## Formations

Des formations à la prise en main et à l'utilisation avancée sont disponibles.
Contactez [Agentique](https://agentique.fr) pour plus d'informations.

## Licence

MIT

## Auteurs

- **Yves Music** ([@yves34690](https://github.com/yves34690)) — Vision produit, expertise finance/collectivités
- **Claude** (Anthropic) — Architecture technique, développement

---

*Projet initié par [Agentique](https://agentique.fr) — Conseil & IA pour la finance et le secteur public*
