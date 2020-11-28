require("@rails/ujs").start();
require("@rails/activestorage").start();
require("channels");

import flatpickr from "flatpickr"
require("flatpickr/dist/flatpickr.css")
flatpickr(".datepicker", {})
import jquery from 'jquery';
window.$ = window.jquery = jquery;


document.addEventListener("turbolinks:load", () =>{
  flatpickr("[data-behaviour='flatpickr']",{
    altInput: true,
    altFormat: "F j , Y",
    dateFormat: "Y-m-d"
  })
})

import "bootstrap";
import '../stylesheets/application'

//= require bootstrap-toggle-buttons
