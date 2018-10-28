//
//  kern_devinfo.hpp
//  Lilu
//
//  Copyright © 2018 vit9696. All rights reserved.
//

#ifndef kern_devinfo_h
#define kern_devinfo_h

#include <Headers/kern_config.hpp>
#include <Headers/kern_util.hpp>
#include <Library/LegacyIOService.h>

/**
 *  Obtain installed devices split into categories.
 *  Should be used from onPatcherLoad and onwards.
 */
class DeviceInfo {
	/**
	 *  Updates reportedLayoutId
	 */
	void updateLayoutId();

	/**
	 *  Updates reportedFramebufferId
	 */
	void updateFramebufferId();

	/**
	 *  Updates firmwareVendor
	 */
	void updateFirmwareVendor();

public:
	/**
	 *  Obtains autodetected legacy framebuffer if applicable
	 *
	 *  @return framebuffer or 0xFFFFFFFF
	 */
	static uint32_t getLegacyFramebufferId();

	/**
	 *  Checks whether the framebuffer has connectors or not.
	 *
	 *  @return true if the framebuffer has no connectors
	 */
	static bool isConnectorLessPlatformId(uint32_t id);

	/**
	 *  Common external GPU parameter list
	 */
	struct ExternalVideo {
		/**
		 *  Aka GFX0 device
		 */
		IORegistryEntry *video {nullptr};

		/**
		 *  Aka HDAU device
		 */
		IORegistryEntry *audio {nullptr};

		/**
		 *  External GPU vendor
		 */
		uint32_t vendor {0};
	};

	/**
	 *  Aka HDEF device
	 */
	IORegistryEntry *audioBuiltinAnalog {nullptr};

	/**
	 *  Aka HDAU device for builtin GPU
	 */
	IORegistryEntry *audioBuiltinDigital {nullptr};

	/**
	 *  Aka IGPU device
	 */
	IORegistryEntry *videoBuiltin {nullptr};

	/**
	 *  Aka IMEI device
	 */
	IORegistryEntry *managementEngine {nullptr};

	/**
	 *  Aka GFX0 devices (kept in sync with audioExternal)
	 */
	evector<ExternalVideo> videoExternal;

private:
	/**
	 *  This is the default reported layout-id passed to reportedLayoutId.
	 *  The reason for choosing 7 is its presence in 10.14 and the fact
	 *  Apple frameworks still communicate to the files present on disk.
	 *  For information purposes only! Use reportedLayoutId!
	 */
	static constexpr uint32_t DefaultReportedLayoutId = 7;

	/**
	 *  The boot-arg to override the reported layout-id to AppleHDA.
	 *  For user configuration only! Use reportedLayoutId!
	 */
	static constexpr const char *ReportedLayoutIdArg = "alcapplid";

	/**
	 *  The property to override the reported layout-id to AppleHDA.
	 *  For user configuration only! Use reportedLayoutId!
	 */
	static constexpr const char *ReportedLayoutIdName = "apple-layout-id";

public:
	/**
	 *  Layout id to be reported by all audio devices (you must update it yourself).
	 *  This follows the standard convention initially found in AppleALC:
	 *	alcapplid=X boot-arg has highest priority and overrides any other value.
	 *  apple-layout-id HDEF prop has normal priority, you may use it if you need.
	 *  DefaultReportedLayoutId will be used if both of the above are not set.
	 */
	uint32_t reportedLayoutId {0};

private:
	/**
	 *  The boot-arg to override the reported AAPL,ig-platform-id to Intel drivers.
	 *  For user configuration only! Use reportedFramebufferId!
	 */
	static constexpr const char *ReportedFrameIdArg = "igfxframe";

	/**
	 *  The property to set your platform id for Intel drivers (Ivy and newer).
	 *  For user configuration only! Use reportedFramebufferName!
	 */
	static constexpr const char *ReportedFrameIdName = "AAPL,ig-platform-id";

	/**
	 *  The property to set your platform id for Intel drivers (Sandy).
	 *  For user configuration only! Use reportedFramebufferName!
	 */
	static constexpr const char *ReportedFrameIdLegacyName = "AAPL,snb-platform-id";

	/**
	 *  Known platform ids used by Intel GPU kexts
	 *  For user configuration only!
	 */
	static constexpr uint32_t DefaultSkylakePlatformId {0x19120000};
	static constexpr uint32_t DefaultKabyLakePlatformId {0x59160000};

	/**
	 *  Framebuffers without any ports used for hardware acceleration only
	 *  Note: Broadwell framebuffers all have connectors added.
	 *  For user configuration only!
	 */
	static constexpr uint32_t ConnectorLessSandyBridgePlatformId1 {0x00030030};
	static constexpr uint32_t ConnectorLessSandyBridgePlatformId2 {0x00050000};
	static constexpr uint32_t ConnectorLessIvyBridgePlatformId1 {0x01620006};
	static constexpr uint32_t ConnectorLessIvyBridgePlatformId2 {0x01620007};
	static constexpr uint32_t ConnectorLessHaswellPlatformId1 {0x04120004};
	static constexpr uint32_t ConnectorLessHaswellPlatformId2 {0x0412000B};
	static constexpr uint32_t ConnectorLessSkylakePlatformId1 {0x19020001};
	static constexpr uint32_t ConnectorLessSkylakePlatformId2 {0x19170001};
	static constexpr uint32_t ConnectorLessSkylakePlatformId3 {0x19120001};
	static constexpr uint32_t ConnectorLessSkylakePlatformId4 {0x19320001};
	static constexpr uint32_t ConnectorLessKabyLakePlatformId1 {0x59180002};
	static constexpr uint32_t ConnectorLessKabyLakePlatformId2 {0x59120003};

public:
	/**
	 *  Invalid framebuffer identifier
	 */
	static constexpr uint32_t DefaultInvalidPlatformId {0xFFFFFFFF};

	/**
	 *  Framebuffer id to be reported to IGPU.
	 *  This follows the standard convention initially found in IntelGraphicsFixup:
	 *  igfxframe=X boot-arg has highest priority and overrides any other value.
	 *  Manually specified AAPL,ig-platform-id or AAPL,snb-platform-id go next.
	 *  On Sandy Bridge processors a default AAPL,snb-platform-id will be tried afterwards.
	 *  On Skylake and Kaby Lake processors some default id will be tried afterwards.
	 */
	uint32_t reportedFramebufferId {0};

	/**
	 *  Compatible platform id property name for this IGPU
	 */
	const char *reportedFramebufferName {nullptr};

	/**
	 *  Set to true if the framebuffer has no connectors
	 */
	bool reportedFramebufferIsConnectorLess {false};

	/**
	 *  Known variants of firmware vendors
	 *  Please note, that it may not be possible to always detect the right vendor
	 */
	enum class FirmwareVendor {
		Unknown,
		Apple,
		VMware,
		EDKII,
		Parallels,
		AMI,
		Insyde,
		Phoenix,
		HP
	};

	/**
	 *  Firmware vendor manufacturer
	 */
	FirmwareVendor firmwareVendor {FirmwareVendor::Unknown};

	/**
	 *  Allocate and initialise the device list.
	 *
	 *  @return device list or nullptr
	 */
	EXPORT static DeviceInfo *create();

	/**
	 *  Release initialised device list.
	 *
	 *  @param d  device list
	 */
	EXPORT static void deleter(DeviceInfo *d);
};

#endif /* kern_devinfo_h */
