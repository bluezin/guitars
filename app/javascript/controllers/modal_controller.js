import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="modal"
export default class extends Controller {
  static targets = ["modal"];

  connect() {}

  open() {
    const el = document.getElementById("list-products")
    el.classList.remove("hidden");
  }

  close() {
    const el = document.getElementById("list-products")
    el.classList.add("hidden")
  }
}
