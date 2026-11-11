# OnePlus 8T (kebab) — Paranoid Android CLO

Standalone configuration for `device/oneplus/kebab`, product `aospa_kebab`.
Device/vendor integration is prepared; a full PA product build and device tests
have not been completed. The former PA checkout is unavailable.

The unified vendor output is required through strict product/board includes.
Static checks verify its 2,552 files, 34 pins, 778 unique vendor modules and exact
regeneration of four build files. The recorded VINTF merge passes for 34 inputs
and 109 instances: 51 legacy records declared, one optional interface not selected.
These checks do not establish complete product, ABI, policy or boot compatibility.

Start with [current status and remaining gates](docs/INTEGRATION_STATUS.md).
See [vendor integration](docs/VENDOR_INTEGRATION.md),
[vendor provenance/checks](docs/vendor-consolidation.md),
[source selection](docs/source-assembly.md),
[extraction workflow](docs/extraction.md), and
[reference sources](docs/REFERENCE_SOURCES.md).

Hardware configuration uses the matching OnePlus Lineage device/common references,
PA Oplus from aospa-trees, and reviewed Kona sources from the alioth CLO reference.
The tree includes variant libinit, recovery/init, source audio/power/display,
optical fingerprint, camera, slider, sensors, thermal/health, Bluetooth/Wi-Fi/NFC,
USB/boot control, radio/IMS, DRM and overlays. Detailed historical milestones are
in [BRINGUP.md](docs/BRINGUP.md); its earlier source checks are historical.

Apply the required init/audio source patches and the reviewed source manifest to
a full PA checkout before building. Kernel/header integration, full install/linker
and policy/matrix checks, product compilation and hardware validation remain open.
