---
title: Lecture 16
title: "Process Daemonization for Long-Running Automations"
date: 2026-04-15
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

# Why *Continuous* Process Automation?

Automation tasks often require:

- Continuous execution
- Event-driven logic
- Scheduling
- Monitoring
- Fault tolerance

---

# Examples of Contnuous Automation Tasks

- File ingestion pipelines
- Email processing
- Log monitoring
- API polling
- Report generation
- Backup systems
- Alerting systems

---

# What is a Daemon?

A **daemon** is:

- Background process
- Long-running
- Detached from terminal
- Automated execution
- Service-like behavior

---

# Examples of System Daemons

Common daemons:

- `cron`
- `sshd`
- `systemd`
- `nginx`
- `docker`

---

# Why Use Daemons?

Advantages:

- Always running
- No user interaction required
- Automatic recovery
- Centralized automation

---

# Script vs Daemon

## Script

- Runs once
- Manual execution
- Short lived

## Daemon

- Long running
- Automatic execution
- Background service

---

# Daemon Architecture

\begin{center}
\begin{tikzpicture}[
node distance=2cm,
every node/.style={draw, rectangle, rounded corners, align=center}
]

\node (client) {Clients};
\node (daemon) [right=of client] {Daemon};
\node (worker) [right=of daemon] {Worker Logic};
\node (external) [below=of daemon] {External Systems};

\draw[->] (client) -- (daemon);
\draw[->] (daemon) -- (worker);
\draw[->] (worker) -- (external);
\draw[->] (external) -- (daemon);

\end{tikzpicture}
\end{center}

---

# Daemon Components

Core Components:

- Initialization
- Daemonization
- Main loop
- Worker logic
- Logging
- Shutdown handling

---

# Daemon Lifecycle

1. Start
2. Detach
3. Initialize
4. Run loop
5. Shutdown

---

# Unix Daemonization Steps

Traditional daemonization:

1. Fork
2. Exit parent
3. `setsid()`
4. Fork again
5. Change directory
6. Reset permissions
7. Close file descriptors

---

# Python Daemonization Example

```python
import os
import sys

def daemonize():
    pid = os.fork()
    if pid > 0:
        sys.exit(0)

    os.setsid()

    pid = os.fork()
    if pid > 0:
        sys.exit(0)
```

---

```python
    os.chdir("/")
    os.umask(0)

    sys.stdout.flush()
    sys.stderr.flush()

    with open("/dev/null", "r") as f:
        os.dup2(f.fileno(), sys.stdin.fileno())

    with open("/dev/null", "a+") as f:
        os.dup2(f.fileno(), sys.stdout.fileno())
        os.dup2(f.fileno(), sys.stderr.fileno())
```

---

# Main Loop Pattern

```python
while True:
    do_work()
    sleep()
```

---

# Avoid Busy Loops

Bad:

```python
while True:
    do_work()
```

Good:

```python
import time

while True:
    do_work()
    time.sleep(10)
```

---

# How do I Banish my Daemon?

Once a daemon is created:

- How to communicate instructions?
- How to kill it?

---

# Signal Handling

Important signals:

- `SIGTERM`
- `SIGINT`
- `SIGHUP`

---

# Signal Example

```python
import signal
import sys

def shutdown(signum, frame):
    sys.exit(0)

signal.signal(signal.SIGTERM, shutdown)
signal.signal(signal.SIGINT, shutdown)
```

---

# Logging

Always log:

- Startup
- Shutdown
- Errors
- Events

---

# PID Files

Purpose:

- Track process
- Prevent duplicates
- Stop daemon

## PID File Example

```python
import os

with open("/tmp/daemon.pid","w") as f:
    f.write(str(os.getpid()))
```

---

# Configuration Files

Example:

```yaml
interval: 60
directory: /data/incoming
```

---

# Communication Methods

- Files
- Pipes
- Sockets
- REST APIs
- Message queues
- Signals

---

# File-Based Communication

Pattern:

- Poll directory contents
- Daemon processes files

---

# File Example

```python
import os

files = os.listdir("/tmp/incoming")
```

---

# Socket Communication

Advantages:

- Fast
- Local
- Efficient

## Socket Example

```python
import socket
```

---

# REST API Communication

Advantages:

- Remote control
- Easy integration

---

# Message Queue Communication

Examples:

- Redis
- RabbitMQ
- Kafka

---

# Business Automation Example

Task:

Automate report generation

- Poll database
- Generate report
- Send email

---

# Business Automation Architecture

\begin{center}
\begin{tikzpicture}[
node distance=2cm,
every node/.style={draw, rectangle, rounded corners}
]

\node (db) {Database};
\node (daemon) [right=of db] {Daemon};
\node (report) [right=of daemon] {Report};
\node (email) [below=of report] {Email};

\draw[->] (db) -- (daemon);
\draw[->] (daemon) -- (report);
\draw[->] (daemon) -- (email);

\end{tikzpicture}
\end{center}

---

# Example Business Daemon

```python
import time
import logging

def generate_report():
    logging.info("Generating report")

while True:
    generate_report()
    time.sleep(60)
```

---

# Full Example Daemon

```python
import time
import logging
import signal

running = True
def shutdown(signum, frame):
    global running
    running = False

signal.signal(signal.SIGTERM, shutdown)

```

---

```python
logging.basicConfig(
    filename="report.log",
    level=logging.INFO
)

def generate_report():
    logging.info("Generating report")

while running:
    generate_report()
    time.sleep(60)
```

---

# `systemd` Service Example

```ini
[Unit]
Description=Report Daemon

[Service]
ExecStart=/usr/bin/python3 daemon.py
Restart=always

[Install]
WantedBy=multi-user.target
```

---

# Best Practices

- Logging
- Signal handling
- Graceful shutdown
- Config files
- PID files

---

# Deployment Steps

1. Write daemon
2. Test foreground
3. Deploy
4. Monitor

---

# Monitoring

Tools:

- systemctl
- logs
- metrics

---

# Security Considerations

- Least privilege
- Input validation
- Logging

---

# Performance Considerations

- Avoid blocking
- Use queues
- Async processing

---

# Testing

Testing strategies:

- Unit tests
- Integration tests
- Load tests

---

# Summary

Key Takeaways:

- Daemons enable automation
- Use best practices
- Implement communication
- Monitor systems

---

# End of Lecture

$$\text{\huge Questions?}$$
