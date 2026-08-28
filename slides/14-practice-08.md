---
title: Lecture 14
subtitle: "Precision Web Form Submission (Sniping)"
date: 2026-03-25
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
 - \usepackage{amsmath}
 - \usepackage{tikz}
 - \usetikzlibrary{arrows.meta,positioning,shapes,shapes.geometric,fit}
---

# What is Precision Web Form Submission (Sniping)?

## Definition

**Precision Web Form Submission ("Sniping")** is the process of submitting a web form at **exactly** the right moment.

Common scenarios:

- Course registration
- Ticket sales
- Appointment booking
- Limited inventory purchasing
- Auction bidding

---

# Why Precision Matters

Example:

Form opens at:

```
09:00:00.000
```

Submissions:

| Time | Result |
|------|--------|
| 09:00:00.010 | Success |
| 09:00:00.120 | Failure |

Milliseconds matter.

---

# Challenges in Precision Timing

Sources of timing error:

- Network latency
- DNS lookup
- TLS handshake
- OS scheduling
- Interpreter delay
- CPU contention
- Timezone mistakes

---

# Naive Approach

## Incorrect Strategy

```python
time.sleep(target - now)
submit()
```

Problem:

Sleep is not precise.

You wake late.

---

# Example Failure

Execution target:

```
09:00:00.000
```

Sleep wakes:

```
09:00:00.042
```

You are too late.

---

# Precision Sniping Strategy

## High-Level Steps

1. Determine time remaining until execution
2. Sleep repeatedly using adaptive quanta
3. Benchmark execution time
4. Busy wait near execution
5. Submit at execution time minus mean benchmark

---

# Running Example

We will build this function incrementally.

```python
def snipe(target, submit_fn):
    pass
```

---

# Running Gantt Diagram (Initial)

\begin{tikzpicture}
\begin{ganttchart}[
    hgrid,
    vgrid,
    x unit=0.6cm,
    y unit chart=0.6cm
]{1}{19}

\gantttitle{Sniping Timeline}{19} \\
\gantttitlelist{0,...,18}{1} \\
\ganttbar{Sleep}{1}{15} \\
\ganttbar{Busy Wait}{16}{17} \\
\ganttbar{Submit}{18}{19} \\
\end{ganttchart}
\end{tikzpicture}

---

# Step 1 — Determine Time Remaining

## Theory

We compute:

$$\text{time remaining (ms)} = \mathtt{execution time} - \mathtt{now}$$

This drives all decisions.

---

# Why This Matters

Without recalculating:

- Drift accumulates
- Sleep overshoots
- Submission late

---

# Example Failure

Compute once:

- Time remaining = 30 minutes

System pauses:

- Actual delay = 30m 5s

Miss execution.

---

# Running Example Code

```python
import datetime
import time

def time_remaining(target):
    now = datetime.datetime.now()
    return (target - now).total_seconds()
```

---

# Update Running Example

```python
def snipe(target, submit_fn):

    remaining = time_remaining(target)
    print(remaining)
```

---

# Updated Gantt Diagram

\begin{tikzpicture}
\begin{ganttchart}[
    hgrid,
    vgrid,
    x unit=0.6cm,
    y unit chart=0.6cm
]{1}{19}

\gantttitle{Sniping Timeline}{19} \\
\gantttitlelist{0,...,18}{1} \\
\ganttbar{Measure}{1}{1} \\
\ganttbar{Sleep}{2}{15} \\
\ganttbar{Busy Wait}{16}{17} \\
\ganttbar{Submit}{18}{19} \\
\end{ganttchart}
\end{tikzpicture}

---

# Step 2 — Adaptive Sleep Quanta

## Strategy

Use:

$$\mathtt{quanta} = \min(30 \text{ minutes}, \frac{1}{2} * \mathtt{time\_remaining})$$

---

# Why Adaptive Sleep

Advantages:

- Efficient CPU usage
- Improved precision
- Avoid oversleep

---

# Example

| Remaining | Sleep |
|----------:|------:|
| 4.0 hours | 30.0 min |
| 3.5 hours | 30.0 min |
| 3.0 hours | 30.0 min |
| 2.0 hours | 30.0 min |
| 1.5 hours | 30.0 min |
| 1.0 hours | 30.0 min |
| 0.5 hours | 15.0 min |
| 15.00 min | 7.5 min |
| 7.00  min | 3.5 min |
| 3.20  min | 1.6 min |
| 1.50  min |  45 sec |
|  10  sec | `BUSY LOOP` |

---

# What Goes Wrong Without Adaptive Sleep

Fixed sleep:

- Too large → overshoot
- Too small → CPU waste

---

# Running Example

```python
# Returns milliseconds to sleep
def compute_quanta(remaining):
    return min(30*60*1000, remaining / 2)
```

---

# Update Main Function

```python
def snipe(target, submit_fn):

    while True:
        remaining = time_remaining(target)
        if remaining <= 0:
            break
        quanta = compute_quanta(remaining)
        time.sleep(quanta)
```

---

# Updated Gantt Diagram

\begin{tikzpicture}
\begin{ganttchart}[
    hgrid,
    vgrid,
    x unit=0.6cm,
    y unit chart=0.6cm
]{1}{19}

\gantttitle{Sniping Timeline}{19} \\
\gantttitlelist{0,...,18}{1} \\
\ganttbar{Measure}{1}{1} \\
\ganttbar{Sleep}{2}{7} \\
\ganttbar{Measure}{8}{8} \\
\ganttbar{Sleep}{9}{15} \\
\ganttbar{Busy Wait}{16}{17} \\
\ganttbar{Submit}{18}{19} \\
\end{ganttchart}
\end{tikzpicture}

---

# Step 3 — Benchmark Execution Time

## Theory

Submission takes time.

We must measure:

- DNS lookup
- TLS handshake
- HTTP request

---

# Why Benchmarking Matters

Execution time:

```
120 ms
```

Submit early:

```
target - 120ms
```

---

# Running Average

$$\texttt{preempt}\Delta = \frac{1}{n} \sum x_i$$

```python
benchmarks = []

def benchmark(fn):
    start = time.perf_counter()
    fn(dry_run=True)
    end = time.perf_counter()

    benchmarks.append(end - start)

    return sum(benchmarks)/len(benchmarks)
```

---

# Final Implementation

```python
def snipe(target, submit_fn):
    while True:
        remaining = time_remaining(target)
        if remaining <= 0:
            break
        quanta = compute_quanta(remaining)
        time.sleep(quanta)
        preempt = benchmark(submit_fn)
        if remaining <= prempt:
            break

    busy_wait(target, avg)
    submit_fn()
```

---

# Example Submit Function

```python
import requests

def submit_form(dry_run=False):

    if dry_run:
        requests.get("https://example.com/ping")
    else:
        requests.post(
            "https://example.com/submit",
            data={"field": "value"}
        )
```

---

# Final Gantt Diagram

\begin{tikzpicture}
\begin{ganttchart}[
    hgrid,
    vgrid,
    x unit=0.6cm,
    y unit chart=0.6cm
]{1}{19}
\gantttitle{Sniping Timeline}{19} \\
\gantttitlelist{0,...,18}{1} \\
\ganttbar{Measure}{1}{1} \\
\ganttbar{Sleep}{2}{4} \\
\ganttbar{Benchmark}{5}{6} \\
\ganttbar{Sleep}{7}{9} \\
\ganttbar{Benchmark}{10}{11} \\
\ganttbar{Sleep}{12}{15} \\
\ganttbar{Busy Wait}{16}{17} \\
\ganttbar{Submit}{18}{19} \\

\end{ganttchart}
\end{tikzpicture}

---

# Additional Considerations

## Clock Synchronization

Use:

- NTP
- time servers
- system sync

---

# System Load

Close:

- Browsers
- Updates
- Background tasks

Running on a dedicated device with minimal other processes is ideal. Comsider a Raspberry Pi or other networked micro computer.

---

# Network Stability

Prefer:

- Wired connection
- No VPN
- Low latency

---

# Summary

Precision Sniping Steps:

1. Determine time remaining
2. Adaptive sleep
3. Benchmark execution
4. Busy wait
5. Submit precisely

---

# Questions

Thank You


# End of Lecture

$$\text{\huge Questions?}$$
