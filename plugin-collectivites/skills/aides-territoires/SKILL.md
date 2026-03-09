---
name: aides-territoires
description: Rechercher des aides publiques (subventions, prêts, ingénierie) pour les collectivités, associations et entreprises via l'API Aides-territoires. Use when user says "aides", "subventions", "financements publics", "aides territoires", "appels à projets", "aides investissement", "aides collectivité", "aides association", "aides entreprise", "France Relance", "DETR", "DSIL", "fonds vert", or asks about public funding, grants, subsidies for territories.
license: MIT
metadata:
  author: Agentique
  version: 1.0.0
  category: workflow-automation
  tags: [aides, subventions, collectivites, financement, territoires, appels-projets]
---

# Aides-territoires — API de recherche d'aides publiques

Skill pour rechercher et filtrer les aides publiques françaises (subventions, prêts, ingénierie technique) via l'API Aides-territoires (beta.gouv.fr).

## Authentification — Flow en 2 étapes

L'API utilise un flow JWT. Le token API est dans `$AIDES_TERRITOIRES_TOKEN`.

```bash
# Étape 1 : obtenir le JWT (valide 24h)
JWT=$(curl -s -X POST -H "X-Auth-Token: $AIDES_TERRITOIRES_TOKEN" \
  "https://aides-territoires.beta.gouv.fr/api/connexion/" \
  | python3 -c "import sys,json; print(json.load(sys.stdin)['token'])")

# Étape 2 : utiliser le JWT pour toutes les requêtes suivantes
curl -s -H "Authorization: Bearer $JWT" \
  "https://aides-territoires.beta.gouv.fr/api/aids/?page_size=10"
```

**Important :** Toujours enchaîner les 2 étapes dans le même appel bash (le JWT expire).

## Endpoints disponibles

| Endpoint | Description |
|----------|-------------|
| `/api/aids/` | Liste/recherche d'aides (GET, paginé) |
| `/api/aids/{slug}/` | Détail d'une aide par slug |
| `/api/aids/all/` | Toutes les aides (action custom) |
| `/api/perimeters/` | Périmètres géographiques |
| `/api/backers/` | Porteurs d'aides (financeurs) |
| `/api/programs/` | Programmes (France Relance, etc.) |
| `/api/themes/` | Thématiques |
| `/api/synonymlists/` | Listes de synonymes (autocomplétion) |

## Paramètres de recherche — `/api/aids/`

### Filtres principaux

| Paramètre | Type | Description | Exemple |
|-----------|------|-------------|---------|
| `text` | string | Recherche plein texte (mots-clés) | `text=rénovation énergétique` |
| `targeted_audiences` | multi | Bénéficiaires cibles | `targeted_audiences=commune&targeted_audiences=epci` |
| `aid_type` | multi | Type d'aide (groupé) | `aid_type=financial_group` ou `aid_type=technical_group` |
| `financial_aids` | multi | Aides financières spécifiques | `financial_aids=grant&financial_aids=loan` |
| `technical_aids` | multi | Aides en ingénierie spécifiques | `technical_aids=technical_engineering` |
| `themes` | multi | Thématiques (IDs) | `themes=1&themes=2` |
| `categories` | multi | Sous-catégories (IDs) | `categories=5` |
| `programs` | multi | Programmes (IDs) | `programs=1` |
| `backers` | multi | Financeurs (IDs) | `backers=42` |
| `perimeter` | ID | Périmètre géographique | `perimeter=12345` |
| `mobilization_step` | multi | Étape du projet | `mobilization_step=preop&mobilization_step=op` |
| `destinations` | multi | Destination de l'aide | `destinations=investment` |
| `recurrence` | string | Récurrence | `recurrence=ongoing` |
| `call_for_projects_only` | bool | Appels à projets uniquement | `call_for_projects_only=true` |
| `apply_before` | date | Date limite de dépôt (avant) | `apply_before=2026-12-31` |
| `is_charged` | string | Aide payante ? | `is_charged=False` |
| `in_france_relance` | bool | France Relance uniquement | `in_france_relance=true` |
| `european_aid` | string | Aides européennes | `european_aid=european` |
| `order_by` | string | Tri | `order_by=relevance` ou `submission_deadline` ou `publication_date` |
| `page_size` | int | Résultats par page | `page_size=25` |

### Valeurs des filtres

**targeted_audiences** (bénéficiaires) :

| Valeur | Libellé |
|--------|---------|
| `commune` | Commune |
| `epci` | Intercommunalité / Pays |
| `department` | Département |
| `region` | Région |
| `special` | Collectivité d'outre-mer à statut particulier |
| `association` | Association |
| `private_sector` | Entreprise privée |
| `public_cies` | Entreprise publique locale (Sem, Spl, SemOp) |
| `public_org` | Établissement public / Service de l'État |
| `private_person` | Particulier |
| `farmer` | Agriculteur |
| `researcher` | Recherche |

**aid_type** (groupes) :

| Valeur | Libellé |
|--------|---------|
| `financial_group` | Aide financière (toutes) |
| `technical_group` | Aide en ingénierie (toutes) |

**financial_aids** (aides financières détaillées) :

| Valeur | Libellé |
|--------|---------|
| `grant` | Subvention |
| `loan` | Prêt |
| `recoverable_advance` | Avance remboursable |
| `cee` | Certificat d'économie d'énergie (CEE) |
| `other` | Autre aide financière |

**technical_aids** (ingénierie détaillée) :

| Valeur | Libellé |
|--------|---------|
| `technical_engineering` | Ingénierie technique |
| `financial_engineering` | Ingénierie financière |
| `legal_engineering` | Ingénierie juridique / administrative |

**mobilization_step** (étape du projet) :

| Valeur | Libellé |
|--------|---------|
| `preop` | Réflexion / conception |
| `op` | Mise en œuvre / réalisation |
| `postop` | Usage / fonctionnement |

**destinations** (nature de la dépense) :

| Valeur | Libellé |
|--------|---------|
| `supply` | Fonctionnement |
| `investment` | Investissement |

**recurrence** :

| Valeur | Libellé |
|--------|---------|
| `oneoff` | Ponctuelle |
| `ongoing` | Permanente |
| `recurring` | Récurrente |

## Structure d'une aide (réponse API)

| Champ | Type | Description |
|-------|------|-------------|
| `id` | int | Identifiant unique |
| `slug` | string | Identifiant textuel (pour URL) |
| `url` | URL | Lien vers la fiche sur aides-territoires |
| `name` | string | Nom de l'aide |
| `short_title` | string | Titre court |
| `description` | HTML | Description complète |
| `eligibility` | HTML | Conditions d'éligibilité |
| `financers` | string[] | Noms des financeurs |
| `instructors` | string[] | Noms des instructeurs |
| `programs` | string[] | Noms des programmes associés |
| `targeted_audiences` | string[] | Bénéficiaires cibles |
| `aid_types` | string[] | Types d'aide |
| `categories` | string[] | Catégories (format "theme\|categorie") |
| `perimeter` | string | Périmètre géographique |
| `mobilization_steps` | string[] | Étapes de mobilisation |
| `destinations` | string[] | Destinations (investissement/fonctionnement) |
| `is_call_for_project` | bool | Appel à projets ? |
| `is_charged` | bool | Aide payante ? |
| `start_date` | date | Date de début |
| `predeposit_date` | date | Date de pré-dépôt |
| `submission_deadline` | date | Date limite de dépôt |
| `subvention_rate_lower_bound` | float | Taux de subvention min (%) |
| `subvention_rate_upper_bound` | float | Taux de subvention max (%) |
| `loan_amount` | decimal | Montant du prêt |
| `recoverable_advance_amount` | decimal | Montant de l'avance remboursable |
| `contact` | HTML | Informations de contact |
| `origin_url` | URL | URL source (site du financeur) |
| `application_url` | URL | URL de candidature |
| `recurrence` | string | Récurrence |
| `project_examples` | HTML | Exemples de projets |
| `date_created` | datetime | Date de création |
| `date_updated` | datetime | Dernière mise à jour |

## curl Patterns

### Obtenir le JWT (préalable à toute requête)

```bash
JWT=$(curl -s -X POST -H "X-Auth-Token: $AIDES_TERRITOIRES_TOKEN" \
  "https://aides-territoires.beta.gouv.fr/api/connexion/" \
  | python3 -c "import sys,json; print(json.load(sys.stdin)['token'])")
```

### Recherche par mots-clés

```bash
response=$(curl -s -H "Authorization: Bearer $JWT" \
  "https://aides-territoires.beta.gouv.fr/api/aids/?text=r%C3%A9novation+%C3%A9nerg%C3%A9tique&page_size=10") && echo "$response" | python3 -m json.tool
```

### Recherche par bénéficiaire (commune)

```bash
response=$(curl -s -H "Authorization: Bearer $JWT" \
  "https://aides-territoires.beta.gouv.fr/api/aids/?targeted_audiences=commune&page_size=10") && echo "$response" | python3 -m json.tool
```

### Subventions d'investissement pour communes

```bash
response=$(curl -s -H "Authorization: Bearer $JWT" \
  "https://aides-territoires.beta.gouv.fr/api/aids/?targeted_audiences=commune&financial_aids=grant&destinations=investment&page_size=20") && echo "$response" | python3 -m json.tool
```

### Aides pour associations + recherche textuelle

```bash
response=$(curl -s -H "Authorization: Bearer $JWT" \
  "https://aides-territoires.beta.gouv.fr/api/aids/?targeted_audiences=association&text=emploi+insertion&page_size=10") && echo "$response" | python3 -m json.tool
```

### Appels à projets en cours (deadline future)

```bash
response=$(curl -s -H "Authorization: Bearer $JWT" \
  "https://aides-territoires.beta.gouv.fr/api/aids/?call_for_projects_only=true&apply_before=2026-12-31&order_by=submission_deadline&page_size=20") && echo "$response" | python3 -m json.tool
```

### Détail d'une aide par slug

```bash
response=$(curl -s -H "Authorization: Bearer $JWT" \
  "https://aides-territoires.beta.gouv.fr/api/aids/{slug}/") && echo "$response" | python3 -m json.tool
```

### Lister les thématiques

```bash
response=$(curl -s -H "Authorization: Bearer $JWT" \
  "https://aides-territoires.beta.gouv.fr/api/themes/") && echo "$response" | python3 -m json.tool
```

### Lister les financeurs

```bash
response=$(curl -s -H "Authorization: Bearer $JWT" \
  "https://aides-territoires.beta.gouv.fr/api/backers/") && echo "$response" | python3 -m json.tool
```

### Lister les programmes

```bash
response=$(curl -s -H "Authorization: Bearer $JWT" \
  "https://aides-territoires.beta.gouv.fr/api/programs/") && echo "$response" | python3 -m json.tool
```

### Combiner plusieurs filtres

```bash
# Prêts et avances remboursables pour entreprises, thème environnement
response=$(curl -s -H "Authorization: Bearer $JWT" \
  "https://aides-territoires.beta.gouv.fr/api/aids/?targeted_audiences=private_sector&financial_aids=loan&financial_aids=recoverable_advance&text=environnement&page_size=20") && echo "$response" | python3 -m json.tool
```

## Script complet réutilisable

Pour simplifier les appels, utiliser ce pattern en une seule commande bash :

```bash
python3 -c "
import urllib.request, json, os

BASE = 'https://aides-territoires.beta.gouv.fr/api'
TOKEN = os.environ.get('AIDES_TERRITOIRES_TOKEN', '')

# Étape 1 : JWT
req = urllib.request.Request(BASE + '/connexion/', headers={'X-Auth-Token': TOKEN}, method='POST')
jwt = json.loads(urllib.request.urlopen(req).read())['token']

# Étape 2 : requête
url = BASE + '/aids/?targeted_audiences=commune&financial_aids=grant&destinations=investment&page_size=10'
req2 = urllib.request.Request(url, headers={'Authorization': 'Bearer ' + jwt})
data = json.loads(urllib.request.urlopen(req2).read())

print(f\"Nombre total: {data.get('count', '?')}\")
for aid in data.get('results', []):
    deadline = aid.get('submission_deadline', 'permanent')
    financers = ', '.join(aid.get('financers', []))
    print(f\"- {aid['name']}\")
    print(f\"  Financeur(s): {financers}\")
    print(f\"  Deadline: {deadline}\")
    print(f\"  Types: {', '.join(aid.get('aid_types', []))}\")
    print()
"
```

## Business Logic

### Interpréter l'intention

| L'utilisateur dit | Filtres à appliquer |
|---|---|
| "aides pour ma commune" | `targeted_audiences=commune` |
| "subventions investissement" | `financial_aids=grant&destinations=investment` |
| "aides rénovation école" | `targeted_audiences=commune&text=rénovation+école` |
| "prêts pour entreprise" | `targeted_audiences=private_sector&financial_aids=loan` |
| "appels à projets en cours" | `call_for_projects_only=true&order_by=submission_deadline` |
| "aides association sport" | `targeted_audiences=association&text=sport` |
| "aides EPCI transition écologique" | `targeted_audiences=epci&text=transition+écologique` |
| "ingénierie technique" | `technical_aids=technical_engineering` |
| "DETR" / "DSIL" / "fonds vert" | `text=DETR` (ou DSIL, fonds vert) |
| "France Relance" | `in_france_relance=true` |
| "aides européennes" | `european_aid=european` |
| "création d'entreprise" | `targeted_audiences=private_sector&text=création+entreprise` |

### Pagination

La réponse contient `count` (total), `next` (URL page suivante), `previous` (URL page précédente). Utiliser `page_size` (défaut 10, max recommandé 50) et naviguer via `next`/`previous`.

### Affichage

- Toujours afficher le **nom de l'aide**, le(s) **financeur(s)**, et la **date limite** (ou "permanente" si null)
- Pour les subventions : mentionner le **taux** si disponible (`subvention_rate_lower_bound` / `upper_bound`)
- Pour les prêts : mentionner le **montant** si disponible (`loan_amount`)
- Indiquer le nombre total de résultats (`count`)
- Fournir le lien vers la fiche : `url` ou construire `https://aides-territoires.beta.gouv.fr/aides/{slug}/`
- Mentionner la **source** : "Source : Aides-territoires (beta.gouv.fr)"

## Workflows types

### Recherche d'aides pour un projet d'investissement communal

1. Filtrer : `targeted_audiences=commune&destinations=investment&financial_aids=grant`
2. Ajouter mots-clés si thème précis : `text=voirie` ou `text=école` ou `text=énergie`
3. Trier par deadline : `order_by=submission_deadline`
4. Présenter les résultats avec nom, financeur, taux de subvention, deadline
5. Pour les aides pertinentes, récupérer le détail via `/api/aids/{slug}/`

### Recherche d'aides pour création d'entreprise

1. Filtrer : `targeted_audiences=private_sector&text=création+entreprise`
2. Combiner avec aides financières : `financial_aids=grant&financial_aids=loan&financial_aids=recoverable_advance`
3. Présenter avec montants et conditions

### Veille sur les appels à projets

1. Filtrer : `call_for_projects_only=true&order_by=submission_deadline`
2. Ajouter bénéficiaire si pertinent : `targeted_audiences=commune`
3. Filtrer par deadline future : `apply_before=2026-12-31`
4. Lister par date limite croissante

### Panorama des aides d'un programme

1. Lister les programmes : `/api/programs/`
2. Filtrer par programme : `programs={id}`
3. Présenter toutes les aides du programme

## Error Handling

| Situation | Cause | Action |
|-----------|-------|--------|
| `401 JWT Token not found` | Auth manquante ou expirée | Re-générer le JWT (étape 1) |
| `401` sur étape 1 | Token API invalide | Vérifier `$AIDES_TERRITOIRES_TOKEN` |
| `count: 0` | Filtres trop restrictifs | Élargir la recherche (moins de filtres, mots-clés plus larges) |
| Réponse HTML au lieu de JSON | Mauvais endpoint | Vérifier l'URL (ne pas oublier `/api/`) |
| Champs vides/null | Aide incomplète | Normal, afficher "non renseigné" |

## Safety Rules

- **Lecture seule** : API en lecture uniquement
- **Token** : ne jamais afficher le token API (`$AIDES_TERRITOIRES_TOKEN`) en clair dans les réponses
- **Données publiques** : les aides sont des informations publiques
- **Pas de conseil juridique** : orienter vers le financeur pour les conditions précises d'éligibilité
- **Citer la source** : toujours mentionner "Aides-territoires (beta.gouv.fr)"

## Examples

### Example 1: Subventions pour rénovation énergétique d'un bâtiment communal
User says: "quelles aides pour rénover l'école de ma commune ?"
Actions:
1. Obtenir JWT
2. `aids/?targeted_audiences=commune&financial_aids=grant&text=rénovation+énergétique+bâtiment&destinations=investment&page_size=20`
3. Présenter les résultats triés par pertinence avec financeur, taux, deadline
Result: Liste d'aides (DETR, DSIL, fonds vert, CEE, etc.) avec liens et conditions

### Example 2: Prêts pour une association
User says: "quels prêts existent pour les associations ?"
Actions:
1. Obtenir JWT
2. `aids/?targeted_audiences=association&financial_aids=loan&financial_aids=recoverable_advance&page_size=20`
3. Présenter avec montants et conditions
Result: Liste des prêts et avances remboursables accessibles aux associations

### Example 3: Appels à projets transition écologique
User says: "appels à projets en cours sur la transition écologique"
Actions:
1. Obtenir JWT
2. `aids/?call_for_projects_only=true&text=transition+écologique&order_by=submission_deadline&page_size=20`
3. Présenter triés par date limite
Result: Liste des AAP avec deadlines, classés du plus urgent au plus lointain

### Example 4: Détail d'une aide spécifique
User says: "donne-moi les détails du fonds vert"
Actions:
1. Obtenir JWT
2. `aids/?text=fonds+vert&page_size=5` pour trouver le slug
3. `aids/{slug}/` pour le détail complet
4. Présenter description, éligibilité, contact, URL de candidature
Result: Fiche complète avec conditions, taux, contact et lien de candidature

## Troubleshooting

### Error: JWT expiré en cours de session
**Cause:** Le JWT a une durée de vie limitée (~24h).
**Solution:** Re-exécuter l'étape 1 pour obtenir un nouveau JWT.

### Error: Résultats non pertinents
**Cause:** Recherche textuelle trop large.
**Solution:** Combiner `text` avec des filtres structurés (`targeted_audiences`, `financial_aids`, `destinations`).

### Error: Trop de résultats
**Cause:** Filtres insuffisants.
**Solution:** Ajouter des filtres (bénéficiaire, type d'aide, thème) et utiliser `page_size` + pagination.
