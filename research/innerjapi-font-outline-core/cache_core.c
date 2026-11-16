// Native PIC implementation of KK's separate shadow-cache design, pinned Game ABI.
// No Lua callbacks, global data, timers, imported CRT or engine-owned array mutation.
typedef unsigned int U;
typedef unsigned char B;
typedef unsigned short H;
#define FAST __attribute__((fastcall))
#define SYS __attribute__((stdcall))
#define MARK 0x80000000U
#define SLOTS 64
#define BUCKETS 128
typedef void (FAST *Fn)(void*,void*);
typedef void (FAST *Request)(void*,void*,U);
typedef void* (SYS *Alloc)(void*,U,U);
typedef void* (SYS *Realloc)(void*,U,void*,U);
typedef int (SYS *Free)(void*,U,void*);
typedef float (FAST *Convert)(U,U,float);
typedef void (FAST *Vertices)(U,void*,U,void*,U,void*,U,void*,U,void*,U,void*,U);
typedef void (FAST *Indices)(U,U,void*);
typedef void (*Submit)(void);
// Merge only within the engine's existing atlas/group batch, never across TEXTs.
// Bound the combined stream to 4096 vertices; large batches retain the old path.
#define PACK_VERTICES 4096U
struct Batch {B*batch;U count;float*points;U packedCopies;U*uv;H*indices;U indexCount;};
struct Cache {U groups,batches,vertices;U offsets[129];struct Batch entries[];};
struct Slot {B*frame;B*object;struct Cache*cache;U capacity,copies,next,updating,ready,epoch;float directions[32];};
struct Context {
 B*game;Fn rebuild,frameRebuild,shadowRebuild,destroy,rawDestroy;Request requestDestroy;
 void*heap;Alloc alloc;Realloc realloc;Free free;
 U draws,extraDraws,builds,rebuilds,frameRebuilds,shadowUpdates,destroys,rawDestroys;
 U allocations,reallocations,releases,liveBlocks,liveBytes,peakBytes,errors,lookups,probes;
 U destroyRequests,nativeDestructors,lastRequestedFrame,lastDestroyedFrame;
 U submissions;
 U heads[BUCKETS];struct Slot slots[SLOTS];
};
static U get(B*p){return *(U*)p;}
static void put(B*p,U n){*(U*)p=n;}
static B* object(B*f){B*h=(B*)get(f+0x204);return h?(B*)get(h+8):0;}
// Same byte-wise FNV-1a hash seen in KKAPI; bucket chains only contain live raw strings.
static U hash(B*p){U v=(U)p,h=2166136261U;for(U i=0;i<4;i++){h=(h^(v&255))*16777619U;v>>=8;}return h&(BUCKETS-1);}
static struct Slot* find(struct Context*c,B*o){
 if(!o)return 0;c->lookups++;
 for(U n=c->heads[hash(o)];n;n=c->slots[n-1].next){c->probes++;if(c->slots[n-1].object==o)return c->slots+n-1;}
 return 0;
}
static struct Slot* frameSlot(struct Context*c,B*f){for(U i=0;i<SLOTS;i++)if(c->slots[i].frame==f)return c->slots+i;return 0;}
static void release(struct Context*c,struct Slot*s){
 if(s->cache){c->free(c->heap,0,s->cache);c->releases++;c->liveBlocks--;c->liveBytes-=s->capacity;}
 s->cache=0;s->capacity=0;s->ready=0;
}
// Unbind geometry without freeing the live TEXT's capacity. No old pointers may
// be rendered while the original engine rebuild replaces its raw string.
static void unbind(struct Context*c,struct Slot*s){
 if(s->object){
  U*link=c->heads+hash(s->object);while(*link&&c->slots+*link-1!=s)link=&c->slots[*link-1].next;
  if(*link)*link=s->next;
  put(s->object+0x70,get(s->object+0x70)&~MARK);
 }
 s->object=0;s->next=0;s->ready=0;
}
static void detach(struct Context*c,struct Slot*s){unbind(c,s);release(c,s);}
static void retire(struct Context*c,struct Slot*s){detach(c,s);s->frame=0;s->epoch++;}
static void attach(struct Context*c,struct Slot*s,B*o){
 if(s->object==o)return;
 unbind(c,s);s->object=o;
 if(o){U h=hash(o);s->next=c->heads[h];c->heads[h]=(U)(s-c->slots)+1;}
}
static int reserve(struct Context*c,struct Slot*s,U bytes){
 if(bytes<=s->capacity)return 1;
 U cap=(bytes+4095)&~4095U;
 void*p=s->cache?c->realloc(c->heap,0,s->cache,cap):c->alloc(c->heap,0,cap);
 if(!p)return 0;
 if(s->cache)c->reallocations++;else{c->allocations++;c->liveBlocks++;}
 c->liveBytes+=cap-s->capacity;if(c->liveBytes>c->peakBytes)c->peakBytes=c->liveBytes;
 s->cache=p;s->capacity=cap;return 1;
}
static U packed(U n,U copies){U p=n?PACK_VERTICES/n:1;if(p<1)p=1;return p<copies?p:copies;}
static int build(struct Context*c,struct Slot*s){
 B*o=s->object;if(!o)return 1;
 s->ready=0;U groups=get(o+0x50),batches=0,total=0,streams=0;
 if(groups>128)return 0;
 for(U g=0;g<groups;g++){
  B*q=((B**)get(o+0x54))[g];U n=get(q+12);if(n>128||batches+n>1024)return 0;batches+=n;
  for(U j=0;j<n;j++){
   B*b=((B**)get(q+16))[j];U count=get(b+12);
   if(count%4||count>=65536||get(b+28)!=count||get(b+60)!=count)return 0;
   if(!(get(o+0x70)&8)&&get(b+44)!=count)return 0;
   U ni=get(b+76);if(ni!=count/4*6)return 0;
   H*ix=(H*)get(b+80);for(U i=0;i<ni;i++)if(ix[i]>=count)return 0;
   U p=packed(count,s->copies);if(p>1)streams+=count*p*8+ni*p*2;
   total+=count;if(total>131072)return 0;
  }
 }
 U bytes=sizeof(struct Cache)+batches*sizeof(struct Batch)+total*s->copies*12+streams;
 if(!reserve(c,s,bytes))return 0;
 struct Cache*k=s->cache;k->groups=groups;k->batches=batches;k->vertices=total;
 float*dst=(float*)(k->entries+batches);
 float x=((Convert)(c->game+0xD0380))(0,0,*(float*)(o+0x34));
 float y=((Convert)(c->game+0xD0310))(0,0,*(float*)(o+0x38));
 float z=(get(o+0x70)&128)?-1.0f:0.0f;
 U index=0;
 for(U g=0;g<groups;g++){
  k->offsets[g]=index;B*q=((B**)get(o+0x54))[g];
  for(U j=0;j<get(q+12);j++){
   B*b=((B**)get(q+16))[j];U n=get(b+12);float*m=(float*)get(b+16);
   struct Batch*entry=k->entries+index++;entry->batch=b;entry->count=n;entry->points=dst;
   entry->packedCopies=packed(n,s->copies);entry->indexCount=get(b+76);
   for(U a=0;a<s->copies;a++){
    float cs=s->directions[a*2],sn=s->directions[a*2+1];
    float dx=x*cs-y*sn,dy=x*sn+y*cs;
    for(U v=0;v<n;v++){*dst++=m[v*3]+dx;*dst++=m[v*3+1]+dy;*dst++=m[v*3+2]+z;}
   }
   entry->uv=(U*)get(b+64);entry->indices=(H*)get(b+80);
   if(entry->packedCopies>1){
    U*src=(U*)get(b+64);H*ix=(H*)get(b+80);U ni=entry->indexCount;
    entry->uv=(U*)dst;entry->indices=(H*)(entry->uv+n*entry->packedCopies*2);
    for(U a=0;a<entry->packedCopies;a++){
     for(U v=0;v<n*2;v++)entry->uv[a*n*2+v]=src[v];
     for(U v=0;v<ni;v++)entry->indices[a*ni+v]=(H)(ix[v]+a*n);
    }
    dst=(float*)(entry->indices+ni*entry->packedCopies);
   }
  }
 }
 k->offsets[groups]=index;s->ready=1;put(o+0x70,get(o+0x70)|MARK);c->builds++;return 1;
}
static void refresh(struct Context*c,struct Slot*s){if(!build(c,s)){c->errors++;release(c,s);if(s->object)put(s->object+0x70,get(s->object+0x70)&~MARK);}}
void FAST outline_rebuilt(B*o,struct Context*c){
 struct Slot*s=find(c,o);U epoch=s?s->epoch:0;if(s)s->updating++;
 c->rebuild(o,0);
 if(s&&s->frame&&s->epoch==epoch){s->updating--;if(s->object==o){c->rebuilds++;refresh(c,s);}}
}
void FAST outline_shadow_rebuilt(B*o,struct Context*c){
 c->shadowRebuild(o,0);struct Slot*s=find(c,o);
 if(s&&!s->updating){c->shadowUpdates++;refresh(c,s);}
}
void FAST outline_frame_rebuilt(B*f,struct Context*c){
 struct Slot*s=frameSlot(c,f);U epoch=s?s->epoch:0;if(s)unbind(c,s);
 c->frameRebuild(f,0);
 // A native callback may request destruction/re-register during reconstruction.
 // Never resurrect its slot or dereference the old frame after that transition.
 if(s&&s->frame==f&&s->epoch==epoch){c->frameRebuilds++;attach(c,s,object(f));refresh(c,s);}
}
void FAST outline_request_destroy(B*f,struct Context*c,U flags){
 struct Slot*s=frameSlot(c,f);
 if(s){retire(c,s);c->destroyRequests++;c->destroys++;c->lastRequestedFrame=(U)f;}
 c->requestDestroy(f,0,flags);
}
void FAST outline_destroy(B*f,struct Context*c){
 struct Slot*s=frameSlot(c,f);if(s){retire(c,s);c->destroys++;}
 c->nativeDestructors++;c->lastDestroyedFrame=(U)f;
 c->destroy(f,0);
}
void FAST outline_raw_destroy(B*o,struct Context*c){
 struct Slot*s=find(c,o);if(s){detach(c,s);c->rawDestroys++;}
 c->rawDestroy(o,0);
}
// Called immediately AFTER original shadow submission at DC510, BEFORE foreground.
// UV/color/index buffers belong to the engine and are never copied or replaced.
void outline_draw_extra(struct Context*c,B*o,U group,U batch,B*b,U*color){
 struct Slot*s=find(c,o);if(!s||!s->ready)return;
 struct Cache*k=s->cache;c->draws++;
 if(group>=k->groups||batch>=k->offsets[group+1]-k->offsets[group]){c->errors++;return;}
 struct Batch*e=k->entries+k->offsets[group]+batch;U n=get(b+12);
 if(e->batch!=b||e->count!=n){c->errors++;return;}
 for(U a=0;a<s->copies;){
  U take=s->copies-a;if(take>e->packedCopies)take=e->packedCopies;
  ((Vertices)(c->game+0xE35B0))(n*take,e->points+a*n*3,12,c->game+0xBC53A8,0,color,0,0,0,e->uv,8,0,0);
  ((Indices)(c->game+0xE3520))(3,e->indexCount*take,e->indices);
  ((Submit)(c->game+0xE3670))();c->submissions++;c->extraDraws+=take;a+=take;
 }
}
int outline_set(struct Context*c,B*f,U copies,float*directions){
 if(copies<1||copies>16)return 0;
 struct Slot*s=frameSlot(c,f);
 if(!s)for(U i=0;i<SLOTS;i++)if(!c->slots[i].frame){s=c->slots+i;break;}
 if(!s)return 0;
 unbind(c,s);s->frame=f;s->copies=copies;s->updating=0;s->epoch++;
 for(U i=0;i<copies*2;i++)s->directions[i]=directions[i];
 outline_frame_rebuilt(f,c);return 1;
}
void outline_remove(struct Context*c,B*f){struct Slot*s=frameSlot(c,f);if(s)retire(c,s);}
int outline_validate(struct Context*c,B*f){
 struct Slot*s=frameSlot(c,f);if(!s||!s->ready||s->object!=object(f)||!s->cache)return 0;
 B*o=s->object;struct Cache*k=s->cache;if(!(get(o+0x70)&MARK)||k->groups!=get(o+0x50))return 0;
 float x=((Convert)(c->game+0xD0380))(0,0,*(float*)(o+0x34));
 float y=((Convert)(c->game+0xD0310))(0,0,*(float*)(o+0x38));
 float z=(get(o+0x70)&128)?-1.0f:0.0f;
 for(U g=0;g<k->groups;g++){
  B*q=((B**)get(o+0x54))[g];if(k->offsets[g+1]-k->offsets[g]!=get(q+12))return 0;
  for(U j=0;j<get(q+12);j++){
   B*b=((B**)get(q+16))[j];struct Batch*e=k->entries+k->offsets[g]+j;U n=get(b+12);
   if(e->batch!=b||n!=e->count||get(b+28)!=n||get(b+60)!=n||get(b+76)!=n/4*6)return 0;
   if(!(get(o+0x70)&8)&&get(b+44)!=n)return 0;
   if(e->packedCopies!=packed(n,s->copies)||e->indexCount!=get(b+76))return 0;
   U*uv=(U*)get(b+64);H*ix=(H*)get(b+80);
   for(U a=0;a<e->packedCopies;a++){
    for(U v=0;v<n*2;v++)if(e->uv[(e->packedCopies>1?a*n*2:0)+v]!=uv[v])return 0;
    for(U v=0;v<e->indexCount;v++)if(e->indices[(e->packedCopies>1?a*e->indexCount:0)+v]!=ix[v]+a*n)return 0;
   }
   float*m=(float*)get(b+16),*p=e->points;
   for(U a=0;a<s->copies;a++)for(U v=0;v<n;v++){
    float dx=*p++-m[v*3]-(x*s->directions[a*2]-y*s->directions[a*2+1]);
    float dy=*p++-m[v*3+1]-(x*s->directions[a*2+1]+y*s->directions[a*2]);
    float dz=*p++-m[v*3+2]-z;
    if(dx>0.002f||dx< -0.002f||dy>0.002f||dy< -0.002f||dz>0.002f||dz< -0.002f)return 0;
   }
  }
 }
 return 1;
}
U outline_context_size(void){return sizeof(struct Context);}
