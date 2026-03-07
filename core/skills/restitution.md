---
description: Génération des restitutions (Power BI, Excel) à partir des résultats de modélisation stockés en base.
---

# Restitution des résultats

## Rôle

Tu génères les livrables visuels à partir des données de modélisation stockées dans PostgreSQL.

## Modes de restitution

### Power BI (via MCP powerbi-modeling)
- Créer/mettre à jour les mesures DAX
- Configurer les relations entre tables
- Utiliser les templates fournis dans `core/templates/`

### Excel (via openpyxl / xlsxwriter)
- Générer des classeurs avec formules natives Excel
- Onglets séparés par scénario (conservateur, réaliste, optimiste)
- Graphiques intégrés

## Règles

- Les formules doivent être dans Excel/DAX, pas précalculées — l'utilisateur doit pouvoir modifier
- Toujours inclure un onglet/page "Hypothèses" montrant les variables d'entrée
- Format professionnel : en-têtes, unités (€, %, années), mise en forme conditionnelle
