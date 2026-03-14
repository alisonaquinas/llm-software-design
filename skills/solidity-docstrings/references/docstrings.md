# Solidity documentation convention

## Preferred convention

NatSpec comments

## Decision rules

- preserve an established machine-readable style when the repository or toolchain already depends on it
- otherwise standardize on the preferred convention above for the requested surface
- document public and externally consumed symbols before private helpers
- keep summaries, parameters, returns, errors, and examples aligned with the real code

## Why this is the default

Prefer NatSpec because it is the canonical machine-readable documentation format understood by the Solidity compiler and downstream tooling.

## Best targets

public and external functions, contracts, interfaces, events, custom errors

## Canonical syntax

```text
/// @notice Add two integers and return the sum.
/// @param a Left operand.
/// @param b Right operand.
/// @return Sum of the operands.
function add(uint256 a, uint256 b) public pure returns (uint256);
```

## Example

```text
/// @notice Build the current report snapshot.
/// @param request Immutable report request.
/// @return Generated snapshot.
function build(bytes calldata request) external returns (bytes memory);
```

## External tool access

solc userdoc and devdoc output, block explorer tooling, forge doc

```text
solc --userdoc --devdoc Contract.sol
forge doc
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

Document the ABI-facing surface first. Accurate NatSpec is especially important when external users read docs through generated metadata rather than source code.
