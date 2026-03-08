---
description: Analyser un DCE et produire un memoire technique complet pour repondre a un appel d'offres
argument-hint: "[documents-dce]"
---

# Reponse AO

Analyser le Dossier de Consultation des Entreprises (DCE) et produire une reponse complete (memoire technique, BPU/DQE, planning).

## Usage

```
/modelisation-collectivites:reponse-ao [documents]
```

### Arguments

- `documents` — Fichiers du DCE fournis par l'utilisateur (RC, CCTP, CCAP, BPU, etc.)

## Workflow

### Phase 1 — Analyse du DCE (skill `analyse-dce`)

1. Lire et extraire les informations cles de chaque piece du DCE
2. Identifier les criteres de jugement et leur ponderation
3. Reperer le format impose (nombre de pages, plan, etc.)
4. Produire le diagnostic go/no-go
5. **Demander validation a Yves avant de continuer**

### Phase 2 — Construction de la reponse

Si go valide par Yves :

6. Construire la matrice criteres / reponse
7. Pour chaque critere, developper la reponse adaptee :
   - **Methodologie** : s'appuyer sur les skills metier (prospective, simulation-fiscale) pour decrire une approche concrete et differenciante. Mettre en avant l'approche IA + 3 scenarios + restitution BI.
   - **References** : selectionner les missions passees les plus pertinentes. Consulter la base Notion (Missions Actives) si besoin.
   - **Moyens** : decrire l'equipe, les outils, les competences
   - **Planning** : construire un planning realiste avec jalons de validation
   - **Prix** : remplir le BPU/DQE selon la strategie tarifaire validee par Yves

### Phase 3 — Production du memoire technique

8. Verifier si le RC impose un format / plan / nombre de pages :
   - **Si oui** : suivre strictement le format impose
   - **Si non** : utiliser la charte Agentique (`templates/charte-ao.md`)

9. Produire le memoire technique en Word (.docx) avec :
   - Page de garde (identite Agentique ou format impose)
   - Sommaire
   - Sections structurees selon les criteres de jugement
   - Tableaux, schemas, graphiques pertinents
   - Mise en forme professionnelle

10. Produire les annexes si demandees :
    - CV des intervenants
    - Fiches de references
    - Attestations et formulaires (DC1, DC2, etc.)

11. Remplir le BPU/DQE en Excel si fourni

### Phase 4 — Relecture et finalisation

12. Verifier la coherence globale :
    - Le memoire repond-il a TOUS les criteres du RC ?
    - Le planning est-il coherent avec les delais du CCTP ?
    - Le prix est-il coherent avec la charge estimee ?
    - Toutes les pieces demandees sont-elles presentes ?

13. Verifier la forme :
    - Orthographe et grammaire
    - Mise en page conforme
    - Pagination et sommaire a jour
    - Noms et references corrects (pas de copier-coller d'un ancien AO)

14. Presenter la reponse complete a Yves pour validation finale avant depot

## Points d'attention

- **Ne jamais deposer automatiquement** — Yves depose lui-meme sur la plateforme (AWS, PLACE, etc.)
- **Chaque reponse est unique** — pas de copier-coller generique, tout doit etre adapte au contexte de la collectivite
- **Les criteres pilotent la reponse** — un critere a 60% merite 60% de l'effort de redaction
- **Le prix n'est pas tout** — sur les MAPA, le technique pese souvent 60-70%. Miser sur la qualite du memoire.
