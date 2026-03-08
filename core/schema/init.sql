-- Schema PostgreSQL pour les plugins de modelisation financiere
-- Usage : docker exec -i <container> psql -U modelisation_user -d modelisation_db -f init.sql

-- ============================================================
-- TABLES COMMUNES (core)
-- ============================================================

-- Projets (un projet = une modelisation)
CREATE TABLE IF NOT EXISTS projets (
    id              SERIAL PRIMARY KEY,
    nom             VARCHAR(255) NOT NULL,
    type            VARCHAR(50) NOT NULL CHECK (type IN ('collectivite', 'business_plan')),
    description     TEXT,
    horizon_annees  INTEGER NOT NULL DEFAULT 3,
    date_creation   TIMESTAMP DEFAULT NOW(),
    date_maj        TIMESTAMP DEFAULT NOW(),
    statut          VARCHAR(20) DEFAULT 'brouillon' CHECK (statut IN ('brouillon', 'en_cours', 'valide', 'archive')),
    metadata        JSONB DEFAULT '{}'
);

-- Variables d'hypotheses (parametres du modele)
CREATE TABLE IF NOT EXISTS hypotheses (
    id              SERIAL PRIMARY KEY,
    projet_id       INTEGER NOT NULL REFERENCES projets(id) ON DELETE CASCADE,
    categorie       VARCHAR(100) NOT NULL,       -- ex: 'ca', 'charges_fixes', 'fiscalite'
    variable        VARCHAR(100) NOT NULL,       -- ex: 'croissance_ca_an2', 'taux_tf'
    libelle         VARCHAR(255) NOT NULL,       -- ex: 'Croissance CA annee 2'
    unite           VARCHAR(20) DEFAULT '%',     -- '%', '€', 'jours', 'mois', 'ratio'
    val_conservateur NUMERIC(15,4),
    val_realiste    NUMERIC(15,4),
    val_optimiste   NUMERIC(15,4),
    val_reference   NUMERIC(15,4),               -- benchmark / historique
    source_ref      VARCHAR(255),                -- source du benchmark
    justification   TEXT,
    ordre           INTEGER DEFAULT 0,
    UNIQUE(projet_id, categorie, variable)
);

-- Projections (resultats calcules par annee et scenario)
CREATE TABLE IF NOT EXISTS projections (
    id              SERIAL PRIMARY KEY,
    projet_id       INTEGER NOT NULL REFERENCES projets(id) ON DELETE CASCADE,
    scenario        VARCHAR(20) NOT NULL CHECK (scenario IN ('conservateur', 'realiste', 'optimiste')),
    annee           INTEGER NOT NULL,            -- 1, 2, 3...
    mois            INTEGER,                     -- 1-12, NULL si annuel
    poste           VARCHAR(100) NOT NULL,       -- ex: 'ca_net', 'charges_personnel', 'epargne_brute'
    categorie       VARCHAR(50) NOT NULL,        -- ex: 'recettes', 'depenses', 'solde'
    montant         NUMERIC(15,2) NOT NULL,
    UNIQUE(projet_id, scenario, annee, mois, poste)
);

-- Resultats (indicateurs synthetiques)
CREATE TABLE IF NOT EXISTS resultats (
    id              SERIAL PRIMARY KEY,
    projet_id       INTEGER NOT NULL REFERENCES projets(id) ON DELETE CASCADE,
    scenario        VARCHAR(20) NOT NULL CHECK (scenario IN ('conservateur', 'realiste', 'optimiste')),
    indicateur      VARCHAR(100) NOT NULL,       -- ex: 'seuil_rentabilite', 'taux_epargne_brute'
    libelle         VARCHAR(255) NOT NULL,
    valeur          NUMERIC(15,4) NOT NULL,
    unite           VARCHAR(20),
    annee           INTEGER,                     -- NULL si global
    alerte          BOOLEAN DEFAULT FALSE,
    seuil_alerte    NUMERIC(15,4),
    commentaire     TEXT,
    UNIQUE(projet_id, scenario, indicateur, annee)
);

-- Benchmarks (donnees de reference sectorielles)
CREATE TABLE IF NOT EXISTS benchmarks (
    id              SERIAL PRIMARY KEY,
    secteur         VARCHAR(100) NOT NULL,       -- code NAF ou libelle
    indicateur      VARCHAR(100) NOT NULL,       -- ex: 'marge_brute', 'taux_survie_3ans'
    libelle         VARCHAR(255) NOT NULL,
    p25             NUMERIC(15,4),               -- percentile 25 (conservateur)
    mediane         NUMERIC(15,4),               -- mediane (realiste)
    p75             NUMERIC(15,4),               -- percentile 75 (optimiste)
    unite           VARCHAR(20),
    source          VARCHAR(255) NOT NULL,        -- ex: 'INSEE 2024', 'BPI France'
    annee_donnees   INTEGER,
    date_maj        TIMESTAMP DEFAULT NOW()
);

-- Analyse de sensibilite
CREATE TABLE IF NOT EXISTS sensibilite (
    id              SERIAL PRIMARY KEY,
    projet_id       INTEGER NOT NULL REFERENCES projets(id) ON DELETE CASCADE,
    variable_testee VARCHAR(100) NOT NULL,       -- ex: 'prix_vente', 'charges_fixes'
    variation       NUMERIC(8,4) NOT NULL,       -- ex: -0.10 pour -10%
    impact_seuil    NUMERIC(15,2),               -- nouveau seuil de rentabilite
    impact_resultat NUMERIC(15,2),               -- nouveau resultat net
    impact_tresorerie NUMERIC(15,2),             -- nouvelle tresorerie min
    commentaire     TEXT
);

-- ============================================================
-- TABLES SPECIFIQUES COLLECTIVITES
-- ============================================================

-- Donnees fiscales collectivites
CREATE TABLE IF NOT EXISTS fiscalite_locale (
    id              SERIAL PRIMARY KEY,
    projet_id       INTEGER NOT NULL REFERENCES projets(id) ON DELETE CASCADE,
    annee           INTEGER NOT NULL,
    impot           VARCHAR(20) NOT NULL,        -- 'tfpb', 'tfpnb', 'th_rs', 'cfe', 'cvae'
    base_nette      NUMERIC(15,2),
    taux_vote       NUMERIC(8,4),
    taux_strate     NUMERIC(8,4),
    produit         NUMERIC(15,2),
    compensations   NUMERIC(15,2),
    UNIQUE(projet_id, annee, impot)
);

-- Dotations et perequation
CREATE TABLE IF NOT EXISTS dotations (
    id              SERIAL PRIMARY KEY,
    projet_id       INTEGER NOT NULL REFERENCES projets(id) ON DELETE CASCADE,
    annee           INTEGER NOT NULL,
    type            VARCHAR(50) NOT NULL,        -- 'dgf_forfaitaire', 'dsu', 'dsr', 'dnp', 'fpic', 'fctva'
    montant         NUMERIC(15,2) NOT NULL,
    UNIQUE(projet_id, annee, type)
);

-- Dette
CREATE TABLE IF NOT EXISTS dette (
    id              SERIAL PRIMARY KEY,
    projet_id       INTEGER NOT NULL REFERENCES projets(id) ON DELETE CASCADE,
    annee           INTEGER NOT NULL,
    encours         NUMERIC(15,2),
    annuite_capital NUMERIC(15,2),
    annuite_interet NUMERIC(15,2),
    taux_moyen      NUMERIC(8,4),
    duree_residuelle NUMERIC(5,1),
    UNIQUE(projet_id, annee)
);

-- ============================================================
-- TABLES SPECIFIQUES BUSINESS PLAN
-- ============================================================

-- Plan de tresorerie mensuel
CREATE TABLE IF NOT EXISTS tresorerie (
    id              SERIAL PRIMARY KEY,
    projet_id       INTEGER NOT NULL REFERENCES projets(id) ON DELETE CASCADE,
    scenario        VARCHAR(20) NOT NULL CHECK (scenario IN ('conservateur', 'realiste', 'optimiste')),
    annee           INTEGER NOT NULL,
    mois            INTEGER NOT NULL CHECK (mois BETWEEN 1 AND 12),
    poste           VARCHAR(100) NOT NULL,       -- ex: 'ca_ttc_encaisse', 'loyer', 'tva_decaisser'
    type_flux       VARCHAR(20) NOT NULL CHECK (type_flux IN ('encaissement', 'decaissement')),
    montant         NUMERIC(15,2) NOT NULL,
    UNIQUE(projet_id, scenario, annee, mois, poste)
);

-- ============================================================
-- INDEX
-- ============================================================

CREATE INDEX IF NOT EXISTS idx_hypotheses_projet ON hypotheses(projet_id);
CREATE INDEX IF NOT EXISTS idx_projections_projet_scenario ON projections(projet_id, scenario);
CREATE INDEX IF NOT EXISTS idx_resultats_projet_scenario ON resultats(projet_id, scenario);
CREATE INDEX IF NOT EXISTS idx_benchmarks_secteur ON benchmarks(secteur);
CREATE INDEX IF NOT EXISTS idx_tresorerie_projet_scenario ON tresorerie(projet_id, scenario);
CREATE INDEX IF NOT EXISTS idx_fiscalite_projet ON fiscalite_locale(projet_id);

-- ============================================================
-- VUES UTILES
-- ============================================================

-- Vue : SIG par projet et scenario
CREATE OR REPLACE VIEW v_sig AS
SELECT
    p.nom AS projet,
    pr.scenario,
    pr.annee,
    SUM(CASE WHEN pr.poste = 'ca_net' THEN pr.montant ELSE 0 END) AS ca_net,
    SUM(CASE WHEN pr.poste = 'marge_brute' THEN pr.montant ELSE 0 END) AS marge_brute,
    SUM(CASE WHEN pr.poste = 'valeur_ajoutee' THEN pr.montant ELSE 0 END) AS valeur_ajoutee,
    SUM(CASE WHEN pr.poste = 'ebe' THEN pr.montant ELSE 0 END) AS ebe,
    SUM(CASE WHEN pr.poste = 'resultat_exploitation' THEN pr.montant ELSE 0 END) AS resultat_exploitation,
    SUM(CASE WHEN pr.poste = 'resultat_net' THEN pr.montant ELSE 0 END) AS resultat_net
FROM projections pr
JOIN projets p ON p.id = pr.projet_id
WHERE pr.mois IS NULL
GROUP BY p.nom, pr.scenario, pr.annee
ORDER BY p.nom, pr.scenario, pr.annee;

-- Vue : tresorerie cumulee par mois
CREATE OR REPLACE VIEW v_tresorerie_cumulee AS
SELECT
    p.nom AS projet,
    t.scenario,
    t.annee,
    t.mois,
    SUM(CASE WHEN t.type_flux = 'encaissement' THEN t.montant ELSE 0 END) AS encaissements,
    SUM(CASE WHEN t.type_flux = 'decaissement' THEN t.montant ELSE 0 END) AS decaissements,
    SUM(CASE WHEN t.type_flux = 'encaissement' THEN t.montant ELSE -t.montant END) AS solde_mensuel,
    SUM(SUM(CASE WHEN t.type_flux = 'encaissement' THEN t.montant ELSE -t.montant END))
        OVER (PARTITION BY t.projet_id, t.scenario ORDER BY t.annee, t.mois) AS tresorerie_cumulee
FROM tresorerie t
JOIN projets p ON p.id = t.projet_id
GROUP BY p.nom, t.projet_id, t.scenario, t.annee, t.mois
ORDER BY p.nom, t.scenario, t.annee, t.mois;

-- Vue : ratios collectivites
CREATE OR REPLACE VIEW v_ratios_collectivite AS
SELECT
    p.nom AS projet,
    r.scenario,
    r.annee,
    r.indicateur,
    r.libelle,
    r.valeur,
    r.unite,
    r.alerte,
    r.seuil_alerte,
    r.commentaire
FROM resultats r
JOIN projets p ON p.id = r.projet_id
WHERE p.type = 'collectivite'
ORDER BY p.nom, r.scenario, r.annee, r.indicateur;
