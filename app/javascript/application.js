// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import * as bootstrap from "bootstrap"
import githubAutoCompleteElement from "@github/auto-complete-element"
import Blacklight from "blacklight"
import Geoblacklight from "geoblacklight";
import { application } from "controllers/application"
import LeafletViewerController from "geoblacklight/controllers/leaflet_viewer_controller";

// Custom Leaflet Viewer Controller that adds aria-hidden for accessibility
class CustomLeafletViewerController extends LeafletViewerController {
  connect() {
    super.connect();
    this.element.setAttribute('aria-hidden', 'true');
  }
}

// Register the custom controller after GeoBlacklight loads to override its registration
application.register("leaflet-viewer", CustomLeafletViewerController);
