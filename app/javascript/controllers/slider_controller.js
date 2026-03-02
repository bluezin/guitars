import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["item"]

  connect() {
    this.index = 0
    this.updatePerView()
    this.showCurrent()

    window.addEventListener("resize", () => {
      this.updatePerView()
      this.index = 0   // 🔥 reinicia para evitar errores
      this.showCurrent()
    })
  }

  updatePerView() {
    this.perView = window.innerWidth <= 450 ? 2 : 3
  }

  next() {
    this.index += this.perView

    if (this.index >= this.itemTargets.length) {
      this.index = 0
    }

    this.showCurrent()
  }

  prev() {
    this.index -= this.perView

    if (this.index < 0) {
      this.index = Math.max(this.itemTargets.length - this.perView, 0)
    }

    this.showCurrent()
  }

  showCurrent() {
    this.itemTargets.forEach((el, i) => {
      el.style.display =
        i >= this.index && i < this.index + this.perView
          ? "block"
          : "none"
    })
  }
}
