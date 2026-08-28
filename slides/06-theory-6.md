---
title: Lecture 6
subtitle: Descriptive, Definative Documentation
date: 2026-02-23
theme: "Frankfurt"
colortheme: "beaver"
fonttheme: "professionalfonts"
mainfont: Font-Regular.otf
mainfont: DejaVuSerif.ttf
sansfont: DejaVuSans.ttf
monofont: DejaVuSansMono.ttf
mathfont: texgyredejavu-math.otf
---

# Lecture Roadmap

- Why documentation is critical
- Types of documentation
- Two running examples
- A unified documentation format
- Bridging business and technical audiences

---

# What Goes Wrong Without Documentation?

- Hidden assumptions
- Tribal knowledge
- Fragile systems
- Expensive outages
- Compliance violations


*Automation without documentation creates technical debt!*

---

# Why Documentation Is Critical

Documentation:

- Aligns business and engineering
- Defines expected behavior
- Enables maintenance
- Supports auditing
- Reduces operational risk

---

# Running Example 1
## Online Order Processing

Customer places order:

- Validate payment
- Check inventory
- Ship order
- Notify customer

---

# Running Example 2
## Employee Onboarding Workflow

New hire process:

- Submit hiring form
- Create accounts
- Assign equipment
- Schedule orientation
- Confirm completion

---

# Same Structural Pattern

Both processes:

- Move through defined steps
- React to events
- Can fail
- Must handle exceptions

Structure matters.

---

# Forms of Documentation

Different stakeholders need different views:

- Business-level documentation
- Functional specifications
- Process diagrams
- State models
- Data definitions
- Interface/API documentation

---

# Business-Level Documentation

**Audience:** Managers, compliance officers

**Includes:**
  - Purpose
  - Scope
  - Business rules
  - Key Performance Indicators (KPIs)
  - Risks

*No implementation details.*

---

# Example 1 — Business View

**Order Processing Automation**

Purpose:
  - Reduce processing time

Business Rules:
  - Payment must be confirmed before shipping
  - Orders over $10,000 require approval

KPIs:
  - Processing time < 2 minutes
  - Failure rate < 1%

---

# Example 2 — Business View

**Employee Onboarding Automation**

Purpose:
  - Ensure every hire is provisioned correctly

Business Rules:
  - All hires receive IT accounts
  - Contractors receive restricted access

KPIs:
  - Accounts created within 1 business day

---

# Functional Specification

Audience: Analysts + Developers

Defines:
  - Inputs
  - Outputs
  - Events
  - System responses
  - Error handling

*Focuses on behavior*

---

# Functional Spec — Order Processing

Inputs:
  - Order submission
  - Payment confirmation
  - Inventory response

Outputs:
  - Shipping request
  - Failure notification

Errors:
  - Payment declined
  - Out of stock

---

# Functional Spec — Onboarding

Inputs:
  - Hiring form submission
  - Manager approval

Outputs:
  - IT account created
  - Email confirmation

Errors:
  - Missing documents
  - Provisioning failure

---

# Process Diagram — Order Processing

    [Order Submitted]
            |
            v
    [Validate Payment] --fail--> [Reject Order]
            |
            v
    [Check Inventory] --fail--> [Backorder/Cancel]
            |
            v
        [Ship Order]
            |
            v
     [Notify Customer]

---

# Process Diagram — Onboarding

    [Hire Approved]
            |
            v
    [Create IT Account]
            |
            v
    [Assign Equipment]
            |
            v
    [Schedule Orientation]
            |
            v
    [Complete Onboarding]

---

# The Need for Precision

Flowcharts are helpful
—but informal.

We need:

- Explicit states
- Explicit transitions
- Defined failure behavior

---

# What Is a State?

A **state** is:

> A distinct situation the system can be in.

Order system examples:
- Awaiting Payment
- Awaiting Inventory
- Shipped
- Cancelled

Only one state at a time.

---

# Order Processing — States

    +--------------------+
    | Awaiting Payment   |
    +--------------------+
               |
               v
    +--------------------+
    | Awaiting Inventory |
    +--------------------+
               |
               v
    +--------------------+
    | Shipped            |
    +--------------------+

---

# Onboarding — States

    +--------------------+
    | Pending Approval   |
    +--------------------+
               |
               v
    +--------------------+
    | Provisioning       |
    +--------------------+
               |
               v
    +--------------------+
    | Completed          |
    +--------------------+

---

# Why State-Based Documentation Helps

- Eliminates ambiguity
- Makes edge cases explicit
- Enables systematic testing
- Supports formal reasoning
- Prevents undefined behavior

---

# A Unified Documentation Format

Each automated process should include:

1. Overview
2. Stakeholders
3. Business Rules
4. Inputs & Outputs
5. State Model
6. Transition Table
7. Data Model
8. Integration Points
9. Exception Handling
10. Operational Concerns

---

# Section 1 — Overview

Short, non-technical:

- What does the automation do?
- Why does it exist?
- What value does it provide?

Audience: Everyone

---

# Section 2 — Stakeholders

List those who interact with the process:

- Business owner
- Technical owner
- Compliance authority
- Support contact

Clarifies accountability.

---

# Section 3 — Business Rules

Precise statements:

- "Payment must be confirmed before shipment."
- "All employees must have an email account."

Avoid vague language.

Define all domain knowledge terminology used.

---

# Section 4 — Inputs and Outputs

Define clearly:

Inputs:
  - Events
  - User actions
  - External triggers

Outputs:
  - Notifications
  - Database updates
  - API calls

---

# Section 5 — State Model

List all states.

Example (Order):

- Awaiting Payment
- Awaiting Inventory
- Shipped
- Cancelled
- Failed

States must be:

- Mutually exclusive
- Collectively exhaustive

---

# Section 6 — Transition Table (Order)

| Current State        | Event               | Next State          |
|---------------------|--------------------|--------------------|
| Awaiting Payment     | Payment Confirmed  | Awaiting           |
| Awaiting Payment     | Payment Failed     | Failed             |
| Awaiting Inventory   | In Stock           | Shipped            |
| Awaiting Inventory   | Out of Stock       | Cancelled          |

---

# Transition Table (Onboarding)

| Current State       | Event        | Next State           |
|--------------------|-------------|----------------------|
| Pending Approval    | Approved    | Provisioning         |
| Pending Approval    | Rejected    | Rejected             |
| Provisioning        | Success     | Completed            |
| Provisioning        | Failure     | Provisioning Failed  |

---

# Section 7 — Data Model

Define key _techincal_ entities and fields.

Order:
  - Order ID
  - Customer ID
  - Payment Status
  - Inventory Status

Onboarding:
  - Employee ID
  - Role
  - Access Level
  - Provisioning Status

---

# Section 8 — Integration Points

Document:

- External APIs
- Databases
- Email systems
- Payment gateways
- HR systems

Include:

- Expected input format
- Expected output format
- Error codes

---

# Section 9 — Exception Handling

Define behavior for:

- System timeouts
- Service outages
- Data inconsistencies
- Partial failures

Never leave failure undefined.

---

# Section 10 — Operational Concerns

Include specifications for:

- Logging strategy
- Monitoring metrics
- Alert thresholds
- Recovery procedures
- Audit requirements

---

# Documentation for Non-Technical Users

Sections 1, 2, 3, (sometimes 4, 5).

Focus on:

- Purpose
- Rules
- Responsibilities
- Outcomes

Avoid:

- Code
- Schemas
- Internal algorithms

---

# Documentation for Technical Users

Focus on:

- State definitions
- Transition logic
- Data contracts
- Error handling
- Performance constraints

Be precise and unambiguous.

---

# Testing from Documentation

From state documentation you can derive:

- Tests for each state
- Tests for each transition
- Tests for each failure path

Documentation → Test Plan

---

# Auditing and Compliance

Well-documented automation:

- Demonstrates rule enforcement
- Provides traceability
- Supports investigations
- Reduces regulatory risk

---

# Maintenance and Change

Business rules evolve.

With structured documentation:

- Impact analysis is easier
- Changes are localized
- Regression risk is reduced

---

# Key Takeaways

- Automation without documentation is fragile.
- Different stakeholders need different views.
- State-based models improve precision.
- A unified structure bridges business and technical teams.
- Good documentation reduces risk and cost.

---

# Final Thought

Automation is not just code.

It is:

- A formalized business policy
- A defined set of rules
- A structured state machine
- A living operational system

Document it accordingly.

---
