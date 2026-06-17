import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  open() {
    const panel = document.getElementById("list-products")
    const backdrop = document.getElementById("cart-backdrop")

    if (panel) panel.classList.remove("hidden")
    if (backdrop) backdrop.classList.remove("hidden")

    const notice = document.getElementById("notice-main")
    if (notice) notice.style.display = "none"

    document.body.style.overflow = "hidden"
  }

  close() {
    const panel = document.getElementById("list-products")
    const backdrop = document.getElementById("cart-backdrop")

    if (panel) panel.classList.add("hidden")
    if (backdrop) backdrop.classList.add("hidden")

    document.body.style.overflow = ""
  }
}
