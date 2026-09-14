function toggleMenu() {
    const menu = document.getElementById('menu');
    const button = document.querySelector('.menu-toggle');
    if (!menu) return;

    menu.classList.toggle('open');
    if (button) {
        button.setAttribute('aria-expanded', String(menu.classList.contains('open')));
    }
}

document.addEventListener('keydown', function (event) {
    if (event.key !== 'Escape') return;

    const menu = document.getElementById('menu');
    const button = document.querySelector('.menu-toggle');
    if (!menu || !menu.classList.contains('open')) return;

    menu.classList.remove('open');
    if (button) {
        button.setAttribute('aria-expanded', 'false');
        button.focus();
    }
});
