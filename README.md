# MotoHub — API REST de gestion d'un garage moto

Projet Backend · CPNV Sainte-Croix · Classe SI-CA2a · Node.js + Express + MySQL

MotoHub est un backend (sans interface graphique obligatoire) qui expose, via une API REST en JSON, les données nécessaires au suivi d'un garage moto : **utilisateurs, clients, motos, rendez-vous et interventions**. L'accès est sécurisé par un jeton JWT et protégé par des rôles.

| | |
|---|---|
| Auteur | Sellé Sow (réalisation individuelle, ajustement soumis à l'approbation de l'enseignant) |
| Mandante | Violeta Seretan |
| Période | 4 novembre 2026 → 13 janvier 2027 |
| Charge | 36 périodes (27 h) |
| Méthode | Agile, 5 sprints, suivi avec **GitHub Project** : _(lien à ajouter dès que le GitHub Project est créé)_ |
| Statut | En cours de réalisation — release visée : **v1.0** |

## Sommaire

1. [Documentation du dépôt](#documentation-du-dépôt)
2. [Objectifs et périmètre](#objectifs-et-périmètre)
3. [Technologies](#technologies)
4. [Modèle de données](#modèle-de-données)
5. [Règles métier](#règles-métier)
6. [Exigences fonctionnelles](#exigences-fonctionnelles)
7. [Endpoints](#endpoints)
8. [Gestion des erreurs](#gestion-des-erreurs)
9. [Planification](#planification)
10. [Livrables et échéances](#livrables-et-échéances)
11. [Exigences techniques de l'enseignant](#exigences-techniques-de-lenseignant)
12. [Critères d'acceptation](#critères-dacceptation)
13. [Risques](#risques)
14. [Évolutions futures](#évolutions-futures)
15. [Points d'attention](#points-dattention)
16. [Installation et utilisation](#installation-et-utilisation)

## Documentation du dépôt

| Document | Contenu |
|---|---|
| [`docs/cahier-des-charges.md`](docs/cahier-des-charges.md) | Cahier des charges MotoHub v1.0 (transcription complète du PDF) |
| [`docs/consignes-projet-backend.md`](docs/consignes-projet-backend.md) | Consignes de l'enseignant pour le Projet Backend |
| [`docs/journal-de-travail.md`](docs/journal-de-travail.md) | Journal de travail (critère d'évaluation) |

## Objectifs et périmètre

**Objectif général** : concevoir et livrer une API REST fiable, documentée et testable pour centraliser la gestion d'un garage moto.

**Inclus**

- Authentification des utilisateurs (JWT) et contrôle des droits par rôle
- Gestion des clients, des motos, des rendez-vous et des interventions (CRUD)
- Gestion des relations entre entités, validation des données
- Gestion uniforme des erreurs
- Documentation des endpoints, tests manuels avec Postman, dépôt GitHub et README

**Exclus de la v1.0**

- Interface frontend complète, application mobile native
- Facturation, paiements, comptabilité
- Gestion avancée des stocks et pièces détachées
- Notifications SMS ou e-mail, synchronisation avec un agenda externe
- Multi-garages avancé
- Déploiement cloud de production

## Technologies

| Domaine | Choix |
|---|---|
| Backend | Node.js |
| Framework | Express |
| Base de données | MySQL |
| Architecture | API REST, échanges en JSON |
| Authentification | JWT Bearer |
| Mots de passe | Hachage (par exemple bcrypt) |
| Validation | Côté serveur |
| Erreurs | Gestion centralisée |
| Tests | Postman |
| Configuration | Variables d'environnement |
| Organisation du code | Séparation routes / contrôleurs / services / middlewares / accès aux données |

Les versions exactes des dépendances seront précisées dans ce README au fil du développement.

## Modèle de données

Cinq entités. Les livrables **MCD** et **MLD** (PDF) seront ajoutés dans le dossier `docs/`.

| Entité | Rôle | Attributs principaux |
|---|---|---|
| Utilisateur | Compte autorisé à accéder à l'API | id, nom, e-mail, mot de passe haché, rôle, date de création |
| Client | Personne cliente du garage | id, nom, prénom, e-mail, téléphone, adresse, date de création |
| Moto | Véhicule appartenant à un client | id, marque, modèle, année, immatriculation, numéro de châssis, kilométrage, client_id |
| Rendez-vous | Créneau planifié pour une moto et un client | id, date et heure, motif, statut, notes, moto_id, client_id, utilisateur_id |
| Intervention | Travail réalisé ou à réaliser sur une moto | id, description, date de début, date de fin, statut, coût estimé, coût final, notes, moto_id, rendez_vous_id, utilisateur_id |

**Relations**

- Un Client possède 0..n Motos ; une Moto appartient à un seul Client.
- Un Client peut avoir 0..n Rendez-vous ; une Moto peut faire l'objet de 0..n Rendez-vous.
- Un Rendez-vous concerne une Moto et un Client et peut être créé par un Utilisateur.
- Une Moto possède 0..n Interventions ; un Rendez-vous peut être associé à 0..1 Intervention.
- Un Utilisateur peut créer ou gérer plusieurs Rendez-vous et Interventions.

Les clés étrangères et contraintes d'intégrité sont définies dans MySQL pour éviter les références orphelines.

## Règles métier

| ID | Règle |
|---|---|
| RB-01 | L'e-mail d'un utilisateur est unique. |
| RB-02 | Les mots de passe ne sont jamais stockés en clair. |
| RB-03 | Un client doit exister avant de lui rattacher une moto. |
| RB-04 | Immatriculation et numéro de châssis sont uniques lorsqu'ils sont renseignés. |
| RB-05 | Une moto ne peut pas être rattachée à un client inexistant. |
| RB-06 | Un rendez-vous référence un client et une moto existants. |
| RB-07 | Le client du rendez-vous est le propriétaire de la moto concernée. |
| RB-08 | Pas de rendez-vous avec une date invalide ; les conflits de créneau sont signalés lorsque la règle s'applique. |
| RB-09 | Le statut d'un rendez-vous est limité à des valeurs définies (ex. planifié, confirmé, réalisé, annulé). |
| RB-10 | Une intervention référence une moto existante ; son statut suit des valeurs autorisées (ex. ouverte, en cours, terminée, annulée). |
| RB-11 | Les montants et le kilométrage ne peuvent pas être négatifs. |
| RB-12 | Les ressources protégées exigent un JWT valide ; les opérations sensibles respectent les droits du rôle. |
| RB-13 | Une suppression respecte les dépendances référentielles et retourne une erreur explicite en cas de conflit. |

## Exigences fonctionnelles

| ID | Exigence | Description | Priorité |
|---|---|---|---|
| EF-01 | Authentification | Connexion et réception d'un jeton JWT | Haute |
| EF-02 | Autorisation | Vérification du jeton et du rôle avant une opération protégée | Haute |
| EF-03 | Utilisateurs | Consulter et gérer les comptes selon les droits | Moyenne |
| EF-04 | Clients | CRUD client | Haute |
| EF-05 | Motos | CRUD moto liée à un client | Haute |
| EF-06 | Rendez-vous | CRUD rendez-vous | Haute |
| EF-07 | Interventions | CRUD intervention | Haute |
| EF-08 | Recherche | Filtrer ou consulter par identifiant et critères utiles | Moyenne |
| EF-09 | Validation | Refuser les données absentes, invalides ou incohérentes | Haute |
| EF-10 | Erreurs | Codes HTTP et messages JSON cohérents | Haute |
| EF-11 | Documentation | Installation, variables, routes et exemples | Haute |
| EF-12 | Tests | Scénarios principaux vérifiés avec Postman | Haute |
| EF-13 | Versionnement | Code et livrables dans GitHub | Haute |
| EF-14 | Traçabilité | Documenter choix, limites et écarts | Moyenne |

## Endpoints

| Domaine | Méthode | Route | Usage | Protection |
|---|---|---|---|---|
| Auth | POST | `/api/auth/login` | Authentifier et retourner un JWT | Publique |
| Auth | POST | `/api/auth/register` | Créer un utilisateur | Protégée ou restreinte (décision finale à prendre) |
| Clients | GET | `/api/clients` | Lister les clients | JWT |
| Clients | GET | `/api/clients/:id` | Consulter un client | JWT |
| Clients | POST | `/api/clients` | Créer un client | JWT |
| Clients | PUT | `/api/clients/:id` | Mettre à jour un client | JWT + rôle |
| Clients | DELETE | `/api/clients/:id` | Supprimer un client (sans dépendance bloquante) | JWT + rôle |
| Motos | GET | `/api/motos` | Lister les motos | JWT |
| Motos | GET | `/api/motos/:id` | Consulter une moto | JWT |
| Motos | POST | `/api/motos` | Créer une moto | JWT |
| Motos | PUT | `/api/motos/:id` | Modifier une moto | JWT + rôle |
| Motos | DELETE | `/api/motos/:id` | Supprimer une moto | JWT + rôle |
| Rendez-vous | GET | `/api/rendez-vous` | Lister les rendez-vous | JWT |
| Rendez-vous | GET | `/api/rendez-vous/:id` | Consulter un rendez-vous | JWT |
| Rendez-vous | POST | `/api/rendez-vous` | Créer un rendez-vous | JWT |
| Rendez-vous | PUT | `/api/rendez-vous/:id` | Modifier un rendez-vous | JWT + rôle |
| Rendez-vous | DELETE | `/api/rendez-vous/:id` | Annuler ou supprimer un rendez-vous | JWT + rôle |
| Interventions | GET | `/api/interventions` | Lister les interventions | JWT |
| Interventions | GET | `/api/interventions/:id` | Consulter une intervention | JWT |
| Interventions | POST | `/api/interventions` | Créer une intervention | JWT |
| Interventions | PUT | `/api/interventions/:id` | Modifier une intervention | JWT + rôle |
| Interventions | DELETE | `/api/interventions/:id` | Supprimer une intervention si autorisé | JWT + rôle |

Les statuts définitifs, les droits précis par rôle et les schémas JSON seront figés ici et dans la documentation de l'API.

## Gestion des erreurs

| Code | Utilisation |
|---|---|
| 200 OK | Lecture ou mise à jour réussie (corps JSON) |
| 201 Created | Ressource créée |
| 204 No Content | Suppression réussie (sans corps) |
| 400 Bad Request | Données absentes, invalides ou JSON mal formé |
| 401 Unauthorized | Authentification absente, invalide ou jeton expiré |
| 403 Forbidden | Authentifié mais droits insuffisants |
| 404 Not Found | Ressource ou relation introuvable |
| 409 Conflict | Doublon, conflit de créneau ou contrainte d'intégrité |
| 500 Internal Server Error | Erreur interne, journalisée côté serveur sans détail sensible |

Format d'erreur JSON homogène recommandé : au minimum `status`, `code` et `message`, plus des détails de validation si nécessaire.

## Planification

Période : 4 nov. 2026 → 13 janv. 2027 · 36 périodes (27 h) · planification indicative, ajustable avec validation de l'enseignant.

| Sprint | Semaines | Objectif | Résultats attendus | Charge |
|---|---|---|---|---|
| Sprint 1 | 1–2 | Cadrage et structuration | Cadrage, analyse, périmètre, MCD initial, structure du projet, dépôt GitHub | 6 p. |
| Sprint 2 | 3–4 | Fondations techniques et sécurité | Schéma MySQL, modèles, connexion à la base, authentification JWT, sécurité des mots de passe | 8 p. |
| Sprint 3 | 5–6 | Ressources principales | Endpoints Clients et Motos, validations, règles métier, premiers tests Postman | 9 p. |
| Sprint 4 | 7 | Suivi opérationnel | Endpoints Rendez-vous et Interventions, gestion des erreurs, autorisations, intégration | 8 p. |
| Sprint 5 | 8 | Stabilisation et remise | Tests de bout en bout, README, collection Postman, MLD, nettoyage du code, préparation de la remise | 5 p. |

Le suivi détaillé (backlog, avancement par sprint) se fait dans le **GitHub Project** : _(lien à ajouter dès que le GitHub Project est créé)_

## Livrables et échéances

Échéances fixées par les consignes de l'enseignant :

| Livrable | Format | Support | Échéance |
|---|---|---|---|
| Cahier des charges | PDF | Teams | Semaine 1 |
| MCD | PDF | Teams | Semaine 2 |
| Lien GitHub | URL | Teams | Semaine 2 |
| MLD | PDF | Teams | Semaine 3 |
| Version 1.0 : API pleinement fonctionnelle et testable avec Postman | Release GitHub | GitHub | Semaine 7 |

Livrables complémentaires du cahier des charges : README, collection Postman (avec environnements/variables), code source Node.js/Express, scripts ou instructions MySQL, éléments de preuve des tests (résultats, captures).

## Exigences techniques de l'enseignant

- Chaque fichier a un **en-tête rempli**.
- Le code est **correctement commenté**.
- Respect des **conventions de nommage du langage** et des **conventions du CPNV** pour la modélisation de la base de données.
- Cas d'erreur traités : messages d'erreur, pas de bug bloquant.
- API **sécurisée** (gestion d'un token).
- Documentation de l'API générable à partir des commentaires du code (facultatif).
- Utilisation de l'IA : comme aide et pour des points ponctuels uniquement ; l'IA n'écrit pas le code et ne réfléchit pas à la place de l'étudiant.
- Évaluation : documentation, journal de travail, respect des normes, qualité, etc.

## Critères d'acceptation

- [ ] L'installation est décrite et reproductible
- [ ] L'API démarre avec la configuration documentée
- [ ] La connexion MySQL fonctionne
- [ ] L'authentification JWT fonctionne
- [ ] Les mots de passe sont hachés
- [ ] Les routes Clients, Motos, Rendez-vous et Interventions sont disponibles
- [ ] Les relations et contraintes sont respectées
- [ ] Les entrées invalides sont rejetées
- [ ] Les autorisations sont appliquées
- [ ] Les codes HTTP attendus sont retournés
- [ ] Les erreurs sont lisibles et homogènes
- [ ] Les scénarios principaux sont vérifiés avec Postman
- [ ] Le README et la collection Postman sont exploitables
- [ ] Le dépôt GitHub contient la version remise
- [ ] Les livrables MCD et MLD sont cohérents avec la base
- [ ] La release v1.0 est identifiable
- [ ] Le périmètre reste compatible avec une réalisation individuelle (approbation de l'enseignant)

## Risques

| Risque | Mesure d'atténuation |
|---|---|
| Périmètre trop large | Réduire aux fonctionnalités prioritaires, validation régulière |
| Estimation de charge insuffisante | Suivi hebdomadaire, priorisation |
| Erreurs de modélisation | Revue du MCD/MLD avant l'implémentation |
| Failles d'authentification, mots de passe mal protégés | JWT, hachage, variables d'environnement, tests négatifs |
| Incohérences de données | Clés étrangères, contraintes, validations |
| Conflits de rendez-vous | Règle métier dédiée, tests de cas limites |
| Documentation incomplète | Rédaction progressive du README |
| Perte de code ou historique insuffisant | Commits réguliers, dépôt GitHub |
| Dépendance à une décision pédagogique | Signalement transparent de l'ajustement individuel, validation de l'enseignant |

## Évolutions futures

Hors périmètre v1.0 : interface web pour le personnel, application mobile, notifications e-mail/SMS, pièces et stock, devis/factures/paiements, historique détaillé du véhicule, rapports et indicateurs, calendrier synchronisé, multi-garages et permissions avancées, documentation OpenAPI/Swagger, tests automatisés et CI/CD, déploiement cloud sécurisé, journal d'audit.

## Points d'attention

Écarts et points à trancher repérés en croisant le cahier des charges et les consignes (à documenter dans le cadre de l'exigence EF-14) :

- **Projet individuel** : les consignes prévoient des groupes de 1 à 4 membres avec au moins une entité par membre ; MotoHub compte 5 entités pour 1 personne. L'ajustement est soumis à l'approbation de l'enseignant.
- **Échéance du MLD** : les consignes fixent le MLD à la **semaine 3**, alors que le planning du cahier des charges le place dans le Sprint 5 (semaine 8).
- **Échéance de la release v1.0** : les consignes demandent la release à la **semaine 7**, alors que le planning du cahier des charges prévoit la stabilisation et la remise en semaine 8 (Sprint 5).
- **Gestion des utilisateurs (EF-03)** : aucun endpoint de gestion des comptes (hors login/register) n'apparaît dans la vue d'ensemble ; à définir.
- **`POST /api/auth/register`** : protection (publique, restreinte, réservée à un rôle) à décider.
- **Rôles, statuts et droits par rôle** : à figer dans la documentation de l'API.

## Installation et utilisation

> Section à compléter au fil des sprints (Sprint 2 pour la base de données et la configuration, Sprint 5 pour la version finale). Rien n'est figé tant que le code n'est pas écrit.

- [ ] Prérequis (versions de Node.js et de MySQL)
- [ ] Installation des dépendances
- [ ] Création et préparation de la base MySQL (script SQL ou instructions)
- [ ] Variables d'environnement à définir (connexion MySQL, secret JWT, port, etc.)
- [ ] Démarrage de l'API
- [ ] Utilisation de la collection Postman (environnement, variables)
- [ ] Exemples de requêtes et de réponses (succès et erreurs)
- [ ] Versions exactes des dépendances
