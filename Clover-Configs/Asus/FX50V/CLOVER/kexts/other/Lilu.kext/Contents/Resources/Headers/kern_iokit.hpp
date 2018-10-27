//
//  kern_iokit.hpp
//  Lilu
//
//  Copyright © 2016-2017 vit9696. All rights reserved.
//

#ifndef kern_iokit_hpp
#define kern_iokit_hpp

#include <Headers/kern_config.hpp>
#include <Headers/kern_util.hpp>
#include <Headers/kern_patcher.hpp>

#include <libkern/c++/OSSerialize.h>
#include <IOKit/IORegistryEntry.h>

namespace WIOKit {

	/**
	 *  AppleHDAEngine::getLocation teaches us to use while(1) when talking to IOReg
	 *  This feels mad and insane, since it may prevent the system from booting.
	 *  Although this had never happened, we will use a far bigger fail-safe stop value.
	 */
	static constexpr size_t bruteMax {0x10000000};

	/**
	 *  Read OSData
	 *
	 *  @param sect   IORegistryEntry section
	 *  @param value  read value
	 *  @param name   propert name
	 *
	 *  @return true on success
	 */
	template <typename T>
	bool getOSDataValue(IORegistryEntry *sect, const char *name, T &value) {
		auto obj = sect->getProperty(name);
		if (obj) {
			auto data = OSDynamicCast(OSData, obj);
			if (data && data->getLength() == sizeof(T)) {
				value = *static_cast<const T *>(data->getBytesNoCopy());
				DBGLOG("util @ getOSData %s has %llX value", name, static_cast<uint64_t>(value));
				return true;
			} else {
				SYSLOG("util @ getOSData %s has unexpected format", name);
			}
		} else {
			DBGLOG("util @ getOSData %s was not found", name);
		}
		return false;;
	}

	/**
	 *  Retrieve property object
	 *
	 *  @param entry    IORegistry entry
	 *  @param property property name
	 *
	 *  @return property object (must be released) or nullptr
	 */
	EXPORT OSSerialize *getProperty(IORegistryEntry *entry, const char *property);
	
	/**
	 *  Model variants
	 */
	struct ComputerModel {
		enum {
			ComputerLaptop = 0x1,
			ComputerDesktop = 0x2,
			ComputerAny = ComputerLaptop | ComputerDesktop
		};
	};
	
	/**
	 *  Retrieve the computer model (hw.model syscall analogue that actually works)
	 *
	 *  @return valid computer model or ComputerAny
	 */
	EXPORT int getComputerModel();
	
	/**
	 *  Retrieve an ioreg entry by path/prefix
	 *
	 *  @param path    an exact lookup path
	 *  @param prefix  entry prefix at path
	 *  @param plane   plane to lookup in
	 *  @param proc    process every found entry with the method
	 *  @param brute   kick ioreg until a value is found
	 *  @param user    pass some value to the callback function
	 *
	 *  @return entry pointer (must NOT be released) or nullptr (on failure or in proc mode)
	 */
	EXPORT IORegistryEntry *findEntryByPrefix(const char *path, const char *prefix, const IORegistryPlane *plane, bool (*proc)(void *, IORegistryEntry *)=nullptr, bool brute=false, void *user=nullptr);
	
	/**
	 *  Retrieve an ioreg entry by path/prefix
	 *
	 *  @param entry   an ioreg entry to look in
	 *  @param prefix  entry prefix at path
	 *  @param plane   plane to lookup in
	 *  @param proc    process every found entry with the method
	 *  @param brute   kick ioreg until a value is found
	 *  @param user    pass some value to the callback function
	 *
	 *  @return entry pointer (must NOT be released) or nullptr (on failure or in proc mode)
	 */
	EXPORT IORegistryEntry *findEntryByPrefix(IORegistryEntry *entry, const char *prefix, const IORegistryPlane *plane, bool (*proc)(void *, IORegistryEntry *)=nullptr, bool brute=false, void *user=nullptr);
}

#endif /* kern_iokit_hpp */
