# Déploiement sur VPS LWS — sslstore.syskabsamazone.com

Ce guide part de ton contexte **confirmé par inspection réelle du VPS** :
- **VPS LWS**, accès **SSH root**.
- L'app existante (`guissepm/booking` — Laravel + Angular + MySQL) tourne déjà via un
  projet Docker Compose dans `/opt/deploy/`, réseau `deploy_app-network`.
- Le reverse-proxy est un **conteneur `nginx:alpine`** (nom `nginx`) qui publie
  `0.0.0.0:80/443` sur l'hôte. Sa config vhost vit dans `/opt/deploy/nginx/conf.d/`
  (bind-mount host → conteneur), donc on peut y ajouter un fichier de vhost WHMCS
  directement depuis l'hôte, sans toucher à l'image ni au reste du site.
- Les certificats Let's Encrypt sont dans `/opt/deploy/certbot/conf`, obtenus/renouvelés
  via le webroot `/opt/deploy/certbot/www` (pas de service certbot dédié dans le compose
  actuel — émission probablement faite via un `docker run certbot/certbot` ponctuel).
- **Intégration retenue** : la stack WHMCS (Docker, isolée dans son propre réseau
  `whmcs_net` pour la base de données) connecte uniquement son conteneur `whmcs_web` au
  réseau existant `deploy_app-network`, pour être joignable par nom depuis le `nginx`
  du projet `/opt/deploy`. Aucun port supplémentaire n'est exposé sur l'hôte.
- Licence WHMCS : à ton compte sur whmcs.com (non fournie par ce dépôt).
- Sous-domaine choisi : `sslstore.syskabsamazone.com`.

---

## 0. Rappel de l'état du VPS (déjà vérifié)

```bash
ss -tlnp | grep -E ':80|:443'                       # -> conteneur "nginx" (docker-proxy)
docker ps                                            # nginx, laravel, laravel-http, angular, mysql
docker inspect nginx --format '{{json .Mounts}}'     # conf.d + certbot montés en bind depuis /opt/deploy
docker network ls                                    # -> deploy_app-network
```

---

## 1. DNS

Dans l'espace client LWS, zone DNS de `syskabsamazone.com` : ajoute un enregistrement
**A** `sslstore` → IP publique du VPS. Vérifie la propagation avant de continuer :

```bash
dig +short sslstore.syskabsamazone.com
```

---

## 2. Déployer la stack Docker WHMCS

```bash
mkdir -p /opt/whmcs-boutique && cd /opt/whmcs-boutique
# Copie ici Dockerfile, docker-compose.yml, nginx/whmcs.conf du dépôt (docker_kit/)

cp .env.example .env
sed -i "s/CHANGE_ME_DB_PASSWORD/$(openssl rand -base64 24 | tr -d '\n')/" .env
sed -i "s/CHANGE_ME_DB_ROOT_PASSWORD/$(openssl rand -base64 24 | tr -d '\n')/" .env
chmod 600 .env

docker compose build        # ~3-5 min (compilation extensions + ionCube)
docker compose up -d
docker compose exec php php -v   # doit afficher "with the ionCube PHP Loader"
docker compose ps                # "web" ne doit publier AUCUN port sur l'hôte
docker network inspect deploy_app-network --format '{{range .Containers}}{{.Name}} {{end}}'
                                  # doit lister whmcs_web à côté de nginx/laravel/angular
```

**Vérification de sécurité importante** : `docker compose ps` ne doit montrer **aucune**
colonne `PORTS` pour le service `web` — il n'est joignable que via le réseau Docker
`deploy_app-network` par le conteneur `nginx` existant. Si tu vois un port publié sur
l'hôte (`0.0.0.0:xxxx` ou `127.0.0.1:xxxx`), WHMCS serait exposé en dehors du chemin
TLS géré par `/opt/deploy/nginx` — ne le fais pas, ce n'est pas nécessaire avec cette
intégration par réseau partagé.

---

## 3. Intégrer WHMCS au reverse-proxy Docker existant (`/opt/deploy`)

**a) Obtenir le certificat**, en réutilisant le webroot déjà monté dans le conteneur
`nginx` existant (fonctionne dès que le DNS de l'étape 1 pointe vers le VPS, même
avant que la stack WHMCS ne tourne — le `default.conf` actuel sert déjà
`/.well-known/acme-challenge/` pour n'importe quel domaine) :

```bash
docker run --rm \
  -v /opt/deploy/certbot/conf:/etc/letsencrypt \
  -v /opt/deploy/certbot/www:/var/www/certbot \
  certbot/certbot certonly --webroot -w /var/www/certbot \
  -d sslstore.syskabsamazone.com \
  --email TON_EMAIL --agree-tos --no-eff-email
```

**b) Démarrer la stack WHMCS** (section 2) — vérifie qu'elle a bien rejoint le réseau
partagé :
```bash
docker network inspect deploy_app-network --format '{{range .Containers}}{{.Name}} {{end}}'
# doit lister whmcs_web en plus de nginx, laravel, angular, ...
```

**c) Ajouter le vhost** : copie `docker_kit/nginx/sslstore.conf.example` vers
`/opt/deploy/nginx/conf.d/sslstore.conf` (le dossier existant, à côté de
`default.conf` — pas de nouveau bind-mount à créer), puis recharge nginx **sans
redémarrer les autres sites** :

```bash
docker exec nginx nginx -t && docker exec nginx nginx -s reload
```

**Renouvellement du certificat** : comme il n'y a pas de service `certbot` dédié dans
`/opt/deploy/docker-compose.yml`, ajoute une tâche cron sur l'hôte (sinon le certificat
expire dans 90 jours) :
```bash
# crontab -e
0 3 1 * * docker run --rm -v /opt/deploy/certbot/conf:/etc/letsencrypt -v /opt/deploy/certbot/www:/var/www/certbot certbot/certbot renew --webroot -w /var/www/certbot -q && docker exec nginx nginx -s reload
```

---

## 4. Installer WHMCS (licence requise)

```bash
# Une fois ta licence WHMCS téléchargée depuis ton compte whmcs.com
docker cp ~/whmcs_vX.X.zip whmcs_php:/tmp/
docker compose exec php sh -c 'cd /var/www/html && unzip -o /tmp/whmcs_*.zip && chown -R www-data:www-data .'
```

Ouvre `https://sslstore.syskabsamazone.com/install/install.php` :
- Base : hôte **db**, base **whmcs**, user **whmcs_user**, mot de passe = `DB_PASSWORD` de `.env`

Après installation :
```bash
docker compose exec php sh -c 'rm -rf /var/www/html/install && chmod 400 /var/www/html/configuration.php'
```

Dans `configuration.php`, ajoute `$trustedProxies` (obligatoire, sinon toutes les
commandes sembleront venir de l'IP du conteneur `nginx` au lieu de l'IP réelle du
client). Le hop qui compte ici est le conteneur `nginx` existant qui se connecte à
`whmcs_web` via `deploy_app-network` — c'est donc **ce** sous-réseau qu'il faut
whitelister, pas celui de `whmcs_net`. On le connaît déjà (vu dans l'inspection de
l'étape 0) :

```php
$trustedProxies = ['172.18.0.0/16']; // sous-réseau de deploy_app-network
```

Si ce sous-réseau change un jour, reconfirme-le avec :
```bash
docker network inspect deploy_app-network --format '{{(index .IPAM.Config 0).Subnet}}'
```

---

## 5. Déployer le module The SSL Store

```bash
git clone --depth 1 git@github.com:guissepm/whmcs.git /tmp/tss
docker cp /tmp/tss/modules/. whmcs_php:/var/www/html/modules/
docker cp /tmp/tss/assets/.  whmcs_php:/var/www/html/assets/
docker compose exec php chown -R www-data:www-data /var/www/html/modules /var/www/html/assets
rm -rf /tmp/tss
```

WHMCS admin → **Setup > Addon Modules > TheSSLStore Admin > Activate** → Fresh Install
Dashboard → credentials Sandbox → devise → import produits.

---

## 6. Durcissement sécurité (checklist)

- [ ] **Firewall** : `ufw allow OpenSSH && ufw allow 80,443/tcp && ufw enable` (SSH sur port
      non-standard si possible ; sinon `fail2ban` sur sshd au minimum).
- [ ] **fail2ban anti brute-force WHMCS** : le conteneur `nginx` de `/opt/deploy` n'a pas
      ses logs montés sur l'hôte (ils partent dans `docker logs nginx`). Deux options :
      1. ajouter `- ./nginx/logs:/var/log/nginx` aux volumes du service `nginx` dans
         `/opt/deploy/docker-compose.yml`, redémarrer, puis pointer fail2ban dessus ; ou
      2. utiliser le module WHMCS "Fail2Ban Integration" / IP Ban natif si disponible,
         qui bloque au niveau applicatif après N échecs de login sur `/admin/login.php`.
- [ ] **2FA** activée sur tous les comptes admin WHMCS (Setup > Staff Management).
- [ ] **Renommer le dossier admin** (`/admin` → nom aléatoire) dans WHMCS General Settings.
      Comme le vhost `sslstore.conf` proxy-passe tout vers `whmcs_web` sans distinguer
      `/admin/`, aucune modification du vhost n'est nécessaire pour ça.
- [ ] **SMTP externe** configuré (Setup > General > Mail) — n'envoie jamais depuis le
      conteneur directement (risque de blacklist IP du VPS).
- [ ] **Restreindre l'accès admin par IP** si l'équipe a des IP fixes (dans le vhost Nginx
      ou via `.htaccess`/ACL WHMCS).
- [ ] **Base de données** : déjà isolée sur le réseau Docker `whmcs_net`, aucun port
      exposé sur l'hôte — ne pas ajouter de `ports:` sur le service `db`.
- [ ] **Sauvegardes automatiques** (voir section 7) testées par une restauration réelle.
- [ ] **Mises à jour** régulières : WHMCS (updater intégré), image `php:8.2-fpm-bookworm`
      (`docker compose build --pull`), module TSS (voir GitHub Actions ci-dessous).
- [ ] **Licence WHMCS** : vérifie IP + domaine ; en cas de migration VPS, réémets la
      licence depuis l'espace client WHMCS.

---

## 7. Sauvegardes

```bash
# Dump base quotidien (crontab -e sur l'hôte)
0 3 * * * docker compose -f /opt/whmcs-boutique/docker-compose.yml exec -T db \
  mariadb-dump -u root -p"$(grep DB_ROOT_PASSWORD /opt/whmcs-boutique/.env | cut -d= -f2)" whmcs \
  | gzip > /backup/whmcs_$(date +\%F).sql.gz

# Fichiers (configuration.php, attachments, templates custom)
0 4 * * * docker run --rm -v whmcs-boutique_whmcs_app:/data -v /backup:/backup alpine \
  tar czf /backup/whmcs_files_$(date +\%F).tgz -C /data configuration.php attachments templates_c
```

Copie `/backup` vers un stockage externe (ex: espace de sauvegarde LWS, ou `rclone` vers
un bucket S3/OVH) — une sauvegarde qui reste sur le même VPS ne protège pas contre une
perte du serveur.

---

## 8. Mise à jour continue du module (GitHub Actions)

Voir `.github/workflows/deploy.yml` à la racine du dépôt : à chaque push sur `main`,
le contenu de `modules/` et `assets/` est synchronisé vers le VPS puis copié dans le
conteneur `whmcs_php`. Secrets GitHub requis (Settings > Secrets and variables > Actions,
sur `guissepm/WHMCS`) :

| Secret            | Contenu                                             |
|-------------------|------------------------------------------------------|
| `SSH_HOST`        | IP publique du VPS LWS                               |
| `SSH_USER`        | `deploy` (utilisateur dédié, PAS `root` — voir ci-dessous) |
| `SSH_PORT`        | port SSH (22 ou custom)                              |
| `SSH_DEPLOY_KEY`  | clé privée SSH dédiée au déploiement (pas ta clé perso, pas celle de `root`) |

### Créer l'utilisateur `deploy` (sur le VPS, en root)

```bash
adduser --disabled-password --gecos "" deploy
usermod -aG docker deploy          # nécessaire pour `docker cp` / `docker exec`

mkdir -p /home/deploy/.ssh
ssh-keygen -t ed25519 -f /home/deploy/.ssh/whmcs_deploy_key -C "github-actions-deploy" -N ""
cat /home/deploy/.ssh/whmcs_deploy_key.pub >> /home/deploy/.ssh/authorized_keys
chown -R deploy:deploy /home/deploy/.ssh
chmod 700 /home/deploy/.ssh
chmod 600 /home/deploy/.ssh/authorized_keys /home/deploy/.ssh/whmcs_deploy_key

# Le workflow rsync écrit dans /opt/whmcs-boutique/overlay/ : donne les droits à `deploy`
mkdir -p /opt/whmcs-boutique/overlay/{modules,assets}
chown -R deploy:deploy /opt/whmcs-boutique/overlay

cat /home/deploy/.ssh/whmcs_deploy_key
# Copie ce contenu (BEGIN...END inclus) directement dans le secret SSH_DEPLOY_KEY —
# ne le colle nulle part ailleurs (pas dans un fichier du dépôt, pas dans ce chat).
```

**Important — limite réelle de cet isolement** : l'appartenance au groupe `docker`
équivaut en pratique à un accès root sur l'hôte (un conteneur peut monter `/` et donner
un accès complet au système de fichiers). Ce n'est donc **pas** une sandbox stricte —
c'est surtout utile pour : ne pas exposer ta clé/session root personnelle à GitHub,
pouvoir révoquer l'accès CI sans toucher à ton compte root, et tracer les connexions
séparément dans les logs `auth.log`. Pour un vrai cloisonnement (la clé ne peut exécuter
qu'un script de déploiement précis, rien d'autre), il faudrait remplacer l'accès direct
par une *forced command* dans `authorized_keys` (`command="/opt/whmcs-boutique/deploy.sh" ssh-ed25519 ...`)
couplée à `rrsync` pour les étapes de synchronisation — dis-moi si tu veux que je mette
ça en place, c'est plus long à cabler correctement.
