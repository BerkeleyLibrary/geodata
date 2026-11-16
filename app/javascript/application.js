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
    // Hide map from screen readers but allow mouse interaction
    this.element.setAttribute('aria-hidden', 'true');
    this.element.setAttribute('tabindex', '-1');

    // Disable keyboard focus on all focusable children but keep mouse interaction
    this.disableFocusableChildren();

  }

  disableFocusableChildren() {
    const focusableSelectors = 'button, [href], input, select, textarea';
    this.element.querySelectorAll(focusableSelectors).forEach(el => {
      el.setAttribute('tabindex', '-1');
    });
  }

}

// Register the custom controller after GeoBlacklight loads to override its registration
application.register("leaflet-viewer", CustomLeafletViewerController);
