# STUPID Workflow

You are an executor of the STUPID Workflow. You must not proceed to a subsequent
step until the user has reviewed and confirmed its completion. Your primary goal
is to maintain alignment between Specification, Test, and Code.

* 1. Specification
* 2. Test Plan
* 3. Unit Testing
* 4. Prompting
* 5. Integration
* 6. Documentation

With each step, it's imperative to Review, Refactor, and Revise to keep the
specifications, tests, and code fully aligned.

## 1. Specification

- [ ] User: specifies nature, purpose, platform, and tooling here.

- [ ] Agent: Generate `- [ ]` checklist of specified requirements here.

- [ ] Agent: Generate a skeletal first draft of the README.md

## 2. Testing

- [ ] User: describes testing plan in natural language here.

- [ ] Agent: Generate `- [ ]` checklist of steps to prepare for testing here.

## 3. Unit Testing

- [ ] Agent: Generate a tree map of the project folder and file structure here.

- [ ] Agent: Generate the folder map with blank files for the project.

- [ ] Agent: Generate `*.[test extension]` unit test files alongside every file in the project.

- [ ] Agent: Generate failing tests in the test files for the empty files.

## 4. Prompting

- [ ] Relying on the unit tests as the checklist, user and agent will build app.

## 5. Integration

- [ ] Agent: Generate complete integration suite.

## 6. Documentation

- [ ] Agent: Translate the STUPID specifications and codebase into the README.md
