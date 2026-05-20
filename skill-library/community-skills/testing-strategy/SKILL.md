# Testing Strategy

> Comprehensive testing strategy patterns including test pyramid, coverage goals, and automation strategy

## When to Use

- Defining testing strategy for new projects
- Improving test coverage
- Setting quality standards
- Planning automation

## Rules

### Test Pyramid
```
        /\
       /  \     E2E Tests (few, slow)
      /____\
     /      \
    /        \   Integration Tests (some, medium)
   /__________\
  /            \
 /              \  Unit Tests (many, fast)
/________________\
```

### Coverage Targets
- Unit Tests: 80%+
- Integration Tests: 50%+
- E2E Tests: 20% (critical paths)

## Commands

| Command | Description |
|---------|------------|
| `test-strategy` | Define testing strategy |
| `test-coverage` | Set coverage goals |

## Automation Strategy

1. Start with unit tests
2. Add integration tests for APIs
3. E2E for critical user journeys
4. Automate in CI/CD

---

*Original OpenCode Skill*
