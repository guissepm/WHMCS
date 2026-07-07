# =============================================================================
# Dockerfile — PHP 8.2-FPM prêt pour WHMCS + module The SSL Store
# ionCube inclus, extensions WHMCS complètes, max_input_vars=4000
# =============================================================================
FROM php:8.2-fpm-bookworm

# --- Dépendances système pour compiler les extensions PHP
RUN apt-get update && apt-get install -y --no-install-recommends \
      libpng-dev libjpeg-dev libfreetype6-dev libzip-dev libicu-dev \
      libxml2-dev libc-client-dev libkrb5-dev libgmp-dev unzip curl cron \
    && rm -rf /var/lib/apt/lists/*

# --- Extensions PHP requises par WHMCS
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
 && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
 && docker-php-ext-install -j"$(nproc)" \
      gd bcmath intl soap imap gmp zip pdo_mysql mysqli opcache

# --- ionCube Loader (OBLIGATOIRE : WHMCS + module TSS sont encodés)
RUN PHP_EXT_DIR="$(php -r 'echo ini_get("extension_dir");')" \
 && curl -fsSL https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz \
      | tar -xz -C /tmp \
 && cp "/tmp/ioncube/ioncube_loader_lin_8.2.so" "${PHP_EXT_DIR}/" \
 && echo "zend_extension=${PHP_EXT_DIR}/ioncube_loader_lin_8.2.so" \
      > /usr/local/etc/php/conf.d/00-ioncube.ini \
 && rm -rf /tmp/ioncube

# --- Tuning PHP pour WHMCS (dont max_input_vars=4000 exigé par le module TSS)
RUN { \
      echo "max_input_vars = 4000"; \
      echo "memory_limit = 256M"; \
      echo "upload_max_filesize = 32M"; \
      echo "post_max_size = 32M"; \
      echo "max_execution_time = 120"; \
      echo "expose_php = Off"; \
      echo "date.timezone = Africa/Dakar"; \
    } > /usr/local/etc/php/conf.d/zz-whmcs.ini

WORKDIR /var/www/html
