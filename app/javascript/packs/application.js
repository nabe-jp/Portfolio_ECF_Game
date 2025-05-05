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

Rails.start()
Turbolinks.start()
ActiveStorage.start()
