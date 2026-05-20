# 🪝 GLOBAL SKILLS HOOKS
## "Complete Skill Reference with Descriptions"

> **Location:** `~/.global-skills/`
> **Total Skills:** 685
> **Updated:** 2026-02-04

---

## ⚡ REGRA DE USO DE SKILLS (OBRIGATORIO)

### ANTES DE INICIAR QUALQUER TASK, VOCE DEVE:

1. **Ler este arquivo** (`~/.global-skills/HOOKS.md`) para identificar skills relevantes
2. **Invocar skill(s)** necessaria(s) usando `/skill:nome-da-skill`
3. **Seguir regras e padroes** da skill durante toda a task

### FLUXO OBRIGATORIO:

```bash
# 1. Recebe task do usuario
user> /implement "nova feature"

# 2. Verificar hooks para identificar skills
[HOOKS] Lendo ~/.global-skills/HOOKS.md...
[HOOKS] Task identificada: Backend API
[HOOKS] Skills recomendadas:
[HOOKS]   - /skill:typescript-expert
[HOOKS]   - /skill:api-security
[HOOKS]   - /skill:postgresql-expert

# 3. Invocar skills necessarias
/system> /skill:typescript-expert
/system> /skill:api-security
/system> /skill:postgresql-expert

# 4. Executar task com skills ativas
[TS-EXPERT] Implementando com types...
[API-SECURITY] Adicionando validacao...
[PG-EXPERT] Criando migrations...
```

### QUANDO INVOCAR SKILLS:

| Tipo de Task | Skill(s) Recomendada(s) |
|--------------|------------------------|
| AI/LLM features | `/skill:ai-engineer` |
| APIs REST | `/skill:rest-api-design` |
| APIs GraphQL | `/skill:graphql-expert` |
| Containers | `/skill:docker-expert` |
| Kubernetes | `/skill:kubernetes-expert` |
| Databases | `/skill:postgresql-expert` |
| Testing | `/skill:testing-expert` |
| Security | `/skill:api-security` |
| Code review | `/skill:code-reviewer` |
| Refactoring | `/skill:refactoring` |
| Performance | `/skill:performance-optimization` |
| Frontend React | `/skill:react-expert` |
| Frontend Next.js | `/skill:nextjs-expert` |
| CI/CD | `/skill:cicd-pipeline` |
| Architecture | `/skill:architecture` |
| Brainstorming | `/skill:brainstorming` |

---

## 🤖 AI & MACHINE LEARNING

### `/skill:ai-engineer`
**Description:** Build production-ready LLM applications, advanced RAG systems, and intelligent agents
**When to use:** Creating AI features, chatbots, RAG systems, agent workflows
**Rules:** LLM integration patterns, RAG architecture, Prompt engineering, Vector search, Agent orchestration

### `/skill:rag-engineer`
**Description:** Retrieval-Augmented Generation patterns including vector databases, embeddings, and RAG architectures
**When to use:** Building search systems, knowledge bases, document retrieval
**Rules:** Vector database selection, Embedding strategies, Chunking optimization

### `/skill:prompt-engineer`
**Description:** Prompt engineering patterns, techniques, and optimization strategies for LLMs
**When to use:** Improving LLM outputs, creating prompts, optimizing for accuracy
**Rules:** Prompt templates, Few-shot learning, Chain-of-thought, Prompt optimization

### `/skill:llm-integration`
**Description:** LLM API integration patterns including OpenAI, Anthropic, and multi-provider strategies
**When to use:** Integrating LLMs into applications, multi-provider setups
**Rules:** API client setup, Provider abstraction, Token management, Cost optimization

### `/skill:agent-orchestration`
**Description:** Multi-agent orchestration patterns, coordination strategies, and agent communication
**When to use:** Building multi-agent systems, agent teams, coordination workflows
**Rules:** Agent coordination, Task delegation, Communication patterns, Error handling

### `/skill:vector-database`
**Description:** Vector database patterns including pgvector, Pinecone, Weaviate, and similarity search
**When to use:** Implementing semantic search, embeddings storage, similarity matching
**Rules:** Index selection, Similarity metrics, Hybrid search, Index optimization

### `/skill:autonomous-agents`
**Description:** Autonomous agent patterns for building self-directed AI systems
**When to use:** Creating autonomous workflows, self-improving agents
**Rules:** Autonomy patterns, Goal setting, Self-monitoring, Adaptation strategies

### `/skill:langchain-architecture`
**Description:** LangChain framework architecture and patterns
**When to use:** Building LangChain applications, chains, agents
**Rules:** Chain design, Agent integration, Memory management, Tool calling

### `/skill:langgraph`
**Description:** LangGraph patterns for building complex agent workflows
**When to use:** Creating state machines, complex agent flows, workflow automation
**Rules:** Graph design, State management, Edge conditions, Cycle handling

---

## 🔐 SECURITY

### `/skill:api-security`
**Description:** Implement secure API design patterns including authentication, authorization, input validation, rate limiting
**When to use:** Building APIs, implementing auth, securing endpoints
**Rules:** Authentication (JWT, OAuth2), Authorization (RBAC), Input validation, API vulnerability protection

### `/skill:jwt-auth`
**Description:** JWT implementation patterns including refresh tokens, validation, and security best practices
**When to use:** Implementing token-based authentication, session management
**Rules:** Token refresh strategy, Secure signing algorithms, Token storage, Expiration management

### `/skill:oauth2-implementation`
**Description:** OAuth 2.0 flows, grants, provider integration, and token management
**When to use:** Integrating third-party auth (Google, GitHub, etc.), implementing OAuth flows
**Rules:** OAuth 2.0 flows, Provider configuration, Token exchange, Scope management

### `/skill:csrf-protection`
**Description:** Cross-site request forgery prevention patterns and token validation
**When to use:** Protecting forms, APIs from CSRF attacks
**Rules:** CSRF token generation, Token validation, Same-site cookies, Origin checking

### `/skill:sql-injection`
**Description:** SQL injection detection, prevention, and testing patterns
**When to use:** Securing database queries, preventing SQL injection
**Rules:** Parameterized queries, ORM usage, Input validation, Detection techniques

### `/skill:xss-prevention`
**Description:** Cross-site scripting detection, prevention, and content security policies
**When to use:** Protecting against XSS in user input/output
**Rules:** Output encoding, CSP configuration, DOM sanitization, Input validation

### `/skill:penetration-testing`
**Description:** Penetration testing methodologies, tools, and reporting patterns
**When to use:** Security assessments, vulnerability hunting
**Rules:** Reconnaissance, Enumeration, Vulnerability assessment, Exploitation, Reporting

### `/skill:vulnerability-scanner`
**Description:** Automated vulnerability scanning, dependency checking, and security assessment
**When to use:** Automated security checks, dependency audits
**Rules:** Dependency scanning, SAST integration, DAST patterns, Reporting

### `/skill:api-rate-limiting`
**Description:** Rate limiting patterns including token bucket, sliding window, and distributed limiting
**When to use:** Protecting APIs from abuse, rate control
**Rules:** Token bucket, Sliding window, Redis-based limiting, Response headers, User tiers

### `/skill:security-audit`
**Description:** Security auditing patterns, compliance checks, and remediation
**When to use:** Security reviews, compliance assessments
**Rules:** Audit methodology, Compliance frameworks, Risk assessment, Remediation planning

---

## 🏗️ ARCHITECTURE & PATTERNS

### `/skill:architecture`
**Description:** Architectural decision-making framework, system design, and ADR documentation
**When to use:** System design, architectural decisions, documentation
**Rules:** Requirements analysis, Trade-off evaluation, ADR documentation, System design review

### `/skill:microservices`
**Description:** Microservices patterns including service decomposition, communication, and resilience
**When to use:** Building microservices, service decomposition, inter-service communication
**Rules:** Service decomposition, API gateway, Service mesh, Circuit breaker

### `/skill:event-driven-architecture`
**Description:** Event-driven patterns including message queues, event sourcing, and CQRS
**When to use:** Event-based systems, event sourcing, CQRS
**Rules:** Event sourcing, Message queues, CQRS patterns, Kafka integration

### `/skill:clean-code`
**Description:** Clean code principles, refactoring patterns, and code readability
**When to use:** Code reviews, refactoring, improving code quality
**Rules:** Meaningful names, Functions single responsibility, Comments when needed, Formatting

### `/skill:solid-principles`
**Description:** SOLID design principles for object-oriented design
**When to use:** OOP design, code organization, SOLID compliance
**Rules:** Single Responsibility, Open/Closed, Liskov Substitution, Interface Segregation, Dependency Inversion

### `/skill:design-patterns`
**Description:** Common design patterns including Creational, Structural, and Behavioral patterns
**When to use:** Solving recurring design problems, code organization
**Rules:** Factory pattern, Observer pattern, Strategy pattern, Repository pattern

### `/skill:cqrs-implementation`
**Description:** Command Query Responsibility Segregation implementation patterns
**When to use:** Separating read/write models, scaling read operations
**Rules:** Command/Query separation, Event sourcing integration, Read models, Write models

### `/skill:event-sourcing-architect`
**Description:** Event sourcing architecture patterns for building audit-able systems
**When to use:** Systems requiring audit trail, replay capability
**Rules:** Event store design, Snapshots, Projections, Event versioning

---

## 💻 LANGUAGES

### `/skill:typescript-expert`
**Description:** Master TypeScript with advanced types, generics, decorators, and strict typing patterns
**When to use:** TypeScript projects, type safety, advanced patterns
**Rules:** Strict mode, No 'any', Generic types, Decorators, Utility types

### `/skill:nodejs-expert`
**Description:** Production-ready Node.js patterns including async/await, streams, clustering, and error handling
**When to use:** Node.js backend development, performance optimization
**Rules:** Async/await patterns, Stream processing, Cluster mode, Error handling

### `/skill:python-expert`
**Description:** Python patterns including async/await, type hints, FastAPI, and best practices
**When to use:** Python backend, FastAPI, data processing
**Rules:** Type hints, Async patterns, Pydantic validation, FastAPI patterns

### `/skill:rust-pro`
**Description:** Rust programming patterns, memory safety, and systems programming
**When to use:** Systems programming, WASM, high-performance code
**Rules:** Memory safety, Ownership model, Borrowing, Lifetime management

### `/skill:golang-pro`
**Description:** Go programming patterns, concurrency, and best practices
**When to use:** Go backend, microservices, high-concurrency systems
**Rules:** Goroutines, Channels, Error handling, Concurrency patterns

### `/skill:java-pro`
**Description:** Java patterns, Spring framework, and enterprise best practices
**When to use:** Java backend, Spring applications, enterprise systems
**Rules:** Spring patterns, Dependency injection, Concurrency, Performance

### `/skill:javascript-pro`
**Description:** JavaScript best practices, patterns, and modern ES6+ features
**When to use:** JavaScript projects, frontend/backend JS
**Rules:** ES6+ features, Async/await, Error handling, Module patterns

### `/skill:c-pro`
**Description:** C/C++ programming patterns, memory management, and systems programming
**When to use:** Systems programming, embedded, performance-critical code
**Rules:** Memory management, Pointers, Memory safety, Performance

---

## 🎨 FRONTEND & UI

### `/skill:react-expert`
**Description:** React patterns including hooks, context, performance optimization, and modern patterns
**When to use:** React frontend development, SPAs
**Rules:** Custom hooks, Context API, React.memo, Code splitting, Server components

### `/skill:nextjs-expert`
**Description:** Next.js patterns including app router, server components, SSR, and deployment
**When to use:** Next.js fullstack applications, SSR, API routes
**Rules:** App router patterns, Server components, API routes, Image optimization

### `/skill:tailwindcss-expert`
**Description:** Tailwind CSS patterns including configuration, custom utilities, and responsive design
**When to use:** Styling with Tailwind, responsive design, custom configs
**Rules:** Utility-first, Custom config, Responsive design, Dark mode, Component extraction

### `/skill:vue-developer`
**Description:** Vue.js patterns including Composition API, Pinia, and performance optimization
**When to use:** Vue.js frontend development
**Rules:** Composition API, State management, Performance, TypeScript integration

### `/skill:angular-migration`
**Description:** Angular patterns and migration strategies from older versions
**When to use:** Angular projects, legacy migrations
**Rules:** Standalone components, Signals, RxJS patterns, Migration strategies

### `/skill:ui-ux-designer`
**Description:** UI/UX design principles, component design, and user experience patterns
**When to use:** Designing interfaces, user experience
**Rules:** Component design, User flow, Accessibility, Visual hierarchy

### `/skill:accessibility-compliance-accessibility-audit`
**Description:** Accessibility patterns, WCAG compliance, and a11y auditing
**When to use:** Making apps accessible, WCAG compliance
**Rules:** WCAG guidelines, ARIA, Keyboard navigation, Screen reader support

---

## 🌐 APIs & PROTOCOLS

### `/skill:rest-api-design`
**Description:** RESTful API design principles, naming conventions, and versioning strategies
**When to use:** Designing REST APIs, API contracts
**Rules:** Resource naming, HTTP methods, Status codes, Versioning, Documentation

### `/skill:graphql-expert`
**Description:** GraphQL patterns including schema design, resolvers, subscriptions, and optimization
**When to use:** GraphQL APIs, flexible queries
**Rules:** Schema design, Resolver patterns, Query optimization, Subscriptions

### `/skill:websocket-expert`
**Description:** WebSocket patterns including real-time communication, socket.io, and connection management
**When to use:** Real-time features, chat, live updates
**Rules:** Connection management, Reconnection strategies, Room patterns, Authentication

### `/skill:grpc-expert`
**Description:** gRPC patterns including protobuf, streaming, and service definitions
**When to use:** High-performance APIs, microservices communication
**Rules:** Protobuf definitions, Streaming, Interceptors, Error handling

---

## 🗄️ DATABASES

### `/skill:postgresql-expert`
**Description:** PostgreSQL patterns including advanced queries, indexes, partitions, and optimization
**When to use:** PostgreSQL databases, query optimization
**Rules:** Index strategies, Query optimization, Partitioning, JSON columns, Full-text search

### `/skill:redis-expert`
**Description:** Redis patterns including caching, sessions, pub/sub, and data structures
**When to use:** Caching, sessions, real-time features
**Rules:** Caching strategies, Session management, Pub/sub patterns, Data structures

### `/skill:prisma-expert`
**Description:** Prisma ORM patterns including schema design, migrations, and performance
**When to use:** Node.js + SQL with Prisma
**Rules:** Schema design, Relation patterns, Migration strategies, Query optimization

### `/skill:mongodb-expert`
**Description:** MongoDB patterns including schema design, indexing, and aggregation
**When to use:** Document databases, flexible schemas
**Rules:** Schema design, Indexing, Aggregation pipeline, Data modeling

### `/skill:supabase-patterns`
**Description:** Supabase patterns including auth, database, real-time, and storage
**When to use:** Supabase projects, backend-as-a-service
**Rules:** Auth patterns, RLS policies, Realtime subscriptions, Storage

### `/skill:database-migrations`
**Description:** Database migration patterns including safe schema changes and zero-downtime deployments
**When to use:** Schema changes, migrations in production
**Rules:** Safe migrations, Zero-downtime deploys, Rollback strategies, Data consistency

### `/skill:sql-optimization-patterns`
**Description:** SQL query optimization patterns, execution plans, and performance tuning
**When to use:** Slow queries, performance tuning
**Rules:** Query analysis, Index usage, Execution plans, Query rewriting

---

## ☁️ CLOUD & INFRASTRUCTURE

### `/skill:docker-expert`
**Description:** Docker patterns including multi-stage builds, optimization, and orchestration
**When to use:** Containerizing applications, Dockerfiles
**Rules:** Multi-stage builds, Layer optimization, Security best practices, Docker Compose

### `/skill:kubernetes-expert`
**Description:** Kubernetes patterns including deployments, services, ingress, and helm charts
**When to use:** K8s deployments, container orchestration
**Rules:** Pod/deployment patterns, Service discovery, Ingress, Helm charts, Security contexts

### `/skill:terraform-expert`
**Description:** Infrastructure as Code patterns using Terraform, modules, and state management
**When to use:** Cloud infrastructure provisioning
**Rules:** Module design, State management, Remote backend, Workspace patterns

### `/skill:aws-skills`
**Description:** AWS patterns including EC2, S3, Lambda, RDS, and other AWS services
**When to use:** AWS infrastructure, cloud deployment
**Rules:** Service selection, IAM, Cost optimization, Best practices per service

### `/skill:aws-lambda`
**Description:** Serverless patterns including Lambda functions, API Gateway, and event-driven
**When to use:** Serverless applications, AWS Lambda
**Rules:** Cold start optimization, Layers, API Gateway, DynamoDB integration

### `/skill:azure-expert`
**Description:** Microsoft Azure patterns including App Service, Functions, and Azure SQL
**When to use:** Azure cloud infrastructure
**Rules:** App Service, Azure Functions, Azure SQL, DevOps integration

### `/skill:gcp-expert`
**Description:** Google Cloud Platform patterns including Cloud Run, Cloud Functions, and Firestore
**When to use:** GCP cloud infrastructure
**Rules:** Cloud Run, Cloud Functions, Firestore, Cloud Build

### `/skill:serverless-framework`
**Description:** Serverless Framework patterns for multi-cloud serverless deployments
**When to use:** Serverless applications across providers
**Rules:** Service configuration, Lambda functions, Event sources, Plugin usage

### `/skill:vercel-deployment`
**Description:** Vercel deployment patterns including edge functions, ISR, and preview
**When to use:** Deploying Next.js, frontend apps
**Rules:** Edge functions, ISR configuration, Preview deployments, Environment variables

### `/skill:cicd-pipeline`
**Description:** CI/CD patterns including GitHub Actions, GitLab CI, deployment strategies
**When to use:** Building CI/CD pipelines, automation
**Rules:** Pipeline stages, Quality gates, Environment promotion, Secret management

---

## 🧪 TESTING

### `/skill:testing-expert`
**Description:** Testing patterns including unit, integration, e2e tests, mocking, and coverage strategies
**When to use:** Setting up test suites, test strategies
**Rules:** Test pyramid, Mocking strategies, Integration tests, Coverage targets

### `/skill:tdd`
**Description:** Test-Driven Development patterns including red-green-refactor cycle
**When to use:** TDD approach, test-first development
**Rules:** Red-green-refactor cycle, Test organization, First make it work, Then make it right

### `/skill:unit-testing`
**Description:** Unit testing patterns including mocking, assertions, and test organization
**When to use:** Writing unit tests, isolated test coverage
**Rules:** One expectation per test, Mock external dependencies, Test behavior not implementation

### `/skill:integration-testing`
**Description:** Integration testing patterns including API testing, database integration
**When to use:** Testing component integration, API endpoints
**Rules:** API integration tests, Database integration, Service mocking, Test fixtures

### `/skill:e2e-testing`
**Description:** End-to-end testing patterns including user journeys, cross-browser testing
**When to use:** E2E test suites, user flow testing
**Rules:** User journey coverage, Cross-browser testing, CI integration, Flakiness prevention

### `/skill:playwright-expert`
**Description:** Playwright patterns including e2e tests, selectors, page objects
**When to use:** Writing Playwright tests, browser automation
**Rules:** Best selectors, Page object patterns, CI integration, Parallel execution

### `/skill:mocking-strategies`
**Description:** Mocking patterns including unit mocks, API mocking with MSW
**When to use:** Mocking dependencies, API simulation
**Rules:** Mock external APIs, Mock database, Mock time, Mock file system

---

## ⚡ PERFORMANCE

### `/skill:performance-optimization`
**Description:** Performance patterns including profiling, caching, and optimization
**When to use:** Performance tuning, profiling applications
**Rules:** Profiling techniques, Caching strategies, Bundle optimization, CDN usage

### `/skill:redis-caching`
**Description:** Redis caching patterns including cache-aside, TTL, and invalidation
**When to use:** Implementing caching layers, cache invalidation
**Rules:** Cache-aside pattern, TTL strategies, Cache invalidation, Serialization

### `/skill:database-optimizer`
**Description:** Database performance optimization patterns and query tuning
**When to use:** Slow database queries, performance issues
**Rules:** Query analysis, Index optimization, Connection pooling, Query rewriting

---

## 🔄 WORKFLOW & DEVOPS

### `/skill:brainstorming`
**Description:** Transform vague ideas into validated designs through reasoning and collaboration
**When to use:** Planning features, design discussions
**Rules:** Use before creative work, Incremental reasoning, Collaborative validation

### `/skill:git-workflow`
**Description:** Git workflow patterns including branching strategies and commit conventions
**When to use:** Git operations, team workflows
**Rules:** Branching strategy, Commit conventions, Merge strategies, Tagging releases

### `/skill:refactoring`
**Description:** Code refactoring patterns including extract method, rename, and technical debt
**When to use:** Improving existing code, reducing technical debt
**Rules:** Extract method, Rename refactoring, Technical debt tracking, Incremental refactoring

### `/skill:technical-debt`
**Description:** Technical debt identification, prioritization, and repayment strategies
**When to use:** Debt assessment, repayment planning
**Rules:** Debt identification, Prioritization matrix, Repayment planning, Debt tracking

### `/skill:documentation`
**Description:** Technical documentation patterns including README, API docs, and developer experience
**When to use:** Writing documentation, improving DX
**Rules:** README structure, API documentation, Code comments, ADR

### `/skill:code-reviewer`
**Description:** Elite code review expert specializing in security, performance, and quality
**When to use:** Code reviews, quality assessment
**Rules:** Security vulnerability detection, Performance optimization, Quality standards

### `/skill:concise-planning`
**Description:** Concise planning patterns for efficient task breakdown
**When to use:** Planning sprints, task estimation
**Rules:** Task breakdown, Estimation, Prioritization, Clear deliverables

---

## 📈 BUSINESS & MARKETING

### `/skill:ab-testing`
**Description:** A/B testing patterns including hypothesis, experiment design, and statistical analysis
**When to use:** Conversion optimization, feature testing
**Rules:** Hypothesis definition, Sample size calculation, Statistical significance, Result interpretation

### `/skill:seo-expert`
**Description:** SEO patterns including technical SEO, content optimization, and analytics
**When to use:** Improving search rankings, SEO audits
**Rules:** On-page SEO, Technical SEO, Link building, Schema markup

### `/skill:analytics-tracking`
**Description:** Analytics patterns including event tracking, dashboards, and metrics
**When to use:** Setting up analytics, tracking user behavior
**Rules:** Event tracking, Metric definition, Dashboard design, Data visualization

### `/skill:product-strategy`
**Description:** Product management patterns including roadmap planning and metrics
**When to use:** Product planning, strategy definition
**Rules:** Roadmap planning, User research, Feature prioritization, OKR definition

### `/skill:user-research`
**Description:** User research patterns including interviews, usability testing, and personas
**When to use:** Understanding users, research planning
**Rules:** Interview techniques, Usability testing, Persona creation, Journey mapping

### `/skill:pricing-strategy`
**Description:** Pricing patterns including value-based pricing, tier design, and psychology
**When to use:** Pricing strategy, revenue optimization
**Rules:** Value-based pricing, Tier design, Price anchoring, Discount strategies

### `/skill:copywriting`
**Description:** Conversion-focused copywriting patterns for marketing
**When to use:** Writing copy, marketing content
**Rules:** AIDA framework, Persuasive writing, CTA optimization, SEO copywriting

---

## 📱 MOBILE

### `/skill:react-native-architecture`
**Description:** React Native patterns including architecture, navigation, and state management
**When to use:** React Native app development
**Rules:** Architecture patterns, Navigation, State management, Native modules

### `/skill:flutter-expert`
**Description:** Flutter patterns including widget design, state management, and performance
**When to use:** Flutter app development
**Rules:** Widget composition, State management, Performance, Platform channels

### `/skill:ios-developer`
**Description:** iOS development patterns including SwiftUI, UIKit, and Swift
**When to use:** iOS app development
**Rules:** SwiftUI patterns, UIKit integration, Swift concurrency, XcodeGen

### `/skill:android-developer`
**Description:** Android development patterns including Jetpack Compose, Kotlin, and architecture
**When to use:** Android app development
**Rules:** Jetpack Compose, Kotlin patterns, Architecture components, Gradle

---

## 📡 OBSERVABILITY

### `/skill:logging-monitoring`
**Description:** Logging and monitoring patterns including structured logs, metrics, and alerts
**When to use:** Setting up observability, monitoring
**Rules:** Structured logging, Metric collection, Alert configuration, SLO/SLI definition

### `/skill:prometheus-configuration`
**Description:** Prometheus patterns including metrics, alerting, and integration
**When to use:** Setting up Prometheus monitoring
**Rules:** Metric design, Alerting rules, Service discovery, Integration with Grafana

### `/skill:grafana-dashboards`
**Description:** Grafana dashboard patterns including queries, visualizations, and alerts
**When to use:** Creating monitoring dashboards
**Rules:** Query optimization, Visualization selection, Alert configuration, Dashboard organization

### `/skill:distributed-tracing`
**Description:** Distributed tracing patterns including OpenTelemetry, Jaeger, and Zipkin
**When to use:** Tracing distributed systems, debugging microservices
**Rules:** Trace propagation, Span design, Sampling strategies, Integration

---

## 🔌 INTEGRATIONS

### `/skill:stripe-integration`
**Description:** Stripe payment integration patterns including checkout, subscriptions, and webhooks
**When to use:** Implementing payments, subscriptions
**Rules:** Checkout integration, Subscription management, Webhook handling, Error handling

### `/skill:twilio-communications`
**Description:** Twilio patterns including SMS, voice, and messaging
**When to use:** Implementing SMS, voice, messaging features
**Rules:** SMS sending, Voice calls, Messaging, Webhooks

### `/skill:algolia-search`
**Description:** Algolia search patterns including indexing, faceting, and relevance
**When to use:** Implementing search, discovery features
**Rules:** Index configuration, Search optimization, Faceting, Relevance tuning

### `/skill:webhook-handler`
**Description:** Webhook patterns including receiving, processing, and security
**When to use:** Implementing webhook endpoints, event processing
**Rules:** Signature verification, Retry logic, Idempotency, Error handling

### `/skill:zapier-make-patterns`
**Description:** Zapier/Make automation patterns for no-code integrations
**When to use:** Building automations, no-code workflows
**Rules:** Trigger setup, Action configuration, Filter logic, Error handling

---

## 📊 DATA ENGINEERING

### `/skill:data-engineer`
**Description:** Data engineering patterns including pipelines, ETL, and data modeling
**When to use:** Building data pipelines, ETL processes
**Rules:** Pipeline design, ETL patterns, Data modeling, Quality checks

### `/skill:ml-engineer`
**Description:** Machine learning engineering patterns including MLOps and model deployment
**When to use:** ML model deployment, MLOps
**Rules:** Model versioning, Feature stores, Model serving, Monitoring

### `/skill:airflow-dag-patterns`
**Description:** Apache Airflow patterns including DAG design, operators, and scheduling
**When to use:** Scheduling data pipelines, workflow automation
**Rules:** DAG design, Task dependencies, Operators, SLAs

### `/skill:dbt-transformation-patterns`
**Description:** DBT patterns including models, tests, and macros
**When to use:** Data transformations, analytics engineering
**Rules:** Model design, Testing, Macros, Materializations

### `/skill:spark-optimization`
**Description:** Apache Spark patterns including optimization, streaming, and DataFrames
**When to use:** Big data processing, Spark applications
**Rules:** Performance optimization, Streaming, Partitioning, Caching

---

## 📦 ORIGINAL & SPECIAL SKILLS

### `/skill:skill-supabase-rls`
**Description:** Supabase Row Level Security patterns including policies, performance, and troubleshooting
**When to use:** Supabase database security, RLS policies
**Rules:** RLS policy design, Performance optimization, Common errors, Troubleshooting

### `/skill:testing-strategy`
**Description:** Testing strategy patterns including coverage goals and test organization
**When to use:** Defining testing strategy, quality standards
**Rules:** Coverage targets, Test organization, Pyramid structure, Automation strategy

### `/skill:code-quality`
**Description:** Code quality patterns including linting, formatting, and quality gates
**When to use:** Maintaining code quality, CI quality gates
**Rules:** Linting, Formatting, Quality metrics, Automated checks

---

## 🚀 QUICK REFERENCE

| Need | Use This Skill |
|------|----------------|
| AI features | `/skill:ai-engineer` |
| API security | `/skill:api-security` |
| Docker containers | `/skill:docker-expert` |
| Testing setup | `/skill:testing-expert` |
| System design | `/skill:architecture` |
| Code review | `/skill:code-reviewer` |
| TypeScript | `/skill:typescript-expert` |
| React | `/skill:react-expert` |
| PostgreSQL | `/skill:postgresql-expert` |
| Kubernetes | `/skill:kubernetes-expert` |
| Performance | `/skill:performance-optimization` |
| Refactoring | `/skill:refactoring` |

---

*Global Skills Hooks v1.0 - 2026-02-04*
*Based on antigravity-awesome-skills (681 skills)*
