import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["image"]

  move(event) {
    const { left, top, width, height } = this.imageTarget.getBoundingClientRect()

    const x = (event.clientX - left) / width * 100
    const y = (event.clientY - top) / height * 100

    this.imageTarget.style.transformOrigin = `${x}% ${y}%`
    this.imageTarget.style.transform = "scale(2)"
  }

  reset() {
    this.imageTarget.style.transform = "scale(1)"
  }
}
