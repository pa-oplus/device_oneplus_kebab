# PA system perf clients and OnePlus HIDL 2.2

The PA reference libqti-perfd-client_system.so supports both AIDL perf2 and HIDL
perf 2.2/2.3. The prior diagnosis of an unavoidable protocol mismatch was based
on an AIDL DT_NEEDED entry without tracing dispatch; that conclusion was incorrect.
No adapter or binary replacement is justified by the reviewed dispatch path.

The device retains the PA system/perf recipe and the stock OnePlus vendor perf
2.2 service. PRODUCT_SHIPPING_API_LEVEL remains the real shipping API, 30; it is
not changed to influence the client. No AIDL perf2 backend is declared by the
recorded device/vendor fragments. Interface libraries in DT_NEEDED remain packaged,
including the AIDL library; a runtime branch does not remove a load-time dependency.

## Static evidence

The exact arm and arm64 client SHA256 hashes and interface source hashes are in
perf-client-contract.json. The reference files are under
aospa-trees/vendor/qcom/common/system/perf; this directory is a reference snapshot,
not a live PA checkout. readelf and LLVM objdump were used for both architectures
(with Thumb decoding for arm).

| Evidence | arm64 | arm |
|---|---|---|
| Protocol selector | isHalTypeAidl stub 0x15fc0 branches to 0xa4e4 | Thumb stub 0x107b4 branches to 0x7ab0 |
| Service declaration check | AServiceManager_isDeclared at 0xa5dc; absent sets state 2 and returns false | PLT call at 0x7b58; absent sets state 2 and returns false at 0x7b96 |
| HIDL branch | call at 0xaf0c tests the selector; false takes 0xaf20 to HIDL acquisition at 0xb818 | Imports HIDL 2.2 getService/tryGetService; protocol-selector false path confirmed |
| HIDL lookup | 0xb954 calls V2_2::IPerf::tryGetService for default | Matching HIDL 2.2 imports; no target execution claimed |
| HIDL version choice | get_perf_hal_ver stub 0x15f30 leads to 0x12594; compares ro.board.first_api_level with 30 | Stub 0x1076c leads to 0xd560; compares against 30 at 0xd5ca |
| Version constants | API <=30 selects double 2.2 at 0x3ec0; >30 selects 2.3 | API <=30 selects double 2.2 at 0xd600; >30 selects 2.3 at 0xd608 |

The reviewed arm64 protocol selector also falls back when AIDL was declared but
its service could not be obtained. Kebab relies on the simpler undeclared-AIDL
case. This is a static inference about the reviewed bytes, not a service-call test.

The PA JNI libqti_performance.so names libqti-perfd-client_system.so as its client.
The PA reference HIDL interface definitions exist under
vendor/aospa/interfaces/qcom/perf/2.0 through 2.3. They are now explicit source
requirements, since the stock vendor service and system client depend on them.
The generic policy reference labels the stock 2.2 executable as
vendor_hal_perf_default_exec, maps IPerf to vendor_hal_perf_hwservice, and grants
HIDL lookup to the perf client attribute. The system perfservice joins that client
attribute. No speculative device policy allow rules were added.

## Reproduce the contract check

```sh
python3 tools/check-perf-contract.py \
  --system-perf-root /path/to/vendor/qcom/common/system/perf \
  --interfaces-root /path/to/vendor/aospa/interfaces/qcom/perf \
  --vendor-root /path/to/vendor/oneplus/kebab
```

The check verifies the exact reviewed binary/interface hashes, expected imported
symbols, API 30, exclusion of the generic vendor perf component, preservation of
the PA system client recipe, and a single recorded HIDL 2.2/default backend with
no recorded AIDL perf2 declaration. Changed client bytes require a new review.
This checks the recorded fragments, not the final product's entire manifest graph.

## Runtime gates

- Confirm final ro.board.first_api_level=30 and the HIDL service registration.
- Compile/install all required system and vendor interface variants and libraries.
- Verify linker namespaces and SELinux access from actual framework/system clients.
- Test perf acquire/release/hint paths, resource IDs, power modes and suspend.
- Validate optional system-perf components separately; this central-client review
  does not prove their complete compatibility with every stock service.

A current full PA checkout is still needed for product and target-policy checks.
Forty-two other legacy HAL reference obligations remain unchanged by this review.
