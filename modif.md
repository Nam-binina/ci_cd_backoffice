# Modifications

- Assignation automatique : split des reservations quand une reservation depasse la capacite d une voiture, avec remise du reste pour un prochain assignement.
- Confirmation auto : lecture des tokens `id:passagers`, creation d une nouvelle reservation pour la partie assignee, mise a jour du nombre de passagers restant.
- ReservationRepository : ajout de `insertAndReturnId`, `updatePassengers`, insertion avec `id_aeroport` et fallback.
- JSP resultat auto : envoi de `id:passagers` dans le formulaire de confirmation.
