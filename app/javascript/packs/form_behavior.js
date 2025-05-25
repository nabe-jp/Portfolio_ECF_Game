// フォームないでボタンを押した際の振る舞いを姓よするために使用
document.addEventListener('turbolinks:load', () => {
  const toggleCheckbox = document.getElementById('enable_sort_order');
  const sortOrderField = document.getElementById('sort_order_field');
  if (!toggleCheckbox || !sortOrderField) return;

  const toggleSortOrderVisibility = () => {
    sortOrderField.style.display = toggleCheckbox.checked ? 'block' : 'none';
  };

  toggleCheckbox.addEventListener('change', toggleSortOrderVisibility);
  toggleSortOrderVisibility();
});