# File Header and Docstring Conventions

## What a file-level header must contain

A file-level header comment or module docstring should communicate:

1. **Purpose** — what this file does in one or two sentences
2. **Key exports** — the primary types, functions, classes, or constants it provides
3. **Role in the system** — how it fits into the larger codebase
4. **Constraints or notes** — threading, lifecycle, platform, or performance notes when they matter

A header that only restates the filename is not acceptable. Write for a reader who has never seen the codebase.

## Bootstrap rule

The bundled header generator is intentionally conservative. It creates **bootstrap headers**, not final prose.

A generated header should therefore:

- include a visible bootstrap marker
- give the next editor a strong structure to refine
- never pretend to be complete if the script had to guess

Before merge, either refine the header or explicitly report that bootstrap text remains.

## Language templates

### Python

```python
"""
BOOTSTRAP HEADER: refine before merge.

Purpose: <short description of what this module does>

Provides: <ClassName>, <function_name>, <CONSTANT_NAME>

Role in system: <one or two sentences on how this module fits into the system>

Constraints: <omit if none>
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
 * BOOTSTRAP HEADER: refine before merge.
 *
 * Purpose: <short description of what this module does>
 *
 * Provides: {@link ClassName}, {@link functionName}
 *
 * Role in system: <one or two sentences on how this module fits into the system>
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
 * @param token - The bearer token to validate.
 * @returns True if the token is current and matches the user.
 * @throws {TokenExpiredError} If the token has passed its TTL.
 */
function authenticate(userId: string, token: string): boolean {
```

### Java

```java
/**
 * BOOTSTRAP HEADER: refine before merge.
 *
 * Purpose: <short description of what this class or file does>
 *
 * <p>Provides: {@link ClassName}
 *
 * <p>Role in system: <one or two sentences on how this class fits into the system>
 */
```

### C / C++

```cpp
/**
 * @file <filename.cpp>
 * @brief BOOTSTRAP HEADER: refine before merge.
 *
 * Purpose: <short description of what this file does>
 *
 * Provides: <function_name>, <ClassName>
 *
 * Role in system: <one or two sentences on how this file fits into the system>
 */
```

### C# (.NET XML docs)

```csharp
/// <summary>
/// BOOTSTRAP HEADER: refine before merge.
/// </summary>
/// <remarks>
/// Purpose: <short description>
/// Provides: <see cref="ClassName"/>
/// Role in system: <how this type fits into the system>
/// </remarks>
```

### Go

```go
// Package <name> BOOTSTRAP HEADER: refine before merge.
//
// Purpose: <short description of what this package does>
//
// Provides: <TypeName>, <FunctionName>, and <ConstantName>.
//
// Role in system: <one or two sentences on how this package fits into the system>
```

### Ruby

```ruby
# frozen_string_literal: true
#
# BOOTSTRAP HEADER: refine before merge.
#
# Purpose: <short description of what this file does>
#
# Provides: <ClassName>, <method_name>
#
# Role in system: <one or two sentences on how this file fits into the system>
```

### Rust

```rust
//! BOOTSTRAP HEADER: refine before merge.
//!
//! Purpose: <short description of what this module does>
//!
//! Provides: [`TypeName`], [`function_name`]
//!
//! Role in system: <one or two sentences on how this module fits into the system>
```

## Exclusions

Skip headers on:

- generated code
- vendored third-party code
- minified bundles
- fixtures whose value is realism rather than maintainability
- files that already have a useful header or module docstring

## Verification

After generating headers:

1. search for `BOOTSTRAP HEADER` and confirm every remaining instance is expected
2. refine the highest-traffic files first
3. verify the file's real exports still match the `Provides:` line
4. verify the role statement still matches how the file is used in the codebase
