# os_activity_example

Example of the os.activity API being broken in Flutter Beta

## Example Output from Flutter Stable (2.10.5)

```
Results:
Created activity 9223372036866891746
Result with that activity in scope: [9223372036866891746, 0]
Created activity 9223372036866891747
Result with that activity in scope [9223372036866891747, 9223372036866891746]
```

## Example Output From Flutter Beta (2.13.0-0.2.pre)

```
Results
Created activity 9223372036866913749
Result with that activity in scope: [0, 0]
Created activity 9223372036866913750
Result with that activity in scope [0, 0]
```