"use strict";

document.addEventListener("DOMContentLoaded", () => {
  const $navbarBurgers = Array.prototype.slice.call(
    document.querySelectorAll(".navbar-burger"),
    0
  );
  if ($navbarBurgers.length > 0) {
    $navbarBurgers.forEach((el) => {
      el.addEventListener("click", () => {
        const target = el.dataset.target;
        const $target = document.getElementById(target);
        el.classList.toggle("is-active");
        $target.classList.toggle("is-active");
      });
    });
  }

  const $navbarDropdowns = Array.prototype.slice.call(
    document.querySelectorAll(".navbar-item.has-dropdown"),
    0
  );
  if ($navbarDropdowns.length > 0) {
    $navbarDropdowns.forEach((el) => {
      el.addEventListener("click", (event) => {
        event.stopPropagation();
        $navbarDropdowns.forEach((e) => {
          e.classList.remove("is-active");
        });
        el.classList.toggle("is-active");
      });
    });
  }
  const $body = document.querySelector("body");
  $body.addEventListener("click", () => {
    $navbarDropdowns.forEach((e) => {
      e.classList.remove("is-active");
    });
  });
});
