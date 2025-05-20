// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

// カリキュラムより抜粋、Bootstrap用 ここから
import "jquery";         // Bootstrap 5 以降のバージョンでは不要みたい
import "popper.js";      // Bootstrap 5 以降のバージョンでは不要みたい
import "bootstrap";
import "../stylesheets/application"; 
// ここまで

// Rails.start()
// Turbolinks.start()
// ActiveStorage.start()



// import { Turbo } from "@hotwired/turbo-rails"
// import "./controllers"

// // 上記のスクリプトを追加
// ddocument.addEventListener("DOMContentLoaded", function() {
//   // すべてのラジオボタンに対して選択状態を監視
//   const radioButtons = document.querySelectorAll('.search-form__category-radio');
  
//   radioButtons.forEach(function(radio) {
//     // ラジオボタンが選択されたときに対応するラベルにクラスを追加
//     radio.addEventListener('change', function() {
//       // すべてのラベルから 'search-form__category--selected' クラスを削除
//       document.querySelectorAll('.search-form__category').forEach(function(label) {
//         label.classList.remove('search-form__category--selected');
//       });
      
//       // 選択されたラジオボタンのラベルにクラスを追加
//       if (radio.checked) {
//         radio.closest('label').classList.add('search-form__category--selected');
//       }
//     });
//   });

//   // ページ読み込み時に、最初に選択されているラジオボタンにクラスを追加
//   const selectedRadio = document.querySelector('.search-form__category-radio:checked');
//   if (selectedRadio) {
//     selectedRadio.closest('label').classList.add('search-form__category--selected');
//   }
// });
