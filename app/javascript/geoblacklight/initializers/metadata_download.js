export default function initializeMetadataDownload() {
    const modal = document.getElementById("blacklight-modal")

    const updateDownloadLink = (metadata) => {
        const download = modal.querySelector("#btn-metadata-download")
        const refUrl = metadata?.getAttribute("data-ref-endpoint")

        if (!download || !refUrl) {
            return
        }

        download.setAttribute("href", refUrl)
    }

    modal.addEventListener("click", (event) => {
        const metadata = event.target.closest(".pill-metadata[data-ref-endpoint]")
        const download = event.target.closest("#btn-metadata-download")

        if (metadata) {
            updateDownloadLink(metadata)
        } else if (download) {
            const activeMetadata = modal.querySelector(".pill-metadata.active[data-ref-endpoint]")

            if (activeMetadata) {
                updateDownloadLink(activeMetadata)
            } else {
                event.preventDefault()
            }
        }
    }, true)

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
