---
name: my-write-tests
description: Write unit tests for changes on the current git branch, following existing test patterns and style guides in the repo.
allowed-tools: Read, Grep, Glob, Bash, Edit, Write
---

# Write Tests

- Get context by indexing all changes on the current git branch
- Get context by analyzing existing unit tests and their patterns in the current repo
- Follow the style-guide in the repo and existing unit tests
- One test file per class
- Don't include comments
- Once complete, provide a one-line summary for each test added, what it tests, and why it was added
- Validate tests pass. If they don't iterate on the tests until they do. The business logic should not be changed unless a bug is found

## Validate tests
If in a java project, use the following commands:
- `./gradlew test` - Run all tests
- `./gradlew test --tests "com.didalgo.intellij.chatgpt.chat.metadata.UsageAggregatorTest"` - Run a specific test class
