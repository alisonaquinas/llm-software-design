# Planguage testing patterns

## Turn fields into tests

- `Scale` defines the observable and units
- `Meter` defines the procedure
- `Goal` defines the pass line
- `Fail` defines the red-line case
- `Stretch` and `Wish` define optional performance exploration

## Test design sequence

1. write one test objective per requirement tag
2. define the exact environment and workload for the meter
3. design boundary cases around fail and goal
4. define the sample size, timing method, and pass calculation
5. package the evidence so another reviewer can reproduce it

## Evidence package

- requirement tag
- test procedure
- data set or workload profile
- raw measurements
- pass or fail calculation
- reviewer notes and remaining uncertainty

## Common problems

- meter wording is too vague to repeat
- scale omits units or conditions
- goal uses percentages without sample size
- pass criteria depend on hidden analyst judgment
