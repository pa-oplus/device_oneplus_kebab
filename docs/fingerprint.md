# OnePlus optical fingerprint integration

Use the PA hardware tree in `aospa-trees/hardware/oplus`, remote
`clo-oscaro/hardware_oplus`, branch calcite at `cc126d9`. It supplies the HIDL 2.3
wrapper, RC, manifest fragment, Oplus interface and display ioctl header. It imports
`hardware/google/interfaces`, which the final source checkout must also provide.
The Lineage hardware clone is reference material, not the selected hardware tree.

The PA hardware tree does not contain the Lineage UDFPS extension library.
This device carries that small implementation locally, retaining its source
license and changing only the unused parameter spelling. The three function
signatures match the cloned calcite CompositionEngine header; its actual build
uses the `surfaceflinger/udfps_lib` Soong selector. Do not substitute the unused
legacy PA vendor selector merely because it appears in BoardConfigSoong.

The overlay uses Lineage kebab's optical sensor center/radius (540, 1897, 95).
The non-empty legacy sensor configuration identifies sensor 0 as fingerprint,
strong, and selects the HIDL registration path used by the wrapper. Strength
and geometry describe the intended baseline, not a successful biometric test.
The optical property enables the wrapper's Oplus HBM/finger-press ioctl path.

The wrapper includes its own VINTF fragment; do not duplicate its default HIDL
instance in the later device manifest. The underlying proprietary Oplus service,
its manifest/init fragments and calibration data remain vendor dependencies.
`/dev/oplus_display` permissions are supplied by the OnePlus init script; SELinux
label/access integration is still pending. Kernel UDFPS header/bit definitions,
HBM behavior, generated_kernel_headers availability, framework registration,
enrollment, unlock and screen-off behavior need full build/device validation.
No Xiaomi fingerprint extension, side-sensor geometry or Xiaomi library is used.

## Initial fingerprint policy

The source wrapper and OnePlus backend receive hal_fingerprint_default executable
labels and the vendor backend interface maps to the existing fingerprint hwservice
type. Same-domain binder calls follow the selected PA Oplus policy contract.
/dev/oplus_display has a device-specific type granted only to the HAL for its
source-defined optical ioctls; the local SurfaceFlinger extension does not open
that node. The historical OnePlus goodix_fp mapping uses fingerprint_device.

Exact sensor_type/version properties use a local vendor-internal property type,
with fingerprint HAL access and vendor-init setting access. No broad fingerprint
property prefix or unrelated Oplus service policy is imported. Backend data,
persist/TEE/device paths and remaining property requirements still need actual
vendor/policy reconciliation. This initial slice does not validate enrollment,
HBM, ioctl ABI or authentication on device.
