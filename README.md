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
| **Données de référence** | Benchmarks, ratios sectoriels, données publiques | API (datagouv, INSEE...) |
| **Moteur de calcul** | Formules, projections, 3 scénarios | SQL / DAX |
| **Restitution** | KPI, tableaux, graphiques | Power BI / Excel |

L'utilisateur dialogue en langage naturel. L'agent construit le modèle, le stocke dans une base structurée, et produit les visuels. Tout est auditable, itérable, et reproductible.

## Plugins disponibles

### 1. Plugin Collectivités (`plugin-collectivites/`)

Modélisation financière pour les collectivités territoriales françaises :
- Prospective financière pluriannuelle
- Programmation pluriannuelle des investissements (PPI)
- Simulation fiscale (bases, taux, produits)
- Capacité d'autofinancement et gestion de la dette

**Source de données** : [datagouv-mcp](https://github.com/datagouv/datagouv-mcp) — données publiques (budgets, fiscalité locale, démographie, dotations)

### 2. Plugin Business Plan (`plugin-business-plan/`)

Prévisionnel financier pour entrepreneurs et TPE/PME :
- Compte de résultat prévisionnel (3-5 ans)
- Plan de trésorerie mensuel
- Bilan prévisionnel
- Seuil de rentabilité et point mort
- Analyse de sensibilité (3 scénarios)

**Source de données** : benchmarks sectoriels, ratios INSEE, données marché

## Architecture

```
Plugin-modelisation/
├── core/                          # Socle commun
│   ├── skills/                    # Skills partagés (hypothèses, restitution)
│   ├── schema/                    # Schéma PostgreSQL
│   └── templates/                 # Templates Power BI / Excel
│
├── plugin-collectivites/          # Plugin Cowork - Collectivités
│   ├── .claude-plugin/plugin.json
│   ├── .mcp.json                  # datagouv-mcp + PostgreSQL
│   ├── skills/                    # Prospective, PPI, fiscalité
│   └── agents/                    # Agent spécialisé collectivités
│
├── plugin-business-plan/          # Plugin Cowork - Business Plan
│   ├── .claude-plugin/plugin.json
│   ├── .mcp.json                  # Benchmarks + PostgreSQL
│   ├── skills/                    # Prévi, trésorerie, rentabilité
│   └── agents/                    # Agent spécialisé BP
│
└── docs/                          # Documentation et guides
    ├── installation.md
    ├── guide-collectivites.md
    └── guide-business-plan.md
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
