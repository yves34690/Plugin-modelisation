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

### Phase 2 — Recherche et base de connaissance

Si go valide par Yves, constituer une base de connaissance exhaustive AVANT de rediger. L'objectif : maitriser le sujet aussi bien qu'un consultant qui connait le terrain.

#### 2a. Connaitre la collectivite

6. Rechercher les donnees financieres via datagouv / API BOAMP :
   - Budgets des 3-5 derniers exercices (comptes administratifs)
   - Donnees fiscales (bases, taux, produits, comparaison strate)
   - Endettement (encours, capacite de desendettement)
   - Dotations (DGF, FCTVA, perequation)
   - Ratios cles : epargne brute/nette, taux d'epargne, dette/habitant

7. Rechercher le contexte territorial :
   - Population, evolution demographique, strate (INSEE)
   - Intercommunalite d'appartenance et son role
   - Projets structurants en cours (web search presse locale, deliberations)
   - Contexte politique : date du mandat, priorites affichees (site web collectivite)

8. Rechercher les documents publics de la collectivite :
   - DOB / ROB recents (souvent publies sur le site)
   - Rapports CRC (disponibles sur ccomptes.fr)
   - PPI ou plan de mandat existant
   - Deliberations budgetaires recentes

#### 2b. Maitriser le sujet technique

9. Rechercher les donnees de reference selon le type de mission :
   - **Prospective** : tendances nationales DGF (loi de finances), evolution bases fiscales, inflation (INSEE), taux d'interet collectivites (Finance Active, Banque Postale)
   - **PPI** : indices cout construction (BT01, TP01), taux de subventionnement moyens (DETR, DSIL, FCTVA), couts de reference par type d'equipement
   - **Simulation fiscale** : reforme fiscale en cours, evolution des compensations, donnees DGFIP
   - **Audit financier** : grille d'analyse CRC, seuils d'alerte DGCL, ratios de reference par strate

10. Rechercher les benchmarks :
    - Collectivites comparables (meme type, meme strate, meme departement) via datagouv
    - Ratios moyens nationaux (observatoire des finances locales, rapport Cazeneuve, DGCL)
    - Etudes recentes du secteur (Banque Postale, Cour des comptes, AdCF)

#### 2c. Connaitre l'ecosysteme

11. Rechercher la concurrence et l'historique :
    - AO similaires passes sur BOAMP (meme collectivite ou meme sujet dans le departement)
    - Attributaires precedents (avis d'attribution BOAMP)
    - Cabinets concurrents actifs sur le secteur et la zone

12. **Presenter la synthese de la base de connaissance a Yves** :
    - Fiche collectivite (chiffres cles, contexte, enjeux)
    - Donnees de reference collectees
    - Analyse concurrentielle
    - Points forts a exploiter dans le memoire
    - **Demander validation avant de passer a la redaction**

### Phase 3 — Construction de la reponse

13. Construire la matrice criteres / reponse en s'appuyant sur la base de connaissance
14. Pour chaque critere, developper la reponse adaptee :
   - **Methodologie** : s'appuyer sur les skills metier (prospective, simulation-fiscale) pour decrire une approche concrete et differenciante. Integrer les donnees collectees pour montrer la connaissance du terrain. Mettre en avant l'approche IA + 3 scenarios + restitution BI.
   - **References** : selectionner les missions passees les plus pertinentes. Consulter la base Notion (Missions Actives) si besoin.
   - **Moyens** : decrire l'equipe, les outils, les competences
   - **Planning** : construire un planning realiste avec jalons de validation
   - **Prix** : remplir le BPU/DQE selon la strategie tarifaire validee par Yves

### Phase 4 — Production du memoire technique

15. Verifier si le RC impose un format / plan / nombre de pages :
    - **Si oui** : suivre strictement le format impose
    - **Si non** : utiliser la charte Agentique (`templates/charte-ao.md`)

16. Produire le memoire technique en Word (.docx) avec :
    - Page de garde (identite Agentique ou format impose)
    - Sommaire
    - Sections structurees selon les criteres de jugement
    - Donnees chiffrees de la collectivite (issues de la base de connaissance)
    - Tableaux, schemas, graphiques pertinents
    - Mise en forme professionnelle

17. Produire les annexes si demandees :
    - CV des intervenants
    - Fiches de references
    - Attestations et formulaires (DC1, DC2, etc.)

18. Remplir le BPU/DQE en Excel si fourni

### Phase 5 — Relecture et finalisation

19. Verifier la coherence globale :
    - Le memoire repond-il a TOUS les criteres du RC ?
    - Le planning est-il coherent avec les delais du CCTP ?
    - Le prix est-il coherent avec la charge estimee ?
    - Toutes les pieces demandees sont-elles presentes ?
    - Les donnees chiffrees citees sont-elles sourcees et a jour ?

20. Verifier la forme :
    - Orthographe et grammaire
    - Mise en page conforme
    - Pagination et sommaire a jour
    - Noms et references corrects (pas de copier-coller d'un ancien AO)

21. Presenter la reponse complete a Yves pour validation finale avant depot

## Points d'attention

- **Ne jamais deposer automatiquement** — Yves depose lui-meme sur la plateforme (AWS, PLACE, etc.)
- **Chaque reponse est unique** — pas de copier-coller generique, tout doit etre adapte au contexte de la collectivite
- **Les criteres pilotent la reponse** — un critere a 60% merite 60% de l'effort de redaction
- **Le prix n'est pas tout** — sur les MAPA, le technique pese souvent 60-70%. Miser sur la qualite du memoire.
