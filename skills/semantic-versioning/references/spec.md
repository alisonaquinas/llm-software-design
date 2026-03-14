# SemVer 2.0.0 Specification Reference

Source: <https://semver.org/spec/v2.0.0.html>
Authors: Tom Preston-Werner et al. — licensed under Creative Commons CC BY 3.0.

---


## Version Format

```text
MAJOR.MINOR.PATCH[-PRE-RELEASE][+BUILD]
```text


- **MAJOR**, **MINOR**, **PATCH** — non-negative integers, no leading zeros.

- **PRE-RELEASE** — optional; dot-separated identifiers after a hyphen.

- **BUILD** — optional; dot-separated identifiers after a plus sign.

Valid examples:

```text
1.0.0
1.0.0-alpha
1.0.0-alpha.1
1.0.0-0.3.7
1.0.0-x.7.z.92
1.0.0-beta+exp.sha.5114f85
1.0.0+20130313144700
```text

---


## The Twelve Clauses

### 1 — Public API declaration

Software using SemVer MUST declare a public API. The API may be declared in
code itself or in documentation. It MUST be precise and comprehensive.

### 2 — Version format

A version number MUST take the form X.Y.Z where X, Y, and Z are non-negative
integers, and MUST NOT contain leading zeros. X is the major version, Y is the
minor version, and Z is the patch version. Each element MUST increase
numerically. For instance: 1.9.0 → 1.10.0 → 1.11.0.

### 3 — Immutability

Once a versioned package has been released, the contents of that version MUST
NOT be modified. Any modifications MUST be released as a new version.

### 4 — Major version zero

Major version zero (0.y.z) is for initial development. Anything MAY change at
any time. The public API SHOULD NOT be considered stable.

### 5 — Version 1.0.0 and stability

Version 1.0.0 defines the public API. The way in which the version number is
incremented after this release is dependent on how the public API changes.

### 6 — Patch version

Patch version Z (x.y.Z | x > 0) MUST be incremented if only backward-
compatible bug fixes are introduced. A bug fix is defined as an internal change

that fixes incorrect behavior.

### 7 — Minor version

Minor version Y (x.Y.z | x > 0) MUST be incremented if new, backward-
compatible functionality is introduced to the public API. It MUST be

incremented if any public API functionality is marked as deprecated. It MAY be
incremented if substantial new functionality or improvements are introduced
within the private code. It MAY include patch-level changes. Patch version MUST
be reset to 0 when minor version is incremented.

### 8 — Major version

Major version X (X.y.z | X > 0) MUST be incremented if any backward-
incompatible changes are introduced to the public API. It MAY also include

minor and patch-level changes. Patch and minor versions MUST be reset to 0 when
major version is incremented.

### 9 — Pre-release version

A pre-release version MAY be denoted by appending a hyphen and a series of dot
separated identifiers immediately following the patch version. Identifiers MUST
comprise only ASCII alphanumerics and hyphens `[0-9A-Za-z-]`. Identifiers MUST
NOT be empty. Numeric identifiers MUST NOT include leading zeros. Pre-release
versions have a lower precedence than the associated normal version. A
pre-release version indicates that the version is unstable and might not satisfy
the intended compatibility requirements as denoted by its associated normal
version. Examples: 1.0.0-alpha, 1.0.0-alpha.1, 1.0.0-0.3.7, 1.0.0-x.7.z.92.

### 10 — Build metadata

Build metadata MAY be denoted by appending a plus sign and a series of dot
separated identifiers immediately following the patch or pre-release version.
Identifiers MUST comprise only ASCII alphanumerics and hyphens `[0-9A-Za-z-]`.
Identifiers MUST NOT be empty. Build metadata MUST be ignored when determining
version precedence. Thus two versions that differ only in the build metadata
have equal precedence. Examples: 1.0.0-alpha+001, 1.0.0+20130313144700,
1.0.0-beta+exp.sha.5114f85, 1.0.0+21AF26D3----117B344092BD.

### 11 — Version precedence

Precedence refers to how versions are compared to each other when ordered.

1. Precedence MUST be calculated by separating the version into major, minor,
   patch, and pre-release identifiers in that order. Build metadata MUST be
   ignored when determining precedence.
2. Precedence is determined by the first difference when comparing each of
   these identifiers from left to right: major, minor, and patch versions are
   always compared numerically. Example: 1.0.0 < 2.0.0 < 2.1.0 < 2.1.1.
3. When major, minor, and patch are equal, a pre-release version has lower
   precedence than a normal version. Example: 1.0.0-alpha < 1.0.0.
4. Precedence for two pre-release versions with the same major, minor, and
   patch version MUST be determined by comparing each dot separated identifier
   from left to right until a difference is found:
   a. Identifiers consisting of only digits are compared numerically.
   b. Identifiers with letters or hyphens are compared lexically in ASCII sort
      order.
   c. Numeric identifiers always have lower precedence than alphanumeric
      identifiers.
   d. A larger set of pre-release fields has a higher precedence than a
      smaller set, if all of the preceding identifiers are equal.

   Example: 1.0.0-alpha < 1.0.0-alpha.1 < 1.0.0-alpha.beta < 1.0.0-beta
            < 1.0.0-beta.2 < 1.0.0-beta.11 < 1.0.0-rc.1 < 1.0.0

### 12 — Backus–Naur Form grammar

```bnf
<valid semver> ::= <version core>
                 | <version core> "-" <pre-release>
                 | <version core> "+" <build>
                 | <version core> "-" <pre-release> "+" <build>

<version core> ::= <major> "." <minor> "." <patch>

<major> ::= <numeric identifier>
<minor> ::= <numeric identifier>
<patch> ::= <numeric identifier>

<pre-release> ::= <dot-separated pre-release identifiers>

<dot-separated pre-release identifiers> ::=
    <pre-release identifier>
  | <pre-release identifier> "." <dot-separated pre-release identifiers>

<build> ::= <dot-separated build identifiers>

<dot-separated build identifiers> ::=
    <build identifier>
  | <build identifier> "." <dot-separated build identifiers>

<pre-release identifier>  ::= <alphanumeric identifier> | <numeric identifier>
<build identifier>        ::= <alphanumeric identifier> | <digits>

<alphanumeric identifier> ::=
    <non-digit>
  | <non-digit> <identifier characters>
  | <identifier characters> <non-digit>
  | <identifier characters> <non-digit> <identifier characters>

<numeric identifier>      ::= "0"
                            | <positive digit>
                            | <positive digit> <digits>

<identifier characters>   ::= <identifier character>
                            | <identifier character> <identifier characters>

<identifier character>    ::= <digit> | <non-digit>

<non-digit>    ::= <letter> | "-"
<digits>       ::= <digit> | <digit> <digits>
<digit>        ::= "0" | <positive digit>
<positive digit> ::= "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9"
<letter>       ::= "A" | "B" | "C" | "D" | "E" | "F" | "G" | "H" | "I"
                 | "J" | "K" | "L" | "M" | "N" | "O" | "P" | "Q" | "R"
                 | "S" | "T" | "U" | "V" | "W" | "X" | "Y" | "Z"
                 | "a" | "b" | "c" | "d" | "e" | "f" | "g" | "h" | "i"
                 | "j" | "k" | "l" | "m" | "n" | "o" | "p" | "q" | "r"
                 | "s" | "t" | "u" | "v" | "w" | "x" | "y" | "z"
```text

---


## Regex for Validation

The official regex from semver.org (PCRE / ECMAScript compatible):

```regex
^(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)
(?:-((?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)
   (?:\.(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*))*))
(?:\+([0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+)*))?$
```text

For quick shell validation:

```bash
semver_valid() {
  echo "$1" | grep -qE \
    '^(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)' \
    '(-[0-9A-Za-z-]+(\.[0-9A-Za-z-]+)*)?(\+[0-9A-Za-z-]+(\.[0-9A-Za-z-]+)*)?$'
}
```text

---


## FAQ

## When should I release 1.0.0?
When the software is used in production or when it has a stable API that users
depend on. If you are already worrying about backward compatibility, you are
probably at 1.0.0.

## How should I handle bug fixes that accidentally broke the API?
Release a minor version that restores backward compatibility as soon as you
realise the mistake. Even if a release was technically a breaking change, it
was not intentional and users expect it to work. Only increment the major
version when you intentionally break compatibility.

## Should I rename a package instead of bumping major?
If you frequently break the API, consider whether a major bump or a new package
name communicates intent better to users.

## What do I do when 0.y.z reaches production readiness?
Release 1.0.0 and start following the full semver rules. Avoid skipping to
higher numbers (such as jumping from 0.9.0 to 2.0.0) without going through
1.0.0 first.

## Can I deprecate public API in a patch version?
No. Deprecation is a new public API affordance and requires at minimum a minor
bump. Removal of a deprecated symbol requires a major bump.

## What about lock files and generated code — do they count?
No. Only changes to the public API surface that consumers depend on affect the
version number. Lock file updates alone are patch-or-nothing territory.

## When is a pre-release appropriate vs. tagging a release?
Use pre-release suffixes (alpha, beta, rc) when a release candidate needs
external testing before becoming stable. Use the normal version once the
release is intentional and stable.
