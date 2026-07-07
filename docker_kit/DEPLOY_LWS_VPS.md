# Déploiement sur VPS LWS — boutique.syskabsamazone.com

Ce guide part de ton contexte confirmé :
- **VPS LWS**, accès **SSH root**, une **autre application tourne déjà** sur les ports 80/443.
- Reverse-proxy retenu par défaut : **Nginx installé nativement sur l'hôte** (le plus simple à auditer/sécuriser).
  Si en fait c'est **Traefik** qui gère déjà 80/443 sur ce VPS, saute la partie 3 et utilise la
  section "Cas Traefik" de `README_DOCKER.md` à la place — tout le reste (Docker WHMCS,
  module SSL Store, hardening) ne change pas.
- Licence WHMCS : à ton compte sur whmcs.com (non fournie par ce dépôt).
- Sous-domaine choisi : `boutique.syskabsamazone.com`.

---

## 0. Détecter précisément l'état actuel du VPS (à faire en premier)

```bash
ss -tlnp | grep -E ':80|:443'      # qui écoute déjà sur ces ports ?
docker ps                          # une stack Traefik/NPM tourne-t-elle en conteneur ?
which nginx && systemctl status nginx --no-pager   # nginx natif installé ?
docker --version || curl -fsSL https://get.docker.com | sh   # Docker dispo ?
```

Si `nginx` n'est pas encore installé sur l'hôte : `apt update && apt install -y nginx certbot python3-certbot-nginx`.

---

## 1. DNS

Dans l'espace client LWS, zone DNS de `syskabsamazone.com` : ajoute un enregistrement
**A** `boutique` → IP publique du VPS. Vérifie la propagation avant de continuer :

```bash
dig +short boutique.syskabsamazone.com
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
docker compose ps                # web doit être bindé sur 127.0.0.1:8081 uniquement
```

**Vérification de sécurité importante** : `docker compose ps` doit montrer le port
`web` publié en `127.0.0.1:8081->80/tcp` — jamais `0.0.0.0:8081`. C'est déjà le cas
dans `docker-compose.yml` fourni ; ne le modifie pas, sinon WHMCS serait exposé
directement sans passer par ton reverse-proxy/TLS.

---

## 3. Reverse-proxy Nginx hôte + Let's Encrypt

```bash
certbot certonly --nginx -d boutique.syskabsamazone.com
```

Ajoute une fois dans `http {}` de `/etc/nginx/nginx.conf` (rate-limit anti brute-force admin) :

```nginx
limit_req_zone $binary_remote_addr zone=whmcs_admin:10m rate=10r/m;
```

Copie `docker_kit/nginx/host-reverse-proxy.conf.example` vers
`/etc/nginx/sites-available/boutique.syskabsamazone.com.conf`, puis :

```bash
ln -s /etc/nginx/sites-available/boutique.syskabsamazone.com.conf /etc/nginx/sites-enabled/
nginx -t && systemctl reload nginx
```

Renouvellement auto déjà géré par le timer `certbot.timer` sur Debian/Ubuntu — vérifie :
```bash
systemctl list-timers | grep certbot
```

---

## 4. Installer WHMCS (licence requise)

```bash
# Une fois ta licence WHMCS téléchargée depuis ton compte whmcs.com
docker cp ~/whmcs_vX.X.zip whmcs_php:/tmp/
docker compose exec php sh -c 'cd /var/www/html && unzip -o /tmp/whmcs_*.zip && chown -R www-data:www-data .'
```

Ouvre `https://boutique.syskabsamazone.com/install/install.php` :
- Base : hôte **db**, base **whmcs**, user **whmcs_user**, mot de passe = `DB_PASSWORD` de `.env`

Après installation :
```bash
docker compose exec php sh -c 'rm -rf /var/www/html/install && chmod 400 /var/www/html/configuration.php'
```

Dans `configuration.php`, ajoute (obligatoire, sinon toutes les commandes sembleront
venir de l'IP du reverse-proxy au lieu de l'IP réelle du client) :
```php
$trustedProxies = ['127.0.0.1'];
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
- [ ] **fail2ban** : `apt install fail2ban`, active la jail `nginx-http-auth` et ajoute une
      jail custom sur les tentatives de login WHMCS (`/admin/login.php`) via les logs Nginx.
- [ ] **2FA** activée sur tous les comptes admin WHMCS (Setup > Staff Management).
- [ ] **Renommer le dossier admin** (`/admin` → nom aléatoire) dans WHMCS General Settings,
      puis mettre à jour `location /admin/` dans le vhost avec le nouveau nom.
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
conteneur `whmcs_php`. Secrets GitHub requis (Settings > Secrets and variables > Actions) :

| Secret            | Contenu                                             |
|-------------------|------------------------------------------------------|
| `SSH_HOST`        | IP ou nom d'hôte du VPS LWS                          |
| `SSH_USER`        | utilisateur SSH (root ou utilisateur sudo dédié)     |
| `SSH_PORT`        | port SSH (22 ou custom)                              |
| `SSH_DEPLOY_KEY`  | clé privée SSH dédiée au déploiement (pas ta clé perso) |

Génère une clé dédiée plutôt que de réutiliser ta clé personnelle :
```bash
ssh-keygen -t ed25519 -f deploy_key -C "github-actions-deploy" -N ""
# Ajoute deploy_key.pub à ~/.ssh/authorized_keys sur le VPS
# Colle le contenu de deploy_key (clé privée) dans le secret SSH_DEPLOY_KEY
```
