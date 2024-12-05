import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["output"]

  connect() {
    console.log("Admin Hello Controller Connected")
    if (this.hasOutputTarget) {
      this.outputTarget.textContent = "Hello from Admin Controller!"
    } else {
      console.log("No output target found for admin hello controller")
    }
  }
}
