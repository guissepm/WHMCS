/* ============================================================================
   Sys Kabs Amazone — Modale de configuration/commande (remplace la 1re page
   de configuration produit du panier WHMCS).
   ----------------------------------------------------------------------------
   Au clic sur « Commander », la modale RÉCUPÈRE le vrai formulaire de
   cart.php?a=add&pid=X (durée, options configurables, champs perso, jeton
   CSRF) et l'affiche joliment :
     - le cycle de facturation devient des cartes (1/2/3 ans, prix/an, remise)
     - les options configurables restent les vrais champs WHMCS (stylés)
     - un TOTAL est calculé en direct à partir des prix affichés
     - « Ajouter au panier » SOUMET le vrai formulaire -> WHMCS ajoute au
       panier et affiche le récapitulatif.
   Robuste : on réutilise le formulaire officiel tel quel (jeton inclus).
   Repli : si la récupération/analyse échoue, on ouvre la vraie page.
   Délégation d'événement -> marche aussi sur le catalogue importé de l'accueil.
   ============================================================================ */
(function () {
  var ov = null;

  function esc(s) {
    return String(s).replace(/[&<>"]/g, function (c) {
      return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;' }[c];
    });
  }
  function num(txt) {
    var m = (txt || '').replace(/[\s,]/g, '').match(/(-?\d+(?:\.\d+)?)/);
    return m ? parseFloat(m[1]) : null;
  }
  function fmtFrom(sampleTxt, n) {
    // reconstitue un affichage monétaire à partir d'un texte de prix existant
    var cur = (sampleTxt.match(/^[^\d\-]*/) || [''])[0].trim();
    var sfx = (sampleTxt.match(/[A-Za-z]{2,4}\s*$/) || [''])[0].trim();
    var s = (cur || '$') + n.toFixed(2).replace(/\B(?=(\d{3})+(?!\d))/g, ',');
    return sfx ? s + ' ' + sfx : s;
  }
  function yearsOf(txt) {
    txt = (txt || '').toLowerCase();
    if (txt.indexOf('trienn') >= 0) return 3;
    if (txt.indexOf('bienn') >= 0) return 2;
    if (txt.indexOf('annual') >= 0) return 1;
    return null;
  }
  function yLabel(y) { return y + (y > 1 ? ' ans' : ' an'); }

  function lockScroll(on) {
    document.documentElement.classList[on ? 'add' : 'remove']('ska-modal-open');
  }
  function close() {
    if (!ov) return;
    ov.classList.remove('show');
    var el = ov; ov = null;
    setTimeout(function () { if (el && el.parentNode) el.parentNode.removeChild(el); }, 200);
    lockScroll(false);
    document.removeEventListener('keydown', onKey);
  }
  function onKey(e) { if (e.key === 'Escape' || e.keyCode === 27) close(); }

  function shell(title, inner) {
    ov = document.createElement('div');
    ov.className = 'ska-modal-ov';
    ov.setAttribute('role', 'dialog');
    ov.setAttribute('aria-modal', 'true');
    ov.innerHTML =
      '<div class="ska-modal ska-modal-cfg">' +
        '<div class="ska-modal-head"><h3>' + esc(title) + '</h3>' +
          '<button class="ska-modal-x" type="button" aria-label="Fermer">&times;</button></div>' +
        '<div class="ska-modal-body">' + inner + '</div>' +
      '</div>';
    document.body.appendChild(ov);
    lockScroll(true);
    void ov.offsetWidth;
    ov.classList.add('show');
    ov.querySelector('.ska-modal-x').addEventListener('click', close);
    ov.addEventListener('click', function (e) { if (e.target === ov) close(); });
    document.addEventListener('keydown', onKey);
  }

  function open(trigger) {
    var href = trigger.getAttribute('href') || '';
    var name = trigger.getAttribute('data-ska-name') || 'Configurer le produit';
    if (!href || href.charAt(0) === '#') return false;

    shell(name, '<div class="ska-modal-loading">Chargement…</div>');

    fetch(href, { credentials: 'same-origin' })
      .then(function (r) { return r.text(); })
      .then(function (html) {
        var doc = new DOMParser().parseFromString(html, 'text/html');
        var form = doc.querySelector('#orderfrm')
                || doc.querySelector('form[action*="cart.php"][method="post"]')
                || doc.querySelector('form[action*="cart.php"]');
        if (!form || !ov) { window.location.href = href; return; }
        render(form, name);
      })
      .catch(function () { window.location.href = href; });
    return true;
  }

  function render(form, name) {
    // Nettoie : on retire les <script> et les boutons de soumission d'origine.
    Array.prototype.forEach.call(form.querySelectorAll('script'), function (s) { s.remove(); });
    Array.prototype.forEach.call(
      form.querySelectorAll('button[type="submit"], input[type="submit"], .btn-primary, .checkout, a.btn'),
      function (b) { b.classList.add('ska-hide'); }
    );

    var body = ov.querySelector('.ska-modal-body');
    body.innerHTML = '';

    // Conteneur des cartes de durée (au-dessus du formulaire)
    var termsBox = document.createElement('div');
    termsBox.className = 'ska-terms';
    body.appendChild(termsBox);

    // On insère le VRAI formulaire (déplacé du document analysé) dans la modale.
    var imported = document.importNode(form, true);
    imported.classList.add('ska-cfg-form');
    body.appendChild(imported);

    var cycleSel = imported.querySelector('select[name="billingcycle"], select#inputBillingcycle');

    // --- Cartes de durée à partir du <select> billingcycle ---
    var base1 = null; // prix 1 an (référence remise)
    if (cycleSel) {
      var opts = Array.prototype.slice.call(cycleSel.options).map(function (o) {
        return { el: o, price: num(o.text), y: yearsOf(o.text), raw: o.text };
      }).filter(function (d) { return d.price != null; });

      var a1 = opts.filter(function (d) { return d.y === 1; })[0];
      base1 = a1 ? a1.price : null;

      if (opts.length >= 1) {
        opts.sort(function (a, b) { return (a.y || 9) - (b.y || 9); });
        opts.forEach(function (d) {
          var card = document.createElement('div');
          card.className = 'ska-term' + (d.el.selected ? ' active' : '');
          var main, sub = '';
          if (d.y) {
            var per = d.price / d.y;
            main = '<b>' + yLabel(d.y) + '</b> à ' + fmtFrom(d.raw, per) + ' <span>/ an</span>';
            if (base1 != null && d.y > 1) {
              var list = base1 * d.y, save = list - d.price;
              if (save > 0.01) {
                var pct = Math.round(save / list * 100);
                sub = '<div class="ska-term-sub">Prix normal&nbsp;<s>' + fmtFrom(d.raw, list) + '</s>' +
                      ' <em class="ska-term-save">Économisez ' + fmtFrom(d.raw, save) + '</em>' +
                      ' <em class="ska-term-off">&minus;' + pct + '%</em></div>';
              }
            }
          } else {
            main = '<b>' + esc(d.raw) + '</b>';
          }
          card.innerHTML = '<span class="ska-term-radio" aria-hidden="true"></span>' +
            '<div class="ska-term-body"><div class="ska-term-main">' + main + '</div>' + sub + '</div>';
          card.addEventListener('click', function () {
            cycleSel.value = d.el.value;
            trigger(cycleSel);
            termsBox.querySelectorAll('.ska-term').forEach(function (c) { c.classList.remove('active'); });
            card.classList.add('active');
            recalc();
          });
          termsBox.appendChild(card);
        });
        // masque le menu déroulant d'origine (remplacé par les cartes)
        var wrap = cycleSel.closest('.form-group') || cycleSel.parentNode;
        if (wrap) wrap.classList.add('ska-hide');
      }
    }

    // Total + actions
    var footer = document.createElement('div');
    footer.innerHTML =
      '<div class="ska-modal-total"><span class="lbl">Total</span>' +
        '<span><span class="amt"></span><span class="per"></span></span></div>' +
      '<div class="ska-modal-cta">' +
        '<a href="#" class="ska-modal-add">Ajouter au panier</a>' +
        '<button type="button" class="ska-modal-ghost">Continuer mes achats</button>' +
      '</div>' +
      '<div class="ska-modal-note">Émission rapide · certificat de confiance · assistance en français.</div>';
    body.appendChild(footer);

    var amtEl = footer.querySelector('.amt');
    var perEl = footer.querySelector('.per');

    function selectedCycle() {
      if (!cycleSel) return null;
      var o = cycleSel.options[cycleSel.selectedIndex];
      return o ? { price: num(o.text), y: yearsOf(o.text), raw: o.text } : null;
    }
    function optionsExtra() {
      var sum = 0;
      // selects d'options configurables
      Array.prototype.forEach.call(
        imported.querySelectorAll('select[name^="configoption"]'),
        function (s) { var o = s.options[s.selectedIndex]; var n = o ? num(o.text) : null; if (n) sum += n; }
      );
      // cases à cocher / radios d'options cochées
      Array.prototype.forEach.call(
        imported.querySelectorAll('input[name^="configoption"]:checked, input[name^="configoption"][type="text"]'),
        function (i) {
          var lbl = i.closest('label') || (i.id && imported.querySelector('label[for="' + i.id + '"]'));
          var n = num((lbl ? lbl.textContent : '') || i.value);
          if (i.type === 'checkbox' || i.type === 'radio') { if (i.checked && n) sum += n; }
        }
      );
      return sum;
    }
    function recalc() {
      var c = selectedCycle();
      if (!c || c.price == null) { amtEl.textContent = ''; perEl.textContent = ''; return; }
      var total = c.price + optionsExtra();
      amtEl.textContent = fmtFrom(c.raw, total);
      perEl.textContent = (c.y && c.y > 1) ? 'soit ' + fmtFrom(c.raw, total / c.y) + ' / an' : '';
    }

    // recalcul quand une option change
    imported.addEventListener('change', recalc);
    recalc();

    // Ajout au panier = soumission du vrai formulaire WHMCS
    footer.querySelector('.ska-modal-add').addEventListener('click', function (e) {
      e.preventDefault();
      submitForm(imported);
    });
    footer.querySelector('.ska-modal-ghost').addEventListener('click', close);

    // Titre
    var h = ov.querySelector('.ska-modal-head h3');
    if (h) h.textContent = name;
  }

  function trigger(el) {
    var ev;
    try { ev = new Event('change', { bubbles: true }); }
    catch (e) { ev = document.createEvent('HTMLEvents'); ev.initEvent('change', true, false); }
    el.dispatchEvent(ev);
    if (window.jQuery) { try { window.jQuery(el).trigger('change'); } catch (e2) {} }
  }

  function submitForm(form) {
    // Le formulaire a été déplacé dans la modale ; il porte l'action, la
    // méthode, tous les champs et le jeton CSRF d'origine -> soumission fiable.
    if (typeof form.requestSubmit === 'function') { form.requestSubmit(); }
    else { form.submit(); }
  }

  // Délégation (capte aussi le catalogue importé de l'accueil).
  document.addEventListener('click', function (e) {
    var t = e.target.closest ? e.target.closest('[data-ska-modal]') : null;
    if (!t) return;
    if (e.metaKey || e.ctrlKey || e.shiftKey || e.button !== 0) return;
    if (open(t)) e.preventDefault();
  });
})();
