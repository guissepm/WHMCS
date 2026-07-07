# Boutique WHMCS en Docker — Guide de déploiement
### Sys Kabs Amazone SAS — VPS Debian avec Docker existant

Cette stack fait tourner WHMCS + le module The SSL Store en conteneurs, **à côté de votre application Docker actuelle**, sans rien installer sur l'hôte.

```
Internet ──▶ Reverse proxy existant (80/443) ──▶ 127.0.0.1:8081 ──▶ nginx ──▶ php-fpm (ionCube)
                                                                      │
                                                              MariaDB + cron
```

---

## 1. Préparation

```bash
mkdir -p /opt/whmcs-boutique && cd /opt/whmcs-boutique
# Copiez ici : Dockerfile, docker-compose.yml, nginx/whmcs.conf

# Secrets (jamais dans Git)
cat > .env <<EOF
DB_PASSWORD=$(openssl rand -base64 24)
DB_ROOT_PASSWORD=$(openssl rand -base64 24)
EOF
chmod 600 .env

docker compose build        # ~3-5 min (compilation extensions + ionCube)
docker compose up -d
docker compose exec php php -v   # doit afficher "with the ionCube PHP Loader"
```

---

## 2. Intégration à votre reverse proxy existant

La boutique écoute sur **127.0.0.1:8081** — c'est votre proxy actuel qui publie le domaine. Selon votre setup :

**Cas Nginx sur l'hôte** — ajoutez un vhost :
```nginx
server {
    listen 443 ssl http2;
    server_name boutique.syskabsamazone.com;
    # vos certificats ici (Certbot puis votre EV The SSL Store)
    location / {
        proxy_pass http://127.0.0.1:8081;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto https;
    }
}
```

**Cas Traefik** — supprimez le bloc `ports:` du service `web`, connectez-le au réseau Traefik et ajoutez les labels :
```yaml
    networks: [whmcs_net, traefik_net]
    labels:
      - traefik.enable=true
      - traefik.http.routers.whmcs.rule=Host(`boutique.syskabsamazone.com`)
      - traefik.http.routers.whmcs.entrypoints=websecure
      - traefik.http.routers.whmcs.tls.certresolver=letsencrypt
      - traefik.http.services.whmcs.loadbalancer.server.port=80
```

**Cas votre app occupe 80/443 sans proxy** — c'est le moment d'introduire un proxy (Traefik ou Nginx Proxy Manager) qui routera les deux applications par nom de domaine. Dites-moi ce qui tourne, je vous fais la config exacte.

> WHMCS derrière un proxy : après installation, dans **configuration.php**, ajoutez
> `$trustedProxies = ['172.16.0.0/12'];` pour que les IP clients réelles soient vues
> (sinon toutes les commandes sembleront venir du proxy).

---

## 3. Installer WHMCS dans le volume

```bash
# Copier l'archive WHMCS (obtenue avec votre licence) dans le conteneur
docker cp ~/whmcs_vX.X.zip whmcs_php:/tmp/
docker compose exec php sh -c 'cd /var/www/html && unzip -o /tmp/whmcs_*.zip && chown -R www-data:www-data .'
```
Puis ouvrez `https://boutique.syskabsamazone.com/install/install.php` :
- Base de données : hôte **db**, base **whmcs**, user **whmcs_user**, mot de passe = `DB_PASSWORD` du `.env`
- Après installation :
```bash
docker compose exec php sh -c 'rm -rf /var/www/html/install && chmod 400 /var/www/html/configuration.php'
```

---

## 4. Déployer le module The SSL Store depuis votre GitHub

```bash
git clone --depth 1 git@github.com:guissepm/WHMCS.git /tmp/tss
docker cp /tmp/tss/modules/. whmcs_php:/var/www/html/modules/
docker cp /tmp/tss/assets/.  whmcs_php:/var/www/html/assets/
docker compose exec php chown -R www-data:www-data /var/www/html/modules /var/www/html/assets
rm -rf /tmp/tss
```
Puis WHMCS admin → **Setup > Addon Modules > Activate** → Fresh Install Dashboard → credentials **Sandbox** → devise **XOF** → import produits (cf. README de déploiement général).

### Adapter le pipeline GitHub Actions
Dans `deploy.yml`, remplacez les deux rsync par un rsync vers un dossier de staging sur l'hôte puis `docker cp`, ou plus simple : montez le module en bind mount. Variante recommandée pour Docker — remplacez l'étape « Déployer l'overlay » par :
```yaml
      - name: Déployer l'overlay dans le conteneur
        run: |
          rsync -rlptzv --checksum -e "ssh -i ~/.ssh/deploy_key -p ${{ secrets.SSH_PORT }}" \
            modules/ assets/ ${{ secrets.SSH_USER }}@${{ secrets.SSH_HOST }}:/opt/whmcs-boutique/overlay/
          ssh -i ~/.ssh/deploy_key -p ${{ secrets.SSH_PORT }} ${{ secrets.SSH_USER }}@${{ secrets.SSH_HOST }} '
            docker cp /opt/whmcs-boutique/overlay/modules/. whmcs_php:/var/www/html/modules/ &&
            docker cp /opt/whmcs-boutique/overlay/assets/.  whmcs_php:/var/www/html/assets/ &&
            docker exec whmcs_php chown -R www-data:www-data /var/www/html/modules /var/www/html/assets'
```

---

## 5. Sauvegardes & exploitation

```bash
# Dump base quotidien (ajoutez au cron de l'hôte)
docker compose exec -T db mariadb-dump -u root -p"$DB_ROOT_PASSWORD" whmcs | gzip > /backup/whmcs_$(date +%F).sql.gz
# Fichiers (configuration.php, attachments, templates custom)
docker run --rm -v whmcs-boutique_whmcs_app:/data -v /backup:/backup alpine \
  tar czf /backup/whmcs_files_$(date +%F).tgz -C /data configuration.php attachments templates_c
```

- **Logs** : `docker compose logs -f web php cron`
- **Mise à jour WHMCS** : via l'updater intégré de WHMCS (fonctionne dans le volume) ou remplacement de l'archive
- **Vérif crons** : le System Check du module doit montrer des dates récentes (pas « Never ») après 24 h

---

## Points d'attention Docker + WHMCS

1. **Licence** : WHMCS vérifie IP + domaine. En Docker sur votre VPS, l'IP sortante est celle du VPS — aucun problème. Si vous migrez plus tard, réémettez la licence depuis l'espace client WHMCS.
2. **Emails** : configurez un SMTP externe dans WHMCS (Setup > General > Mail) — n'envoyez pas depuis le conteneur.
3. **Ressources** : la stack complète consomme ~600 Mo-1 Go de RAM. Vérifiez la marge disponible à côté de votre application (`docker stats`).
4. **Isolation réseau** : la base n'est accessible que sur le réseau `whmcs_net` — votre autre application n'y a pas accès, et réciproquement.

---
*Sys Kabs Amazone SAS — Partenaire The SSL Store® & Acunetix (by Invicti)*
