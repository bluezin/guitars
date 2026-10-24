import { Controller } from "@hotwired/stimulus"

// Cuenta regresiva hasta endsAt (ISO 8601).
export default class extends Controller {
  static values = { endsAt: String }
  static targets = ["days", "hours", "minutes", "seconds"]

  connect() {
    this.tick()
    this.timer = setInterval(() => this.tick(), 1000)
  }

  disconnect() {
    clearInterval(this.timer)
  }

  tick() {
    const ms = Math.max(0, new Date(this.endsAtValue) - Date.now())
    const s = Math.floor(ms / 1000)
    const pad = (n) => String(n).padStart(2, "0")
    this.daysTarget.textContent = pad(Math.floor(s / 86400))
    this.hoursTarget.textContent = pad(Math.floor((s % 86400) / 3600))
    this.minutesTarget.textContent = pad(Math.floor((s % 3600) / 60))
    this.secondsTarget.textContent = pad(s % 60)
    if (ms === 0) clearInterval(this.timer)
  }
}
