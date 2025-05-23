// ページ読み込み時の表示位置を設定できるようにするために使用
document.addEventListener("turbolinks:load", function () {
  const params = new URLSearchParams(window.location.search);
  const scrollToId = params.get("scroll_to");
  if (scrollToId) {
    const target = document.getElementById(scrollToId);
    if (target) {
      target.scrollIntoView({ behavior: "smooth" });
    }
  }
});
