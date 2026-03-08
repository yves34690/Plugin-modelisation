---
description: Lancer une veille sur les appels d'offres BOAMP lies a l'ingenierie financiere des collectivites
argument-hint: "[nombre-jours]"
---

# Veille appels d'offres

Scanner le BOAMP a la recherche d'appels d'offres pertinents pour nos competences en ingenierie financiere des collectivites territoriales.

## Usage

```
/modelisation-collectivites:veille-ao [nombre-jours]
```

### Arguments

- `nombre-jours` — Nombre de jours a scanner en arriere (defaut : 7)

## Workflow

1. Scanner l'API BOAMP avec les mots-cles metier (prospective financiere, PPI, simulation fiscale, etc.)
2. Dedoublonner et filtrer les resultats (exclure expires, hors perimetre)
3. Scorer la pertinence de chaque AO (Fort / Moyen / Faible)
4. Creer les opportunites dans le CRM Notion (base Opportunites, statut "Identification")
5. Notifier @Yves par commentaire Notion pour chaque AO pertinent
6. Produire un rapport de synthese

## Pour une veille automatique quotidienne

Dans Claude Desktop Cowork, taper `/schedule` dans une conversation et configurer :
- **Prompt** : `/modelisation-collectivites:veille-ao 1`
- **Frequence** : tous les jours a 8h
- **Description** : Veille quotidienne AO collectivites
