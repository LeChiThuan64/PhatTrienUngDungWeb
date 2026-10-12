document.addEventListener('DOMContentLoaded', function () {
    var themeButtons = document.querySelectorAll('[data-admin-theme-toggle]');
    var root = document.documentElement;

    function updateThemeButtons() {
        var isDark = root.dataset.adminTheme === 'dark';

        themeButtons.forEach(function (button) {
            button.setAttribute('aria-pressed', String(isDark));
            button.textContent = isDark ? 'Chế độ sáng' : 'Chế độ tối';
        });
    }

    themeButtons.forEach(function (button) {
        button.addEventListener('click', function () {
            var nextTheme = root.dataset.adminTheme === 'dark' ? 'light' : 'dark';
            root.dataset.adminTheme = nextTheme;
            updateThemeButtons();

            try {
                localStorage.setItem('nord-admin-theme', nextTheme);
            } catch (error) {
                console.warn('Không thể lưu lựa chọn giao diện quản trị trên trình duyệt.', error);
            }
        });
    });

    updateThemeButtons();
});
