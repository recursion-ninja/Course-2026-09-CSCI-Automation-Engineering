---
title: Lecture 10
subtitle: "HTTP Requests and REST APIs"
date: 2026-03-11
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
 - \usetikzlibrary{arrows.meta,positioning,shapes,fit}
---

# Lecture Overview

## Topics

- Historical development of web APIs
- HTTP protocol fundamentals
- REST architecture and industry consensus
- Routes and endpoints
- REST schemas and structured data
- Programmatic access of web content
- Python automation examples for each concept

---

# Motivation: Why REST APIs Matter in Automation

## The Role of APIs in Automation

Modern automation frequently relies on external services:

Examples:

- Financial data feeds
- Weather data
- Messaging systems
- AI services
- Business platforms (CRM, ERP)

## Automation pipelines often look like:

- Retrieve data
- Process data
- Trigger action

---

Automation Architecture with Web APIs

\begin{center}
\begin{tikzpicture}[
node distance=3cm,
box/.style={draw, rectangle, rounded corners, minimum width=2.8cm, minimum height=1cm},
arrow/.style={->, thick}
]

\node[box] (script) {Automation Script};
\node[box, right=2.5cm of script] (api) {REST API};
\node[box, right=2.5cm of api] (service) {Web Service};

\path
    (script)   edge[bend left] node {HTTP Request} (api)
    (api)      edge[bend left] node {Internal Logic} (service)
    (service)  edge[bend left] node {Response}     (script);

\end{tikzpicture}
\end{center}

Automation software interacts with remote services through HTTP requests.

---

# History of Web APIs

## Early Web: Static Documents

The early web (1990s) focused primarily on static documents.

Technologies included:

- HTML
- HTTP
- Web servers
- Browsers

Interaction was minimal:

- Users requested documents
- Servers returned files

The web was essentially a distributed document system.

---

## CGI and Dynamic Web Content

Dynamic content appeared through **Common Gateway Interface (CGI)**.

Workflow:

1. Browser sends request
2. Server executes program
3. Program generates HTML
4. HTML returned to browser

Examples of CGI languages:

- Perl
- C
- Python

Automation scripts could mimic browsers to retrieve content.

---

## The Emergence of Web APIs

Around the early 2000s, websites began exposing structured interfaces.

Common early formats:

- XML
- SOAP (Simple Object Access Protocol)

Problems with SOAP:

- Complex
- Verbose
- Heavy specification

Developers wanted simpler approaches.

---

## REST Architecture

REST stands for:

**Representational State Transfer**

Term introduced by:

Roy Fielding (2000)

REST is an architectural style rather than a strict standard.

Key idea:

Resources are manipulated via HTTP.

---

## REST Principles

REST systems typically follow these constraints:

- Client-server architecture
- Stateless interactions
- Uniform interface
- Cacheable responses
- Layered system

Core idea:

Resources are identified by **URLs**.

Example:

```
https://api.example.com/users/123
```

---

## REST Interaction Model

\begin{center}
\begin{tikzpicture}[
node distance=3cm,
box/.style={draw, rectangle, rounded corners, minimum width=3cm, minimum height=1cm},
arrow/.style={->, thick}
]

\node[box] (client) {Automation Client};
\node[box, right=3cm of client] (server) {REST API Server};

\path
    (client) edge[bend left] node {HTTP Request} (server)
    (server) edge[bend left] node {JSON Response} (client);

\end{tikzpicture}
\end{center}

---

# HTTP Request Fundamentals

Hypertext Transfer Protocol

## Key characteristics:

- Stateless
- Request/response protocol
- Text-based messages

## An HTTP request contains:

- Method
- URL
- Headers
- Optional body

---

## Common HTTP Methods

| Method | Purpose |
|------|------|
| GET | Retrieve resource |
| POST | Create resource |
| PUT | Replace resource |
| PATCH | Modify resource |
| DELETE | Remove resource |

These operations correspond roughly to database CRUD operations.

---

# Python Example: Performing an HTTP GET

## Python Libraries for HTTP Requests

Common Python libraries:

- `requests`
- `httpx`
- built-in `urllib`

The most widely used library is **requests**.

---

## Example: Retrieving JSON from a REST API

```python
import requests

url = "https://api.github.com/repos/python/cpython"

response = requests.get(url)

print("Status code:", response.status_code)

data = response.json()

print("Repository name:", data["name"])
print("Stars:", data["stargazers_count"])
```

---

Key steps:

1. Send HTTP request
2. Receive response
3. Parse JSON
4. Use data in automation pipeline

---

# HTTP Status Codes

## Why Status Codes Matter

Every HTTP response includes a **status code** indicating the result of the request.

Example:

```
HTTP/1.1 200 OK
```

Status codes allow automation scripts to determine:

- whether a request succeeded
- whether authentication failed
- whether a resource exists
- whether the server encountered an error

---

# 1xx Status Codes — Informational Responses

## Meaning for the Client

1xx codes indicate that the request was **received and processing is continuing**.

### Common 1xx Codes

| Code | Meaning |
|-----|-----|
| 100 Continue | Server received headers and expects body |
| 101 Switching Protocols | Protocol change (e.g., HTTP → WebSocket) |
| 102 Processing | Request received but still being processed |

For most automation scripts, these responses are handled internally by HTTP libraries.

---

# 2xx Status Codes — Successful Requests

## Meaning for the Client

2xx codes indicate that the request **was successfully received, understood, and processed**.

### Common 2xx Codes

| Code | Meaning |
|-----|-----|
| 200 OK | Request succeeded |
| 201 Created | New resource created |
| 202 Accepted | Request accepted but not finished |
| 204 No Content | Request succeeded but no response body |

---

# 3xx Status Codes — Redirection

## Meaning for the Client

3xx codes indicate that the requested resource has **moved or requires another request**.

Clients should follow a redirect to another URL.

### Common 3xx Codes

| Code | Meaning |
|-----|-----|
| 301 Moved Permanently | Resource permanently moved |
| 302 Found | Temporary redirect |
| 303 See Other | Redirect to another resource |
| 304 Not Modified | Cached version still valid |

---

# 4xx Status Codes — Client Errors

## Meaning for the Client

4xx codes indicate that **the client made an invalid request**.

Automation scripts must correct the request.

### Common 4xx Codes

| Code | Meaning |
|-----|-----|
| 400 Bad Request | Invalid syntax |
| 401 Unauthorized | Authentication required |
| 403 Forbidden | Access denied |
| 404 Not Found | Resource does not exist |
| 418 I'm a teapot | The device makes hot beverages |
| 429 Too Many Requests | Rate limit exceeded |

Automation scripts must handle these errors carefully.

---

# 5xx Status Codes — Server Errors

## Meaning for the Client

5xx codes indicate that **the server failed to process a valid request**.

This usually means the problem is on the server side.

Automation scripts should often retry later.

### Common 5xx Codes

| Code | Meaning |
|-----|-----|
| 500 Internal Server Error | Generic server failure |
| 501 Not Implemented | Feature not supported |
| 502 Bad Gateway | Invalid response from upstream server |
| 503 Service Unavailable | Server overloaded or offline |
| 504 Gateway Timeout | Upstream server timed out |

---

# Routes and Endpoints

## What is a Route?

A **route** defines how URLs map to server functionality.

Example route pattern:

```
/users/{id}
```

Routes are implemented by the server framework.

Example frameworks:

- Flask
- Django
- Express
- FastAPI

---

## What is an Endpoint?

An **endpoint** is a specific URL that exposes functionality.

Examples:

```
GET /users
GET /users/42
POST /users
```

Each endpoint represents a resource operation.

---

## Endpoint Architecture

\begin{center}
\begin{tikzpicture}[
node distance=2.6cm,
box/.style={draw, rectangle, rounded corners, minimum width=3cm, minimum height=0.9cm},
arrow/.style={->, thick}
]

\node[box] (client) {Automation Script};

\node[box, right=3.5cm of client] (route1) {/users};
\node[box, below of=route1] (route2) {/users/42};
\node[box, below of=route2] (route3) {/orders};

\draw[arrow] (client) -- (route1);
\draw[arrow] (client) -- (route2);
\draw[arrow] (client) -- (route3);

\end{tikzpicture}
\end{center}

Each endpoint corresponds to a specific resource.

---

# Python Example: Calling Multiple Endpoints

```python
import requests

BASE = "https://jsonplaceholder.typicode.com"

users = requests.get(f"{BASE}/users").json()
posts = requests.get(f"{BASE}/posts").json()

print("Total users:", len(users))
print("Total posts:", len(posts))

print("First user name:", users[0]["name"])
```

Automation tasks often involve querying multiple endpoints and combining results.

---

# REST Schemas and Data Formats

## Structured Data in REST APIs

REST APIs usually return structured data formats.

Most common formats:

- JSON
- XML
- YAML

JSON has become the dominant format because it is:

- Lightweight
- Human readable
- Easily parsed in many languages

---

## Example JSON Response

```json
{
  "id": 42,
  "name": "Alice",
  "email": "alice@example.com",
  "active": true
}
```

Automation scripts parse this data and perform actions.

---

## REST Data Model Diagram

\begin{center}
\begin{tikzpicture}[
node distance=2.8cm,
box/.style={draw, rectangle, rounded corners, minimum width=3cm, minimum height=1cm},
arrow/.style={->, thick}
]

\node[box] (api) {REST API};
\node[box, right=2cm of api] (json) {JSON Response};
\node[box, right=2cm of json] (script) {Automation Script};

\draw[arrow] (api) -- (json);
\draw[arrow] (json) -- (script);

\end{tikzpicture}
\end{center}

---

# Python Example: Parsing JSON

```python
import requests

url = "https://jsonplaceholder.typicode.com/todos/1"

response = requests.get(url)

data = response.json()

print("Task:", data["title"])
print("Completed:", data["completed"])
```

JSON parsing converts text responses into Python dictionaries.

---

# REST API Authentication

## Why Authentication is Needed

Many APIs require authentication to:

- limit abuse
- enforce permissions
- track usage
- enable billing

Common methods:

- API keys
- OAuth tokens
- Bearer tokens

---

## API Key Example

Example header:

```
Authorization: Bearer <token>
```

Automation scripts must include credentials in requests.

---

# Python Example: Authenticated Request

```python
import requests

API_KEY = "YOUR_API_KEY"
headers = { "Authorization": f"Bearer {API_KEY}" }
url = "https://api.example.com/data"

response = requests.get(url, headers=headers)
print(response.status_code)
print(response.text)
```

Authentication is commonly handled via request headers.

---

# Programmatic Access of Web Content

## Automation Use Cases

Automated HTTP requests enable many tasks:

- Data aggregation
- Monitoring systems
- Automated reporting
- Triggering workflows
- Integrating third-party services

Example pipeline:

1. Retrieve data
2. Transform data
3. Send alerts

---

## Automation Pipeline Example

\begin{center}
\begin{tikzpicture}[
node distance=3cm,
box/.style={draw, rectangle, rounded corners, minimum width=3cm, minimum height=1cm},
arrow/.style={->, thick}
]

\node[box] (api) {External API};
\node[box, right=2cm of api] (script) {Python Automation};
\node[box, right=2cm of script] (alert) {Notification};

\draw[arrow] (api) -- (script);
\draw[arrow] (script) -- (alert);

\end{tikzpicture}
\end{center}

---

# Python Example: Automated Monitoring Script

```python
import requests
import time

URL = "https://api.coindesk.com/v1/bpi/currentprice.json"

while True:

    r = requests.get(URL)
    data = r.json()

    price = data["bpi"]["USD"]["rate"]

    print("Bitcoin price:", price)

    time.sleep(60)
```

This script polls a REST API every minute.

Automation systems frequently run on scheduled intervals.

---

# Combining REST APIs with Automation Logic

## Typical Automation Workflow

Steps in an automated process:

1. Send HTTP request
2. Receive JSON response
3. Parse data
4. Apply business rules
5. Trigger action

Example actions:

- send email
- update database
- trigger another API

---

# Example: Conditional Automation

```python
import requests

url = "https://jsonplaceholder.typicode.com/todos"

todos = requests.get(url).json()

for task in todos:
    if task["completed"]:
        print("Completed:", task["title"])
```

Automation often involves filtering and reacting to conditions.

---

# Best Practices for REST Automation

## Reliability

Automation scripts should include:

- error handling
- retry logic
- timeout limits

Example issues:

- network failure
- API rate limits
- server errors

---

## Example: Robust Request

```python
import requests

try:
    r = requests.get("https://api.example.com/data", timeout=5)
    r.raise_for_status()

    data = r.json()

except requests.exceptions.RequestException as e:
    print("Request failed:", e)
```

Reliable automation must anticipate failures.

---

# Summary

## Key Takeaways

REST APIs are fundamental to modern automation.

Important concepts:

- HTTP request structure
- REST architecture
- endpoints and routes
- structured JSON data
- authentication
- programmatic access via Python

Automation scripts frequently integrate multiple APIs into larger workflows.

---


# End of Lecture

$$\text{\huge Questions?}$$
