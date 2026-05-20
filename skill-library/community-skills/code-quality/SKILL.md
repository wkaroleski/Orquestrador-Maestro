# Code Quality

> Code quality patterns including linting, formatting, metrics, and automated quality gates

## When to Use

- Setting up code quality standards
- CI/CD quality gates
- Linting configuration
- Code review automation

## Rules

### Linting (ESLint)
```json
{
  "extends": ["plugin:react/recommended", "prettier"],
  "rules": {
    "no-unused-vars": "error",
    "no-console": "warn"
  }
}
```

### Formatting (Prettier)
```json
{
  "semi": true,
  "singleQuote": true,
  "trailingComma": "es5"
}
```

### Quality Metrics
- Complexity: < 10
- Coverage: > 80%
- Technical debt: < 5%

## Commands

| Command | Description |
|---------|------------|
| `quality-gate` | Setup quality gate |
| `lint-fix` | Run linter fix |

---

*Original OpenCode Skill*
