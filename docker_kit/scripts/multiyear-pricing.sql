-- =============================================================================
-- Sys Kabs Amazone — Remises multi-annuelles (WHMCS)
-- =============================================================================
-- Pose en une fois les tarifs 2 ans et 3 ans à partir du tarif 1 an, avec
-- remise croissante (comme thesslstore). Le module TheSSLStore lit le cycle
-- de facturation choisi (Annually/Biennially/Triennially) et émet un
-- certificat de 12 / 24 / 36 mois.
--
--   2 ans  = tarif 1 an × 2 × 0.90   -> -10 % (soit -10 %/an)
--   3 ans  = tarif 1 an × 3 × 0.85   -> -15 % (soit -15 %/an)
--
-- Ajuste les facteurs 0.90 / 0.85 pour changer les remises.
-- Ne touche que les produits RÉCURRENTS du groupe SSL (gid=1) ayant un tarif
-- 1 an > 0, dans TOUTES les devises configurées.
--
-- ---------------------------------------------------------------------------
-- COMMENT L'EXÉCUTER (sur le VPS, depuis /opt/whmcs-boutique) :
--
--   docker compose exec -T db \
--     mariadb -u whmcs_user -p"$DB_PASSWORD" whmcs < docker_kit/scripts/multiyear-pricing.sql
--
--   (ou copie/colle le bloc UPDATE dans:  docker compose exec db mariadb -u root -p whmcs )
--
-- Fais TOUJOURS une sauvegarde avant :
--   docker compose exec db sh -c 'mariadb-dump -u root -p"$MARIADB_ROOT_PASSWORD" whmcs' > backup-avant-multiyear.sql
-- =============================================================================

-- 1) (Optionnel) Vérifie le type de facturation de tes produits SSL.
--    Le multi-annuel par cycle exige paytype = 'recurring'.
--    S'ils sont en 'onetime', voir la note en bas de fichier.
SELECT paytype, COUNT(*) AS nb
FROM tblproducts
WHERE gid = 1
GROUP BY paytype;

-- 2) Pose les remises 2 ans / 3 ans.
UPDATE tblpricing pr
JOIN tblproducts p ON p.id = pr.relid
SET
  pr.biennially  = ROUND(pr.annually * 2 * 0.90, 2),
  pr.triennially = ROUND(pr.annually * 3 * 0.85, 2)
WHERE pr.type = 'product'
  AND p.gid = 1
  AND p.paytype = 'recurring'
  AND pr.annually > 0;

-- 3) (Vérif) Affiche le résultat pour contrôle (prix/an implicite).
SELECT p.name,
       pr.annually            AS an_1,
       pr.biennially          AS total_2ans,
       ROUND(pr.biennially/2,2)  AS par_an_2ans,
       pr.triennially         AS total_3ans,
       ROUND(pr.triennially/3,2) AS par_an_3ans
FROM tblpricing pr
JOIN tblproducts p ON p.id = pr.relid
WHERE pr.type = 'product' AND p.gid = 1 AND pr.annually > 0
ORDER BY p.name
LIMIT 20;

-- =============================================================================
-- NOTE — produits en 'onetime'
-- -----------------------------------------------------------------------------
-- Si l'étape 1 montre des produits en paytype='onetime', ils ne peuvent PAS
-- offrir de multi-annuel par cycle de facturation. Deux options :
--   a) Les passer en récurrent (Setup > Products/Services > [produit] >
--      Details > "Payment Type" = Recurring), puis relancer ce script ;
--   b) Les laisser en 1 an unique.
-- Ne bascule en récurrent que si tu factures réellement le renouvellement.
-- =============================================================================
