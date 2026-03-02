import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="increase-product"
export default class extends Controller {
  static values = { max: Number }

  connect() {
    this.count = 0
    document.getElementById("show-value").textContent = this.count
  }

  changeValue() {
    document.getElementById("button-add-to-cart").value = this.count
    document.getElementById("show-value").textContent = this.count
  }

  increase() {
    if (this.count < this.maxValue) {
      this.count += 1
      this.changeValue()
    } else {
      this.button = this.element.querySelector('[data-action="click->increase-product#increase"]')
      this.button.disabled = true
      this.button.classList += "disable-btn"

      document.getElementById("notice").textContent = `*Solo hay ${this.maxValue} unidades disponibles.`
    }
  }

  decrease() {
    if (this.count !== 0) {
      this.count -= 1
      this.changeValue()
    }
  }
}
