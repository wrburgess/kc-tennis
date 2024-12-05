import { application } from "../../controllers/application"
import HelloController from "./hello_controller"

// Register the controller with the application instance
application.register("hello", HelloController)
