// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import * as bootstrap from "bootstrap"
import githubAutoCompleteElement from "@github/auto-complete-element"
import Blacklight from "blacklight"
import Geoblacklight from "geoblacklight";
import { application } from "controllers/application"
import LeafletViewerController from "geoblacklight/controllers/leaflet_viewer_controller";

const focusableSelectors = 'a[href], button, input, select, object, embed, summary, [tabindex]';

// Custom Leaflet Viewer Controller that adds aria-hidden for accessibility
class CustomLeafletViewerController extends LeafletViewerController {
  connect() {
    super.connect();

    // Hide map from screen readers but allow mouse interaction
    this.element.setAttribute('aria-hidden', 'true');
    this.element.setAttribute('tabindex', '-1');
    this.observeFocusableChildren();
    this.disableFocusableChildren(this.element);
  }

  disconnect() {
    this.focusableObserver?.disconnect();
    super.disconnect();
  }

  disableFocusableChildren(root) {
    if (root.matches(focusableSelectors) && root.getAttribute('tabindex') !== '-1') {
      root.setAttribute('tabindex', '-1');
    }
    root.querySelectorAll(focusableSelectors).forEach(element => {
      if (element.getAttribute('tabindex') !== '-1') {
        element.setAttribute('tabindex', '-1');
      }
    });
  }

  observeFocusableChildren() {
    this.focusableObserver = new MutationObserver((mutations) => {
      mutations.forEach(mutation => {
        if (mutation.type === 'attributes') {
          if (!this.element.contains(mutation.target)) return;
          if (mutation.target === this.element && mutation.target.getAttribute('tabindex') !== '-1') {
            mutation.target.setAttribute('tabindex', '-1');
          } else if (mutation.target.matches(focusableSelectors) && mutation.target.getAttribute('tabindex') !== '-1') {
            mutation.target.setAttribute('tabindex', '-1');
          }
        } else if (mutation.type === 'childList') {
          mutation.addedNodes.forEach(node => {
            if (node.nodeType === 1 && this.element.contains(node)) {
              this.disableFocusableChildren(node);
            }
          });
        }
      });
    });

    this.focusableObserver.observe(this.element, {
      childList: true,
      subtree: true,
      attributes: true,
      attributeFilter: ['tabindex', 'href']
    });
  }
}

// Register the custom controller after GeoBlacklight loads to override its registration
application.register("leaflet-viewer", CustomLeafletViewerController);

document.addEventListener("click", (event) => {
  const button = event.target.closest('button[data-blacklight-modal~="trigger"][data-modal-url]');
  if (!button) return;

  event.preventDefault();
  const url = button.dataset.modalUrl;
  fetch(url)
    .then((response) => {
      if (!response.ok) throw new TypeError("Request failed");
      return response.text();
    })
    .then((content) => Blacklight.Modal.receiveAjax(content))
    .catch((error) => Blacklight.Modal.onFailure.call({ url }, error));
});
