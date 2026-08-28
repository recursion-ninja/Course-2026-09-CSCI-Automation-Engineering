---
title: Lecture 17
subtitle: "Logging and Debugging Automated Processes"
date: 2026-04-20
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

# Logging and Debugging Automated Processes

- Why logging matters in automation
- Debugging automated systems
- Observability fundamentals
- Logging best practices
- Structured logging
- Error handling strategies
- Monitoring automated processes
- Documentation best practices
- Example business automation task
- Example exemplary documentation

---

# Why Logging Matters

## Automation Without Logging

Automation systems often:

- Run unattended
- Execute on schedules
- Process large volumes
- Fail silently

### Without Logging

- Failures go unnoticed
- Debugging becomes difficult
- No audit trail
- No performance insight

---

# Automation With Logging

Logging provides:

- Visibility into system behavior
- Failure diagnosis
- Audit trail
- Performance metrics
- Compliance support

---

# Documentation of Automated Processes

## Why Documentation Matters

Automation systems:

- Outlive developers
- Require maintenance
- Must be understood

---

# Observability in Automation

## Three Pillars of Observability

- Logs
- Metrics
- Traces

### In Automation Context

- Logs: What happened
- Metrics: How often
- Traces: Execution flow

---

# Logging Architecture

## Typical Automation Logging Architecture

\begin{center}
\begin{tikzpicture}[
node distance=2cm,
box/.style={draw, rectangle, minimum width=3cm, minimum height=1cm}
]

\node[box] (automation) {Automation Script};
\node[box, below of=automation] (logger) {Logger};
\node[box, below left of=logger, xshift=-1cm] (file) {Log File};
\node[box, below right of=logger, xshift=1cm] (console) {Console};
\node[box, below of=logger, yshift=-1cm] (monitor) {Monitoring System};

\draw[->] (automation) -- (logger);
\draw[->] (logger) -- (file);
\draw[->] (logger) -- (console);
\draw[->] (logger) -- (monitor);

\end{tikzpicture}
\end{center}

---

# Types of Logs

## Log Levels

Standard log levels:

- `ERROR`
- `WARNING`
- `INFO`
- `VERBOSE`
- `DEBUG`

---

# Log Level Example

| Level | Eaxmple
|:----|-----------|
| `ERROR`   | Failed to retrieve data |
| `WARNING` | API latency high |
| `INFO`    | Job started |
| `VERBOSE` | Job size for 12 totaling 2.42 GiB  |
| `DEBUG`   | Connecting to API endpoint |


---

# Logging Best Practices

## Best Practice #1: Use Log Levels

Do not log everything as INFO.

Use:

- `ERROR` for failures
- `WARNING` for unexpected conditions
- `INFO` for normal operations
- `VERBOSE` for more detailed information
- `DEBUG` for development

---

# Best Practice #2: Include Context

Bad logging:

```
Error occurred
```

Good logging:

```
Error retrieving invoice 48392 from API
```

---

# Best Practice #3: Structured Logging

Structured logging example:

```json
{
  "timestamp": "2025-01-01T12:00:00",
  "level": "ERROR",
  "service": "invoice_bot",
  "message": "Failed to retrieve invoice",
  "invoice_id": 48392
}
```

---

# Structured Logging Benefits

Structured logging allows:

- Searchable logs
- Filtering
- Analytics
- Monitoring
- Alerting

---

# Logging Formats

Common formats:

- Plain text
- JSON
- CSV
- Key-value

Recommended:

- JSON
- Structured key-value

---

# Logging Example in Python

```python
import logging

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s %(levelname)s %(message)s'
)

logging.info("Job started")
logging.error("Failure detected")
```

---

# Structured Logging in Python

```python
import json
import logging

logging.info(json.dumps({
    "event": "job_start",
    "job_id": 123
}))
```

---

# Debugging Automated Processes

## Challenges

- No user interaction
- Scheduled execution
- Remote execution
- Large data volume

---

# Debugging Strategies

## Strategy #1: Reproducibility

- Capture inputs
- Capture outputs
- Save state

---

# Strategy #2: Verbose Logging

Enable debug mode:

```
--debug
--verbose
```

---

# Debugging Architecture

\begin{center}
\begin{tikzpicture}[
node distance=2cm,
box/.style={draw, rectangle, minimum width=3cm, minimum height=1cm}
]

\node[box] (input) {Input};
\node[box, right of=input, xshift=2cm] (automation) {Automation};
\node[box, right of=automation, xshift=2cm] (output) {Output};

\node[box, below of=automation] (log) {Logs};

\draw[->] (input) -- (automation);
\draw[->] (automation) -- (output);
\draw[->] (automation) -- (log);

\end{tikzpicture}
\end{center}

---

# Error Handling Best Practices

## Always Handle Exceptions

Bad:

```python
data = fetch_data()
```

Good:

```python
try:
    data = fetch_data()
except Exception as e:
    logging.error(str(e))
```

---

# Retry Logic

Automation often requires retries:

```python
for attempt in range(3):
    try:
        process()
        break
    except Exception:
        logging.warning("Retrying...")
```

---

# Monitoring Automated Processes

## Monitoring Techniques

- Log monitoring
- Health checks
- Alerts
- Metrics dashboards

---

# Alerting Strategy

Alert on:

- Failures
- Timeouts
- Performance degradation

---

# Debugging Process Behavior From Logs

## Why Debug Using Logs?

Automated processes often:

- Run without user interaction
- Execute on remote systems
- Run on schedules
- Fail intermittently

Logs allow you to:

- Reconstruct execution flow
- Identify failure points
- Detect performance problems
- Understand system behavior over time

---

# What Can Logs Reveal?

Logs can reveal:

- Execution order
- Timing behavior
- Retry logic
- Hidden dependencies
- Failure patterns
- Race conditions
- Resource contention

Key Insight:

Logs are often the **only observable behavior** of automated processes.

---

# Example: Automated Order Processing System

Assume an automated process:

1. Polls API for new orders
2. Downloads order data
3. Processes payment
4. Updates inventory
5. Sends confirmation email

We will debug behavior using logs.

---

# Example Log

::: columns
:::: column

\tiny
```
2025-03-10 10:00:00 INFO  Starting order processor
2025-03-10 10:00:01 INFO  Polling API for new orders
2025-03-10 10:00:02 INFO  Found 3 new orders

2025-03-10 10:00:02 INFO  Processing order 1021
2025-03-10 10:00:02 INFO  Charging payment for order 1021
2025-03-10 10:00:04 INFO  Payment success order 1021
2025-03-10 10:00:04 INFO  Updating inventory order 1021
2025-03-10 10:00:05 INFO  Sending confirmation order 1021

2025-03-10 10:00:05 INFO  Processing order 1022
2025-03-10 10:00:05 INFO  Charging payment for order 1022
2025-03-10 10:00:12 WARNING Payment timeout order 1022
2025-03-10 10:00:12 INFO  Retrying payment order 1022
2025-03-10 10:00:20 ERROR Payment failed order 1022

2025-03-10 10:00:20 INFO  Processing order 1023
2025-03-10 10:00:20 INFO  Charging payment for order 1023
2025-03-10 10:00:21 INFO  Payment success order 1023
2025-03-10 10:00:21 INFO  Updating inventory order 1023
2025-03-10 10:00:40 WARNING Inventory update slow order 1023
2025-03-10 10:00:45 INFO  Sending confirmation order 1023

2025-03-10 10:00:45 INFO  Job complete
```
\normalsize

::::

:::: column

From the logs we can infer:

Execution Order:

- Orders processed sequentially
- Order 1021 → 1022 → 1023

Processing Time:

- Order 1021: ~3 seconds
- Order 1022: ~15 seconds
- Order 1023: ~25 seconds

Observation:

Processing time is inconsistent.

::::

:::

---

# Identifying Failures

Failures visible in logs:

```
WARNING Payment timeout order 1022
ERROR Payment failed order 1022
```

We infer:

- Payment system experienced timeout
- Retry attempted
- Retry failed

Behavior Observed:

- System has retry logic
- Retry only occurs once
- Failed orders do not stop pipeline

---

# Detecting Performance Issues

Performance issue visible:

```
10:00:21 Updating inventory
10:00:40 Inventory update slow
```

This indicates:

- Inventory update took ~19 seconds
- Potential slow database
- External dependency latency

Behavior Inferred:

- Inventory system is bottleneck

---

# Behavioral Conclusions From Logs

We can conclude:

- Sequential processing model
- Payment system unreliable
- Inventory system slow
- Retry logic exists
- Failures isolated per order

Logs reveal system architecture without reading code.

---

# Debugging Methodology Using Logs

Step-by-step approach:

1. Identify start and end events
2. Track execution sequence
3. Identify slow operations
4. Locate failures
5. Identify retry patterns
6. Infer system architecture

---

# Best Practices for Debug-Friendly Logs

Write logs that include:

- Timestamps
- Unique IDs
- Step names
- Duration
- Error context

Example:

```
INFO order=1023 step=inventory_update duration=19s
```

This makes debugging far easier.

---

# Key Takeaways

- Logs reveal hidden behavior
- Timing data exposes bottlenecks
- Error patterns reveal instability
- Logs allow debugging without code access

Good logs = debuggable automation





















---

# Documentation Best Practices

## Include

- Purpose
- Inputs
- Outputs
- Dependencies
- Execution schedule
- Failure modes
- Logging strategy
- Monitoring strategy

---

# Documentation Template

## Documentation Structure

1. Overview
2. Inputs
3. Outputs
4. Dependencies
5. Workflow
6. Error Handling
7. Logging
8. Monitoring
9. Maintenance

---

# Example Business Automation Task

## Task: Invoice Processing Automation

Automation description:

- Retrieve invoices from email
- Extract data
- Upload to accounting system
- Send confirmation

---

# Invoice Automation Workflow

\begin{center}
\begin{tikzpicture}[
node distance=2cm,
box/.style={draw, rectangle, minimum width=3cm, minimum height=1cm}
]

\node[box] (email) {Email};
\node[box, right of=email, xshift=2cm] (extract) {Extract Data};
\node[box, right of=extract, xshift=2cm] (upload) {Upload};
\node[box, right of=upload, xshift=2cm] (notify) {Notify};

\draw[->] (email) -- (extract);
\draw[->] (extract) -- (upload);
\draw[->] (upload) -- (notify);

\end{tikzpicture}
\end{center}

---

# Example Logging for Invoice Automation

```
INFO Job started
INFO Retrieving emails
INFO 5 emails found
INFO Extracting invoice 1001
ERROR Invoice parse failed
INFO Retry successful
INFO Upload completed
INFO Job completed
```

---

# Example Automation Script

```python
import logging

logging.basicConfig(level=logging.INFO)

def fetch_invoices():
    logging.info("Fetching invoices")

def process_invoices():
    logging.info("Processing invoices")

def main():
    logging.info("Starting job")

    try:
        fetch_invoices()
        process_invoices()
    except Exception as e:
        logging.error(str(e))

    logging.info("Job complete")

main()
```

---

# Exemplary Documentation Example

# Invoice Automation Documentation

## Overview

This automation retrieves invoice emails, extracts data, and uploads to accounting.

---

## Inputs

- Email inbox
- PDF invoices

---

## Outputs

- Uploaded invoices
- Confirmation emails

---

## Dependencies

- Python 3.10
- API credentials
- Email server access

---

## Execution Schedule

Runs:

- Every hour

---

## Workflow

1. Connect to email
2. Download attachments
3. Parse invoice
4. Upload data
5. Send notification

---

## Logging Strategy

Log:

- Start time
- Emails processed
- Errors
- Completion

---

## Error Handling

Failures:

- Email failure
- Parsing failure
- Upload failure

Mitigation:

- Retry
- Alert

---

# Example Documentation Diagram

\begin{center}
\begin{tikzpicture}[
node distance=2cm,
box/.style={draw, rectangle, minimum width=3cm, minimum height=1cm}
]

\node[box] (start) {Start};
\node[box, below of=start] (retrieve) {Retrieve};
\node[box, below of=retrieve] (process) {Process};
\node[box, below of=process] (upload) {Upload};

\draw[->] (start) -- (retrieve);
\draw[->] (retrieve) -- (process);
\draw[->] (process) -- (upload);

\end{tikzpicture}
\end{center}

---

# Debugging Checklist

## When Debugging Automation

Check:

- Logs
- Inputs
- Outputs
- Timing
- Dependencies

---

# Logging Anti-Patterns

Avoid:

- Logging passwords
- Logging excessive data
- Logging without timestamps

---

# Logging Security

Never log:

- Credentials
- Tokens
- Personal data

---

# Performance Logging

Track:

- Execution time
- Throughput
- Failures

---

# Performance Logging Example

```python
import time
import logging

start = time.time()
process()
end = time.time()

logging.info(f"Duration: {end-start}")
```

---

# Observability Summary

Good automation systems:

- Log everything important
- Handle errors gracefully
- Are observable
- Are documented

---

# Key Takeaways

- Logging is essential
- Debugging requires observability
- Documentation ensures maintainability
- Structured logging improves debugging

---

# End of Lecture

$$\text{\huge Questions?}$$
