//
//  kern_util.hpp
//  Lilu
//
//  Copyright © 2016-2017 vit9696. All rights reserved.
//

#ifndef kern_util_hpp
#define kern_util_hpp

#include <Headers/kern_config.hpp>
#include <Headers/kern_compat.hpp>

#include <libkern/libkern.h>
#include <libkern/OSDebug.h>
#include <mach/vm_types.h>
#include <mach/vm_prot.h>
#include <sys/proc.h>
#include <IOKit/IOLib.h>

#define xStringify(a) Stringify(a)
#define Stringify(a) #a

#define xConcat(a, b) Concat(a, b)
#define Concat(a, b) a ## b

/**
 *  Prefix name with your plugin name (to ease symbolication and avoid conflicts)
 */
#define ADDPR(a) xConcat(xConcat(PRODUCT_NAME, _), a)

/**
 *  Debugging state exported for your plugin
 */
extern bool ADDPR(debugEnabled);

/**
 *  Debugging print delay used as an ugly hack around printf bufferisation,
 *  which results in messages not appearing in the boot log.
 *  Use liludelay=1000 (1 second) boot-arg to put a second after each message.
 */
extern uint32_t ADDPR(debugPrintDelay);

/**
 *  Kernel version major
 */
extern const int version_major;

/**
 *  Kernel version minor
 */
extern const int version_minor;

/**
 *  Kernel map
 */
extern vm_map_t kernel_map;

/**
 *  Kernel proc
 */
extern proc_t kernproc;

/**
 *  Conditional logging to system log prefixed with you plugin name
 *
 *  @param cond  precondition
 *  @param str   printf-like string
 */
#define SYSLOG_COND(cond, module, str, ...)                                                          \
	do {                                                                                             \
	    if (cond) {                                                                                  \
	        IOLog( "%s%10s" str "\n", xStringify(PRODUCT_NAME) ": ", module " @ ", ## __VA_ARGS__);  \
	        if (ADDPR(debugPrintDelay) > 0) IOSleep(ADDPR(debugPrintDelay));                         \
	    }                                                                                            \
	} while (0)

/**
 *  Write to system log prefixed with you plugin name
 *
 *  @param module log module
 *  @param str    printf-like string
 */
#define SYSLOG(module, str, ...) SYSLOG_COND(true, module, str, ## __VA_ARGS__)

/**
 *  Conditional tracing to system log prefixed with you plugin name
 *
 *  @param cond   precondition
 *  @param module log module
 *  @param str    printf-like string
 */
#define SYSTRACE_COND(cond, module, str, ...)                                                                        \
	do {                                                                                                             \
	    if (cond) {                                                                                                  \
	        SYSLOG(module, str, ## __VA_ARGS__);                                                                     \
		    OSReportWithBacktrace( "%s%10s" str "\n", xStringify(PRODUCT_NAME) ": ", module " @ ", ## __VA_ARGS__);  \
	    }                                                                                                            \
	} while (0)

/**
 *  Write call trace to system log prefixed with you plugin name
 *
 *  @param module log module
 *  @param str    printf-like string
 */
#define SYSTRACE(module, str, ...) SYSTRACE_COND(true, module, str, ## __VA_ARGS__)

/**
 *  Conditional panic prefixed with you plugin name
 *
 *  @param cond   precondition
 *  @param module log module
 *  @param str    printf-like string
 */
#define PANIC_COND(cond, module, str, ...)                                                             \
	do {                                                                                               \
	    if (cond)                                                                                      \
	        (panic)( "%s%10s" str "\n", xStringify(PRODUCT_NAME) ": ", module " @ ", ## __VA_ARGS__);  \
	} while (0)

/**
 *  Cause immediate kernel panic prefixed with you plugin name
 *
 *  @param module log module
 *  @param str    printf-like string
 */
#define PANIC(module, str, ...)  PANIC_COND(true, module, str, ## __VA_ARGS__)

#ifdef DEBUG

/**
 *  Conditional debug logging to system log prefixed with you plugin name
 *
 *  @param cond   precondition
 *  @param module log module
 *  @param str    printf-like string
 */
#define DBGLOG_COND(cond, module, str, ...)                                                     \
	do {                                                                                        \
	    SYSLOG_COND(ADDPR(debugEnabled) && (cond), module, "%s" str, "(DBG) ", ## __VA_ARGS__); \
	} while (0)

/**
 *  Write debug message to system log prefixed with you plugin name
 *
 *  @param module log module
 *  @param str    printf-like string
 */
#define DBGLOG(module, str, ...) DBGLOG_COND(true, module, str, ## __VA_ARGS__)

/**
 *  Conditional debug tracing to system log prefixed with you plugin name
 *
 *  @param cond   precondition
 *  @param module log module
 *  @param str    printf-like string
 */
#define DBGTRACE_COND(cond, module, str, ...)                                                     \
	do {                                                                                          \
	    SYSTRACE_COND(ADDPR(debugEnabled) && (cond), module, "%s" str, "(DBG) ", ## __VA_ARGS__); \
	} while (0)

/**
 *  Write debug call trace to system log prefixed with you plugin name
 *
 *  @param module log module
 *  @param str    printf-like string
 */
#define DBGTRACE(module, str, ...) DBGTRACE_COND(true, module, str, ## __VA_ARGS__)

#else /* DEBUG */

#define DBGLOG_COND(module, str, ...) do { } while (0)
#define DBGLOG(module, str, ...) do { } while (0)
#define DBGTRACE_COND(module, str, ...) do { } while (0)
#define DBGTRACE(module, str, ...) do { } while (0)

#endif

/**
 *  Deprecate the interface
 */
#define DEPRECATE(x) __attribute__((deprecated(x)))

/**
 *  Macros to bypass kernel address printing protection
 */
#define PRIKADDR "0x%08X%08X"
#define CASTKADDR(x) \
	static_cast<uint32_t>(reinterpret_cast<uint64_t>(x) >> 32), \
	static_cast<uint32_t>(reinterpret_cast<uint64_t>(x))

/**
 *  Macros to print the UUID
 */
#define PRIUUID "%02X%02X%02X%02X-%02X%02X-%02X%02X-%02X%02X-%02X%02X%02X%02X%02X%02X"
#define CASTUUID(uuid) \
	reinterpret_cast<const uint8_t *>(uuid)[0], \
	reinterpret_cast<const uint8_t *>(uuid)[1], \
	reinterpret_cast<const uint8_t *>(uuid)[2], \
	reinterpret_cast<const uint8_t *>(uuid)[3], \
	reinterpret_cast<const uint8_t *>(uuid)[4], \
	reinterpret_cast<const uint8_t *>(uuid)[5], \
	reinterpret_cast<const uint8_t *>(uuid)[6], \
	reinterpret_cast<const uint8_t *>(uuid)[7], \
	reinterpret_cast<const uint8_t *>(uuid)[8], \
	reinterpret_cast<const uint8_t *>(uuid)[9], \
	reinterpret_cast<const uint8_t *>(uuid)[10], \
	reinterpret_cast<const uint8_t *>(uuid)[11], \
	reinterpret_cast<const uint8_t *>(uuid)[12], \
	reinterpret_cast<const uint8_t *>(uuid)[13], \
	reinterpret_cast<const uint8_t *>(uuid)[14], \
	reinterpret_cast<const uint8_t *>(uuid)[15]

/**
 *  Export function or symbol for linking
 */
#define EXPORT __attribute__((visibility("default")))

/**
 *  Remove padding between fields
 */
#define PACKED __attribute__((packed))

/**
 *  Two-way substring search
 *
 *  @param stack    String to search in
 *  @param needle   Substring to search for
 *  @param len      Length of substring
 *
 *  @return substring address if there or nullptr
 */
EXPORT const char *strstr(const char *stack, const char *needle, size_t len=0);

/**
 *  Reverse character search
 *
 *  @param stack    String to search in
 *  @param ch       Character to search for
 *
 *  @return character address if there or null
 */
EXPORT char *strrchr(const char *stack, int ch);

/**
 *  XNU kernel implementation of a C-standard qsort function normally not exported by the kernel.
 *
 *  @param a    array to sort
 *  @param n    array length
 *  @param es   array element size
 *  @param cmp  array element comparator
 */
EXPORT void qsort(void *a, size_t n, size_t es, int (*cmp)(const void *, const void *));

/**
 *  Count array elements
 *
 *  @param array   Array to process
 *
 *  @return number of elements
 */
template <class T, size_t N>
constexpr size_t arrsize(const T (&array)[N]) {
	return N;
}

/**
 *  C-style memory management from libkern, missing from headers
 */
extern "C" {
	void *kern_os_malloc(size_t size);
	void *kern_os_calloc(size_t num, size_t size);
	void kern_os_free(void *addr);
	void *kern_os_realloc(void *addr, size_t nsize);
	// kern_os_free does not check its argument for nullptr
	EXPORT void lilu_os_free(void *addr);
}

/**
 *  Known kernel versions
 */
enum KernelVersion {
	SnowLeopard   = 10,
	Lion          = 11,
	MountainLion  = 12,
	Mavericks     = 13,
	Yosemite      = 14,
	ElCapitan     = 15,
	Sierra        = 16,
	HighSierra    = 17,
	Mojave        = 18,
};

/**
 *  Kernel minor version for symmetry
 */
using KernelMinorVersion = int;

/**
 *  Obtain major kernel version
 *
 *  @return numeric kernel version
 */
inline KernelVersion getKernelVersion() {
	return static_cast<KernelVersion>(version_major);
}

/**
 *  Obtain minor kernel version
 *
 *  @return numeric minor kernel version
 */
inline KernelMinorVersion getKernelMinorVersion() {
	return static_cast<KernelMinorVersion>(version_minor);
}

/**
 *  Check whether kernel boot argument is passed ignoring the value (e.g. -arg or arg).
 *
 *  @param name  argument name
 *
 *  @return true if argument was passed
 */
inline bool checkKernelArgument(const char *name) {
	int val[16];
	return PE_parse_boot_argn(name, val, sizeof(val));
}

/**
 *  Parse apple version at compile time
 *
 *  @param version string literal representing apple version (e.g. 1.1.1)
 *
 *  @return numeric kernel version
 */
constexpr size_t parseModuleVersion(const char *version) {
	return (version[0] - '0') * 100 + (version[2] - '0') * 10 + (version[4] - '0');
}

/**
 *  Access struct member by its offset
 *
 *  @param T     pointer to the field you need
 *  @param that  pointer to struct
 *  @param off   offset in bytes to the member
 *
 *  @return reference to the struct member
 */
template <typename T>
inline T &getMember(void *that, size_t off) {
	return *reinterpret_cast<T *>(static_cast<uint8_t *>(that) + off);
}

/**
 *  Align value by align (page size by default)
 *
 *  @param size  value
 *
 *  @return algined value
 */
template <typename T>
inline T alignValue(T size, T align = 4096) {
	return (size + align - 1) & (~(align - 1));
}

/**
 *  This is an ugly replacement to std::find_if, allowing you
 *  to check whether a container consists only of value values.
 *
 *  @param in     container
 *  @param size   container size
 *  @param value  value to look for
 *
 *  @return true if an element different from value was found
 */
template <typename T, typename Y>
inline bool findNotEquals(T &in, size_t size, Y value) {
	for (size_t i = 0; i < size; i++)
		if (in[i] != value)
			return true;
	return false;
}

/**
 *  Returns non-null string when they can be null
 *
 *  @param str  original string
 *
 *  @return non-null string
 */
inline const char *safeString(const char *str) {
	return str ? str : "(null)";
}

/**
 *  A shorter form of writing reinterpret_cast<decltype(&org)>(ptr)
 */
template <typename T>
inline T FunctionCast(T org, mach_vm_address_t ptr) {
	return reinterpret_cast<T>(ptr);
}

/**
 *  Typed buffer allocator
 */
namespace Buffer {
	template <typename T>
	inline T *create(size_t size) {
		return static_cast<T *>(kern_os_malloc(sizeof(T) * size));
	}
	
	template <typename T>
	inline bool resize(T *&buf, size_t size) {
		auto nbuf = static_cast<T *>(kern_os_realloc(buf, sizeof(T) * size));
		if (nbuf) {
			buf = nbuf;
			return true;
		}
		
		return false;
	}
	
	template <typename T>
	inline void deleter(T *buf) {
		lilu_os_free(buf);
	}
}

/**
 *  Dynamically allocated page
 */
struct Page {
	/**
	 *  Allocates a page
	 *
	 *  @return true on success
	 */
	EXPORT bool alloc();
	
	/**
	 *  Sets page protection
	 *
	 *  @param prot protection bitmask
	 *
	 *  @return true on success
	 */
	EXPORT bool protect(vm_prot_t prot);
	
	/**
	 *  Deletes the page
	 *
	 *  @param p page
	 */
	EXPORT static void deleter(Page *p);
	
	/**
	 *  Creates a page object
	 *
	 *  @return pointer to new page object or nullptr
	 */
	EXPORT static Page *create();
	
	/**
	 *  Page buffer
	 */
	uint8_t *p {nullptr};
};

/**
 *  Use this deleter when storing scalar types
 */
template <typename T>
static void emptyDeleter(T) {}

template <typename T, typename Y, void (*deleterT)(T)=emptyDeleter<T>, void (*deleterY)(Y)=emptyDeleter<Y>>
struct ppair {
	T first;
	Y second;
	
	static ppair *create() {
		return new ppair;
	}
	
	static void deleter(ppair *p) {
		deleterT(p->first);
		deleterY(p->second);
		delete p;
	}
};

/**
 *  Embedded vector-like container
 *  You muse call deinit before destruction
 *  Ugh, someone, please, port libc++ to XNU...
 *
 *  @param T        held type
 *  @param deleter  type destructor
 */
template <typename T, void (*deleter)(T)=emptyDeleter<T>>
class evector {
	T *ptr {nullptr};
	size_t cnt {0};
	size_t rsvd {0};
public:
	/**
	 *  Return evector size
	 *
	 *  @return element count
	 */
	size_t size() const {
		return cnt;
	}
	
	/**
	 *  Return pointer to the elements
	 *  Valid until evector contents change
	 *
	 *  @return elements ptr
	 */
	T *data() const {
		return ptr;
	}
	
	/**
	 *  Return last element id
	 *
	 *  @return element id
	 */
	size_t last() const {
		return cnt-1;
	}
	
	/**
	 *  Return evector element reference
	 *
	 *  @param index array index
	 *
	 *  @return the element at provided index
	 */
	T &operator [](size_t index) {
		return ptr[index];
	}
	
	/**
	 *  Return evector const element reference
	 *
	 *  @param index array index
	 *
	 *  @return the element at provided index
	 */
	const T &operator [](size_t index) const {
		return ptr[index];
	}
	
	/**
	 *  Reserve memory for at least N elements
	 *
	 *  @param num  amount of elements
	 *
	 *  @return elements ptr or null
	 */
	T *reserve(size_t num) {
		if (rsvd < num) {
			T *nPtr = static_cast<T *>(kern_os_realloc(ptr, num * sizeof(T)));
			if (nPtr) {
				ptr = nPtr;
				rsvd = num;
			} else {
				return nullptr;
			}
		}
		
		return ptr;
	}
	
	/**
	 *  Erase evector element
	 *
	 *  @param index element index
	 *
	 *  @return true on success
	 */
	bool erase(size_t index, bool free=true) {
		deleter(ptr[index]);
		if (--cnt != index)
			lilu_os_memmove(&ptr[index], &ptr[index + 1], (cnt - index) * sizeof(T));

		if (free && cnt == 0) {
			kern_os_free(ptr);
			ptr = nullptr;
			rsvd = 0;
		}

		return true;
	}
	
	/**
	 *  Add an element to evector end
	 *
	 *  @param &element an element to add
	 *
	 *  @return true on success
	 */
	bool push_back(T &element) {
		if (reserve(cnt+1)) {
			ptr[cnt] = element;
			cnt++;
			return true;
		}
		
		SYSLOG("evector", "insertion failure");
		return false;
	}
	
	/**
	 *  Add an element to evector end
	 *
	 *  @param &element an element to add
	 *
	 *  @return true on success
	 */
	bool push_back(T &&element) {
		if (reserve(cnt+1)) {
			ptr[cnt] = element;
			cnt++;
			return true;
		}
		
		SYSLOG("evector", "insertion failure");
		return false;
	}
	
	evector() = default;
	evector(const evector &) = delete;
	evector operator =(const evector &) = delete;
	
	/**
	 * Free the used memory
	 */
	void deinit() {
		if (ptr) {
			for (size_t i = 0; i < cnt; i++)
				deleter(ptr[i]);
			kern_os_free(ptr);
			ptr = nullptr;
			cnt = rsvd = 0;
		}
	}
};

/**
 *  Slightly non-standard helpers to get the date in a YYYY-MM-DD format.
 */
template <size_t i>
inline constexpr char getBuildYear() {
	static_assert(i < 4, "Year consists of four digits");
	return __DATE__[7+i];
}

template <size_t i>
inline constexpr char getBuildMonth() {
	static_assert(i < 2, "Month consists of two digits");
	auto mon = *reinterpret_cast<const uint32_t *>(__DATE__);
	switch (mon) {
		case ' naJ':
			return "01"[i];
		case ' beF':
			return "02"[i];
		case ' raM':
			return "03"[i];
		case ' rpA':
			return "04"[i];
		case ' yaM':
			return "05"[i];
		case ' nuJ':
			return "06"[i];
		case ' luJ':
			return "07"[i];
		case ' guA':
			return "08"[i];
		case ' peS':
			return "09"[i];
		case ' tcO':
			return "10"[i];
		case ' voN':
			return "11"[i];
		case ' ceD':
			return "12"[i];
	}

	return '0';
}

template <size_t i>
inline constexpr char getBuildDay() {
	static_assert(i < 2, "Day consists of two digits");
	if (i == 0 && __DATE__[4+i] == ' ')
		return '0';
	return __DATE__[4+i];
}

#endif /* kern_util_hpp */
