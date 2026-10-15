#ifndef MlsProbeIncluded
#define MlsProbeIncluded
//! zinc
// Local MLS transport probe; no Xlimon business dependencies.
library MlsProbe {
    public function MlsProbeSend(player p, string eventName, string payload) -> boolean {
        return KKApiMlScriptEvent(p, eventName, payload);
    }
}
//! endzinc
#endif
