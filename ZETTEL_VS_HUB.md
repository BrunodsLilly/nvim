# Zettel vs Hub: Quick Visual Guide

## ❌ WRONG: Topic Note (Not Zettelkasten)

```markdown
# Kubernetes

Kubernetes is a container orchestration platform. It manages pods,
which are groups of containers. Services expose pods. Deployments
manage replicas. Namespaces provide isolation. ConfigMaps store
configuration. Secrets store sensitive data. Ingress manages HTTP
routing. StatefulSets handle stateful workloads...

[Continues for 5000 words]
```

**Problem**: This is just a textbook chapter, not a thinking tool.

---

## ✅ RIGHT: Hub Note (Optional Map)

```markdown
# Kubernetes Hub

**Type**: Topic Index (not a zettel!)

A map of my Kubernetes ideas. This note has NO original thinking - just links.

## Configuration Philosophy
- [[202510242300-declarative-config-reduces-error]]
- [[202510242301-reconciliation-loops-enable-self-healing]]
- [[202510242302-gitops-treats-config-as-code]]

## Availability Patterns
- [[202510242310-pod-antiaffinity-spreads-failure-domains]]
- [[202510242311-readiness-probes-prevent-broken-traffic]]
- [[202510242312-rolling-updates-maintain-uptime]]

## When NOT to Use Kubernetes
- [[202509201400-simplicity-over-scale-premature-optimization]]
- [[202510242320-operational-complexity-tax]]
- [[202510011200-right-tool-for-job]]

## Learning Resources
- [[202510240900-lit-kubernetes-up-running-book]]
- [[202510151000-lit-kelsey-hightower-k8s-hard-way]]

## Related Hubs
- [[distributed-systems-hub]]
- [[container-technology-hub]]
- [[cloud-native-hub]]
```

**Hub = Table of Contents. Hubs have NO original ideas.**

---

## ✅ RIGHT: Permanent Zettels (Your Ideas!)

### Zettel 1: Atomic Idea
```markdown
---
title: "Declarative Configuration Reduces Operational Errors"
date: 2025-10-24
type: permanent-note
tags: [systems, reliability, kubernetes, infrastructure]
---

# Declarative Configuration Reduces Operational Errors

When you specify desired state instead of imperative steps,
the system can automatically converge to that state.

## The Core Insight

**Imperative** (error-prone):
```bash
for i in 1 2 3; do
  docker run myapp
done
```
If one fails, you're in unknown state.

**Declarative** (self-healing):
```yaml
replicas: 3
```
System ensures 3 exist, no matter what.

## Why This Matters

1. Eliminates "works on my machine" - state is declarative
2. Enables GitOps - config is code, reviewed and versioned
3. Automatic recovery - system knows desired state
4. Reduces human error - no manual intervention

## This Pattern Appears Everywhere

- [[202508151000-terraform-declarative-infrastructure]]
- [[202509201200-react-declarative-ui]]
- [[202510011300-sql-declarative-queries]]
- [[202507121000-makefile-declarative-builds]]

## The Trade-off

- [[202509151400-imperative-gives-fine-control]] - Sometimes you need steps
- Declarative = less flexibility, more reliability
- Edge cases harder to handle

## Contradicts

- [[202508011200-bash-scripts-for-one-offs]] - Simple tasks don't need this

## Questions

- Can we make CI/CD pipelines more declarative?
- What about state machines - declarative transitions?
- Is CSS declarative? (Yes, but why does it feel imperative?)

## Sources

- Kubernetes design philosophy
- [[202510240900-lit-kubernetes-up-running-ch2]]
- HashiCorp Terraform documentation
```

### Zettel 2: Another Atomic Idea
```markdown
---
title: "Pod Anti-affinity Distributes Failure Risk"
date: 2025-10-24
type: permanent-note
tags: [reliability, distributed-systems, kubernetes]
---

# Pod Anti-affinity Distributes Failure Risk

Forcing replicas into different failure domains prevents
correlated failures from taking down all instances.

## Key Concept

```yaml
podAntiAffinity:
  requiredDuringSchedulingIgnoredDuringExecution:
  - topologyKey: topology.kubernetes.io/zone
```

This says: "Don't put two replicas in same zone."

## Why It Works

Single zone failure = 1 replica down (not all 3).
Single node failure = 1 replica down (not all 3).

Your service stays up.

## This Is a Broader Pattern

**Same principle as:**
- [[202508101000-raft-consensus-split-zones]] - Raft quorum across racks
- [[202509011200-raid-mirroring-different-drives]] - RAID uses separate disks
- [[202507201400-database-multi-region-replication]]
- [[202510011000-dns-multiple-nameservers]]

**Generalized**: [[202508201500-avoid-single-points-of-failure]]

## The Cost

- [[202510011200-multi-zone-triples-cost]] - AWS charges for cross-zone traffic
- [[202509151000-complexity-vs-reliability-tradeoff]]
- Not needed for dev environments

## Implementation Details

`requiredDuringScheduling` = Hard requirement (pod won't schedule)
`preferredDuringScheduling` = Soft preference (best effort)

Trade-off: Hard = more reliable, but might not schedule

## Questions

- What's optimal replica count for 3 zones?
- How does this interact with horizontal pod autoscaling?
- Can we apply this to database sharding?

## Related

- [[202510242300-declarative-config-reduces-error]] - Same K8s philosophy
- [[202508151200-blast-radius-minimization]]
```

---

## The Difference

| Aspect | Topic Note ❌ | Hub Note ✅ | Zettel ✅ |
|--------|--------------|-------------|-----------|
| **Purpose** | Reference dump | Map/index | Original insight |
| **Length** | 5000+ words | 20-50 links | 300-800 words |
| **Content** | "Everything about X" | Links only | ONE idea |
| **Updates** | Constantly edited | Grows gradually | Rarely changed |
| **Value** | Low (Wikipedia exists) | Medium (convenience) | High (YOUR thinking) |

---

## Decision Tree

```
I want to capture information about Kubernetes...

Is this a SPECIFIC INSIGHT or PATTERN?
├─ YES: "Declarative config reduces errors"
│   └─> Create ZETTEL (permanent note)
│       - One clear claim
│       - Your perspective
│       - Links to related ideas
│
├─ NO: "Just want to organize my K8s notes"
│   └─> Create HUB NOTE
│       - Just links
│       - No original content
│       - Optional (can skip!)
│
└─ NO: "Want to dump facts about K8s"
    └─> DON'T DO THIS
        - This is Wikipedia's job
        - Not useful for thinking
```

---

## Example Session: Learning Kubernetes

### You Read Kubernetes Docs...

**Bad approach** ❌:
```
Open: Kubernetes.md
Type 50 paragraphs about pods, services, etc.
Get bored, never finish
Note becomes stale
```

**Good approach** ✅:
```
1. Read about declarative config
   → Insight: "This reduces errors!"
   → Create zettel: 202510242300-declarative-config-reduces-error.md
   → Link to: terraform, react, sql (same pattern!)

2. Read about pod anti-affinity
   → Insight: "This distributes failure risk!"
   → Create zettel: 202510242301-pod-antiaffinity-spreads-risk.md
   → Link to: RAID, Raft, DNS (same pattern!)

3. Read about reconciliation loops
   → Insight: "Control loops enable self-healing!"
   → Create zettel: 202510242302-reconciliation-enables-self-healing.md
   → Link to: thermostats, cruise control (same pattern!)

4. (Optional) Update hub:
   → Add links to kubernetes-hub.md
```

After 1 month: **30 atomic zettels** about K8s patterns
After 1 year: **See patterns across technologies** that you never would have noticed

---

## Real Example: My Zettelkasten

I don't have a "Python" note.

I have:
- `202408151200-list-comprehensions-are-declarative.md`
- `202408151201-duck-typing-enables-flexibility.md`
- `202408151202-context-managers-handle-cleanup.md`
- `202408151203-decorators-modify-behavior-composition.md`

These connect to ideas about:
- Other declarative patterns (SQL, React)
- Other type systems (Go, TypeScript)
- Other resource management (RAII in C++, using in C#)
- Other composition patterns (higher-order functions)

**The web of ideas transcends topics.**

---

## Your Question Answered

> "Should I create a Kubernetes note or reserve zettels for ideas?"

**Answer**: Reserve zettels for ideas. Kubernetes is a topic, not an idea.

**Options**:
1. **No "Kubernetes" note** - Just create zettels, search finds them
2. **Hub note** - Convenient map (optional)
3. **Project note** - If you have K8s project context

**Never**: ❌ Giant "Kubernetes" reference dump

---

## Quick Start

Instead of creating "Kubernetes" today, create:
1. One zettel about a K8s pattern you learned
2. Link it to a similar pattern in another technology
3. Done!

Let the web grow organically.

---

**Remember**: Wikipedia covers topics. Zettels capture YOUR thinking.
