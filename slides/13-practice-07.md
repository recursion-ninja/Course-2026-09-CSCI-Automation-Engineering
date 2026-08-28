---
title: Lecture 13
subtitle: "Automated Web Debugging, Fuzzing, and Probing"
date: 2026-03-23
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
 - \usepackage{tikz}
 - \usetikzlibrary{arrows.meta,positioning,shapes,shapes.geometric,fit}
---

# Motivation

## Why This Matters

- Many business systems expose *undocumented* APIs
- Automation often requires:
  - Reverse engineering workflows
  - Discovering hidden endpoints
  - Understanding request/response formats

---

# Key Idea

## Treat Web Services as Black Boxes

- Inputs → HTTP requests
- Outputs → HTTP responses
- Goal:
  - Infer behavior through experimentation

---

# Definitions

## Web Debugging

- Inspecting requests and responses

## Fuzzing

- Sending unexpected or random inputs

## Probing

- Systematic exploration of endpoints and parameters

---

# Route Discovery

## What is Route Discovery?

- Identifying valid URL paths (endpoints)
- Example:
  - `/api/users`
  - `/api/orders`
  - `/internal/report`

## Why It Matters

- Undocumented APIs often hide critical functionality
- Routes define the "surface area" of automation

---

# Route Discovery Techniques

## Common Strategies

- Wordlist-based guessing
- Observing frontend traffic
- Crawling hyperlinks and scripts
- Analyzing JavaScript bundles

---

# Wordlist-Based Discovery

## Concept

- Try many possible paths automatically

```text
/api
/api/v1
/api/users
/api/admin
/internal
/debug
```

## Evaluate Responses

- 200 → Valid endpoint
- 403 → Exists but restricted
- 404 → Likely invalid

---

# Directory Fuzzing Model

\begin{tikzpicture}
\node (start) at (0,0) [draw] {Wordlist};
\node (test) at (4,0) [draw] {Send Requests};
\node (filter) at (8,0) [draw] {Filter Responses};

\draw[->] (start) -- (test);
\draw[->] (test) -- (filter);
\end{tikzpicture}

---

# API Discovery

## Beyond Routes

- Identify:
  - HTTP methods supported
  - Required parameters
  - Authentication mechanisms

---

# API Discovery Workflow

## Iterative Exploration

1. Discover endpoint
2. Test HTTP methods
3. Add parameters
4. Observe behavior
5. Refine hypothesis

---

# HTTP Method Discovery

## Testing Methods

- Send:
  - GET
  - POST
  - PUT
  - DELETE

## Observe

- 405 Method Not Allowed → method exists but blocked
- 200 OK → method supported

---

# Parameter Discovery

## Hidden Inputs

- Add extra fields
- Modify structure

```json
{
  "username": "test",
  "role": "admin",
  "debug": true
}
```

## Look For

- Changes in response
- Error messages
- New fields in output

---

# JavaScript-Assisted Discovery

## Frontend as Documentation

- Inspect:
  - API calls in JS
  - Embedded endpoints
  - Hardcoded routes

## Tools

- Browser DevTools
- Source maps (if available)

---

# Graph-Based API Mapping

## Building a Map

\begin{tikzpicture}
\node (home) at (0,0) [draw] {/};
\node (users) at (3,1) [draw] {/users};
\node (orders) at (3,-1) [draw] {/orders};
\node (detail) at (6,1) [draw] {/users/{id}};

\draw[->] (home) -- (users);
\draw[->] (home) -- (orders);
\draw[->] (users) -- (detail);
\end{tikzpicture}

---

# Automation Strategy

## Replace Human Interaction

- Manual → Automated
- Deterministic → Programmatic

---

# Fuzzing Basics

## What is Fuzzing?

- Sending unexpected inputs:
  - Random
  - Structured mutations

---

# Types of Fuzzing

## Random Fuzzing

- Completely random input

## Mutation-Based

- Modify known valid inputs

## Generation-Based

- Construct inputs from rules

---

# Endpoint Fuzzing

## Combining Route + Input Discovery

- Test:
  - Paths
  - Methods
  - Parameters

## Example Loop

```text
for route in wordlist:
    for method in methods:
        for payload in payloads:
            send_request(route, method, payload)
```

---

# Industry Tools: Route Discovery

## Common Tools

- `ffuf` (Fast web fuzzer)
- `dirsearch`
- `gobuster`
- `wfuzz`

## Features

- High-speed HTTP requests
- Wordlist support
- Response filtering

---

# Industry Tools: Interception & Debugging

## Widely Used Tools

- Burp Suite
- OWASP ZAP
- mitmproxy

## Capabilities

- Intercept requests
- Modify in real time
- Replay and automate

---

## Developer-Focused

- RESTler (Microsoft)
- Postman Collection Runner
- Newman (CLI for Postman)

---

# Example: ffuf Command

```bash
ffuf -u https://example.com/FUZZ -w wordlist.txt
```

## Behavior

- Replaces `FUZZ` with each word
- Sends requests
- Filters results

---

# Example: wfuzz Command

```bash
wfuzz -c -z file,wordlist.txt https://example.com/FUZZ
```

--

# Advanced Techniques

## Stateful Fuzzing

- Maintain session state
- Sequence of requests

## Grammar-Based Fuzzing

- Define input structure
- Generate valid but unexpected inputs

---

# Use Case 1

## Reverse Engineering Internal API

- Capture frontend calls
- Replay with variations
- Discover full API

---

# Use Case 2

## Automating Business Workflow

- Example:
  - Order processing
  - Form submission
  - Report generation

---

# Use Case 3

## Integration Without Documentation

- Build custom client
- Replace manual steps

---

# Risks

## Technical Risks

- Account lockouts
- IP bans
- Data corruption

---

# Ethics

## Responsible Use

- Only test systems you own or have permission for

---

# Safeguards

## Best Practices

- Rate limiting
- Logging
- Sandbox testing

---

# Summary

- Route discovery reveals hidden endpoints
- API probing uncovers behavior
- Fuzzing enables deep exploration
- Tools accelerate and scale the process

---

# End of Lecture

$$\text{\huge Questions?}$$
