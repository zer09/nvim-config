# Neovim Configuration Context

This context defines the language for a personal Neovim setup. It exists to keep future changes aligned with the owner's workflow rather than treating the repo as a reusable distribution.

## Language

**Personal Neovim configuration**:
A user-specific Neovim setup optimized for one owner's editing workflow and machine assumptions.
_Avoid_: Neovim distribution, editor framework, IDE setup

**Daily driver**:
The trusted editing environment for routine work, where startup reliability and predictable behavior take priority over plugin experimentation.
_Avoid_: Plugin lab, experimental playground

**Working daily workflow**:
The owner's actually used editing path, which takes priority over cosmetic healthcheck cleanliness when the warning does not affect used ecosystems.
_Avoid_: Zero-warning policy, healthcheck purity

**Linux workstation**:
A Linux machine where the config runs, with the active distribution recorded as local context instead of treated as a universal constraint.
_Avoid_: openSUSE-only setup, cross-platform abstraction

**Setup documentation**:
Machine-facing notes for distro packages, local toolchains, and reproducible setup steps that should not be encoded as plugin behavior.
_Avoid_: Distro branches in plugin config, implicit machine assumptions

**Optional host dependency**:
A system tool or language runtime that is only needed when the owner uses its ecosystem on a given machine.
_Avoid_: Broken dependency, required runtime

**Managed toolchain**:
An intentionally managed source for editor-adjacent tools, such as a language tool manager, Mason, Lazy, or the distro package manager.
_Avoid_: Random system package, incidental executable

**Tool ownership boundary**:
The rule that editor plugins belong to Lazy, editor-facing binaries belong to Mason when appropriate, and broader developer tools belong to their language or distro toolchain.
_Avoid_: Duplicate tool installers, install wherever works

**Active language workflow**:
The set of languages currently used often enough to deserve first-class editor support on the owner's machine.
_Avoid_: Permanent language boundary, only supported languages

**First-class language support**:
Editor support for a language that is justified by an actual owner project or use case, not merely by available tooling.
_Avoid_: Speculative language setup, install every LSP

**Language snippet set**:
Owner-maintained snippets that support the current active languages and coding patterns.
_Avoid_: Generic snippet collection, decorative snippets

**Low-friction coding assistance**:
Editor help that speeds up the owner's work without flooding the interface with irrelevant suggestions.
_Avoid_: Maximum suggestions everywhere, autocomplete spam

**Optional workflow accelerator**:
A nonessential tool that can speed up the owner's work when available but must not be required for core editing.
_Avoid_: Core editor dependency, mandatory AI layer

**Navigation workflow**:
The core file, text, symbol, window, and repository movement path used to stay oriented while editing.
_Avoid_: Finder decoration, search plugin extras

**Project-respecting formatting**:
Formatting behavior that uses the owner's editor defaults only when they do not override a project's own formatting rules.
_Avoid_: Force global formatter everywhere, editor-owned project style

**Actionable diagnostics**:
Editor feedback that highlights problems the owner can reasonably act on without turning normal editing into lint noise.
_Avoid_: Maximal lint noise, hostile diagnostics

**Git review workflow**:
The editor-assisted path for inspecting, navigating, and understanding repository changes without replacing command-line Git.
_Avoid_: Git CLI replacement, hidden repo operations

**Readable interface**:
A visual setup that makes long editing sessions clearer and less distracting.
_Avoid_: Aesthetic novelty, theme churn

**Startup reliability**:
The expectation that Neovim opens predictably and remains easy to debug before any clever loading strategy is optimized.
_Avoid_: Lazy-loading cleverness, unpredictable startup

**Plugin maintenance event**:
An intentional plugin or lockfile change that must preserve the daily driver through relevant validation.
_Avoid_: Background plugin churn, casual update sweep

**Local assumption**:
A non-secret machine or session fact that explains how this config runs on the current workstation.
_Avoid_: Secret, credential, universal rule

## Relationships

- A **Personal Neovim configuration** serves one owner's workflow rather than a public audience.
- The **Personal Neovim configuration** is a **Daily driver**.
- A **Daily driver** protects the **Working daily workflow** before chasing zero healthcheck warnings.
- A **Personal Neovim configuration** can run on multiple **Linux workstation** distributions, while each machine records its active distribution.
- A **Linux workstation** records distro-specific package and tool guidance in **Setup documentation**.
- An **Optional host dependency** may appear in healthcheck output without affecting the **Working daily workflow**.
- A missing editor tool should be assigned to a **Managed toolchain** before it is installed or documented.
- A **Managed toolchain** follows the **Tool ownership boundary**.
- The **Working daily workflow** includes an **Active language workflow**, but future languages can be promoted into it when the owner starts using them.
- A language enters the **Active language workflow** through **First-class language support**.
- A **Language snippet set** belongs to the **Active language workflow**.
- Completion should provide **Low-friction coding assistance** for the **Working daily workflow**.
- AI and code-assistant plugins are **Optional workflow accelerator** tools.
- The **Working daily workflow** includes a **Navigation workflow** alongside editing, LSP, formatting, and snippets.
- Formatting should be **Project-respecting formatting**.
- Diagnostics should be **Actionable diagnostics**.
- Git integration supports the **Git review workflow**.
- UI and theming should preserve a **Readable interface**.
- A **Daily driver** depends on **Startup reliability**.
- A **Plugin maintenance event** must protect **Startup reliability** and the **Working daily workflow**.
- A **Linux workstation** records **Local assumption** details in **Setup documentation**.

## Example dialogue

> **Dev:** "Should this change be generalized for every possible Neovim user?"
> **Domain expert:** "No. This is a **Personal Neovim configuration** and **Daily driver**, so optimize the **Working daily workflow** for the current **Linux workstation** without pretending the distro is universal, installing every **Optional host dependency**, or blurring the **Tool ownership boundary** outside **Setup documentation**. Treat languages outside the **Active language workflow** as possible future work, not forbidden territory, and only promote them when there is a real project or use case. Maintain each **Language snippet set** as part of the language workflow, not as plugin decoration, and keep completion as **Low-friction coding assistance** rather than noise. Treat AI helpers as an **Optional workflow accelerator**, not the foundation of editing. Preserve the **Navigation workflow** as a core part of staying oriented, and let **Project-respecting formatting** keep project style authoritative. Prefer **Actionable diagnostics** over maximal lint noise. Use the **Git review workflow** to inspect changes, not to hide repository operations. Keep the **Readable interface** more important than aesthetic novelty. Preserve **Startup reliability** before lazy-loading cleverness, treat plugin updates as a **Plugin maintenance event**, and record **Local assumption** facts without exposing secrets."

## Flagged ambiguities

- "config" was resolved as **Personal Neovim configuration**, not a reusable Neovim distribution, editor framework, or IDE setup.
- "stable Neovim 0.12 daily driver" was resolved as **Daily driver**, with the Neovim 0.12 constraints documented outside the glossary.
- "clean healthcheck" was subordinated to **Working daily workflow** when warnings are unrelated to ecosystems the owner uses.
- "openSUSE Tumbleweed workstation" was rejected as a universal constraint; the current **Linux workstation** is openSUSE Tumbleweed, but another machine may use another Linux distribution if it is explicitly recorded.
- Distro-specific package guidance belongs in **Setup documentation**, not in plugin config logic, unless a runtime branch is needed to protect the **Working daily workflow**.
- Ruby, PHP, Java, Julia, Mercurial, Composer, and similar warnings were resolved as **Optional host dependency** warnings unless the owner uses that ecosystem on the current **Linux workstation**.
- "managed toolchain" means the deliberate owner of a tool installation, such as `uv`, `cargo`, `npm`, `go`, Mason, Lazy, or the distro package manager, not whichever executable happens to be present.
- Lazy owns editor plugins, Mason owns editor-facing LSP/debug/formatter binaries when appropriate, and language-specific managers own broader developer tools.
- New languages should receive **First-class language support** only after an actual project or use case exists.
- Snippets were resolved as **Language snippet set** content tied to the **Active language workflow**, not generic plugin decoration.
- Completion was resolved as **Low-friction coding assistance**, not maximum suggestions everywhere.
- AI and code-assistant plugins were resolved as **Optional workflow accelerator** tools, not requirements for startup, editing, LSP, formatting, or navigation.
- Search, file browsing, symbol lookup, window movement, and git movement were resolved as the **Navigation workflow**, not optional plugin decoration.
- Formatting was resolved as **Project-respecting formatting**, not forcing a global formatter everywhere.
- Diagnostics were resolved as **Actionable diagnostics**, not maximal lint noise.
- Git integration was resolved as **Git review workflow**, not a replacement for command-line Git.
- UI and theming were resolved as **Readable interface** work, not aesthetic novelty.
- Startup behavior was resolved as **Startup reliability**, not lazy-loading cleverness.
- Plugin updates were resolved as **Plugin maintenance event** work, not background churn.
- Hardware facts, current distro, and available toolchains were resolved as **Local assumption** details; secrets and credentials are excluded.
