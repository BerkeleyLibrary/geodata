export default function initializeMetadataDownload() {
    const modal = document.getElementById("blacklight-modal")

    modal.addEventListener("click", (event) => {
        if (event.target.closest("#btn-metadata-download")) {
            event.preventDefault();
            event.stopPropagation();

            const metadata = modal.querySelector(".pill-metadata.active[data-ref-endpoint]") ||
                modal.querySelector(".pill-metadata[data-ref-endpoint]");
            const refUrl = metadata?.getAttribute("data-ref-endpoint");

            if (refUrl) {
                window.open(refUrl, "_blank");
            }
        }
    }, true);

    modal.addEventListener("focus", (e) => {
        if (!Array.from(e.target.classList).includes("show")) {
            return
        }
        e.target.querySelectorAll(".metadata-body").forEach((el) => {
            el.closest(".modal-content").classList.add("metadata-modal")
        })
    })

    modal.addEventListener("blur", (e) => {
        if (Array.from(e.target.classList).includes("show")) {
            return
        }
        e.target.querySelectorAll(".metadata-body").forEach((el) => {
            el.closest(".modal-content").classList.remove("metadata-modal")
        })
    })
}
