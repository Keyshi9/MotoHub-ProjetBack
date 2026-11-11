# Grille d'évaluation — Projet Backend

> Transcription de la grille fournie par l'enseignant (`Grille.pdf`, 1 page). Total : **66 points** (19 critères).

## Critères et points

| Catégorie | Critère | Points |
|---|---|---:|
| **Qualité** | Respect de l'architecture | 3 |
| | Commentaires | 3 |
| | Génération de la documentation de l'API | 3 |
| | Indentation / mise en page | 3 |
| **Codage** | Éviter les répétitions (utilisation des méthodes existantes, écrire du code utile) | 3 |
| | Syntaxe correcte (nommage des fonctions et variables) | 3 |
| **Gestion** | Mise à jour régulière de GitHub + soin dans les commentaires | 3 |
| | Qualité du journal de travail (cheminement reproductible, mise à jour régulière, complet) | 3 |
| | Gestion de GitHub Project (sprint, tenue, tests, mise à jour régulière) | 3 |
| | Qualité des stories et des tests | 3 |
| **Fonctionnalités** | Sécurisation de l'API | 3 |
| | Système de gestion de données (MCD) | 3 |
| | Système de gestion de données (MLD) | 3 |
| | **CRUD implémenté pour au moins 4 entités** | **12** |
| | Résistance aux pannes / gestion des erreurs | 3 |
| **Présentation** | Déroulement, rythme et répartitions | 3 |
| | Explication sur les fonctionnalités mises en place | 3 |
| | Réponses aux questions — méthode de travail | 3 |
| | Réponses aux questions — techniques | 3 |

### Poids par catégorie

| Catégorie | Points | Part du total |
|---|---:|---:|
| Qualité | 12 | 18 % |
| Codage | 6 | 9 % |
| Gestion | 12 | 18 % |
| Fonctionnalités | 24 | 36 % |
| Présentation | 12 | 18 % |
| **Total** | **66** | **100 %** |

## Où chaque critère se joue dans le projet

> Section de suivi propre au dépôt (pas dans le PDF de l'enseignant) : elle relie chaque critère à un livrable ou à une pratique.

| Critère | Où le travailler / le prouver |
|---|---|
| Respect de l'architecture | Séparation routes / contrôleurs / services / middlewares / accès aux données (cahier des charges, section 7) |
| Commentaires | Commentaires dans chaque fichier, en-tête rempli (consigne enseignant) |
| Génération de la documentation de l'API | Documentation générée depuis les commentaires du code, liée dans le README. **Notée dans la grille**, même si les consignes parlent d'une simple possibilité |
| Indentation / mise en page | Revue et nettoyage du code avant la release |
| Éviter les répétitions | Factoriser (validation, erreurs, accès aux données) ; pas de code inutile |
| Syntaxe correcte (nommage) | Conventions du langage + conventions CPNV pour la base de données |
| Mise à jour régulière de GitHub | Commits réguliers avec des messages soignés tout au long des 5 sprints |
| Qualité du journal de travail | `docs/journal-de-travail.md` : une entrée par séance, avec le cheminement reproductible |
| Gestion de GitHub Project | Le Project (sprints, statuts à jour, tests suivis) — lien dans le README |
| Qualité des stories et des tests | User stories dans les issues + scénarios de test Postman (nominaux et erreurs) |
| Sécurisation de l'API | JWT, hachage des mots de passe, rôles, secrets en variables d'environnement |
| MCD / MLD | Livrables PDF (MCD semaine 2, MLD semaine 3), cohérents avec la base |
| CRUD pour au moins 4 entités (12 pts) | Clients, Motos, Rendez-vous, Interventions (+ Utilisateurs pour EF-03) : les 5 opérations doivent fonctionner sur chaque entité |
| Résistance aux pannes / erreurs | Gestion centralisée des erreurs, codes HTTP du cahier des charges, aucun bug bloquant |
| Présentation | Préparer le déroulé, la démonstration des fonctionnalités et les réponses aux questions de méthode et de technique |

## Proposition de « Definition of Done »

> Proposition d'équipe (un seul membre) pour garder les critères de **Gestion** et de **Qualité** à jour en continu. À ajuster librement.

Une tâche est terminée lorsque :

- [ ] Le code respecte l'architecture, le nommage et l'indentation, et il est commenté (en-tête de fichier rempli)
- [ ] Les cas d'erreur sont gérés avec les bons codes HTTP et un message JSON
- [ ] Les scénarios de test (nominal + erreurs) sont dans la collection Postman
- [ ] Les commits sont réguliers, avec un message clair
- [ ] L'issue du GitHub Project est à jour (statut, critères cochés)
- [ ] Le journal de travail et, si besoin, le README sont mis à jour
