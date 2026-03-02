import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    setTimeout(() => {
      this.element.style.transition = "opacity 0.5s ease"
      this.element.style.opacity = 0
      this.element.remove()
    }, 5000) // 5 segundos
  }
}
