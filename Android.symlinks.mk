# Automatically generated. Do not modify.
# Stock symlinks, emitted from inventory.
# NOTE: toybox_vendor (174) and toolbox (6) symlinks are intentionally omitted:
# AOSP Soong modules (external/toybox:toybox_vendor, system/core/toolbox:toolbox_vendor)
# already generate them, and emitting them here duplicates install rules.

ifeq ($(BUILDING_VENDOR_IMAGE),true)
$(call symlink-file,,/mnt/vendor/productinfo/wcn/tsx_bt_data.txt,$(PRODUCT_OUT)/vendor/firmware/tsx_data)
$(call declare-0p-target,$(PRODUCT_OUT)/vendor/firmware/tsx_data)
ALL_DEFAULT_INSTALLED_MODULES += $(PRODUCT_OUT)/vendor/firmware/tsx_data

$(call symlink-file,,./hw/enhance.ums9230.so,$(PRODUCT_OUT)/vendor/lib/enhance.ums9230.so)
$(call declare-0p-target,$(PRODUCT_OUT)/vendor/lib/enhance.ums9230.so)
ALL_DEFAULT_INSTALLED_MODULES += $(PRODUCT_OUT)/vendor/lib/enhance.ums9230.so

$(call symlink-file,,../egl/libGLES_mali.so,$(PRODUCT_OUT)/vendor/lib/hw/vulkan.ums9230.so)
$(call declare-0p-target,$(PRODUCT_OUT)/vendor/lib/hw/vulkan.ums9230.so)
ALL_DEFAULT_INSTALLED_MODULES += $(PRODUCT_OUT)/vendor/lib/hw/vulkan.ums9230.so

$(call symlink-file,,/vendor/lib/hw/libAlgo_Config.so,$(PRODUCT_OUT)/vendor/lib/libAlgo_Config.so)
$(call declare-0p-target,$(PRODUCT_OUT)/vendor/lib/libAlgo_Config.so)
ALL_DEFAULT_INSTALLED_MODULES += $(PRODUCT_OUT)/vendor/lib/libAlgo_Config.so

$(call symlink-file,,libOpenCL.so.1.2,$(PRODUCT_OUT)/vendor/lib/libOpenCL.so)
$(call declare-0p-target,$(PRODUCT_OUT)/vendor/lib/libOpenCL.so)
ALL_DEFAULT_INSTALLED_MODULES += $(PRODUCT_OUT)/vendor/lib/libOpenCL.so

$(call symlink-file,,libOpenCL.so.1.2,$(PRODUCT_OUT)/vendor/lib/libOpenCL.so.1)
$(call declare-0p-target,$(PRODUCT_OUT)/vendor/lib/libOpenCL.so.1)
ALL_DEFAULT_INSTALLED_MODULES += $(PRODUCT_OUT)/vendor/lib/libOpenCL.so.1

$(call symlink-file,,libOpenCL.so.1.2,$(PRODUCT_OUT)/vendor/lib/libOpenCL.so.1.1)
$(call declare-0p-target,$(PRODUCT_OUT)/vendor/lib/libOpenCL.so.1.1)
ALL_DEFAULT_INSTALLED_MODULES += $(PRODUCT_OUT)/vendor/lib/libOpenCL.so.1.1

$(call symlink-file,,libGLES_mali.so,$(PRODUCT_OUT)/vendor/lib/libOpenCL.so.1.2)
$(call declare-0p-target,$(PRODUCT_OUT)/vendor/lib/libOpenCL.so.1.2)
ALL_DEFAULT_INSTALLED_MODULES += $(PRODUCT_OUT)/vendor/lib/libOpenCL.so.1.2

$(call symlink-file,,/vendor_dlkm/lib/modules,$(PRODUCT_OUT)/vendor/lib/modules)
$(call declare-0p-target,$(PRODUCT_OUT)/vendor/lib/modules)
ALL_DEFAULT_INSTALLED_MODULES += $(PRODUCT_OUT)/vendor/lib/modules

$(call symlink-file,,/vendor/lib/libaudionpi.so,$(PRODUCT_OUT)/vendor/lib/npidevice/libaudionpi.so)
$(call declare-0p-target,$(PRODUCT_OUT)/vendor/lib/npidevice/libaudionpi.so)
ALL_DEFAULT_INSTALLED_MODULES += $(PRODUCT_OUT)/vendor/lib/npidevice/libaudionpi.so

$(call symlink-file,,/vendor/lib/libcamcalitest.so,$(PRODUCT_OUT)/vendor/lib/npidevice/libcamcalitest.so)
$(call declare-0p-target,$(PRODUCT_OUT)/vendor/lib/npidevice/libcamcalitest.so)
ALL_DEFAULT_INSTALLED_MODULES += $(PRODUCT_OUT)/vendor/lib/npidevice/libcamcalitest.so

$(call symlink-file,,/vendor/lib/libnpi_rtc.so,$(PRODUCT_OUT)/vendor/lib/npidevice/libnpi_rtc.so)
$(call declare-0p-target,$(PRODUCT_OUT)/vendor/lib/npidevice/libnpi_rtc.so)
ALL_DEFAULT_INSTALLED_MODULES += $(PRODUCT_OUT)/vendor/lib/npidevice/libnpi_rtc.so

$(call symlink-file,,/vendor/lib/libsensornpi.so,$(PRODUCT_OUT)/vendor/lib/npidevice/libsensornpi.so)
$(call declare-0p-target,$(PRODUCT_OUT)/vendor/lib/npidevice/libsensornpi.so)
ALL_DEFAULT_INSTALLED_MODULES += $(PRODUCT_OUT)/vendor/lib/npidevice/libsensornpi.so

$(call symlink-file,,/vendor/lib/hw/vendor.transsion.hardware.camera.imgalgoservice@1.0-impl.so,$(PRODUCT_OUT)/vendor/lib/vendor.transsion.hardware.camera.imgalgoservice@1.0-impl.so)
$(call declare-0p-target,$(PRODUCT_OUT)/vendor/lib/vendor.transsion.hardware.camera.imgalgoservice@1.0-impl.so)
ALL_DEFAULT_INSTALLED_MODULES += $(PRODUCT_OUT)/vendor/lib/vendor.transsion.hardware.camera.imgalgoservice@1.0-impl.so

$(call symlink-file,,./hw/enhance.ums9230.so,$(PRODUCT_OUT)/vendor/lib64/enhance.ums9230.so)
$(call declare-0p-target,$(PRODUCT_OUT)/vendor/lib64/enhance.ums9230.so)
ALL_DEFAULT_INSTALLED_MODULES += $(PRODUCT_OUT)/vendor/lib64/enhance.ums9230.so

$(call symlink-file,,../egl/libGLES_mali.so,$(PRODUCT_OUT)/vendor/lib64/hw/vulkan.ums9230.so)
$(call declare-0p-target,$(PRODUCT_OUT)/vendor/lib64/hw/vulkan.ums9230.so)
ALL_DEFAULT_INSTALLED_MODULES += $(PRODUCT_OUT)/vendor/lib64/hw/vulkan.ums9230.so

$(call symlink-file,,libOpenCL.so.1.2,$(PRODUCT_OUT)/vendor/lib64/libOpenCL.so)
$(call declare-0p-target,$(PRODUCT_OUT)/vendor/lib64/libOpenCL.so)
ALL_DEFAULT_INSTALLED_MODULES += $(PRODUCT_OUT)/vendor/lib64/libOpenCL.so

$(call symlink-file,,libOpenCL.so.1.2,$(PRODUCT_OUT)/vendor/lib64/libOpenCL.so.1)
$(call declare-0p-target,$(PRODUCT_OUT)/vendor/lib64/libOpenCL.so.1)
ALL_DEFAULT_INSTALLED_MODULES += $(PRODUCT_OUT)/vendor/lib64/libOpenCL.so.1

$(call symlink-file,,libOpenCL.so.1.2,$(PRODUCT_OUT)/vendor/lib64/libOpenCL.so.1.1)
$(call declare-0p-target,$(PRODUCT_OUT)/vendor/lib64/libOpenCL.so.1.1)
ALL_DEFAULT_INSTALLED_MODULES += $(PRODUCT_OUT)/vendor/lib64/libOpenCL.so.1.1

$(call symlink-file,,libGLES_mali.so,$(PRODUCT_OUT)/vendor/lib64/libOpenCL.so.1.2)
$(call declare-0p-target,$(PRODUCT_OUT)/vendor/lib64/libOpenCL.so.1.2)
ALL_DEFAULT_INSTALLED_MODULES += $(PRODUCT_OUT)/vendor/lib64/libOpenCL.so.1.2

endif
