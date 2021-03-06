#pragma once

#include <scheduler.h>

#define SMEM_FLAGS_PRIVATE 1

typedef struct {
    uintptr_t* pages; // Physical Pages
    unsigned pgCount; // Size in pages

    uint64_t flags; // Flags
    uint64_t key; // Key
    uint64_t mapCount; // Amount of references/mappings

    pid_t owner; // Owner Process
    pid_t recipient; // Recipient Process (if private)
} shared_mem_t;

namespace Memory{
    void InitializeSharedMemory();

    int CanModifySharedMemory(pid_t pid, uint64_t key);
    shared_mem_t* GetSharedMemory(uint64_t key);
    
    uint64_t CreateSharedMemory(uint64_t size, uint64_t flags, pid_t owner, pid_t recipient);
    void* MapSharedMemory(uint64_t key, process_t* proc, uint64_t hint);
    void DestroySharedMemory(uint64_t key);
}