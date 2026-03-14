# File Header and Docstring Conventions

## What a file-level header must contain

A file-level header comment or module docstring must communicate:

1. **Purpose** — what this file does in one or two sentences.
2. **Key exports** — the primary types, functions, classes, or constants it provides.
3. **Role in the system** — how it fits into the larger codebase (what calls it, what it calls).
4. **Constraints or notes** — threading safety, known limitations, performance considerations (omit if none).

A header that only restates the filename is not acceptable. Write for a reader who has never seen the codebase.

---

## Language templates

### Python

```python
"""
<Short description of what this module does.>

Provides: <ClassName>, <function_name>, <CONSTANT_NAME>

<One or two sentences explaining how this module fits into the system —
what imports it, what it depends on, or why it exists as a separate file.>

Constraints: <threading notes, performance, platform requirements — omit if none>
"""
```

Public function docstring (Google style, preferred):

```python
def authenticate(user_id: str, token: str) -> bool:
    """Verify that a token is valid for the given user.

    Args:
        user_id: The UUID of the user account to check.
        token: The bearer token to validate.

    Returns:
        True if the token is current and matches the user, False otherwise.

    Raises:
        TokenExpiredError: If the token has passed its TTL.
    """
```

### JavaScript / TypeScript

```typescript
/**
 * <Short description of what this module does.>
 *
 * Provides: {@link ClassName}, {@link functionName}
 *
 * <One or two sentences on how this module fits into the system.>
 *
 * @module <module-name>
 */
```

Public function JSDoc:

```typescript
/**
 * Verify that a token is valid for the given user.
 *
 * @param userId - The UUID of the user account to check.
 * @param token  - The bearer token to validate.
 * @returns      True if the token is current and matches the user.
 * @throws       {TokenExpiredError} If the token has passed its TTL.
 */
function authenticate(userId: string, token: string): boolean {
```

### Java

```java
/**
 * <Short description of what this class / file does.>
 *
 * <p>Provides: {@link ClassName}
 *
 * <p><One or two sentences on how this class fits into the system.>
 *
 * <p>Constraints: <thread safety, lifecycle, etc. — omit if none>
 */
```

### C / C++

```cpp
/**
 * @file <filename.cpp>
 * @brief <Short description of what this file does.>
 *
 * Provides: <function_name>, <ClassName>
 *
 * <One or two sentences on how this file fits into the system.>
 *
 * Constraints: <thread safety, platform requirements — omit if none>
 */
```

### C# (.NET XML docs)

```csharp
/// <summary>
/// <Short description of what this file / class does.>
/// </summary>
/// <remarks>
/// Provides: <ClassName>, <MethodName>
/// <One or two sentences on how this class fits into the system.>
/// </remarks>
```

### Go

```go
// Package <name> <short description of what this package does.>
//
// It provides <TypeName>, <FunctionName>, and <ConstantName>.
//
// <One or two sentences on how this package fits into the system.>
```

### Ruby

```ruby
# frozen_string_literal: true

# <Short description of what this file does.>
#
# Provides: <ClassName>, <method_name>
#
# <One or two sentences on how this file fits into the system.>
```

### Rust

```rust
//! <Short description of what this module does.>
//!
//! Provides: [`TypeName`], [`function_name`]
//!
//! <One or two sentences on how this module fits into the system.>
```

### Kotlin

```kotlin
/**
 * <Short description of what this file does.>
 *
 * Provides: [ClassName], [functionName]
 *
 * <One or two sentences on how this file fits into the system.>
 */
```

### Swift

```swift
/// <Short description of what this file does.>
///
/// Provides: ``TypeName``, ``functionName``
///
/// <One or two sentences on how this file fits into the system.>
```

### Bash / Shell

```bash
#!/usr/bin/env bash
# <Short description of what this script does.>
#
# Usage: <script-name> [OPTIONS] <ARGS>
#
# <One or two sentences on how this script fits into the system.>
#
# Dependencies: <tools required, e.g. jq, curl>
# Exit codes: 0 success, 1 argument error, 2 runtime failure
```

### SQL

```sql
-- <Short description of what this script or view does.>
--
-- Provides: <table name>, <view name>, <procedure name>
--
-- <One or two sentences on how this fits into the data model.>
--
-- Parameters: <if a parameterized script>
```

### YAML / JSON configuration files

Place a comment block at the top (YAML only; JSON has no comments):

```yaml
# <Short description of what this configuration file controls.>
#
# Used by: <tool or service that reads this file>
# See: <link to schema or documentation>
```

---

## Docstring depth by symbol type

| Symbol type | Minimum docstring content |
| --- | --- |
| Public module / file | Purpose, key exports, role in system |
| Public class | What it models or does, key responsibilities |
| Public method / function | What it does, parameters, return value, exceptions raised |
| Public property / attribute | What it represents, units, constraints |
| Private method / function | One-line summary (omit if name is self-evident) |
| Test file | What system behavior or module it exercises |
| Test function | What specific behavior it asserts |

---

## When to skip headers

Do not add file-level headers to:
- Auto-generated files (mark them with `@generated` if the generator supports it)
- Minified or bundled output files
- Data files (`.json`, `.csv`, `.sql` dumps) unless they are hand-authored configurations
- Files in `vendor/`, `node_modules/`, `.venv/`, or equivalent

---

## Integration with docstring skills

For language-specific idioms, argument annotation formats, and style nuance beyond these templates, delegate to the appropriate `$[language]-docstrings` skill:

- `$python-docstrings` — Google, NumPy, and Sphinx style, type annotation standards
- `$typescript-docstrings` — JSDoc with TypeScript types, TSDoc compatibility
- `$java-docstrings` — Javadoc, `@param`, `@throws`, `@see` conventions
- `$csharp-docstrings` — .NET XML documentation comments
- `$go-docstrings` — Go doc conventions, package and exported symbol rules
- `$rust-docstrings` — rustdoc, `///` vs `//!`, doc tests
