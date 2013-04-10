//#line 0 "=== FILENAME ==="
=== DEFS ===

#include <string.h>
#include <limits.h>

#ifdef CEU_DEBUG
#include <assert.h>
#include <signal.h>
#include <stdlib.h>
#endif

#ifdef CEU_NEWS
#include <stdlib.h>
#endif

#ifdef __cplusplus
#define CEU_WCLOCK_INACTIVE 0x7fffffffL     // TODO
#else
#define CEU_WCLOCK_INACTIVE INT32_MAX
#endif
#define CEU_WCLOCK_EXPIRED (CEU_WCLOCK_INACTIVE-1)

#define PTR_glb(tp,off) ((tp)(CEU.mem + off))
#ifdef CEU_ORGS
#define PTR_org(tp,org,off) ((tp)(((char*)(org)) + off))
#define PTR_cur(tp,off) ((tp)(((char*)_ceu_org_) + off))
#else
#define PTR_org(tp,org,off) ((tp)(CEU.mem + off))
#define PTR_cur(tp,off) ((tp)(CEU.mem + off))
#endif

#define CEU_NMEM       (=== CEU_NMEM ===)
#define CEU_NTRAILS    (=== CEU_NTRAILS ===)

#ifdef CEU_ORGS
//#define CEU_CLS_NEWS_PRV (=== CEU_CLS_NEWS_PRV ===)
//#define CEU_CLS_NEWS_NXT (=== CEU_CLS_NEWS_NXT ===)
#define CEU_CLS_FREE     (=== CEU_CLS_FREE ===)
#define CEU_CLS_TRAILN   (=== CEU_CLS_TRAILN ===)
#endif
#define CEU_CLS_TRAIL0   (=== CEU_CLS_TRAIL0 ===)

#ifdef CEU_IFCS
#define CEU_NCLS       (=== CEU_NCLS ===)
#define CEU_NIFCS      (=== CEU_NIFCS ===)
#endif

#define GLOBAL CEU.mem

// Macros that can be defined:
// ceu_out_pending() (sync?)
// ceu_out_wclock(dt)
// ceu_out_event(id, len, data)
// ceu_out_async(more?);
// ceu_out_end(v)

typedef === TCEU_NLBL === tceu_nlbl;    // (x) number of trails

#ifdef CEU_IFCS
typedef === TCEU_NCLS === tceu_ncls;    // (x) number of instances
typedef === TCEU_NOFF === tceu_noff;    // (x) number of clss x ifcs
#endif

// align all structs 1 byte
// TODO: verify defaults for microcontrollers
//#pragma pack(push)
//#pragma pack(1)

// TODO: remove this type?
typedef struct {
    tceu_nlbl lbl;
} tceu_trail;

typedef struct {
    union {
        void*   ptr;        // exts/ints
        int*    v;          // exts/ints
        s32     dt;         // wclocks
    };
#ifdef CEU_INTS
#ifdef CEU_ORGS
    void*   org;            // ints
#endif
#endif
} tceu_evt_param;

#define ceu_evt_param_ptr(a)    \
    tceu_evt_param p;           \
    p.ptr = a;

#define ceu_evt_param_v(a)      \
    tceu_evt_param p;           \
    p.v = a;

#define ceu_evt_param_dt(a)     \
    tceu_evt_param p;           \
    p.dt = a;

enum {
=== LABELS_ENUM ===
};

typedef struct {
#ifdef CEU_WCLOCKS
    int         wclk_late;
    s32         wclk_min;
    s32         wclk_min_tmp;
#endif

#ifdef CEU_IFCS
    tceu_noff   ifcs[CEU_NCLS][CEU_NIFCS];
#endif

#ifdef CEU_DEBUG
    tceu_nlbl   trail_lbl; // segfault printf
    void*       trail_org; // segfault printf
#endif

    char        mem[CEU_NMEM];
} tceu;

// TODO: fields that need no initialization?

tceu CEU = {
#ifdef CEU_WCLOCKS
    0, CEU_WCLOCK_INACTIVE, CEU_WCLOCK_INACTIVE,
#endif
#ifdef CEU_IFCS
    { === IFCS === },
#endif
#ifdef CEU_DEBUG
    0, NULL,
#endif
    {}                          // TODO: o q ele gera?
};

//#pragma pack(pop)

=== CLS_ACCS ===

=== HOST ===

/**********************************************************************/

void ceu_call_f (u8 evt_id, tceu_evt_param* evt_p,
                 tceu_nlbl lbl, void* org);
#ifdef CEU_ORGS
#define ceu_call(a,b,c,d) ceu_call_f(a,b,c,d)
#else
#define ceu_call(a,b,c,d) ceu_call_f(a,b,c,NULL)
#endif

/**********************************************************************/

tceu_trail* ceu_trails_get (int idx, void* org) {
    return PTR_org(tceu_trail*, org,
                    CEU_CLS_TRAIL0 + idx*sizeof(tceu_trail));
}
#ifndef CEU_ORGS
#define ceu_trails_get(a,b) ceu_trails_get(a,NULL)
#endif

#ifdef CEU_WCLOCKS

void ceu_wclocks_min (s32 dt, int out) {
    if (CEU.wclk_min > dt) {
        CEU.wclk_min = dt;
#ifdef ceu_out_wclock
        if (out)
            ceu_out_wclock(dt);
#endif
    }
}

int ceu_wclocks_not (s32* t, s32 dt) {
    if (*t>CEU.wclk_min_tmp || *t>dt) {
        *t -= dt;
        ceu_wclocks_min(*t, 0);
        return 1;
    }
    return 0;
}

void ceu_trails_set_wclock (s32* t, s32 dt) {
    s32 dt_ = dt - CEU.wclk_late;
    *t = dt_;
    ceu_wclocks_min(dt_, 1);
}

#endif  // CEU_WCLOCKS

void ceu_trails_set (int idx, tceu_nlbl lbl, void* org) {
    tceu_trail* trl = ceu_trails_get(idx, org);
    trl->lbl = lbl;
}
#ifndef CEU_ORGS
#define ceu_trails_set(a,b,c) ceu_trails_set(a,b,NULL)
#endif

void ceu_trails_clr (int t1, int t2, void* org) {
    int i;
    for (i=t2; i>=t1; i--) {    // lst fins first
#ifdef CEU_FINS
        ceu_call(IN__FIN, NULL,
            ceu_trails_get(i,org)->lbl, org);
#endif
        ceu_trails_get(i,org)->lbl = CEU_INACTIVE;
    }
}
#ifndef CEU_ORGS
#define ceu_trails_clr(a,b,c) ceu_trails_clr(a,b,NULL)
#endif

void ceu_trails_go (u8 evt_id, tceu_evt_param* evt_p, void* trl_org)
{
    int i;

#define trl_vec PTR_org(tceu_trail*,trl_org,CEU_CLS_TRAIL0)
#ifdef CEU_ORGS
    u8 trl_n = *PTR_org(u8*, trl_org, CEU_CLS_TRAILN);
#else
#define trl_n   CEU_NTRAILS
#endif

    if (evt_id == IN__ON) {
        for (i=0; i<trl_n; i++) {
            if (trl_vec[i].lbl < 0)
                trl_vec[i].lbl = -trl_vec[i].lbl;
        }
    }

// TODO: trl_vec is freed
    for (i=0; i<trl_n; i++) {
        if (trl_vec[i].lbl > CEU_INACTIVE) {    // avoid negatives
            ceu_call(evt_id, evt_p, trl_vec[i].lbl, trl_org);
        }
    }
}
#ifndef CEU_ORGS
#define ceu_trails_go(a,b,c) ceu_trails_go(a,b,NULL)
#endif

/**********************************************************************/

#ifdef CEU_NEWS

typedef struct tceu_news_one {
    struct tceu_news_one* prv;
    struct tceu_news_one* nxt;
} tceu_news_one;

typedef struct {
    tceu_news_one fst;
    tceu_news_one lst;
} tceu_news_blk;

#ifdef CEU_RUNTESTS
int __ceu_news = 0;
#endif

void* ceu_news_ins (tceu_news_blk* blk, int len)
{
    tceu_news_one* cur = malloc(len);
    if (cur == NULL)
        return NULL;

#ifdef CEU_RUNTESTS
    if (__ceu_news >= 100)
        return NULL;
    __ceu_news++;
#endif

    (blk->lst.prv)->nxt = cur;
    cur->prv            = blk->lst.prv;
    cur->nxt            = &blk->lst;
    blk->lst.prv        = cur;

    return (void*) cur;
}

void ceu_news_rem (void* org)
{
    tceu_news_one* cur = (tceu_news_one*) org;
    cur->prv->nxt = cur->nxt;
    cur->nxt->prv = cur->prv;

    // [0, N-1]
    ceu_trails_clr(0, *PTR_org(u8*,org,CEU_CLS_TRAILN)-1, org);
    free(org);
#ifdef CEU_RUNTESTS
        __ceu_news--;
#endif
}

void ceu_news_rem_all (tceu_news_one* cur) {
    while (cur->nxt != NULL) {
        void* org = (void*) cur;
        // block already clrs
        //ceu_trails_clr(0, *PTR_org(u8*,org,CEU_CLS_TRAILN)-1, org);
        cur = cur->nxt;
        free(org);
#ifdef CEU_RUNTESTS
        __ceu_news--;
#endif
    }
}

void ceu_news_go (u8 evt_id, tceu_evt_param* evt_p,
                  tceu_news_one* cur) {
    while (cur->nxt != NULL) {
        void* org = (void*) cur;
        cur = cur->nxt;
        ceu_trails_go(evt_id, evt_p, org);      // TODO: kill
    }
}

#endif

/**********************************************************************/

#ifdef CEU_PSES
void ceu_lsts_pse (int child, void* org, tceu_nlbl l1, tceu_nlbl l2, int inc) {
/*
    int i;
    for (i=0 ; i<CEU.lsts_n ; i++) {
        tceu_trail* lst = &CEU.lsts[i];
#ifdef CEU_FINS
        if (lst->evt == IN__FIN)
            continue;
#endif
#ifdef CEU_ORGS
        if ( lst->dst_org==org && lst->lbl>=l1 && lst->lbl<=l2
#ifndef CEU_ORGS_GLOBAL
        ||   child && lst->dst_org!=org &&
                ceu_clr_child(lst->dst_org,org,l1,l2)
#endif
        ) {
#else // CEU_ORGS
        if (lst->lbl>=l1 && lst->lbl<=l2) {
#endif // CEU_ORGS
            lst->pse += inc;
#ifdef CEU_WCLOCKS
            if (lst->pse==0 && lst->evt==IN__WCLOCK)
                ceu_wclocks_min(lst->togo, 1);
#endif
        }
    }
*/
}
#ifndef CEU_ORGS
#define ceu_lsts_pse(a,b,c,d,e) ceu_lsts_pse(a,NULL,c,d,e)
#endif
#endif

/**********************************************************************/

#ifdef CEU_DEBUG
void ceu_segfault (int sig_num) {
#ifdef CEU_ORGS
    fprintf(stderr, "SEGFAULT on %p : %d\n", CEU.trail_org, CEU.trail_lbl);
#else
    fprintf(stderr, "SEGFAULT on %d\n", CEU.trail_lbl);
#endif
    exit(0);
}
#endif

//void ceu_go (void* data);     // TODO: place here?

void ceu_go_init ()
{
#ifdef CEU_DEBUG
    signal(SIGSEGV, ceu_segfault);
#endif

    ceu_call(0,NULL, Class_Main, &CEU.mem);
}

// TODO: ret

#ifdef CEU_EXTS
void ceu_go_event (int id, void* data)
{
#ifdef CEU_DEBUG_TRAILS
    fprintf(stderr, "====== %d\n", id);
#endif
    ceu_evt_param_ptr(data);
    ceu_trails_go(IN__ON, NULL, CEU.mem);
    ceu_trails_go(id,     &p,   CEU.mem);
}
#endif

#ifdef CEU_ASYNCS
void ceu_go_async ()
{
#ifdef CEU_DEBUG_TRAILS
    fprintf(stderr, "====== ASYNC\n");
#endif
    ceu_trails_go(IN__ON,    NULL, CEU.mem);
    ceu_trails_go(IN__ASYNC, NULL, CEU.mem);
}
#endif

void ceu_go_wclock (s32 dt)
{
#ifdef CEU_WCLOCKS

#ifdef CEU_DEBUG_TRAILS
    fprintf(stderr, "====== WCLOCK\n");
#endif

    ceu_evt_param_dt(dt);

    if (CEU.wclk_min <= dt)
        CEU.wclk_late = dt - CEU.wclk_min;   // how much late the wclock is

    CEU.wclk_min_tmp = CEU.wclk_min;
    CEU.wclk_min     = CEU_WCLOCK_INACTIVE;

    ceu_trails_go(IN__ON,     NULL, CEU.mem);
    ceu_trails_go(IN__WCLOCK, &p,   CEU.mem);

#ifdef ceu_out_wclock
    if (CEU.wclk_min != CEU_WCLOCK_INACTIVE)
        ceu_out_wclock(CEU.wclk_min);   // only signal after all
#endif

    CEU.wclk_late = 0;

#endif   // CEU_WCLOCKS

    return;
}

// TODO
#if defined(CEU_EXTS) || defined(CEU_INTS)
// returns a pointer to the received value
int* ceu_ext_f (int* data, int v) {
    *data = v;
    return data;
}
#endif

#ifdef CEU_RUNTESTS
void ceu_stack_clr () {
    int a[1000];
    memset(a, 0, sizeof(a));
}
#endif

void ceu_go_all (int* ret_end)
{
    ceu_go_init();

#ifdef IN_START
    ceu_go_event(IN_START, NULL);
#endif

#ifdef CEU_ASYNCS
    for (;;) {
#ifdef CEU_RUNTESTS
        ceu_stack_clr();
#endif
        ceu_go_async();
        if (*ret_end)
            return;
    }
#endif
}

void ceu_call_f (u8 _ceu_evt_id_, tceu_evt_param* _ceu_evt_p_,
                 tceu_nlbl _ceu_lbl_, void* _ceu_org_)
{
#if defined(CEU_EXTS) || defined(CEU_INTS)
    int _ceu_int_;
#endif

_SWITCH_:
#ifdef CEU_DEBUG
{
    CEU.trail_lbl = _ceu_lbl_;
#ifdef CEU_ORGS
    CEU.trail_org = _ceu_org_;
#endif
}
#endif

    switch (_ceu_lbl_) {
        === CODE ===
    }
}
