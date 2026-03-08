# Connecteurs

## Fonctionnement des references aux outils

Les fichiers du plugin utilisent `~~categorie` comme placeholder pour l'outil connecte par l'utilisateur dans cette categorie. Par exemple, `~~donnees publiques` designe datagouv ou tout autre serveur MCP equivalent.

## Connecteurs de ce plugin

| Categorie | Placeholder | Serveur inclus | Autres options |
|-----------|-------------|----------------|----------------|
| Donnees publiques | `~~donnees publiques` | datagouv (data.gouv.fr) | API INSEE, API Sirene |
| Base de donnees | `~~base de donnees` | — (PostgreSQL a configurer) | Supabase, SQLite |
| Restitution / BI | `~~restitution` | — (Power BI a configurer) | Excel, Metabase |
| Suite bureautique | `~~bureautique` | Microsoft 365 | Google Workspace |
| Recherche web | `~~recherche` | — (web search natif Cowork) | — |
