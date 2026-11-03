#ifndef HashProjectRangeIncluded
#define HashProjectRangeIncluded
// Shared object tables: project-owned child keys. Public library fields must
// stay outside this interval. Independent maps may reuse the same values.
// Parent keys remain native object IDs (ability tables keep their own contract).
// A project must remove only its fields, never flush a shared object parent.
// Exclusively owned timers may use local slots; library timers keep library slots.
#define HASH_PROJECT_KEY_MIN 1000000
#define HASH_PROJECT_KEY_MAX 1999999
#endif
