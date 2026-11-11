function initLightbox() {
  if (document.querySelector('.lightbox-overlay')) {
    return;
  }

  const overlay = document.createElement('div');
  overlay.className = 'lightbox-overlay';
  overlay.setAttribute('role', 'dialog');
  overlay.setAttribute('aria-label', 'Vista ampliada');

  const dialog = document.createElement('div');
  dialog.className = 'lightbox-dialog';

  const image = document.createElement('img');
  image.className = 'lightbox-image';
  image.alt = 'Vista ampliada';

  const closeButton = document.createElement('button');
  closeButton.className = 'lightbox-close';
  closeButton.type = 'button';
  closeButton.setAttribute('aria-label', 'Cerrar');
  closeButton.textContent = '×';

  dialog.appendChild(image);
  dialog.appendChild(closeButton);
  overlay.appendChild(dialog);
  document.body.appendChild(overlay);

  function openLightbox(src, alt, grayscale) {
    image.src = src;
    image.alt = alt || 'Vista ampliada';
    image.classList.toggle('grayscale', !!grayscale);
    overlay.classList.add('is-open');
    document.body.classList.add('lightbox-open');
  }

  function closeLightbox() {
    overlay.classList.remove('is-open');
    document.body.classList.remove('lightbox-open');
    image.removeAttribute('src');
    image.alt = 'Vista ampliada';
  }

  document.addEventListener('click', function (event) {
    const clickedImage = event.target.closest('.md-content img');

    if (!clickedImage || clickedImage.dataset.lightbox === 'disabled') {
      return;
    }

    event.preventDefault();
    event.stopPropagation();
    openLightbox(clickedImage.currentSrc || clickedImage.src, clickedImage.alt || clickedImage.title || '', clickedImage.classList.contains('grayscale'));
  });

  overlay.addEventListener('click', function (event) {
    if (event.target === overlay || event.target === dialog) {
      closeLightbox();
    }
  });

  closeButton.addEventListener('click', closeLightbox);
  document.addEventListener('keydown', function (event) {
    if (event.key === 'Escape' && overlay.classList.contains('is-open')) {
      closeLightbox();
    }
  });
}

if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', initLightbox);
} else {
  initLightbox();
}

window.addEventListener('load', initLightbox);


// Vista completa de tablas anchas, también con navegación instantánea.
function initTableZoom() {
  if (document.querySelector('.table-zoom-overlay')) return;
  const overlay = document.createElement('div');
  overlay.className = 'table-zoom-overlay';
  overlay.setAttribute('role', 'dialog');
  overlay.setAttribute('aria-modal', 'true');
  overlay.setAttribute('aria-label', 'Vista completa de la tabla');
  const panel = document.createElement('div');
  panel.className = 'table-zoom-dialog md-typeset';
  const close = document.createElement('button');
  close.type = 'button';
  close.className = 'table-zoom-close';
  close.textContent = 'Cerrar ×';
  const frame = document.createElement('div');
  frame.className = 'table-zoom-frame';
  panel.append(close, frame);
  overlay.append(panel);
  document.body.append(overlay);
  let opener = null;
  const tableTargets = new WeakMap();

  const tableButtons = new WeakMap();
  let updatePending = false;

  function updateTableButtons() {
    updatePending = false;
    document.querySelectorAll('.md-content table').forEach(function (table) {
      const button = tableButtons.get(table);
      if (!button) return;
      const wrapper = table.closest('.md-typeset__scrollwrap') ||
        table.closest('.md-typeset__table') || table.parentElement;
      const available = wrapper.clientWidth;
      const required = Math.max(table.scrollWidth, table.getBoundingClientRect().width);
      const path = decodeURIComponent(window.location.pathname).toLowerCase();
      const alwaysOfferZoom = /\/(exercicis|ejercicios|soluciones)[^/]*(\/|\.html|$)/.test(path);
      button.hidden = !table.getClientRects().length || available === 0 ||
        (!alwaysOfferZoom && required <= available + 2);
    });
  }

  function scheduleTableUpdate() {
    if (updatePending) return;
    updatePending = true;
    window.requestAnimationFrame(updateTableButtons);
  }

  const tableResizeObserver = typeof ResizeObserver !== 'undefined' ?
    new ResizeObserver(scheduleTableUpdate) : null;

  function addTableButtons() {
    if (tableResizeObserver) tableResizeObserver.disconnect();
    document.querySelectorAll('.md-content table').forEach(function (table) {
      const wrapper = table.closest('.md-typeset__scrollwrap') ||
        table.closest('.md-typeset__table') || table;
      if (!tableButtons.has(table)) {
        const button = document.createElement('button');
        button.type = 'button';
        button.className = 'table-zoom-button';
        button.textContent = '⛶ Ver tabla completa';
        button.hidden = true;
        wrapper.before(button);
        tableTargets.set(button, table);
        tableButtons.set(table, button);
      }
      if (tableResizeObserver) {
        tableResizeObserver.observe(wrapper);
        tableResizeObserver.observe(table);
      }
    });
    scheduleTableUpdate();
  }

  function fitTable() {
    const table = frame.querySelector('table');
    if (!table) return;
    table.style.transform = 'none';
    const width = table.offsetWidth;
    const height = table.offsetHeight;
    const scale = Math.min(1, (window.innerWidth * 0.96 - 32) / width,
      (window.innerHeight * 0.94 - 80) / height);
    table.style.transform = 'scale(' + scale + ')';
    frame.style.width = (width * scale) + 'px';
    frame.style.height = (height * scale) + 'px';
  }

  function dismiss() {
    overlay.classList.remove('is-open');
    document.body.classList.remove('table-zoom-open');
    frame.replaceChildren();
    if (opener) opener.focus();
  }

  document.addEventListener('click', function (event) {
    const button = event.target.closest('.table-zoom-button');
    if (!button) return;
    const table = tableTargets.get(button);
    if (!table) return;
    opener = button;
    const copy = table.cloneNode(true);
    copy.querySelectorAll('[id]').forEach(function (element) {
      element.removeAttribute('id');
    });
    copy.removeAttribute('id');
    frame.replaceChildren(copy);
    overlay.classList.add('is-open');
    document.body.classList.add('table-zoom-open');
    fitTable();
    copy.querySelectorAll('img').forEach(function (image) {
      image.addEventListener('load', fitTable, { once: true });
    });
    close.focus();
  });
  close.addEventListener('click', dismiss);
  overlay.addEventListener('click', function (event) {
    if (event.target === overlay) dismiss();
  });
  document.addEventListener('keydown', function (event) {
    if (!overlay.classList.contains('is-open')) return;
    if (event.key === 'Escape') dismiss();
    if (event.key === 'Tab') {
      event.preventDefault();
      close.focus();
    }
  });
  window.addEventListener('resize', function () {
    fitTable();
    scheduleTableUpdate();
  });
  document.addEventListener('toggle', scheduleTableUpdate, true);
  document.addEventListener('load', scheduleTableUpdate, true);
  if (document.fonts) document.fonts.ready.then(scheduleTableUpdate);
  addTableButtons();
  // Material vuelve a insertar el contenido al navegar sin recargar la página.
  if (typeof document$ !== 'undefined') document$.subscribe(addTableButtons);
}
if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', initTableZoom);
} else {
  initTableZoom();
}
