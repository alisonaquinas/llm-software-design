# Perl documentation convention

## Preferred convention

POD embedded in source

## Decision rules

- preserve an established machine-readable style when the repository or toolchain already depends on it
- otherwise standardize on the preferred convention above for the requested surface
- document public and externally consumed symbols before private helpers
- keep summaries, parameters, returns, errors, and examples aligned with the real code

## Why this is the default

Prefer POD because it is the native Perl documentation format and is routinely embedded directly in module source for extraction by standard tools.

## Best targets

modules, packages, exported subs, scripts, command-line interfaces

## Canonical syntax

```text
=head2 add

Add two integers.

=cut
sub add {
my ($a, $b) = @_;
return $a + $b;
}
```

## Example

```text
=head2 build_report

Build the current report snapshot from the provided request.

=cut
sub build_report {
my ($request) = @_;
...
}
```


## POD section map

POD works best when it describes the package surface in recognizable sections.

- `=head1 NAME`, `SYNOPSIS`, and `DESCRIPTION` for module or script overviews
- `=head2` or itemized sections for exported subs or important entry points
- `=over`, `=item`, and `=back` for option tables or structured argument details
- `=cut` to return cleanly to code when the prose block ends
- keep package-level POD coherent so `perldoc`, manpage generation, and CPAN tooling render it predictably

## External tool access

perldoc, pod2html, pod2man, CPAN tooling

```text
perldoc lib/My/Module.pm
pod2html lib/My/Module.pm > module.html
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

Document the public package surface in POD sections instead of scattering prose comments above every statement-level implementation detail.

## Anti-patterns

- scattering many tiny POD islands through the file when one coherent section would read better
- documenting implementation-private subs while skipping the exported package interface
- drifting `SYNOPSIS` examples after changing the actual call surface
- using plain comments where `perldoc` should be able to render the material directly
- forgetting that POD section structure matters as much as the prose itself

## Reference starting points

- [perlpod](https://perldoc.perl.org/perlpod)
- [perlpodspec](https://perldoc.perl.org/perlpodspec)
- CPAN or house-style conventions for NAME, SYNOPSIS, and exported sub documentation
