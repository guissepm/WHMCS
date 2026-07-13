/* ============================================================================
   Sys Kabs Amazone — Sélecteur de durée façon thesslstore
   ----------------------------------------------------------------------------
   Transforme le menu déroulant WHMCS « Choose Billing Cycle » en cartes radio
   (1 / 2 / 3 ans) affichant le prix PAR AN, le prix barré et l'économie.
   Non-destructif : le <select> d'origine reste dans le DOM et pilote WHMCS ;
   on ne fait que le refléter et déclencher son "change" pour recalculer le total.
   Chargé uniquement sur cart.php (voir hook syskabs_global).
   ============================================================================ */
(function () {
  function money(n) {
    return '$' + n.toFixed(2).replace(/\B(?=(\d{3})+(?!\d))/g, ',');
  }
  function parsePrice(txt) {
    var m = (txt || '').replace(/,/g, '').match(/([0-9]+(?:\.[0-9]+)?)/);
    return m ? parseFloat(m[1]) : null;
  }
  function yearsOf(txt) {
    txt = (txt || '').toLowerCase();
    if (txt.indexOf('trienn') >= 0) return 3;   // Triennially
    if (txt.indexOf('bienn') >= 0) return 2;    // Biennially
    if (txt.indexOf('annual') >= 0) return 1;   // Annually
    return null;                                // Monthly, etc. -> ignoré
  }

  function build(sel) {
    if (sel.dataset.skaTerms) return;           // déjà construit
    var opts = Array.prototype.slice.call(sel.options);
    var data = opts.map(function (o) {
      return { el: o, price: parsePrice(o.text), years: yearsOf(o.text) };
    }).filter(function (d) { return d.price != null && d.years; });

    if (data.length < 2) return;                // pas de multi-annuel -> on laisse le menu

    data.sort(function (a, b) { return a.years - b.years; });
    var annual = data.filter(function (d) { return d.years === 1; })[0];
    var base = annual ? annual.price : null;    // tarif 1 an (référence)

    var wrap = document.createElement('div');
    wrap.className = 'ska-terms';

    data.forEach(function (d) {
      var perYear = d.price / d.years;
      var list = (base != null) ? base * d.years : null;
      var save = (list != null) ? list - d.price : 0;
      var pct = (list != null && list > 0) ? Math.round(save / list * 100) : 0;
      var label = d.years + (d.years > 1 ? ' ans' : ' an');

      var card = document.createElement('div');
      card.className = 'ska-term';
      card.innerHTML =
        '<span class="ska-term-radio" aria-hidden="true"></span>' +
        '<div class="ska-term-body">' +
          '<div class="ska-term-main"><b>' + label + '</b> à ' + money(perYear) + ' <span>/ an</span></div>' +
          (save > 0
            ? '<div class="ska-term-sub">Prix normal&nbsp;<s>' + money(list) + '</s> ' +
              '<em class="ska-term-save">Économisez ' + money(save) + '</em> ' +
              '<em class="ska-term-off">&minus;' + pct + '%</em></div>'
            : '') +
        '</div>';

      if (d.el.selected) { card.classList.add('active'); }

      card.addEventListener('click', function () {
        sel.value = d.el.value;
        // Déclenche les recalculs WHMCS (jQuery ou natif)
        var ev;
        try { ev = new Event('change', { bubbles: true }); }
        catch (e) { ev = document.createEvent('HTMLEvents'); ev.initEvent('change', true, false); }
        sel.dispatchEvent(ev);
        if (window.jQuery) { window.jQuery(sel).trigger('change'); }
        Array.prototype.forEach.call(wrap.children, function (c) { c.classList.remove('active'); });
        card.classList.add('active');
      });

      wrap.appendChild(card);
    });

    sel.parentNode.insertBefore(wrap, sel.nextSibling);
    sel.classList.add('ska-select-hidden');
    sel.dataset.skaTerms = '1';

    // Titre au-dessus des cartes, si le label d'origine existe
    var lbl = sel.parentNode.querySelector('label');
    if (lbl && !lbl.dataset.skaKept) { lbl.dataset.skaKept = '1'; }
  }

  function init() {
    var sels = document.querySelectorAll(
      'select[name="billingcycle"], select#inputBillingcycle'
    );
    Array.prototype.forEach.call(sels, build);
  }

  if (document.readyState !== 'loading') { init(); }
  else { document.addEventListener('DOMContentLoaded', init); }
})();
