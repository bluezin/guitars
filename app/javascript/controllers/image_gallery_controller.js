import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["main", "thumbnail"]

  change(event) {
    const newUrl = event.currentTarget.dataset.url
    this.mainTarget.src = newUrl

    // marcar activa
    this.thumbnailTargets.forEach(el => el.classList.remove("active"))
    event.currentTarget.classList.add("active")
  }
}
