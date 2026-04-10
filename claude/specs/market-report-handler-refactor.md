# Market Report Handler Refactor: Dual Entry Point (Webhook + REST API)

## Summary

Refactor market report triggering to support two entry points — the existing webhook flow (fire-and-forget on incoming ZIM messages) and a new REST API flow (synchronous, caller-initiated). Introduce a handler pattern where each `MarketReportType` (TOUR, OPEN_HOUSE) owns its validation, context-building, and prompt formatting, while the service layer orchestrates entry-point-specific behavior. The handler's `MarketReportTriggerContext` serves as the unified internal model that both entry points produce and the shared submission logic consumes.

**Delivery**: Two MRs.
- **MR1 (Refactor)** — COMPLETE: Interface rename, `validateContext` removal, webhook fan-out to all handlers, comprehensive handler tests (52 tests). `OpenHouseMarketReportHandler` removed as dead code.
- **MR2 (REST API)**: REST API endpoint, request model, re-add `OpenHouseMarketReportHandler` with real `buildContextOrThrow`.

**MR**: https://gitlab.zgtools.net/zillow/mercury-web/messaging-handler/beth-messaging-service/-/merge_requests/830
**Branch**: `worktree-market-report-rest-api`
**Jira**: HUB-4404
**Repo spec**: `.specs/market-report-handler-refactor.md`

## Background

### Current State

Market reports are triggered exclusively via Switchboard webhooks. When a ZIM message arrives:
1. Webhook event handlers (`MessageCreatedWebhookEventHandler`, `NewMessageWebhookEventHandler`) call `MarketReportService.triggerMarketReportIfEligible()`
2. The service delegates to `TourMarketReportHandler.buildTriggerContextFromWebhook()` which filters the message (sender persona, tour rich object, agent team membership) and returns `Optional<MarketReportTriggerContext>`
3. If eligible, the handler submits to Deep Research via `triggerMarketReportOrThrow()`

This refactor (in progress on `worktree-market-report-rest-api`) extracted the handler pattern from a monolithic `MarketReportService`. The handler interface, factory, base class, and two concrete handlers (TOUR, OPEN_HOUSE) already exist.

### What Needs to Change

The current handler interface has a design issue: `triggerMarketReportOrThrow()` calls a `validateContext()` hook before submitting. For the webhook flow, this causes double validation — `buildTriggerContextFromWebhook()` already validates during context building, then `validateContext()` re-validates (including redundant external calls to PDM and Split).

The new REST API entry point needs different semantics:
- **Webhook**: filter -> build context -> submit (silent skip if ineligible)
- **API**: validate -> build context -> submit (throw `BadRequestException` if ineligible)

### Relevant Files

| File | Role |
|------|------|
| `service/productexperience/marketreport/MarketReportService.java` | Orchestrates entry points, owns `@Async` |
| `service/productexperience/marketreport/MarketReportTriggerContext.java` | Unified internal model (the "adapter") |
| `service/productexperience/marketreport/handler/MarketReportHandler.java` | Handler interface |
| `service/productexperience/marketreport/handler/BaseMarketReportHandler.java` | Shared submission logic, Deep Research client call |
| `service/productexperience/marketreport/handler/TourMarketReportHandler.java` | TOUR: webhook filtering, prompts, agent team eligibility |
| `service/productexperience/marketreport/handler/MarketReportHandlerFactory.java` | Type -> handler lookup, `getAllHandlers()` for webhook fan-out |
| `model/api/enums/MarketReportType.java` | TOUR, OPEN_HOUSE enum |
| `service/hooks/post/handlers/MessageCreatedWebhookEventHandler.java` | Webhook caller (V2) |
| `service/hooks/post/handlers/NewMessageWebhookEventHandler.java` | Webhook caller (V1) |

### Design Doc

The [Market Report Design Doc](https://docs.google.com/document/d/1lQuZZcDcU9hZuzsQ-Fh7vb2dI8QOqe2zawsuKQtFoNs/edit?tab=t.4rpz63f0d97q) describes the current webhook-only flow. The API exposure is needed so that non-webhook callers (e.g., Open House flows triggered by concierge reps) can initiate market reports directly.

## Requirements

### Functional

- Each handler defines two **abstract** context-building methods with distinct behavioral contracts:
  - `buildContextIfEligible()` — returns `Optional<MarketReportTriggerContext>`. Empty means "not applicable" (expected, not an error). Used by the webhook flow. Handlers that don't support webhooks throw `UnsupportedOperationException`.
  - `buildContextOrThrow()` — returns `MarketReportTriggerContext` or throws `BadRequestException`. Used by the API flow. Handlers that don't support the API yet throw `UnsupportedOperationException`.
- Both methods are abstract on the interface — every handler must explicitly implement both, making a conscious choice about each flow. The compiler enforces completeness.
- Each handler defines prompt methods (`getQueryPrompt`, `getContextPrompt`) consumed by the shared submission logic.
- `submitMarketReport()` is public on the interface, implemented in `BaseMarketReportHandler`. Accepts a `MarketReportTriggerContext` and submits to Deep Research. No validation — the context is assumed valid by the time it reaches submission. The service orchestrates build + submit separately.
- `MarketReportService` exposes two entry points:
  - `triggerMarketReportIfEligible(conversationDetails, zimMessage, sender, recipient)` — async, calls `buildContextIfEligible`, silently skips if empty, catches submission errors.
  - `triggerMarketReportOrThrow(type)` — sync, delegates to handler's `buildContextOrThrow` then `submitMarketReport`. Lets exceptions propagate. Added as functional code in MR1 (the handler is what throws `UnsupportedOperationException`, not the service).
- Remove the `validateContext()` hook from `BaseMarketReportHandler` and the handler interface — validation is owned by each context-building method.
- The webhook flow iterates all registered handlers via `MarketReportHandlerFactory.getAllHandlers()` — each handler decides its own eligibility. No type is hardcoded at the call site.
- The API flow accepts a `MarketReportType` parameter to select a specific handler.

### Non-Functional

- No double external calls (PDM team membership, Split feature flags) in the webhook flow.
- No double metric increments for the same eligibility check.
- Existing webhook behavior is unchanged — no feature flag needed for the refactor itself.

## Acceptance Criteria

- **GIVEN** a webhook message eligible for TOUR **WHEN** `triggerMarketReportIfEligible` is called **THEN** `buildContextIfEligible` runs once, `submitMarketReport` is called, and a request ID is logged.
- **GIVEN** a webhook message not eligible for TOUR **WHEN** `triggerMarketReportIfEligible` is called **THEN** `buildContextIfEligible` returns empty, no submission occurs, no error is logged.
- **GIVEN** `submitMarketReport` throws during the webhook flow **WHEN** the exception propagates **THEN** it is caught and logged as a warning (not rethrown).
- **GIVEN** the webhook flow **WHEN** `triggerMarketReportIfEligible` is called **THEN** all registered handlers are iterated and each decides its own eligibility independently.
- **GIVEN** any handler's `buildContextIfEligible` **WHEN** called for an eligible message **THEN** PDM and Split are called at most once (no double validation).
- **GIVEN** the `validateContext()` method **WHEN** inspecting the handler interface and base class **THEN** it no longer exists.

## Affected Components

### MR1 (Refactor)

| Layer | File(s) | Change |
|-------|---------|--------|
| Interface | `handler/MarketReportHandler.java` | Replace `buildTriggerContextFromWebhook` with abstract `buildContextIfEligible`; add abstract `buildContextOrThrow`; replace `triggerMarketReportOrThrow` with `submitMarketReport`; remove `validateContext` |
| Base class | `handler/BaseMarketReportHandler.java` | Rename `triggerMarketReportOrThrow` -> `submitMarketReport`; remove `validateContext()` call and method |
| TOUR handler | `handler/TourMarketReportHandler.java` | Rename `buildTriggerContextFromWebhook` -> `buildContextIfEligible`; remove `validateContext` override; add `buildContextOrThrow` that throws `UnsupportedOperationException`; restore `ZIM_DEEP_RESEARCH_EXPERIMENT` feature flag check; refactor `buildContextIfEligible` into validation phases |
| Factory | `handler/MarketReportHandlerFactory.java` | Add `getAllHandlers()` for webhook fan-out |
| Service | `marketreport/MarketReportService.java` | Update `triggerMarketReportIfEligible` to iterate all handlers via `getAllHandlers()` with `buildContextIfEligible` + `submitMarketReport`; add `triggerMarketReportOrThrow` with real delegation logic (handler throws) |
| Tests | `MarketReportServiceTest.java` | Update method names in existing tests; add tests for `triggerMarketReportOrThrow` delegation |
| Tests (NEW) | `handler/TourMarketReportHandlerTest.java` | Comprehensive `buildContextIfEligible` coverage including parameterized persona validation, team membership edge cases, address extraction |
| Tests (NEW) | `handler/BaseMarketReportHandlerTest.java` | `submitMarketReport` error handling, request field verification, zip code extraction |
| Tests (NEW) | `handler/MarketReportHandlerFactoryTest.java` | `getHandler`, `getAllHandlers` |
| Cleanup | `OpenHouseMarketReportHandler.java` | Removed entirely (dead code, deferred to MR2) |
| Cleanup | `ConversationQueryDatafetcher.java` | Revert unrelated spotless import reorder to keep diff focused |

### MR2 (REST API)

| Layer | File(s) | Change |
|-------|---------|--------|
| Controller (NEW) | TBD | REST endpoint for triggering market reports |
| Request model (NEW) | `MarketReportApiRequest.java` | API request body |
| OPEN_HOUSE handler (NEW) | `handler/OpenHouseMarketReportHandler.java` | Re-add with real `buildContextOrThrow` implementation |
| Tests (NEW) | `OpenHouseMarketReportHandlerTest.java` | `buildContextOrThrow` validation |

**Dependency**: MR2's Open House API flow will not be end-to-end functional until event handling (step 4 in the design doc) supports the Concierge persona. That work is tracked separately.

## API Changes

None in MR1. MR2 will define the REST endpoint and request/response models.

## Data Model Changes

None. `MarketReportTriggerContext` is unchanged.

## Open Questions

- **Deep Research `userId` for the API path**: In the webhook flow, `context.getSender().decodedZuid()` is the Consumer who sent the message. For the API flow (e.g., concierge triggering Open House), who should be the sender / Deep Research `userId`? Resolve when designing `MarketReportApiRequest` in MR2.

## Design Decisions

| Decision | Resolution | Rationale |
|----------|-----------|-----------|
| `buildContextIfEligible` / `buildContextOrThrow` | **Abstract** on interface | Every handler must explicitly implement both. Compiler enforces completeness — no silent no-ops from inherited defaults. |
| `submitMarketReport` visibility | **Public** on interface | Service orchestrates build + submit separately. Keeps error handling per entry point (catch vs propagate) in the service. |
| OH handler in MR1 | **Removed** | Dead code — no webhook or API flow uses it yet. Re-add in MR2 with real `buildContextOrThrow` implementation. |
| TOUR `buildContextOrThrow` | **Throws `UnsupportedOperationException`** | TOUR API not in scope. No use case yet. Resolve in MR2 if needed. |
| Service `triggerMarketReportOrThrow` | **Real delegation** in MR1 | Service has the real orchestration: get handler -> `buildContextOrThrow` -> `submitMarketReport`. Handler is what throws. When MR2 lands, only the handler changes. |
| `validateContext` | **Removed** | Validation is owned by each `build*` method. Eliminates double validation in webhook flow. |
| Rich object pattern | **Rejected** | RO validation is thin; market report validation is heavyweight with external calls. Webhook/API have fundamentally different error semantics. `MarketReportTriggerContext` already serves as the adapter. |
| `userId` change (`getSenderId` -> `decodedZuid`) | **Intentional** | The `User.decodedZuid()` is the correct source. Old comment was misleading. |
| DataFetcher import reorder | **Revert** in MR1 | Keep diff focused on market report changes. |

## Implementation Notes

### Handler Interface

```java
public interface MarketReportHandler {
    MarketReportType getType();
    String getQueryPrompt(String address, String zipCode);
    String getContextPrompt(String address);

    Optional<MarketReportTriggerContext> buildContextIfEligible(
            ZIMInternalConversationDetails conversationDetails, ZIMMessage message,
            User sender, User recipient);

    MarketReportTriggerContext buildContextOrThrow();

    String submitMarketReport(MarketReportTriggerContext context);
}
```

### Service Entry Points

```java
@Service
@Log4j2
public class MarketReportService {
    private final MarketReportHandlerFactory handlerFactory;

    @Async(value = "contextPassingExecutor")
    public void triggerMarketReportIfEligible(
            ZIMInternalConversationDetails conversationDetails, ZIMMessage zimMessage,
            User sender, User recipient) {
        for (MarketReportHandler handler : handlerFactory.getAllHandlers()) {
            handler.buildContextIfEligible(conversationDetails, zimMessage, sender, recipient)
                    .ifPresent(context -> {
                        try {
                            String requestId = handler.submitMarketReport(context);
                            log.info("Market Report triggered for message: {}, Request ID: {}",
                                    String.valueOf(zimMessage), requestId);
                        } catch (Exception e) {
                            log.warn("Market Report not triggered: {}", e.getMessage(), e);
                        }
                    });
        }
    }

    public String triggerMarketReportOrThrow(MarketReportType type) {
        MarketReportHandler handler = handlerFactory.getHandler(type);
        MarketReportTriggerContext context = handler.buildContextOrThrow();
        return handler.submitMarketReport(context);
    }
}
```

### Why Not the Rich Object Pattern

The rich object pattern (`RichObjectHandler` -> `validateGqlInput` / `validateRestInput` / `mapToAdapter`) was considered but rejected:
- RO validation and mapping are thin (field presence, version dispatch); market report "validation" includes heavyweight business logic with external calls (PDM, Split)
- The webhook and API flows have fundamentally different error semantics (`Optional.empty()` vs `throw`) — forcing both into a uniform validate-then-map pipeline obscures this
- `MarketReportTriggerContext` already serves as the adapter; no additional abstraction layer needed

## Implementation Tasks

### MR1: Refactor — COMPLETE

- [x] **Step 1** — Revert unrelated `ConversationQueryDatafetcher` import reorder.
- [x] **Step 2** — Update `MarketReportHandler` interface.
- [x] **Step 3** — Update `BaseMarketReportHandler`.
- [x] **Step 4** — Update `TourMarketReportHandler`.
- [x] **Step 5** — Remove `OpenHouseMarketReportHandler` (dead code).
- [x] **Step 6** — Update `MarketReportService`.
- [x] **Step 7** — Add `MarketReportHandlerFactory.getAllHandlers()`.
- [x] **Step 8** — Restore accidentally dropped feature flag check and log statements.
- [x] **Step 9** — Update `MarketReportServiceTest`.
- [x] **Step 10** — Add comprehensive handler tests (52 tests).
- [x] **Step 11** — `./gradlew build` green.

### MR2: REST API

- [ ] **Step 1** — Define `MarketReportApiRequest` model.
- [ ] **Step 2** — Re-add `OpenHouseMarketReportHandler` with real `buildContextOrThrow`.
- [ ] **Step 3** — Add `OpenHouseMarketReportHandlerTest`.
- [ ] **Step 4** — Add REST controller endpoint.
- [ ] **Step 5** — Add API integration tests.
- [ ] **Step 6** — `./gradlew build` green.

## Testing Strategy

### MR1 Tests (Complete — 52 tests)

- **`MarketReportServiceTest`** (6) — service orchestration for both paths
- **`TourMarketReportHandlerTest`** (22) — `buildContextIfEligible` coverage
- **`BaseMarketReportHandlerTest`** (15) — submission + zip code extraction
- **`MarketReportHandlerFactoryTest`** (3) — factory lookup

## Out of Scope

- Open House prompt finalization — separate effort
- Concierge persona event handling (step 4 in design doc) — MR2 depends on this
- TOUR API flow (`buildContextOrThrow` for TOUR) — no use case yet

---

## Review Feedback & Fixes

### CodeRabbit (2026-04-09) — PENDING FIX

**Metric double-counting in `BaseMarketReportHandler.submitMarketReport`** (lines 56-67). `marketReportsTriggered` increments before response validation; if response is null/blank, both triggered and failed metrics fire. Fix: move success metric after the `orElseThrow` chain. Bug existed in original code.

### Manual Review Fixes Applied (commit `61f98568`)

1. **Reordered eligibility checks** — address extraction before PDM network call
2. **Added stack trace to log.warn** — `log.warn("...", e.getMessage(), e)`

### Dale's Review (2026-04-09) — UNRESOLVED

**Comment 1 — Third level of abstraction (line 28):**
Call chain: webhookhandlerfactory -> message.created handler -> productexperienceactivator -> marketreportService -> marketReportFactory -> specificMarketReport. Dale asks if tour/open house could be sibling product experiences at level 2, removing the factory.

**Comment 2 — Factory not picking (line 30):**
Webhook path calls `getAllHandlers()` and iterates — factory doesn't select. Only the API path uses `getHandler(type)`.

**Counter-argument:** Factory is justified by the API path — controller calls `getHandler(type)` to dispatch. Without it, API flow needs manual routing which is effectively a factory anyway. Single registry for both entry points.

**Status:** Needs response on MR. May require architecture change or spec update.
