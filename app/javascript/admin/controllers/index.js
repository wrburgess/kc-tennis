import { application } from "../../controllers/application"

import TomSelectController from "./tom_select_controller"

// Register the controller with the application instance
application.register("tom-select", TomSelectController)

// console.log("Admin JavaScript bundle loaded")
