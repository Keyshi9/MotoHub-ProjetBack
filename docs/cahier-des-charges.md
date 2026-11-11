# MotoHub — Cahier des charges

**API REST de gestion d'un garage moto**

> Transcription du cahier des charges de référence (version 1.0, 4 nov. 2026, PDF de 22 pages).
> CPNV Sainte-Croix · SI-CA2a · Mandante : Violeta Seretan · Réalisation individuelle (ajustement au format individuel soumis à l'approbation de l'enseignant).

| | |
|---|---|
| Période | 4 nov. 2026 – 13 janv. 2027 |
| Charge | 36 périodes (27 h) |
| Technologies | Node.js · MySQL |
| Version | 1.0 · 4 nov. 2026 |

---

## 1. Document de référence et périmètre du projet individuel

Le présent document constitue le cahier des charges de référence du projet MotoHub, consacré à la conception et à la réalisation d'un backend d'API REST pour la gestion d'un garage moto.

Le projet est réalisé individuellement par **Sellé Sow**. Le périmètre fonctionnel, la charge de travail et l'organisation sont donc adaptés à une réalisation individuelle. Cet ajustement est explicitement soumis à l'approbation de l'enseignant.

Le projet s'inscrit dans le contexte du CPNV Sainte-Croix, pour la classe SI-CA2a, sous la responsabilité de la mandante Violeta Seretan.

La réalisation est prévue du 4 nov. 2026 au 13 janv. 2027, pour une charge totale de 36 périodes (27 h).

**Statut du document**

- Version 1.0
- Date : 4 nov. 2026
- Auteur : étudiant individuel
- Validation : sous réserve de l'approbation de l'enseignant

---

## 2. Objectifs

### Objectif général

Concevoir et livrer une API REST fiable, documentée et testable afin de centraliser la gestion d'un garage moto. L'API doit fournir une base exploitable pour administrer les utilisateurs, les clients, les motos, les rendez-vous et les interventions.

### Objectifs spécifiques

- **Utilisateurs et authentification** — gérer les comptes et sécuriser l'accès à l'API.
- **Clients** — créer, consulter, modifier et supprimer les fiches clients selon les droits accordés.
- **Motos** — gérer les motos rattachées à leurs propriétaires et maintenir leurs informations principales.
- **Rendez-vous** — planifier, consulter, modifier et supprimer les créneaux du garage.
- **Interventions** — enregistrer et suivre les travaux réalisés ou à réaliser.
- **Intégrité des données** — appliquer les relations, contraintes et validations nécessaires.
- **Règles d'accès** — protéger les ressources et respecter les droits associés aux rôles.
- **Réponses JSON** — fournir des réponses cohérentes, prévisibles et correctement structurées.
- **Tests** — tester l'API avec Postman sur les scénarios principaux et les cas d'erreur.
- **Versionnement** — versionner le code et les livrables avec GitHub.
- **Remise** — livrer une base exploitable, documentée et compatible avec le périmètre d'une réalisation individuelle.

---

## 3. Description et périmètre fonctionnel

MotoHub est un backend sans interface graphique obligatoire. Il expose des ressources métier au moyen d'une API REST et permet à un garage de gérer les informations nécessaires au suivi des clients, des motos, des rendez-vous et des interventions.

### 3.1 Éléments inclus

- Authentification des utilisateurs.
- Gestion des clients.
- Gestion des motos.
- Planification, consultation, modification et suppression des rendez-vous.
- Création et suivi des interventions.
- Gestion des relations entre les entités.
- Validation des données et contrôle des droits.
- Gestion uniforme des erreurs.
- Documentation des endpoints.
- Tests manuels avec Postman.
- Dépôt GitHub et README.

### 3.2 Éléments exclus

- Interface frontend complète.
- Application mobile native.
- Gestion de facturation et de paiements.
- Comptabilité.
- Gestion avancée des stocks et pièces détachées.
- Notifications SMS ou e-mail.
- Synchronisation avec un agenda externe.
- Multi-garages avancé.
- Déploiement cloud de production, sauf si demandé ultérieurement.

---

## 4. Modèle de données

Le modèle conceptuel de MotoHub repose sur **cinq entités principales**. Chaque entité représente un objet métier nécessaire au fonctionnement du garage et possède des attributs permettant d'assurer son identification, son suivi et ses relations avec les autres entités.

| Entité | Rôle | Attributs principaux |
|---|---|---|
| Utilisateur | Compte autorisé à accéder à l'API | id, nom, e-mail, mot de passe haché, rôle, date de création |
| Client | Personne cliente du garage | id, nom, prénom, e-mail, téléphone, adresse, date de création |
| Moto | Véhicule appartenant à un client | id, marque, modèle, année, immatriculation, numéro de châssis, kilométrage, client_id |
| Rendez-vous | Créneau planifié pour une moto et un client | id, date et heure, motif, statut, notes, moto_id, client_id, utilisateur_id |
| Intervention | Travail réalisé ou à réaliser sur une moto | id, description, date de début, date de fin, statut, coût estimé, coût final, notes, moto_id, rendez_vous_id, utilisateur_id |

### Relations

- Un **Client** possède zéro à plusieurs **Motos**.
- Une **Moto** appartient à un seul **Client**.
- Un **Client** peut avoir zéro à plusieurs **Rendez-vous**.
- Une **Moto** peut faire l'objet de zéro à plusieurs **Rendez-vous**.
- Un **Rendez-vous** concerne une **Moto** et un **Client** et peut être créé par un **Utilisateur**.
- Une **Moto** possède zéro à plusieurs **Interventions**.
- Un **Rendez-vous** peut être associé à zéro ou une **Intervention**.
- Un **Utilisateur** peut créer ou gérer plusieurs **Rendez-vous** et **Interventions**.

Les clés étrangères et les contraintes d'intégrité doivent être définies dans MySQL afin de garantir la cohérence des relations et d'éviter les références orphelines.

**MCD / MLD** : à joindre comme livrables du projet.

---

## 5. Règles métier

| ID | Règle |
|---|---|
| RB-01 | L'e-mail d'un utilisateur doit être unique. |
| RB-02 | Les mots de passe ne sont jamais stockés en clair. |
| RB-03 | Un client doit exister avant de lui rattacher une moto. |
| RB-04 | Une immatriculation et un numéro de châssis doivent être uniques lorsqu'ils sont renseignés. |
| RB-05 | Une moto ne peut pas être rattachée à un client inexistant. |
| RB-06 | Un rendez-vous doit référencer un client et une moto existants. |
| RB-07 | Le client associé au rendez-vous doit être le propriétaire de la moto concernée. |
| RB-08 | Un rendez-vous ne peut pas être créé avec une date invalide ; les conflits de créneau doivent être signalés lorsque la règle s'applique. |
| RB-09 | Le statut d'un rendez-vous est limité à des valeurs définies, par exemple planifié, confirmé, réalisé ou annulé. |
| RB-10 | Une intervention doit référencer une moto existante et son statut doit suivre les valeurs autorisées, par exemple ouverte, en cours, terminée ou annulée. |
| RB-11 | Les montants et le kilométrage ne peuvent pas être négatifs. |
| RB-12 | Les ressources protégées exigent un jeton JWT valide et les opérations sensibles respectent les droits du rôle. |
| RB-13 | La suppression d'une ressource doit respecter les dépendances référentielles et retourner une erreur explicite en cas de conflit. |

---

## 6. Exigences fonctionnelles

Les exigences suivantes définissent les capacités minimales attendues pour la version 1.0. La priorité indique l'importance de chaque exigence pour la remise du projet.

| ID | Exigence | Description | Priorité |
|---|---|---|---|
| EF-01 | Authentification | L'utilisateur peut se connecter et recevoir un jeton JWT. | Haute |
| EF-02 | Autorisation | L'API vérifie le jeton et le rôle avant une opération protégée. | Haute |
| EF-03 | Utilisateurs | Un utilisateur autorisé peut consulter et gérer les comptes selon ses droits. | Moyenne |
| EF-04 | Clients | Créer, consulter, modifier et supprimer un client. | Haute |
| EF-05 | Motos | Créer, consulter, modifier et supprimer une moto liée à un client. | Haute |
| EF-06 | Rendez-vous | Créer, consulter, modifier et supprimer un rendez-vous. | Haute |
| EF-07 | Interventions | Créer, consulter, modifier et supprimer une intervention. | Haute |
| EF-08 | Recherche | Filtrer ou consulter les ressources par identifiant et critères utiles. | Moyenne |
| EF-09 | Validation | Refuser les données absentes, invalides ou incohérentes. | Haute |
| EF-10 | Erreurs | Retourner des codes HTTP et des messages JSON cohérents. | Haute |
| EF-11 | Documentation | Décrire l'installation, les variables, les routes et les exemples. | Haute |
| EF-12 | Tests | Vérifier les scénarios principaux avec Postman. | Haute |
| EF-13 | Versionnement | Maintenir le code et les livrables dans GitHub. | Haute |
| EF-14 | Traçabilité | Documenter les choix, les limites et les éventuels écarts. | Moyenne |

---

## 7. Spécifications techniques

| Domaine | Spécification |
|---|---|
| Backend | Node.js |
| Framework | Express |
| Base de données | MySQL |
| Architecture | API REST |
| Format d'échange | JSON |
| Authentification | JWT Bearer |
| Mots de passe | Hachage avec une bibliothèque adaptée, par exemple bcrypt |
| Validation | Validation des entrées côté serveur |
| Erreurs | Gestion centralisée des erreurs |
| Tests | Tests et vérification avec Postman |
| Versionnement | GitHub |
| Configuration | Variables d'environnement |
| Organisation du code | Séparation recommandée entre routes, contrôleurs, services, middlewares et accès aux données |

Les dépendances et versions exactes seront documentées dans le README, sans être figées dans le présent cahier des charges.

### Exigences de qualité

- Les réponses doivent être déterministes et utiliser des statuts HTTP appropriés.
- Les noms de routes doivent rester cohérents et prévisibles.
- La sécurité de base doit être appliquée aux comptes, aux jetons et aux données sensibles.
- L'intégrité transactionnelle doit être assurée lorsque plusieurs opérations dépendent les unes des autres.
- Le code doit rester lisible, structuré et maintenable dans le périmètre d'une réalisation individuelle.

---

## 8. Vue d'ensemble des endpoints

Routes REST prévues pour la version 1.0. Les droits précis pourront être affinés dans la documentation finale, sans modifier le principe général de protection des ressources.

| Domaine | Méthode | Route | Usage | Protection |
|---|---|---|---|---|
| Auth | POST | `/api/auth/login` | Authentifier un utilisateur et retourner un JWT | Publique |
| Auth | POST | `/api/auth/register` | Créer un utilisateur si autorisé par le périmètre retenu | Protégée ou restreinte selon décision finale |
| Clients | GET | `/api/clients` | Lister les clients | JWT |
| Clients | GET | `/api/clients/:id` | Consulter un client | JWT |
| Clients | POST | `/api/clients` | Créer un client | JWT |
| Clients | PUT | `/api/clients/:id` | Remplacer ou mettre à jour un client | JWT et rôle approprié |
| Clients | DELETE | `/api/clients/:id` | Supprimer un client si aucune dépendance bloquante | JWT et rôle approprié |
| Motos | GET | `/api/motos` | Lister les motos | JWT |
| Motos | GET | `/api/motos/:id` | Consulter une moto | JWT |
| Motos | POST | `/api/motos` | Créer une moto | JWT |
| Motos | PUT | `/api/motos/:id` | Modifier une moto | JWT et rôle approprié |
| Motos | DELETE | `/api/motos/:id` | Supprimer une moto | JWT et rôle approprié |
| Rendez-vous | GET | `/api/rendez-vous` | Lister les rendez-vous | JWT |
| Rendez-vous | GET | `/api/rendez-vous/:id` | Consulter un rendez-vous | JWT |
| Rendez-vous | POST | `/api/rendez-vous` | Créer un rendez-vous | JWT |
| Rendez-vous | PUT | `/api/rendez-vous/:id` | Modifier un rendez-vous | JWT et rôle approprié |
| Rendez-vous | DELETE | `/api/rendez-vous/:id` | Annuler ou supprimer un rendez-vous | JWT et rôle approprié |
| Interventions | GET | `/api/interventions` | Lister les interventions | JWT |
| Interventions | GET | `/api/interventions/:id` | Consulter une intervention | JWT |
| Interventions | POST | `/api/interventions` | Créer une intervention | JWT |
| Interventions | PUT | `/api/interventions/:id` | Modifier une intervention | JWT et rôle approprié |
| Interventions | DELETE | `/api/interventions/:id` | Supprimer une intervention si autorisé | JWT et rôle approprié |

Les noms définitifs des statuts, les droits précis par rôle et les schémas JSON seront figés dans la documentation API et le README.

---

## 9. Gestion des erreurs HTTP

Les erreurs doivent être traitées de manière centralisée afin de fournir des réponses prévisibles au client de l'API et de faciliter les tests avec Postman.

| Code | Signification | Utilisation dans MotoHub |
|---|---|---|
| 200 OK | Lecture ou mise à jour réussie | Lecture ou mise à jour réussie avec corps JSON. |
| 201 Created | Ressource créée | Ressource créée avec succès. |
| 204 No Content | Suppression réussie | Suppression réussie sans corps de réponse. |
| 400 Bad Request | Requête invalide | Données absentes, invalides ou corps JSON mal formé. |
| 401 Unauthorized | Authentification requise | Authentification absente, invalide ou jeton expiré. |
| 403 Forbidden | Accès refusé | Utilisateur authentifié mais sans droit suffisant. |
| 404 Not Found | Ressource introuvable | Ressource ou relation introuvable. |
| 409 Conflict | Conflit | Doublon, conflit de créneau ou contrainte d'intégrité. |
| 500 Internal Server Error | Erreur interne | Erreur interne non prévue, journalisée côté serveur sans exposer de détails sensibles. |

Une réponse d'erreur JSON homogène est recommandée. Elle contient au minimum `status`, `code` et `message`, ainsi que des détails de validation lorsque cela est nécessaire.

---

## 10. Planification

- Période globale : 4 nov. 2026 – 13 janv. 2027
- Charge totale : 36 périodes (27 h)
- La planification est indicative et peut être ajustée avec validation de l'enseignant.

| Sprint | Semaines | Objectif | Résultats attendus | Charge indicative |
|---|---|---|---|---|
| Sprint 1 | Semaines 1–2 | Cadrage et structuration | Cadrage, analyse, périmètre, MCD initial, structure du projet et dépôt GitHub. | 6 périodes |
| Sprint 2 | Semaines 3–4 | Fondations techniques et sécurité | Schéma MySQL, modèles, connexion à la base, authentification JWT et sécurité des mots de passe. | 8 périodes |
| Sprint 3 | Semaines 5–6 | Ressources principales | Endpoints Clients et Motos, validations, règles métier et premiers tests Postman. | 9 périodes |
| Sprint 4 | Semaine 7 | Suivi opérationnel | Endpoints Rendez-vous et Interventions, gestion des erreurs, autorisations et intégration. | 8 périodes |
| Sprint 5 | Semaine 8 | Stabilisation et remise | Stabilisation, tests de bout en bout, README, collection Postman, MLD, nettoyage du code et préparation de la remise. | 5 périodes |
| **Total** | | | | **36 périodes (27 h)** |

---

## 11. Livrables

Les livrables remis doivent permettre de comprendre le projet, de l'installer, de le tester et d'en vérifier la cohérence avec le modèle de données.

| Livrable | Contenu |
|---|---|
| Cahier des charges | Document de référence présentant le périmètre, les objectifs, les exigences et les critères de réussite. |
| MCD | Modèle conceptuel des données cohérent avec les entités et les relations du projet. |
| URL du dépôt GitHub | Adresse du dépôt contenant le code, la documentation et les livrables. L'URL GitHub sera complétée au moment de la remise, sans en inventer une. |
| MLD | Modèle logique des données correspondant à la structure MySQL retenue. |
| Release API v1.0 | Version identifiable de l'API correspondant au périmètre remis. |
| README | Installation, configuration, modèle de données et exemples d'utilisation. |
| Collection Postman | Requêtes de vérification avec environnements ou variables nécessaires. |
| Code source Node.js/Express | Implémentation complète du backend dans une structure lisible et cohérente. |
| Scripts ou instructions MySQL | Scripts ou instructions de création et de préparation de la base MySQL. |
| Éléments de preuve des tests | Résultats, captures ou indications permettant de vérifier les scénarios principaux, lorsque nécessaire. |

---

## 12. Critères d'acceptation

La remise est considérée comme conforme lorsque les points suivants peuvent être vérifiés :

- L'installation est décrite et reproductible.
- L'API démarre avec la configuration documentée.
- La connexion MySQL fonctionne.
- L'authentification JWT fonctionne.
- Les mots de passe sont hachés.
- Les routes principales Clients, Motos, Rendez-vous et Interventions sont disponibles.
- Les relations et contraintes sont respectées.
- Les entrées invalides sont rejetées.
- Les autorisations sont appliquées.
- Les codes HTTP attendus sont retournés.
- Les erreurs sont lisibles et homogènes.
- Les scénarios principaux sont vérifiés avec Postman.
- Le README et la collection Postman sont exploitables.
- Le dépôt GitHub contient la version remise.
- Les livrables MCD et MLD sont cohérents avec la base.
- La release v1.0 est identifiable.
- L'ensemble reste compatible avec le périmètre d'une réalisation individuelle, sous réserve d'approbation de l'enseignant.

---

## 13. Risques et mesures d'atténuation

| Risque | Impact | Mesure d'atténuation |
|---|---|---|
| Périmètre trop large | Retard ou fonctionnalités inachevées | Réduction aux fonctionnalités prioritaires et validation régulière. |
| Estimation de charge insuffisante | Temps insuffisant pour stabiliser le projet | Suivi hebdomadaire et priorisation des tâches. |
| Erreurs de modélisation | Incohérences dans la base et les relations | Revue du MCD/MLD avant l'implémentation. |
| Failles d'authentification ou mots de passe mal protégés | Exposition de données sensibles | JWT, hachage, variables d'environnement et tests négatifs. |
| Incohérences de données | Relations invalides ou données orphelines | Clés étrangères, contraintes et validations. |
| Conflits de rendez-vous | Planification incohérente | Règle métier dédiée et tests de cas limites. |
| Documentation incomplète | Installation ou utilisation difficile | Rédaction progressive du README. |
| Perte de code ou historique insuffisant | Difficulté à restaurer ou justifier le travail | Commits réguliers et dépôt GitHub. |
| Dépendance à une décision pédagogique | Incertitude sur le périmètre individuel | Signalement transparent de l'ajustement individuel et validation de l'enseignant. |

---

## 14. Évolutions futures

Les évolutions suivantes sont envisagées à moyen ou long terme. Elles ne sont pas incluses dans le périmètre v1.0 et ne doivent pas compromettre la réalisation individuelle prévue.

- Interface web pour le personnel.
- Application mobile.
- Notifications e-mail/SMS.
- Gestion des pièces et du stock.
- Devis, factures et paiements.
- Historique détaillé du véhicule.
- Rapports et indicateurs.
- Calendrier avec synchronisation externe.
- Gestion multi-garages et permissions avancées.
- Documentation OpenAPI/Swagger.
- Tests automatisés et pipeline CI/CD.
- Déploiement sécurisé dans le cloud.
- Journal d'audit et traçabilité renforcée.

**Limite de version** : ces évolutions pourront faire l'objet d'un périmètre ultérieur après validation du socle API REST et des livrables de la version 1.0.
