#ifndef OreForgeProbeIncluded
#define OreForgeProbeIncluded
//! zinc
library OreForgeProbe {
    public function OreForgeProbeSend(player p, string eventName, string payload) -> boolean {
        // Chat actions run on all peers; only the owner sends the cloud request.
        if (p == GetLocalPlayer()) return KKApiMlScriptEvent(p, eventName, payload);
        return true;
    }
}
//! endzinc
#endif
