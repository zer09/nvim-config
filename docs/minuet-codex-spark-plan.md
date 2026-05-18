# Minuet Codex Spark completion plugin plan

## Goal

Build a Neovim plugin that reuses Minuet AI's real code completion and blink.cmp integration while using the user's ChatGPT Pro Codex access, specifically `gpt-5.3-codex-spark`, without requiring an OpenAI API key.

The target architecture is:

```text
blink.cmp
  -> minuet-ai.nvim source
  -> custom Minuet backend: codex_acp
  -> persistent codex-acp JSON-RPC process
  -> Codex ChatGPT authentication managed by Codex/codex-acp
  -> gpt-5.3-codex-spark
```

## Local MVP implementation status

Implemented in this Neovim config as a local companion plugin:

- `lua/minuet_codex/` contains the Codex ACP client, prompt builder, parser, config, health, and commands.
- `lua/minuet/backends/codex_acp.lua` exposes the Minuet backend entry point.
- `lua/plugins/minuet.lua` configures `minuet-ai.nvim` to use `provider = "codex_acp"` with ChatGPT auth.
- `lua/plugins/blink.lua` adds the `minuet` blink.cmp provider and binds manual AI completion to `<A-y>` and `<F2>`.
- `plugin/minuet-codex.lua` registers `:MinuetCodexStart`, `:MinuetCodexStop`, `:MinuetCodexRestart`, `:MinuetCodexHealth`, `:MinuetCodexComplete`, `:MinuetCodexLog`, `:MinuetCodexLogOpen`, and `:MinuetCodexLogClear`.
- `lua/minuet_codex/log.lua` writes redacted lifecycle logs to `~/.local/state/nvim/minuet-codex.log`.

The implementation defaults to manual completion. It uses `codex-acp` when available, otherwise falls back to running the local `~/development/codex-acp` clone through Cargo. The Minuet setup includes a `provider_options.codex_acp.name` entry so Minuet's blink source can render the provider without indexing a nil provider option.

## Repositories reviewed

Local source repositories:

- `~/development/minuet-ai.nvim/`
- `~/development/codecompanion.nvim/`
- `~/development/codex-acp/`

Relevant files found:

### Minuet AI

- `lua/minuet/blink.lua`
- `lua/minuet/init.lua`
- `lua/minuet/config.lua`
- `lua/minuet/backends/openai.lua`
- `lua/minuet/backends/openai_compatible.lua`
- `lua/minuet/backends/openai_base.lua`
- `lua/minuet/backends/common.lua`
- `lua/minuet/utils.lua`

### CodeCompanion

- `lua/codecompanion/adapters/acp/codex.lua`
- `lua/codecompanion/acp/init.lua`
- `lua/codecompanion/acp/prompt_builder.lua`

### codex-acp

- `src/codex_agent.rs`
- `src/thread.rs`
- `src/lib.rs`

## Current findings

### Minuet is the right frontend base

Minuet already provides the hard editor-side pieces:

- Native blink.cmp source in `lua/minuet/blink.lua`.
- Completion context construction in `lua/minuet/utils.lua`.
- Debounce and throttle support.
- Manual completion support through `require('minuet').make_blink_map()`.
- Callback-based backend interface.
- Completion item formatting for blink.cmp.
- Duplicate filtering and single-line entry generation.

The key extension point is in `lua/minuet/blink.lua`:

```lua
local provider = require('minuet.backends.' .. config.provider)
provider.complete(context, function(data)
  -- Minuet turns returned strings into blink.cmp items
end)
```

A companion plugin can provide this module:

```text
lua/minuet/backends/codex_acp.lua
```

Then users can configure:

```lua
require('minuet').setup({
  provider = 'codex_acp',
})
```

### Minuet's existing OpenAI backend requires API keys

The current OpenAI path builds HTTP requests directly:

- It reads API keys with `utils.get_api_key`.
- It builds `Authorization: Bearer <key>` headers.
- It calls `curl` through `vim.system`.
- It parses OpenAI chat completion or FIM completion responses.

This is not suitable for ChatGPT Pro subscription auth because ChatGPT Pro Codex access is not exposed as a normal user API key in Minuet.

### CodeCompanion proves the ACP pattern

CodeCompanion's Codex adapter uses `codex-acp` and supports:

```lua
auth_method = 'openai-api-key' -- 'openai-api-key'|'codex-api-key'|'chatgpt'
```

Its ACP client shows the needed lifecycle:

1. Spawn ACP process.
2. Send `initialize`.
3. Send `authenticate` with selected auth method.
4. Send `session/new`.
5. Optionally send `session/set_config_option` for model selection.
6. Send `session/prompt`.
7. Receive `session/update` streaming chunks.
8. Send `session/cancel` when needed.

CodeCompanion itself is not a real code autocomplete engine. Its blink.cmp integration is for chat buffer slash commands, tools, and editor context entries. Still, its ACP client is useful as a reference.

### codex-acp is the right auth bridge

`codex-acp` exposes three auth methods:

- `chatgpt`
- `codex-api-key`
- `openai-api-key`

The plugin should select `chatgpt`.

Important security decision:

- Do not read `~/.codex/auth.json` directly.
- Do not parse, copy, log, print, or expose Codex tokens.
- Let `codex-acp` and Codex handle credential storage and refresh.

`codex-acp` checks whether an existing Codex ChatGPT auth session exists. If already authenticated, it returns success. If not, it starts the Codex login flow.

### GPT-5.3-Codex-Spark model selection is possible

`codex-acp/src/thread.rs` supports `session/set_config_option` for `configId = 'model'`.

If a model preset is known, it uses that preset. If not, it falls back to the raw model string. Therefore the plugin can attempt to set:

```text
gpt-5.3-codex-spark
```

If this fails or is unavailable, the plugin should surface a clear warning and allow the user to fall back to their Codex default model.

## Recommended plugin strategy

Build a companion plugin rather than forking Minuet.

Proposed plugin name:

```text
minuet-codex.nvim
```

Proposed module layout:

```text
lua/minuet/backends/codex_acp.lua
lua/minuet_codex/config.lua
lua/minuet_codex/acp_client.lua
lua/minuet_codex/prompt.lua
lua/minuet_codex/parser.lua
lua/minuet_codex/state.lua
lua/minuet_codex/health.lua
plugin/minuet-codex.lua
```

## Public user configuration

Example MVP configuration:

```lua
require('minuet_codex').setup({
  command = { 'codex-acp' },
  auth_method = 'chatgpt',
  model = 'gpt-5.3-codex-spark',
  auto_start = true,
  request_timeout_ms = 10000,
  completion_separator = '<endCompletion>',
  max_completions = 3,
  prompt = {
    mode = 'completion',
  },
})

require('minuet').setup({
  provider = 'codex_acp',
  blink = {
    enable_auto_complete = false,
  },
  throttle = 3000,
  debounce = 800,
})
```

blink.cmp integration stays the normal Minuet integration:

```lua
sources = {
  default = { 'lsp', 'path', 'buffer', 'snippets', 'minuet' },
  providers = {
    minuet = {
      name = 'minuet',
      module = 'minuet.blink',
      async = true,
      timeout_ms = 10000,
      score_offset = 50,
    },
  },
}
```

Manual trigger remains:

```lua
keymap = {
  ['<A-y>'] = require('minuet').make_blink_map(),
}
```

## Backend contract

`lua/minuet/backends/codex_acp.lua` should expose Minuet's provider API:

```lua
local M = {}

function M.is_available()
  return require('minuet_codex.health').is_available()
end

function M.complete(context, callback)
  require('minuet_codex').complete(context, callback)
end

return M
```

Returned completion data should be a list of strings:

```lua
callback({
  'completion candidate 1',
  'completion candidate 2',
})
```

Minuet's blink source will handle converting strings into completion items.

## ACP client design

### State machine

The ACP client should keep a persistent process and session alive.

States:

```text
stopped
starting
initialized
authenticated
session_ready
request_in_flight
failed
```

### Startup flow

1. Start `codex-acp` with `vim.system` and `stdin = true`.
2. Read JSON-RPC lines from stdout.
3. Send `initialize`:

```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "method": "initialize",
  "params": {
    "protocolVersion": 1,
    "clientCapabilities": {
      "fs": { "readTextFile": true, "writeTextFile": false }
    },
    "clientInfo": {
      "name": "minuet-codex.nvim",
      "version": "0.1.0"
    }
  }
}
```

4. Send `authenticate`:

```json
{
  "jsonrpc": "2.0",
  "id": 2,
  "method": "authenticate",
  "params": {
    "methodId": "chatgpt"
  }
}
```

5. Send `session/new`:

```json
{
  "jsonrpc": "2.0",
  "id": 3,
  "method": "session/new",
  "params": {
    "cwd": "<current working directory>",
    "mcpServers": []
  }
}
```

6. Set model if configured:

```json
{
  "jsonrpc": "2.0",
  "id": 4,
  "method": "session/set_config_option",
  "params": {
    "sessionId": "<session id>",
    "configId": "model",
    "value": {
      "value": "gpt-5.3-codex-spark"
    }
  }
}
```

Exact `value` shape must be verified against ACP schema during implementation. CodeCompanion passes the `SessionConfigOptionValue` object returned by the adapter's config option helpers, so the plugin should mirror that shape rather than guessing.

### Prompt flow

For each Minuet completion request:

1. Increment a local request sequence.
2. Cancel or mark stale the previous request.
3. Build a strict completion prompt from Minuet's context.
4. Send `session/prompt`.
5. Accumulate only `agent_message_chunk` text.
6. Ignore tool call and reasoning chunks.
7. When prompt completes, parse text into completion candidates.
8. Only call the Minuet callback if the request sequence is still current.

## Prompt design

Initial strict prompt:

```text
You are a code completion engine. Complete code at <cursor>.

Rules:
- Return only completion text.
- Do not explain.
- Do not use markdown fences.
- Do not repeat text that already appears before the cursor.
- Do not include text that appears after the cursor unless needed for syntax.
- Preserve indentation.
- Provide at most {max_completions} candidates.
- Separate candidates with <endCompletion>.

Filetype: {filetype}

<contextBeforeCursor>
{lines_before}
</contextBeforeCursor>

<contextAfterCursor>
{lines_after}
</contextAfterCursor>

Return completions now.
```

The parser should defensively remove:

- Markdown code fences.
- Leading explanatory text.
- Trailing explanations.
- Empty candidates.
- Duplicate candidates.

## Request cancellation and stale result handling

ACP has `session/cancel`. The plugin should support both:

1. Send cancel for the active request/session when possible.
2. Always track a local `request_seq` and ignore late chunks from older requests.

This matters because autocomplete requests can become stale quickly as the user types.

## MVP scope

### Include

- `codex_acp` Minuet backend.
- Persistent `codex-acp` process.
- ChatGPT auth through `codex-acp`.
- Session creation.
- Optional model selection to `gpt-5.3-codex-spark`.
- Manual completion support with existing Minuet blink keymap.
- Strict prompt and parser.
- Basic health command.
- Stale request guard.

### Exclude from MVP

- Automatic every-keystroke completion.
- Direct `~/.codex/auth.json` reading.
- Direct OpenAI HTTP calls.
- Tool execution permissions.
- Applying edits.
- Multi-session management.
- Caching beyond maybe the latest request.

## Phase plan

### Phase 1: Prototype ACP client

Create `lua/minuet_codex/acp_client.lua` with:

- process spawn
- JSON-RPC id generation
- line-buffered stdout parser
- pending request callbacks
- initialize
- authenticate
- session/new
- session/prompt

Validation:

- `:MinuetCodexHealth` confirms `codex-acp` exists.
- `:MinuetCodexStart` starts process and authenticates.
- Manual test prompt returns streamed text.

### Phase 2: Minuet backend adapter

Create `lua/minuet/backends/codex_acp.lua`.

Implement:

- `is_available()`
- `complete(context, callback)`

Validation:

- Configure Minuet with `provider = 'codex_acp'`.
- Trigger manual completion through blink.cmp.
- Confirm items appear in completion menu.

### Phase 3: Prompt and parser hardening

Create:

- `lua/minuet_codex/prompt.lua`
- `lua/minuet_codex/parser.lua`

Test cases:

- single-line completion
- multi-line completion
- markdown fenced output
- explanatory preamble
- duplicate candidates
- completion that repeats prefix
- empty output

### Phase 4: Model selection

Implement model setting:

- Check session config options for a `model` option.
- Prefer matching option value for `gpt-5.3-codex-spark`.
- If not listed, try raw model id only if `allow_raw_model = true`.
- Warn clearly if model selection fails.

Validation:

- `:MinuetCodexModel` reports active model if available.
- Fallback to Codex default model is explicit.

### Phase 5: Completion UX tuning

Start with manual mode:

```lua
blink = {
  enable_auto_complete = false,
}
```

Then test conservative auto mode:

```lua
blink = {
  enable_auto_complete = true,
}
throttle = 3000
debounce = 1000
```

Measure:

- time to first item
- final completion latency
- stale request frequency
- rate limit behavior
- UI responsiveness

Only enable auto mode by default if results are consistently good.

## Safety rules

- Never read, print, parse, log, or expose `~/.codex/auth.json`.
- Never ask users to paste auth token values.
- Do not include tokens in debug logs.
- If `codex-acp` requests login, let the external Codex flow handle it.
- Default to manual completion to avoid accidental excessive usage.
- Do not enable tools or file edits through the autocomplete path.

## Risks and mitigations

| Risk | Severity | Mitigation |
|---|---:|---|
| Codex ACP is agent-oriented, not completion-oriented | High | Use strict prompts and parser. MVP manual only. |
| Latency too high for autocomplete | High | Keep persistent process/session warm. Start with manual trigger. |
| Model unavailable or not exposed in picker | Medium | Allow fallback to Codex default and show warning. |
| Output includes explanations | Medium | Parser strips common wrappers; prompt says code only. |
| Stale completions inserted | Medium | Sequence IDs and cancel old requests. |
| Rate limits from frequent requests | Medium | Manual mode first, then conservative debounce/throttle. |
| Auth flow interruption | Medium | Health command explains `codex login` or Codex auth flow. |

## Feasibility assessment

| Mode | Feasible | Recommendation |
|---|---:|---|
| Manual AI completion with blink.cmp | Yes | MVP target. |
| Auto completion after debounce | Maybe | Add after latency testing. |
| Every-keystroke Copilot-style completion | Risky | Do not start here. |
| Direct auth.json token use | No | Do not implement. |

## Open questions

1. Does `codex-acp` expose `gpt-5.3-codex-spark` in session config options on this account?
2. What is the real latency of Spark through `codex-acp` for a strict completion prompt?
3. Does `session/cancel` reliably stop in-flight Codex turns quickly enough for autocomplete?
4. What exact ACP value shape should be used for `session/set_config_option` from a standalone client?
5. Does Codex add agent-specific wrappers that make output parsing unreliable?

## Initial implementation recommendation

Build a local companion plugin first, not a fork:

```text
~/.config/nvim/lua/plugins/minuet-codex.lua
```

Point lazy.nvim at a local development plugin directory if needed.

Once the prototype works, consider extracting it into its own repository:

```text
minuet-codex.nvim
```

## Success criteria

MVP is successful when:

1. User can run `:MinuetCodexHealth` and see Codex ACP readiness.
2. User can trigger manual blink.cmp completion through Minuet.
3. Completion request uses ChatGPT auth, not an API key.
4. Plugin does not read or log `~/.codex/auth.json`.
5. Completion candidates appear in blink.cmp as Minuet items.
6. `gpt-5.3-codex-spark` is selected or a clear fallback warning is shown.
7. Stale completions are ignored when the buffer changes.

## Final recommendation

Proceed with a companion plugin that implements a `minuet.backends.codex_acp` provider.

Do not modify Minuet core for the first prototype. Minuet already has the right provider hook, and keeping this separate reduces risk while preserving upstream compatibility.
