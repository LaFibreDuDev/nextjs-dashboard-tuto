# RECAP DES POINTS BLOQUANTS SUR NEXT

Ces différents points permettent de publier le projet Next sur Vercel, tout en évitant les difficultés.

- On a remplacé `bcrypt` par `bcryptjs` (problème de déploiement sur Vercel)
- On a rajouté dans le script package.json

```json
"build": "next build --experimental-build-mode compile"
```

Problématique : le fait que Next, lorsqu'il compile le projet, a besoin d'accéder à la base PostGreSQL, notamment pour faire un rendu statique des pages. Du coup, cette option permet d'éviter d'avoir besoin de la base PostGreSQL au moment de ce build.
