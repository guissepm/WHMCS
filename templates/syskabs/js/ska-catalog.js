/* Catalogue Sys Kabs Amazone — comportements partagés (boutique + accueil).
   skaInitCatalog(root) lie : onglets catégories (#skaCatTabs -> #skaViewCert/
   #skaViewWebsec/#skaViewPki), onglets marques (#skaBrandTabs + bandeau
   #skaBHero), filtres validation (#skaFilters). Tolère l'absence de chacun. */

/* Assure une balise viewport correcte : sans elle, Safari mobile rend la
   page à 980px virtuels et les media queries ne se déclenchent jamais. */
(function () {
  var m = document.querySelector('meta[name="viewport"]');
  if (!m) {
    m = document.createElement('meta');
    m.setAttribute('name', 'viewport');
    (document.head || document.getElementsByTagName('head')[0]).appendChild(m);
  }
  m.setAttribute('content', 'width=device-width, initial-scale=1, viewport-fit=cover');
})();

function skaInitCatalog(root) {
  root = root || document;
  function q(id) { return root.querySelector('#' + id) || document.getElementById(id); }

  var views = { cert: q('skaViewCert'), websec: q('skaViewWebsec'), pki: q('skaViewPki') };

  var tabs = q('skaCatTabs');
  if (tabs && !tabs.dataset.skaBound) {
    tabs.dataset.skaBound = '1';
    tabs.addEventListener('click', function (e) {
      var t = e.target.closest('.ska-cattab'); if (!t) return;
      tabs.querySelectorAll('.ska-cattab').forEach(function (b) { b.classList.remove('active'); });
      t.classList.add('active');
      var v = t.getAttribute('data-v');
      Object.keys(views).forEach(function (k) {
        if (views[k]) views[k].style.display = (k === v) ? '' : 'none';
      });
    });
  }

  var bar = q('skaBrandTabs');
  if (bar && !bar.dataset.skaBound) {
    bar.dataset.skaBound = '1';
    var hero = q('skaBHero'), ht = q('skaBHeroTitle'), hl = q('skaBHeroLogo');
    var scope = views.cert || root;
    bar.addEventListener('click', function (e) {
      var t = e.target.closest('.ska-tab'); if (!t) return;
      bar.querySelectorAll('.ska-tab').forEach(function (b) { b.classList.remove('active'); });
      t.classList.add('active');
      var f = t.getAttribute('data-b');
      [].forEach.call(scope.querySelectorAll('tr[data-brand]'), function (r) {
        r.style.display = (f === 'all' || r.getAttribute('data-brand') === f) ? '' : 'none';
      });
      if (hero) {
        if (f === 'all') { hero.style.display = 'none'; }
        else {
          if (ht) ht.textContent = 'Certificats SSL ' + f;
          if (hl) {
            hl.style.display = '';
            hl.alt = f;
            hl.onerror = function () { this.style.display = 'none'; };
            hl.src = '/assets/ssl_resources/images/emails/' + f.toLowerCase() + '-logo.svg';
          }
          hero.style.display = '';
        }
      }
    });
  }

  var vf = q('skaFilters');
  if (vf && !vf.dataset.skaBound) {
    vf.dataset.skaBound = '1';
    var scope2 = views.cert || root;
    var empty = q('skaEmpty');
    vf.addEventListener('click', function (e) {
      var t = e.target.closest('.ska-tab'); if (!t) return;
      vf.querySelectorAll('.ska-tab').forEach(function (b) { b.classList.remove('active'); });
      t.classList.add('active');
      var f = t.getAttribute('data-f'), n = 0;
      [].forEach.call(scope2.querySelectorAll('tr[data-cat]'), function (r) {
        var ok = (f === 'all' || r.getAttribute('data-cat') === f);
        r.style.display = ok ? '' : 'none'; if (ok) n++;
      });
      if (empty) empty.style.display = n ? 'none' : 'block';
    });
  }
}
window.skaInitCatalog = skaInitCatalog;
document.addEventListener('DOMContentLoaded', function () { skaInitCatalog(document); });
