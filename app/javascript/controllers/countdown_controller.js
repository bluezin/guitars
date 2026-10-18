import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["hours", "minutes", "seconds"]
  static values = { endsAt: String }

  connect() {
    this.tick()
    this.interval = setInterval(() => this.tick(), 1000)
  }

  disconnect() {
    this.clear()
  }

  tick() {
    const remaining = new Date(this.endsAtValue).getTime() - Date.now()

    if (remaining <= 0) {
      this.render(0, 0, 0)
      this.clear()
      return
    }

    const totalSeconds = Math.floor(remaining / 1000)
    const hours = Math.floor(totalSeconds / 3600)
    const minutes = Math.floor((totalSeconds % 3600) / 60)
    const seconds = totalSeconds % 60

    this.render(hours, minutes, seconds)
  }

  render(hours, minutes, seconds) {
    this.hoursTarget.textContent = this.pad(hours)
    this.minutesTarget.textContent = this.pad(minutes)
    this.secondsTarget.textContent = this.pad(seconds)
  }

  pad(value) {
    return String(value).padStart(2, "0")
  }

  clear() {
    if (!this.interval) return

    clearInterval(this.interval)
    this.interval = null
  }
}
