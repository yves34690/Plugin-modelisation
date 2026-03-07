# Vision du projet

*Document de référence — Mars 2026*

## Constat

La modélisation financière et les prévisionnels sont des exercices complexes qui dépendent de nombreux facteurs contextuels : type d'activité, conjoncture économique, niveau de CAPEX, fiscalité, démographie, etc. Il est impossible de créer un modèle standard universel.

L'IA générative apporte une vraie plus-value ici : étant non déterministe, elle peut **construire des modèles à la volée** adaptés au contexte donné. Mais aujourd'hui, quand on confie cette tâche à une IA, elle va jusqu'à la réalisation du modèle — elle produit un livrable figé dans le chat.

**C'est une erreur.** Le livrable n'est pas auditable, pas itérable, pas reproductible.

## Notre approche

Séparer clairement les responsabilités :

1. **L'IA est l'architecte du modèle**, pas le modèle lui-même
2. **Les données sont dans une base structurée**, pas dans un prompt
3. **La restitution utilise des outils professionnels** (Power BI, Excel), pas du texte
4. **Les hypothèses sont explicites et modifiables**, pas enfouies dans un raisonnement

## Plateforme cible : Claude Cowork

Claude Cowork (mode natif de Claude Desktop) offre l'architecture idéale :
- **Plugins** : distribution packagée de skills + MCP + agents
- **Sub-agents** : parallélisation des tâches (recherche données + calcul + restitution)
- **MCP** : connexion native aux sources de données et outils
- **Tâches long terme** : les modélisations complexes peuvent tourner sans timeout
- **Langage naturel** : l'utilisateur décrit son besoin, l'agent construit

## Deux plugins, un socle commun

### Pourquoi deux plugins ?

Les publics cibles sont différents, les données sources sont différentes, les livrables sont différents. Mais le moteur sous-jacent (hypothèses, scénarios, restitution) est le même.

### Plugin 1 : Collectivités territoriales

**Public** : DAF de collectivités, consultants secteur public, bureaux d'études

**Cas d'usage** :
- Prospective financière pluriannuelle (épargne brute/nette, CAF, dette)
- Programmation pluriannuelle des investissements (PPI)
- Simulation fiscale (évolution des bases, taux, produits)
- Programmation économique (zones d'activité, équipements)
- Analyse comparative inter-collectivités

**Source de données principale** : [datagouv-mcp](https://github.com/datagouv/datagouv-mcp)
- Budgets des collectivités (M57, M14)
- Données fiscales (bases, taux, exonérations)
- Démographie INSEE
- Dotations de l'État (DGF, FCTVA, etc.)
- Données socio-économiques

**Livrables types** :
- Tableau de prospective financière (section de fonctionnement + investissement)
- Plan de financement PPI
- Tableau de simulation fiscale
- Graphiques d'évolution et de comparaison

### Plugin 2 : Business Plan

**Public** : entrepreneurs, startups, TPE/PME, accompagnateurs (CCI, incubateurs)

**Cas d'usage** :
- Business plan complet (3-5 ans)
- Compte de résultat prévisionnel
- Plan de trésorerie mensuel
- Bilan prévisionnel
- Calcul du seuil de rentabilité / point mort
- Analyse de sensibilité multi-scénarios

**Sources de données** :
- Ratios sectoriels INSEE
- Benchmarks par secteur d'activité
- Données marché (taille, croissance, concurrence)

**Livrables types** :
- SIG prévisionnel (soldes intermédiaires de gestion)
- Tableau de trésorerie mensuel
- Bilan prévisionnel simplifié
- Graphiques de rentabilité et cash-flow

## Moteur commun : les 3 scénarios

Chaque modélisation produit systématiquement 3 hypothèses :

| Scénario | Description | Calibration |
|---|---|---|
| **Conservateur** | Hypothèse basse, prudente | Percentile 25 des données de référence |
| **Réaliste** | Hypothèse centrale | Médiane des données de référence |
| **Optimiste** | Hypothèse haute | Percentile 75 des données de référence |

L'IA calibre ces scénarios en croisant :
- Les données historiques du porteur de projet / de la collectivité
- Les données de référence (benchmarks, comparables)
- Le contexte économique (conjoncture, taux, inflation)

## Stack technique

| Composant | Technologie | Rôle |
|---|---|---|
| Agent IA | Claude (Cowork plugin) | Dialogue, construction du modèle |
| Base de données | PostgreSQL (Docker) | Stockage variables, hypothèses, résultats |
| Données publiques | datagouv-mcp | Données collectivités (budgets, fiscalité, démo) |
| Restitution | Power BI / Excel | Tableaux de bord, graphiques, KPI |
| Distribution | GitHub | Repo public, installation via Cowork |

## Modèle économique

- **Plugins** : open-source (licence MIT), repo GitHub public
- **Formations** : payantes, dispensées par Agentique
  - Prise en main des plugins
  - Personnalisation et adaptation au contexte
  - Méthodologie de modélisation financière avec l'IA
- **Conseil** : accompagnement sur mesure pour cas complexes

## Roadmap

### Phase 1 — MVP Plugin Collectivités
- [ ] Étude du plugin finance officiel Anthropic (structure de référence)
- [ ] Étude de datagouv-mcp (données disponibles, intégration)
- [ ] Schéma PostgreSQL (variables, hypothèses, résultats)
- [ ] Skills de base : prospective financière, PPI
- [ ] Template Power BI de restitution
- [ ] Tests en local avec `claude --plugin-dir`

### Phase 2 — MVP Plugin Business Plan
- [ ] Identification des sources de benchmarks sectoriels
- [ ] Skills : compte de résultat prévi, trésorerie, rentabilité
- [ ] Template Power BI / Excel adapté

### Phase 3 — Distribution & Formation
- [ ] Documentation utilisateur complète
- [ ] Vidéos / guides de prise en main
- [ ] Publication sur GitHub
- [ ] Offre de formation structurée

---

*Document maintenu par Agentique — Yves Music & Claude*
