import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["output"]

  connect() {
    console.log("Public Hello Controller Connected")
    if (this.hasOutputTarget) {
      this.outputTarget.textContent = "Hello from Public Controller!"
    } else {
      console.log("No output target found for public hello controller")
    }
  }
}
