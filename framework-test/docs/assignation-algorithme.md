# Fonctionnement détaillé de l’algorithme d’assignation automatique

Ce document décrit **exactement** la logique actuelle d’assignation automatique telle qu’implémentée dans `AssignationController.java`.

> Notation utilisée :
>
> - **Reportées** = réservations non assignées provenant d’anciens groupes.
> - **Nouvelles** = réservations du nouveau groupe (fenêtre TA courante).
> - **TA** = temps d’attente (minutes) défini dans la table `parametre`.

---

## 1) Préparation des données

1. Charger **toutes les réservations** de la date sélectionnée.
2. Trier ces réservations par date d’arrivée (croissant).
3. Initialiser `carryOverReservations` (liste des reportées) vide.
4. Initialiser `carNextAvailable` (heure de retour de chaque voiture) vide.

---

## 2) Construction des groupes (fenêtres temporelles)

L’algorithme itère tant qu’il reste :

- des réservations **nouvelles** à traiter, **ou**
- des réservations **reportées** à réassigner.

### 2.1 Détermination du `referenceTime`

À chaque itération :

- Si des **reportées** existent : `referenceTime = earliestArrival(reportées)`
- Sinon : `referenceTime = dateArriver` de la prochaine réservation nouvelle

### 2.2 Début de fenêtre (`groupStart`)

- **Si aucune reportée** :
  - `groupStart = referenceTime` (c’est la date d’arrivée de la première nouvelle réservation)

- **Si des reportées existent** :
  - `groupStart = earliestAvailability(cars, referenceTime)`
  - (availability = `heure_disponibilite` du véhicule, ou retour précédent)

### 2.3 Fin de fenêtre (`groupEnd`)

- `groupEnd = groupStart + TA`

### 2.4 Sélection des nouvelles réservations dans la fenêtre

- On prend toutes les **nouvelles réservations** dont `dateArriver <= groupEnd`
- Si aucune nouvelle réservation n’entre dans la fenêtre **et** il n’y a pas de reportées :
  - on décale la fenêtre pour commencer à la **prochaine** réservation

---

## 3) Priorités internes dans un groupe

Dans chaque groupe, on crée deux listes distinctes :

1. **Priority list** = reportées (non assignées)
2. **Sorted list** = nouvelles réservations

Les deux listes sont triées par :

- `nbr_passager DESC` (priorité aux plus gros groupes)
- `idReservation ASC` (tie-break)

---

## 4) Sélection de voiture

Pour chaque réservation à traiter (d’abord reportées, puis nouvelles) :

1. On cherche une voiture disponible dans la fenêtre (`carNextAvailable <= groupEnd`)
2. Choix par priorité :
   - **capacité minimale suffisante** (>= passagers)
   - en cas d’égalité : **moins de trajets**
   - en cas d’égalité : **Diesel**
   - en cas d’égalité : choix aléatoire

Si aucune voiture ne convient : la réservation reste **non assignée** et passe en reportée pour le groupe suivant.

---

## 5) Remplissage d’une voiture

Une fois une voiture choisie :

1. La réservation principale est ajoutée.
2. La voiture est **complétée immédiatement** :
   - On cherche la réservation la plus proche du nombre de places restantes
   - On autorise le **split** d’une réservation si nécessaire
3. On continue jusqu’à atteindre la capacité ou épuiser les réservations disponibles.

---

## 6) Règles exactes de départ d’un véhicule

Chaque véhicule a un **départ propre**, qui peut être **fixe** ou **normal**.

### 6.1 Départ fixe (cas spécifiques)

#### A) Voiture complètement remplie par des reportées

- Départ **immédiat** à l’**heure de disponibilité** du véhicule.

#### B) Voiture pas remplie par reportées, mais complétée par une nouvelle réservation

- Départ = **heure d’arrivée de la réservation qui complète la dernière place**.

#### C) Reportées présentes, voiture pas pleine, et aucune nouvelle réservation assignée

- On attend TA.
- Si aucune nouvelle réservation n’est affectée pendant cette fenêtre :
  - Départ **immédiat** à **l’heure de disponibilité** du véhicule.

### 6.2 Départ normal (cas standard)

Si le véhicule ne rentre dans aucun cas “départ fixe” ci-dessus :

- son départ suit **le départ global du groupe**.

---

## 7) Départ global du groupe

Pour les véhicules **sans départ fixe**, le départ du groupe est calculé :

- On prend la **dernière arrivée assignée** du groupe,
- et on compare avec la **dernière disponibilité** des voitures sélectionnées,
- le départ global = le **max** des deux.

Les véhicules à départ fixe **n’influencent pas** ce départ global.

---

## 8) Calcul du retour

Pour chaque véhicule :

1. On calcule la **distance totale optimale** (aéroport → hôtels → aéroport)
2. Si `vitesse_moyenne` > 0 :
   - `minutes = (distance / vitesse_moyenne) * 60`
   - `dateRetour = dateDepart + minutes`

---

## 9) Résumé rapide (flow)

```text
Boucle groupes
  ├── choisir fenêtre TA (groupStart/groupEnd)
  ├── priorité : reportées -> nouvelles
  ├── assigner voiture + remplir
  ├── déterminer départ fixe (si règles applicables)
  ├── calculer départ global pour les autres
  ├── retour + disponibilités
  └── reportées restantes -> prochain groupe
```

---

Si tu veux, je peux ajouter :

- un diagramme étape par étape,
- des exemples chiffrés avec les données `donee.sql`,
- ou une version résumée en pseudo‑code pour ton ami.
