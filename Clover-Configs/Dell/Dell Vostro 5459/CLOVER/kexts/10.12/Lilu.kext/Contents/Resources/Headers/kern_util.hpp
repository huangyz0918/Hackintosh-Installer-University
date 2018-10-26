//
//  kern_util.hpp
//  Lilu
//
//  Copyright © 2016-2017 vit9696. All rights reserved.
//

#ifndef kern_util_hpp
#define kern_util_hpp

#include <Headers/kern_config.hpp>

#include <libkern/libkern.h>
#include <mach/vm_prot.h>
#include <IOKit/IOLib.h>

#define xStringify(a) Stringify(a)
#define Stringify(a) #a

#define xConcat(a, b) Concat(a, b)
#define Concat(a, b) a ## b

#define ADDPR(a) xConcat(xConcat(PRODUCT_NAME, _), a)

extern bool ADDPR(debugEnabled);
// Kernel version major
extern const int version_major;

#define SYSLOG(str, ...) IOLog( xStringify(PRODUCT_NAME) ": " str "\n", ## __VA_ARGS__)

#ifdef DEBUG
#define DBGLOG(str, ...)																\
	do {																				\
		if (xConcat(PRODUCT_NAME, _debugEnabled))										\
			IOLog( xStringify(PRODUCT_NAME) ": (DEBUG) " str "\n", ## __VA_ARGS__);		\
	} while(0)
#else
#define DBGLOG(str, ...) do { } while(0)
#endif

#define EXPORT __attribute__((visibility("default")))

/**
 *  @brief  Two-way substring search
 *
 *  @param stack    String to search in
 *  @param needle   Substring to search for
 *  @param len      Length of substring
 *
 *  @return substring address if there or nullptr
 */
EXPORT const char *strstr(const char *stack, const char *needle, size_t len=0);

/**
 *  @brief  C-style memory management from libkern, missing from headers
 */
extern "C" {
	void *kern_os_malloc(size_t size);
	void *kern_os_calloc(size_t num, size_t size);
	void kern_os_free(void *addr);
	void *kern_os_realloc(void *addr, size_t nsize);
}

enum KernelVersion {
	SnowLeopard = 10,
	Lion = 11,
	MountainLion = 12,
	Mavericks = 13,
	Yosemite = 14,
	ElCapitan = 15,
	Sierra = 16
};

inline KernelVersion getKernelVersion() {
	return static_cast<KernelVersion>(version_major);
}

/**
 *  Typed buffer allocator
 */
namespace Buffer {
	template <typename T>
	T *create(size_t size) {
		return new T[size];
	}
	
	template <typename T>
	void deleter(T *buf) {
		delete[] buf;
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
 *
 *  @param T        held type
 *  @param deleter  type destructor
 */
template <typename T, void (*deleter)(T)=emptyDeleter<T>>
class evector {
	T *ptr {nullptr};
	size_t cnt {0};
public:
	/**
	 *  Return evector size
	 *
	 *  @return element count
	 */
	const size_t size() const {
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
	const size_t last() const {
		return cnt-1;
	}
	
	/**
	 *  Return evector element
	 *
	 *  @param index array index
	 *
	 *  @return the element at provided index
	 */
	T &operator [](size_t index) {
		return ptr[index];
	}
	
	/**
	 *  Erase evector element
	 *
	 *  @param index element index
	 *
	 *  @return true on success
	 */
	bool erase(size_t index) {
		// Free the memory
		deleter(ptr[index]);
		// Shift the items
		for (size_t i = index+1; i < cnt; i++) ptr[i-1] = ptr[i];
		// Reduce the memory used
		cnt--;
		if (cnt == 0) {
			kern_os_free(ptr);
			ptr = nullptr;
		} else {
			T *nPtr = static_cast<T *>(kern_os_realloc(ptr, (cnt)*sizeof(T *)));
			if (nPtr) {
				ptr = nPtr;
			} else {
				return false;
			}
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
		T *nPtr = static_cast<T *>(kern_os_realloc(ptr, (cnt+1)*sizeof(T *)));
		if (nPtr) {
			ptr = nPtr;
			ptr[cnt] = element;
			cnt++;
			return true;
		}
		
		SYSLOG("evector @ insertion failure");
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
		T *nPtr = static_cast<T *>(kern_os_realloc(ptr, (cnt+1)*sizeof(T *)));
		if (nPtr) {
			ptr = nPtr;
			ptr[cnt] = element;
			cnt++;
			return true;
		}
		
		SYSLOG("evector @ insertion failure");
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
			for (size_t i = 0; i < cnt; i++) {
				deleter(ptr[i]);
			}
			kern_os_free(ptr);
			ptr = nullptr;
			cnt = 0;
		}
	}
};

#endif /* kern_util_hpp */
