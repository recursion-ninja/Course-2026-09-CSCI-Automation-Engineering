---
title: Lecture 18
subtitle: "Documentation of Automated Processes"
date: 2026-04-22
theme: "Frankfurt"
colortheme: "beaver"
fonttheme: "professionalfonts"
mainfont: Font-Regular.otf
mainfont: DejaVuSerif.ttf
sansfont: DejaVuSans.ttf
monofont: DejaVuSansMono.ttf
mathfont: texgyredejavu-math.otf
aspectratio: 169
header-includes:
  - \usepackage{pgfgantt}
  - \usepackage{tikz}
  - \usetikzlibrary{arrows.meta,positioning,shapes,shapes.geometric,fit}
  - \usepackage{listings}
  - \usepackage{xcolor}
  - \definecolor{codegray}{gray}{0.9}
  - \lstset{
      backgroundcolor=\color{codegray},
      basicstyle=\ttfamily\footnotesize,
      breaklines=true,
      frame=single
      columns=fullflexible
    }
---

# Lecture Overview

- What is code documentation?
- Why documentation matters in automation
- Core components of automation documentation
- Best practices
- Functional requirements & process mapping
- Value preservation in automation
- Case study: Business task automation
- Example of exemplary documentation

---

# What is Code Documentation?

- Written description of:
  - System behavior
  - Design decisions
  - Usage instructions
- Bridges gap between:
  - Developers
  - Operators
  - Stakeholders
- Especially critical for **automated processes**
  - Often run unattended
  - Fail silently if poorly documented

---

# Why Documentation Matters in Automation

- Automation increases:
  - Complexity
  - Opacity
- Documentation ensures:
  - Objectivity
  - Maintainability
  - Debuggability
  - Scalability
- Reduces:
  - Onboarding time
  - Operational risk

---

# Key Documentation Goals

- Explain **what** the system does
- Explain **why** it exists
- Explain **how** it works
- Explain **how to operate and maintain it**

---

# Types of Documentation

1. **User Documentation**
2. **Developer Documentation**
3. **Operational Documentation**
4. **Process Documentation**

---

# Automation-Specific Documentation Needs

- Scheduling details (cron, triggers)
- Dependencies (APIs, databases)
- Failure modes
- Logging and monitoring
- Idempotency and retries

---

# Core Components of Automation Documentation

- Overview
- Functional Requirements
- Manual Process Description
- System Architecture
- Workflow Description
- Inputs/Outputs
- Error Handling
- Value Creation

---

# Functional Requirements

Define **what the system must do**

- Clear, testable statements
- Avoid ambiguity
- Example:
  - "The system shall retrieve new customer orders every 5 minutes"
  - "The system shall validate order data before processing"

---

# Good vs Bad Requirements

**Bad:**
- "System processes orders quickly"

**Good:**
- "System processes each order within 2 seconds of retrieval"

---

# Documenting the Manual Task

Before automation:

- Who performs the task?
- What steps are involved?
- What tools are used?
- What decisions are made?

---

# Why Document the Manual Process?

- Prevents loss of tacit knowledge
- Ensures correct automation
- Reveals inefficiencies
- Captures edge cases

---

# Manual Process Template

- Actor(s)
- Trigger
- Step-by-step actions
- Decision points
- Outputs
- Time required

---

# Process Value Creation

Key question:

**What value does the manual process create?**

Examples:
- Information accuracy
- Necessary compliance
- Customer satisfaction
- Insightful reporting

---

# Preserving Value in Automation

Automation must NOT:

- Remove critical checks
- Introduce silent errors
- Reduce quality

Documentation must explicitly state:

- What value is preserved
- How it is preserved

---

# Example Value Mapping

| Manual Step | Value | Automation Equivalent |
|------------|------|----------------------|
| Data validation | Accuracy | Input validation logic |
| Human review | Quality | Rule-based checks |

---

# System Architecture Documentation

Include:

- Components
- Data flow
- External systems
- Interfaces

---

# Workflow Documentation

- Step-by-step automated process
- Include:
  - Triggers
  - Inputs
  - Transformations
  - Outputs

---

# Inputs and Outputs

Document:

- Input formats
- Output formats
- Data sources
- Data destinations

---

# Error Handling Documentation

- What can go wrong?
- How is it detected?
- How is it handled?
- How is it logged?

---

# Logging and Monitoring

Documentation should specify:

- What is logged
- Log format
- Alert conditions
- Monitoring tools

---

# Best Practices

- Be concise but complete
- Use consistent structure
- Include examples
- Keep documentation updated
- Write for multiple audiences

---

# Best Practices (Advanced)

- Version documentation
- Co-locate docs with code
- Use diagrams where helpful
- Automate documentation generation when possible

---

# Common Mistakes

- Outdated documentation
- Overly verbose explanations
- Missing edge cases
- Ignoring operational details

---

# Case Study Introduction

**Business Task: Invoice Processing Automation**

Manual process:
- Employee downloads invoices from email
- Extracts data
- Enters into accounting system

---

# Manual Process Description

**Actor:** Accounts Payable Clerk

**Steps:**
1. Open email inbox
2. Download invoice PDF
3. Read invoice details
4. Enter data into system
5. Save and archive

**Time:** ~5 minutes per invoice

---

# Pain Points

- Time-consuming
- Error-prone
- Not scalable
- Repetitive

---

# Functional Requirements (Example)

- System shall monitor email inbox
- System shall download invoice attachments
- System shall extract invoice data
- System shall validate extracted data
- System shall enter data into accounting system

---

# Value Creation in Manual Process

- Accuracy of data entry
- Validation of invoice legitimacy
- Proper categorization

---

# Preserving Value in Automation

- Use OCR + validation rules
- Implement duplicate detection
- Log all processed invoices

---

# Example System Workflow

1. Poll email inbox
2. Identify new invoices
3. Download attachments
4. Extract data (OCR)
5. Validate fields
6. Insert into database
7. Log result

---

# Example Inputs/Outputs

**Input:**
- Email with PDF attachment

**Output:**
- Structured invoice record in database

---

# Example Error Handling

- Missing fields → flag for review
- OCR failure → retry
- Duplicate invoice → skip and log

---

# Example Logging

- Timestamp
- Invoice ID
- Status (success/failure)
- Error messages

---

# Exemplary Documentation (Overview Section)

**System Name:** Invoice Automation Bot

**Purpose:**
Automate invoice data extraction and entry into accounting system

**Scope:**
Handles PDF invoices received via email

---

# Exemplary Documentation (Functional Requirements)

- FR1: Monitor inbox every 2 minutes
- FR2: Process only unread emails
- FR3: Extract invoice number, date, amount
- FR4: Validate data before insertion

---

# Exemplary Documentation (Manual Process)

- Previously performed by AP clerks
- Required manual reading and entry
- Average processing time: 5 minutes/invoice

---

# Exemplary Documentation (Value Preservation)

- Accuracy ensured via validation rules
- Duplicate detection prevents double entry
- Logging ensures traceability

---

# Exemplary Documentation (Workflow)

1. Email polling
2. Attachment extraction
3. OCR processing
4. Data validation
5. Database insertion

---

# Exemplary Documentation (Error Handling)

- OCR failure → retry 3 times
- Missing data → route to manual queue
- System failure → alert admin

---

# Exemplary Documentation (Maintenance)

- Monitor logs daily
- Update OCR model quarterly
- Review validation rules monthly

---

# Summary

- Documentation is essential for automation success
- Must include:
  - Functional requirements
  - Manual process
  - Value preservation
- Good documentation = sustainable systems

---

# Discussion Questions

- What risks arise from poor documentation?
- How can documentation improve automation quality?
- What should never be automated without documentation?

---

# End of Lecture

$$\text{\huge Questions?}$$
