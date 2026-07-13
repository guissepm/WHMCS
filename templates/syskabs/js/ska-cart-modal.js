/* ============================================================================
   Sys Kabs Amazone — Modale de commande rapide (façon thesslstore)
   ----------------------------------------------------------------------------
   Au clic sur « Commander », ouvre une boîte de dialogue : choix de la durée
   en cartes (prix/an, prix barré, économie, -%), total en direct, puis
   « Ajouter au panier » -> page de configuration WHMCS avec la durée
   pré-sélectionnée (les options éventuelles — mode de livraison, etc. — s'y
   choisissent de façon fiable côté WHMCS).

   Données : attribut data-ska-terms (JSON injecté par le hook syskabs_pricing).
   Robuste : aucune récupération de page ; repli sur le lien normal si JS absent.
   Délégation d'événement -> marche aussi sur le catalogue importé de l'accueil.
   ============================================================================ */
(function () {
  var ov = null;

  function money(cur, sfx, n) {
    var s = cur + Number(n).toFixed(2).replace(/\B(?=(\d{3})+(?!\d))/g, ',');
    return sfx ? s + ' ' + sfx : s;
  }
  function yLabel(y) { return y + (y > 1 ? ' ans' : ' an'); }
  function esc(s) {
    return String(s).replace(/[&<>"]/g, function (c) {
      return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;' }[c];
    });
  }

  function close() {
    if (!ov) return;
    ov.classList.remove('show');
    var el = ov; ov = null;
    setTimeout(function () { if (el && el.parentNode) el.parentNode.removeChild(el); }, 200);
    document.documentElement.classList.remove('ska-modal-open');
    document.removeEventListener('keydown', onKey);
  }
  function onKey(e) { if (e.key === 'Escape' || e.keyCode === 27) close(); }

  function open(trigger) {
    var raw = trigger.getAttribute('data-ska-terms');
    var name = trigger.getAttribute('data-ska-name') || 'Certificat';
    var href = trigger.getAttribute('href') || '#';
    var data;
    try { data = JSON.parse(raw); } catch (e) { return false; }
    if (!data || !data.terms || !data.terms.length) return false;

    var cur = data.cur || '$', sfx = data.sfx || '';
    var terms = data.terms.slice().sort(function (a, b) { return a.y - b.y; });
    var sel = terms.length - 1; // durée la plus longue par défaut (meilleur prix/an)

    ov = document.createElement('div');
    ov.className = 'ska-modal-ov';
    ov.setAttribute('role', 'dialog');
    ov.setAttribute('aria-modal', 'true');

    var cards = terms.map(function (t, i) {
      var sub = t.save > 0
        ? '<div class="ska-term-sub">Prix normal&nbsp;<s>' + money(cur, sfx, t.list) + '</s>' +
          ' <em class="ska-term-save">Économisez ' + money(cur, sfx, t.save) + '</em>' +
          ' <em class="ska-term-off">&minus;' + t.pct + '%</em></div>'
        : '';
      return '<div class="ska-term' + (i === sel ? ' active' : '') + '" data-i="' + i + '">' +
        '<span class="ska-term-radio" aria-hidden="true"></span>' +
        '<div class="ska-term-body">' +
          '<div class="ska-term-main"><b>' + yLabel(t.y) + '</b> à ' + money(cur, sfx, t.per) + ' <span>/ an</span></div>' +
          sub +
        '</div></div>';
    }).join('');

    ov.innerHTML =
      '<div class="ska-modal">' +
        '<div class="ska-modal-head"><h3>' + esc(name) + '</h3>' +
          '<button class="ska-modal-x" type="button" aria-label="Fermer">&times;</button></div>' +
        '<div class="ska-modal-body">' +
          '<p class="ska-modal-intro">Choisissez la durée&nbsp;— plus c\'est long, plus vous économisez&nbsp;:</p>' +
          '<div class="ska-terms">' + cards + '</div>' +
          '<div class="ska-modal-total"><span class="lbl">Total</span>' +
            '<span><span class="amt"></span><span class="per"></span></span></div>' +
          '<div class="ska-modal-cta">' +
            '<a href="#" class="ska-modal-add">Ajouter au panier</a>' +
            '<button type="button" class="ska-modal-ghost">Continuer mes achats</button>' +
          '</div>' +
          '<div class="ska-modal-note">Étape suivante&nbsp;: options éventuelles (livraison…) et validation sécurisée du panier.</div>' +
        '</div>' +
      '</div>';

    document.body.appendChild(ov);
    document.documentElement.classList.add('ska-modal-open');
    void ov.offsetWidth;
    ov.classList.add('show');

    var amtEl = ov.querySelector('.amt');
    var perEl = ov.querySelector('.per');
    var addBtn = ov.querySelector('.ska-modal-add');

    function refresh() {
      var t = terms[sel];
      amtEl.textContent = money(cur, sfx, t.t);
      perEl.textContent = t.y > 1 ? 'soit ' + money(cur, sfx, t.per) + ' / an' : '';
      var sep = href.indexOf('?') >= 0 ? '&' : '?';
      addBtn.setAttribute('href', t.c ? href + sep + 'billingcycle=' + t.c : href);
    }
    refresh();

    ov.querySelectorAll('.ska-term').forEach(function (card) {
      card.addEventListener('click', function () {
        sel = parseInt(card.getAttribute('data-i'), 10);
        ov.querySelectorAll('.ska-term').forEach(function (c) { c.classList.remove('active'); });
        card.classList.add('active');
        refresh();
      });
    });

    ov.querySelector('.ska-modal-x').addEventListener('click', close);
    ov.querySelector('.ska-modal-ghost').addEventListener('click', close);
    ov.addEventListener('click', function (e) { if (e.target === ov) close(); });
    document.addEventListener('keydown', onKey);
    return true;
  }

  document.addEventListener('click', function (e) {
    var t = e.target.closest ? e.target.closest('[data-ska-modal]') : null;
    if (!t) return;
    if (e.metaKey || e.ctrlKey || e.shiftKey || e.button !== 0) return;
    if (open(t)) e.preventDefault();
  });
})();
