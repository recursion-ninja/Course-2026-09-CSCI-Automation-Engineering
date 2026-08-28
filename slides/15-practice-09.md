---
title: Lecture 15
title: "Bots for Automating Computerized Business Tasks"
date: 2026-03-30
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
  - \usepackage{listings}
  - \usepackage{xcolor}
  - \definecolor{codegray}{gray}{0.9}
  - \lstset{
      backgroundcolor=\color{codegray},
      basicstyle=\ttfamily\footnotesize,
      breaklines=true,
      frame=single
    }
---

# Bots for Automating Computerized Business Tasks

## Lecture Overview

### Topics Covered

- What is a bot?
- Bot vs traditional programs
- Bot use cases in business
- Classes of bots
- Bot architecture
- Logging and observability
- Bot safety
- Bot ethics
- Running Python example (progressively developed)

---

# What is a Bot?

## Definition

A **Bot** is:

- Long running
- Unsupervised
- Accepts inputs from external sources
- Performs automated tasks

---

## Bots vs Programs

| Traditional Program | Bot |
|---------------------|-----|
| Short-lived | Long-running |
| User provides input | External users provide input |
| Interactive | Autonomous |
| Manual execution | Background execution |

---

# Why Businesses Use Bots

## Business Benefits

- Reduce labor costs
- Increase reliability
- 24/7 availability
- Faster response time
- Reduce human error
- Scalability

---

# Bot Use Cases

## Customer Support Bots

- Ticket automation
- Email response
- Escalation handling
- Knowledge base lookup

---

## Operations Bots

- Deployment bots
- Monitoring bots
- Alert bots
- Restart bots

---

## Finance Bots

- Invoice processing
- Expense validation
- Fraud detection
- Payment processing

---

## HR Bots

- Resume screening
- Interview scheduling
- Employee onboarding
- Notification bots

---

# Deployment

## Running Bots

- systemd
- Docker
- Kubernetes
- Cloud services

---

# Monitoring

## Monitor Bots

- CPU
- Memory
- Logs
- Failures

---

# Minimal Bot

## Is this a bot?

~~~python
import time

def main():
    while True:
        print("Bot running...")
        time.sleep(5)

if __name__ == "__main__":
    main()
~~~

---

# Bot Input Sources

## Common Input Sources

- Files
- Email
- APIs
- Databases
- Message queues
- Webhooks

---

# File-Based Input Example

~~~python
import os

def get_inputs():
    return os.listdir("inputs")
~~~

---

# Add Input Processing

~~~python
import time
import os

def process(file):
    print("Processing", file)

def main():
    while True:
        files = os.listdir("inputs")

        for f in files:
            process(f)

        time.sleep(5)

if __name__ == "__main__":
    main()
~~~

# Classes of Bots

## Polling Bots

Repeatedly check for input.

~~~python
while True:
    check()
    sleep()
~~~

---

## Event Driven Bots

Respond to:

- Webhooks
- Messages
- Events

---

## Monitoring Bots

Monitor:

- Services
- Metrics
- Logs

---

## Workflow Bots

- Multi-step processes
- Business workflows
- Task automation

---

# Logging

## Why Logging Matters

Bots run unattended

You must log:

- Inputs
- Outputs
- Errors
- Decisions

---

# Logging Example

~~~python
import logging

logging.basicConfig(
    filename="bot.log",
    level=logging.INFO
)

logging.info("Bot started")
~~~

---

# Add Logging to Bot

~~~python
import time
import os
import logging

logging.basicConfig(
    filename="bot.log",
    level=logging.INFO
)

def process(file):
    logging.info(f"Processing {file}")

def main():
    logging.info("Bot starting")

    while True:
        files = os.listdir("inputs")

        for f in files:
            process(f)

        time.sleep(5)

if __name__ == "__main__":
    main()
~~~

---

# Error Handling

## Why Error Handling Matters

Bots must:

- Continue running
- Recover automatically
- Log failures

---

# Error Handling Example

~~~python
try:
    process()
except Exception:
    logging.exception("Failure")
~~~

---

# Add Error Handling

~~~python
def main():
    while True:
        try:
            run_cycle()
        except Exception:
            logging.exception("Cycle failure")

        time.sleep(5)
~~~

---

# Bot State

## Bots Must Remember State

- Processed files
- Last run time
- Failures

---

# State Example

~~~python
processed = set()

def process(file):
    if file in processed:
        return

    processed.add(file)
~~~

---

# Running Example: Ticket Bot

## Ticket Bot Skeleton

~~~python
def get_tickets():
    return []

def classify(ticket):
    return "general"

def respond(ticket):
    pass
~~~

---

# Ticket Bot Loop

~~~python
def run_cycle():
    tickets = get_tickets()

    for t in tickets:
        category = classify(t)
        respond(t)
~~~

---

# Full Bot Loop

~~~python
def main():
    while True:
        run_cycle()
        time.sleep(5)
~~~

---

---

# Why Architecture Matters

## Poor Architecture Causes

- Duplicate processing
- Data corruption
- Unrecoverable failures
- Infinite loops
- System overload
- Security issues

---

# High-Level Bot Architecture

\begin{center}
\begin{tikzpicture}[
node distance=2.2cm,
box/.style={draw, rectangle, minimum width=2.8cm, minimum height=1cm}
]

\node[box] (input) {Input Sources};
\node[box, right=of input] (queue) {Queue};
\node[box, below=of queue] (bot) {Bot Workers};
\node[box, right=of bot] (output) {Outputs};

\draw[->] (input) -- (queue);
\draw[->] (queue) -- (bot);
\draw[->] (bot) -- (output);

\end{tikzpicture}
\end{center}

---

# Architecture Components

## Core Components

- Input adapters
- Queue
- Worker engine
- Business logic
- Output adapters
- Logging
- Monitoring
- Persistence

---

# Input Layer

## Input Sources

- Email
- Filesystem
- APIs
- Webhooks
- Databases
- Message queues

---

# Input Adapter Pattern

## Input Adapter

```python
def http_GET():
    pass

def http_POST():
    pass

def http_PUT():
    pass
```

---

# Queue Layer

## Why Use a Queue?

Queues:

- Decouple inputs from processing
- Provide buffering
- Improve reliability
- Enable scaling

---

# Worker Architecture

## Worker Responsibilities

Workers:

- Pull work from queue
- Process input
- Handle errors
- Retry failures
- Log actions

---

# Worker Loop Example

```python
while True:
    task = queue.get()
    if task is not None:
       process(task)
```

---

# Retry Architecture

## Retry Logic

Bots must retry failures.

```python
def retry(task):
    for i in range(3):
        try:
            process(task)
            return
        except Exception:
            continue
```

---

# Dead Letter Queue

## Dead Letter Queue

Failed tasks move to:

Dead Letter Queue (DLQ)

Benefits:

- Prevent infinite retries
- Allow investigation
- Improve reliability

---

# Dead Letter Architecture

\begin{center}
\begin{tikzpicture}[
node distance=2cm,
box/.style={draw, rectangle, minimum width=2.8cm, minimum height=1cm}
]

\node[box] (queue) {Queue};
\node[box, right=of queue] (worker) {Worker};
\node[box, below=of worker] (dlq) {Dead Letter Queue};

\draw[->] (queue) -- (worker);
\draw[->] (worker) -- (dlq);

\end{tikzpicture}
\end{center}

---

# Idempotency

## What is Idempotency?

Operations that can run multiple times safely.

$$f(x) = f(f(x)) = f(f(f(x))) = \ldots$$

Example:

- Processing duplicate tickets
- Retrying failed operations

---

# Persistence Layer

## Persistence Stores

- Database
- Files
- Cache
- Message queues

## Bots store:

- State
- Processed items
- Failures

---

# Configuration Layer

## Configuration

Bots should use configuration:

- Poll interval
- Credentials
- Limits

---

# Config Example

```python
CONFIG = {
    "interval": 5,
    "retries": 3,
    "logdir": "bot-logs"
}
```

---

# Concurrency

## Why Concurrency?

Bots must handle:

- Multiple inputs
- Parallel processing

---

# Worker Pool

\begin{center}
\begin{tikzpicture}[
node distance=1.5cm,
box/.style={draw, rectangle, minimum width=2.5cm, minimum height=1cm}
]

\node[box] (queue) {Queue};
\node[box, right=of queue] (w1) {Worker 1};
\node[box, below=of w1] (w2) {Worker 2};
\node[box, below=of w2] (w3) {Worker 3};

\draw[->] (queue) -- (w1);
\draw[->] (queue) -- (w2);
\draw[->] (queue) -- (w3);

\end{tikzpicture}
\end{center}

---

# Worker Pool Example

```python
import threading

for _ in range(5):
    t = threading.Thread(target=worker)
    t.start()
```

---

# Circuit Breaker Pattern

## Circuit Breaker

Prevent repeated failures

Example:

- External API fails
- Stop calling temporarily

---

# Circuit Breaker Example

```python
failures = 0

if failures > 5:
    sleep(60)
```

---

# Observability Architecture

## Observability Components

- Logging
- Metrics
- Alerts

---

# Security Architecture

## Security Concerns

- Authentication
- Authorization
- Input validation (sanitation)
- Rate limiting

---

# Security Layer

\begin{center}
\begin{tikzpicture}[
node distance=2cm,
box/.style={draw, rectangle, minimum width=2.8cm, minimum height=1cm}
]

\node[box] (input) {Inputs};
\node[box, right=of input] (security) {Security};
\node[box, below=of security] (queue) {Queue};
\node[box, below=of queue] (workers) {Workers};
\node[box, right=of workers] (output) {Outputs};

\draw[->] (input) -- (security);
\draw[->] (security) -- (queue);
\draw[->] (queue) -- (workers);
\draw[->] (workers) -- (output);

\end{tikzpicture}
\end{center}

---

# Final Example

```python
def main():
    logging.info("Bot started")

    pending = Queue()
    failure = Queue()

    for _ in range(4): # 4 worker threads
        spawn(worker(pending, failure))

    while True:
        blob = get_input()
        request = parse(blob)
        if request is not None:
            pending.add(request)
        time.sleep(5)
```
---

```python
def worker(pending, dead_letters):
    while True:
        request = pending.get()
        if request is not None:
            try
                category = classify(request)
                respond(request)
            except Exception as e:
                dead_letters.add(request)

def classify(ticket):
    return "general"

def respond(ticket):
    logging.info(f"Responding to {ticket}")

if __name__ == "__main__":
    main()
```

---

# Bot Safety

## Safety Risks

Bots can:

- Send spam
- Delete data
- Loop infinitely
- Overload systems

---

# Safety Mechanisms

- Rate limiting
- Input parsing/validation
- Authentication
- Authorization
- Circuit breakers

---

# Rate Limiting Example

~~~python
import time

last = 0

def rate_limit(seconds):
    global last
    now = time.time()

    if now - last < seconds:
        return False

    last = now
    return True
~~~

---

# Bot Abuse

## Abuse Scenarios

- Spam bots
- Fraud bots
- Manipulation bots

---

# Bot Ethics

## Ethical Concerns

- Transparency
- Privacy
- Bias
- Manipulation

---

# Ethical Guidelines

Bots should:

- Identify themselves
- Respect privacy
- Avoid deception
- Avoid manipulation

---

# Summary

## Key Takeaways

Bots:

- Long-running
- Unsupervised
- Input-driven
- Require logging
- Require safety
- Require ethics

---

# End of Lecture

$$\text{\huge Questions?}$$
