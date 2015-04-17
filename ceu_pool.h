#ifndef _CEU_POOL_H
#define _CEU_POOL_H

#include "ceu_types.h"

/* TODO: all "int" here, should evaluate the correct unsigned type */

typedef struct {
    tceu_org_lnk** lnks;
                    /* lnks at 0-offset to share same struct with dynamic */
                    /* TODO: "lnks" field is unused for adt */
                    /* TODO: "lnks" field makes no sense for non-Ceu pools */
                    /* TODO: move it to an enclosing struct */
    byte**  queue;
                    /* queue is in the next offset to distinguish dynamic(NULL)
                       from static pools(any-address) */
    int     size;
    int     free;
    int     index;
    int     unit;
    byte*   mem;
} tceu_pool;

#define CEU_POOL_DCL(name, type, size) \
    type*     name##_queue[size];      \
    type      name##_mem[size];        \
    tceu_pool name;

void ceu_pool_init (tceu_pool* pool, int size, int unit, tceu_org_lnk** lnks,
                    byte** queue, byte* mem);
byte* ceu_pool_alloc (tceu_pool* pool);
void ceu_pool_free (tceu_pool* pool, byte* val);
#endif
