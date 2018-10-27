//
//  kern_compression.hpp
//  Lilu
//
//  Copyright © 2016-2017 vit9696. All rights reserved.
//

#ifndef kern_compression_hpp
#define kern_compression_hpp

#include <Headers/kern_config.hpp>

#ifdef COMPRESSION_SUPPORT

#include <Headers/kern_util.hpp>
#include <stdint.h>

/**
 *  CompressedHeader constants
 */
static constexpr uint32_t CompressedMagic {0x706D6F63}; //comp
static constexpr uint32_t CompressionLZVN {0x6E767A6C}; //lzvn
static constexpr uint32_t CompressionLZSS {0x73737A6C}; //lzss

/**
 *  CompressedHeader structure
 */
struct CompressedHeader {
	uint32_t magic;
	uint32_t compression;
	uint32_t hash; // adler32
	uint32_t decompressed;
	uint32_t compressed;
	uint32_t version;
	uint32_t padding[90];
};

/**
 *  Typed decompressing function
 *
 *  @param compression compression type
 *  @param dstlen      decompression buffer size
 *  @param src         compressed data
 *  @param srclen      compressed data size
 *
 *  @return decompressed buffer
 */
EXPORT uint8_t *decompressData(uint32_t compression, uint32_t dstlen, uint8_t *src, uint32_t srclen);

#endif /* COMPRESSION_SUPPORT */

#endif /* kern_compression_hpp */
