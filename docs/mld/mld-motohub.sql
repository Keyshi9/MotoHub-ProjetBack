-- ============================================================
-- MotoHub - MLD (modele logique) implemente en MySQL 8.0.16+
-- Derive du MCD (docs/mcd.md) et du cahier des charges v1.0
-- ============================================================

DROP DATABASE IF EXISTS motohub;
CREATE DATABASE motohub
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;
USE motohub;

-- ------------------------------------------------------------
-- UTILISATEUR
-- RB-01 : e-mail unique ; RB-02 : mot de passe uniquement hache
-- Valeurs de role a valider (non definies dans le cahier des charges)
-- ------------------------------------------------------------
CREATE TABLE utilisateur (
  id                INT UNSIGNED  NOT NULL AUTO_INCREMENT,
  nom               VARCHAR(100)  NOT NULL,
  email             VARCHAR(255)  NOT NULL,
  mot_de_passe_hash VARCHAR(255)  NOT NULL,
  role              ENUM('admin','employe') NOT NULL DEFAULT 'employe',
  date_creation     DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_utilisateur_email (email)
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- CLIENT
-- ------------------------------------------------------------
CREATE TABLE client (
  id            INT UNSIGNED NOT NULL AUTO_INCREMENT,
  nom           VARCHAR(100) NOT NULL,
  prenom        VARCHAR(100) NOT NULL,
  email         VARCHAR(255) NULL,
  telephone     VARCHAR(30)  NULL,
  adresse       VARCHAR(255) NULL,
  date_creation DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- MOTO  (POSSEDER : CLIENT 0,n - MOTO 1,1)
-- RB-03/05 : client_id obligatoire + FK
-- RB-04 : immatriculation et chassis uniques s'ils sont renseignes
--         (UNIQUE autorise plusieurs NULL en MySQL)
-- RB-11 : kilometrage >= 0
-- uq_moto_id_client sert de cible a la FK composite du rendez-vous (RB-07)
-- ------------------------------------------------------------
CREATE TABLE moto (
  id              INT UNSIGNED  NOT NULL AUTO_INCREMENT,
  marque          VARCHAR(100)  NOT NULL,
  modele          VARCHAR(100)  NOT NULL,
  annee           SMALLINT UNSIGNED NULL,
  immatriculation VARCHAR(20)   NULL,
  numero_chassis  VARCHAR(30)   NULL,
  kilometrage     INT UNSIGNED  NOT NULL DEFAULT 0,
  client_id       INT UNSIGNED  NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_moto_immatriculation (immatriculation),
  UNIQUE KEY uq_moto_chassis (numero_chassis),
  UNIQUE KEY uq_moto_id_client (id, client_id),
  CONSTRAINT fk_moto_client FOREIGN KEY (client_id)
    REFERENCES client (id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT ck_moto_km CHECK (kilometrage >= 0)
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- RENDEZ_VOUS
-- PRENDRE   : CLIENT 0,n - RDV 1,1   -> client_id NOT NULL
-- CONCERNER : MOTO 0,n   - RDV 1,1   -> moto_id NOT NULL
-- CREER     : UTILISATEUR 0,n - RDV 0,1 -> utilisateur_id NULL
-- RB-07 : la FK composite (moto_id, client_id) -> moto(id, client_id)
--         garantit que le client du RDV est le proprietaire de la moto
-- RB-08 : un seul RDV par moto et par creneau (conflit -> erreur 1062)
-- RB-09 : statuts a figer
-- ------------------------------------------------------------
CREATE TABLE rendez_vous (
  id             INT UNSIGNED NOT NULL AUTO_INCREMENT,
  date_heure     DATETIME     NOT NULL,
  motif          VARCHAR(255) NOT NULL,
  statut         ENUM('planifie','confirme','realise','annule')
                 NOT NULL DEFAULT 'planifie',
  notes          TEXT         NULL,
  moto_id        INT UNSIGNED NOT NULL,
  client_id      INT UNSIGNED NOT NULL,
  utilisateur_id INT UNSIGNED NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_rdv_moto_creneau (moto_id, date_heure),
  KEY idx_rdv_client (client_id),
  KEY idx_rdv_utilisateur (utilisateur_id),
  CONSTRAINT fk_rdv_moto_proprietaire FOREIGN KEY (moto_id, client_id)
    REFERENCES moto (id, client_id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_rdv_client FOREIGN KEY (client_id)
    REFERENCES client (id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_rdv_utilisateur FOREIGN KEY (utilisateur_id)
    REFERENCES utilisateur (id)
    ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- INTERVENTION
-- AVOIR        : MOTO 0,n - INTERVENTION 1,1  -> moto_id NOT NULL
-- DONNER LIEU A: RDV 0,1 - INTERVENTION 0,1   -> rendez_vous_id NULL + UNIQUE
-- GERER        : UTILISATEUR 0,n - INTERVENTION 0,1 -> utilisateur_id NULL
-- RB-10 : statuts a figer ; RB-11 : montants >= 0
-- ------------------------------------------------------------
CREATE TABLE intervention (
  id             INT UNSIGNED  NOT NULL AUTO_INCREMENT,
  description    TEXT          NOT NULL,
  date_debut     DATETIME      NULL,
  date_fin       DATETIME      NULL,
  statut         ENUM('ouverte','en_cours','terminee','annulee')
                 NOT NULL DEFAULT 'ouverte',
  cout_estime    DECIMAL(10,2) NULL,
  cout_final     DECIMAL(10,2) NULL,
  notes          TEXT          NULL,
  moto_id        INT UNSIGNED  NOT NULL,
  rendez_vous_id INT UNSIGNED  NULL,
  utilisateur_id INT UNSIGNED  NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_intervention_rdv (rendez_vous_id),
  KEY idx_intervention_moto (moto_id),
  KEY idx_intervention_utilisateur (utilisateur_id),
  CONSTRAINT fk_intervention_moto FOREIGN KEY (moto_id)
    REFERENCES moto (id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_intervention_rdv FOREIGN KEY (rendez_vous_id)
    REFERENCES rendez_vous (id)
    ON UPDATE CASCADE ON DELETE SET NULL,
  CONSTRAINT fk_intervention_utilisateur FOREIGN KEY (utilisateur_id)
    REFERENCES utilisateur (id)
    ON UPDATE CASCADE ON DELETE SET NULL,
  CONSTRAINT ck_intervention_cout_estime CHECK (cout_estime IS NULL OR cout_estime >= 0),
  CONSTRAINT ck_intervention_cout_final  CHECK (cout_final  IS NULL OR cout_final  >= 0),
  CONSTRAINT ck_intervention_dates CHECK (date_fin IS NULL OR date_debut IS NULL OR date_fin >= date_debut)
) ENGINE=InnoDB;
