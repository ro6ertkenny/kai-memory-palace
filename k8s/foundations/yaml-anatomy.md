# 🧬 YAML Anatomy
## Understanding what matters in Kubernetes manifests

Mental mode: Reading intent, not memorizing syntax.

This document explains **how Kubernetes YAML is structured**, what fields matter,
and how to reason about manifests without treating them as magic spells.

YAML is not the system.
It is how you express intent to the system.

---

## Purpose
You should be able to answer:
- What parts of a Kubernetes YAML file are essential?
- Which fields are boilerplate?
- How does Kubernetes interpret this structure?
- Where do mistakes usually happen?

Understanding structure prevents cargo-cult copying.

---

## YAML Is a Data Format

YAML is:
- a structured data format
- indentation-sensitive
- used to represent objects

YAML itself does nothing.
Kubernetes interprets the data it contains.

---

## Kubernetes Objects (High Level)

Every Kubernetes manifest represents an **object**.

All objects follow the same top-level structure:
- apiVersion
- kind
- metadata
- spec

This consistency is intentional.

---

## apiVersion

apiVersion tells Kubernetes:
- which API group owns this object
- which version of the schema applies

Example meaning:
Different apiVersions may support different fields.

You do not invent apiVersions.
You select from what the API server supports.

---

## kind

kind tells Kubernetes:
- what type of object this is

Examples:
- Pod
- Deployment
- Service
- ConfigMap

kind determines:
- which controller will act
- how the object is interpreted

Wrong kind equals wrong behavior.

---

## metadata

metadata identifies the object.

Common fields:
- name
- namespace
- labels
- annotations

metadata answers:
- what is this?
- where does it live?
- how can it be selected?

metadata does not define behavior.
It defines identity.

---

## spec

spec describes **desired state**.

This is the most important section.

spec answers:
- what should exist
- how it should behave
- what configuration applies

Controllers read spec and act accordingly.

---

## status (Important Boundary)

status represents **current state**.

Key rule:
You do not set status.
Kubernetes writes status.

If you edit status manually, it will be overwritten.

spec is intent.
status is observation.

---

## Labels vs Annotations

Labels:
- are used for selection
- support queries
- drive grouping and behavior

Annotations:
- store non-identifying metadata
- are not used for selection

If something is meant to be selected, it is a label.

---

## Indentation and Structure

YAML structure is defined by indentation.

Rules:
- spaces matter
- tabs break things
- alignment defines hierarchy

Most YAML errors are indentation errors.

---

## Lists vs Maps

Maps:
- key-value pairs

Lists:
- ordered collections

Confusing these leads to invalid manifests.

Indentation defines whether something is a list item or a map entry.

---

## Minimalism Principle

Good manifests:
- include only required fields
- avoid unnecessary defaults
- emphasize clarity over completeness

Boilerplate hides intent.

---

## Common Mistakes

- copying full manifests without understanding
- editing status instead of spec
- misplacing fields due to indentation
- confusing labels and annotations

Most YAML bugs are structural, not conceptual.

---

## Reading Strategy

When reading a manifest:
1. identify kind
2. scan metadata
3. focus on spec
4. ignore boilerplate
5. infer intent

This prevents overwhelm.

---

## Outcome
You should be able to say:

I can read Kubernetes YAML and understand intent,  
I know which fields matter,  
and I can ignore noise confidently.

That is YAML literacy.
