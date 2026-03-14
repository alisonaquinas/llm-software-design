# Elixir documentation convention

## Preferred convention

@doc and @moduledoc attributes

## Decision rules

- preserve an established machine-readable style when the repository or toolchain already depends on it
- otherwise standardize on the preferred convention above for the requested surface
- document public and externally consumed symbols before private helpers
- keep summaries, parameters, returns, errors, and examples aligned with the real code

## Why this is the default

Prefer `@doc`, `@moduledoc`, and related attributes because they are native to Elixir and flow directly into ExDoc-generated reference sites.

## Best targets

modules, functions, macros, callbacks, types, module guides

## Canonical syntax

```text
defmodule MathX do
  @doc """
  Add two integers and return the sum.
  """
  def add(a, b), do: a + b
end
```

## Example

```text
defmodule Report.Builder do
  @moduledoc """
  Build report snapshots from immutable requests.
  """

  @doc """
  Build the current report snapshot.
  """
  def build(request), do: ...
end
```

## External tool access

ExDoc, IEx help, generated HTML docs

```text
mix docs
```

## Migration guidance

- convert declaration-adjacent comments incrementally so mixed-style files can be cleaned up safely over time
- avoid mixing competing documentation styles in one file unless a staged migration explicitly requires it
- verify generated docs, IDE help, or extracted metadata after making documentation changes

## Review checklist

- [ ] the chosen convention matches the surrounding toolchain or house style
- [ ] comments are attached to the declarations that external tools inspect
- [ ] summaries describe real behavior without invented guarantees
- [ ] parameters, returns, errors, and examples match the code
- [ ] extraction or verification commands are noted when they materially help review or CI

## Notes

Use `@typedoc` for public types and keep module docs high-level. That balance improves both generated navigation and inline help.
