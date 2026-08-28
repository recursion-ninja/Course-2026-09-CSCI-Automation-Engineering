---
title: Lecture 09
subtitle: Subscription Monitoring and Processing
date: 2026-03-09
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

# Subscription Monitoring

### Learning Objectives

By the end of this lecture students should be able to:

- Explain the concept of **subscription-based monitoring**
- Understand how automated systems **subscribe to information streams**
- Implement automation using:
  - **RSS feeds**
  - **Automated email reception**
  - **Automated email sending**
  - **Receiving SMS messages automatically**
  - **Sending SMS messages automatically**
- Write Python scripts to integrate these mechanisms into automation pipelines.

---

# Motivation

## Why Subscription Monitoring?

Modern automation systems must react to **external events**.

Examples:

- A new job posting appears on a feed
- A system receives an alert email
- A monitoring service sends an SMS
- A customer fills out a form that triggers notifications

These events arrive through **subscription mechanisms**.

---

# Pull vs Push Monitoring

## Pull Model

- The system periodically checks for updates
- Example: polling an RSS feed every 5 minutes

## Push Model

- The system receives updates automatically
- Example: email or SMS notifications

---

## Diagram: Push vs Pull

\begin{tikzpicture}[
node distance=3cm,
box/.style={draw, rectangle, rounded corners, minimum width=3cm, minimum height=1cm}
]

\node[box] (source) {Information Source};
\node[box, right=3cm of source] (pull) {Polling System};
\node[box, below of=pull] (push) {Notification Receiver};

\draw[->] (pull)   -- node[above]{request}    (source);
\draw[->] (source) -- node[below]{response}   (pull);
\draw[->] (source) -- node[right]{push event} (push);

\end{tikzpicture}

---

# Section: RSS Feed Monitoring

## Really Simple Syndication (RSS)

RSS is a standardized **XML format for publishing updates**.

Commonly used by:

- Blogs
- News websites
- Podcast feeds
- Software update channels

Each update is called an **item**.

Typical contents:

- title
- link
- publication date
- description

---

# RSS Feed Structure

Example simplified RSS entry:

```xml
<item>
  <title>New Article</title>
  <link>https://example.com/article</link>
  <pubDate>Mon, 10 Mar 2026</pubDate>
  <description>Article summary...</description>
</item>
```

Automation systems parse this structure.

---

# RSS Automation Architecture

\begin{tikzpicture}[
node distance=2.8cm,
box/.style={draw, rectangle, rounded corners, minimum width=3cm, minimum height=1cm}
]

\node[box] (rss) {RSS Feed};
\node[box, right=1cm of rss] (script) {Python Polling Script};
\node[box, right=1cm of script] (process) {Automation Logic};

\draw[->] (rss) -- (script);
\draw[->] (script) -- (process);

\end{tikzpicture}

---

# Python Email Retrieval

Example: connect and read inbox.

```python
import imaplib
import email

imap = imaplib.IMAP4_SSL("imap.gmail.com")
imap.login("user@example.com", "password")
imap.select("INBOX")
status, messages = imap.search(None, "UNSEEN")
for num in messages[0].split():
    status, msg_data = imap.fetch(num, "(RFC822)")
    msg = email.message_from_bytes(msg_data[0][1])
    print("Subject:", msg["Subject"])
    print("From:", msg["From"])
```

---

# Processing Email Content

Email bodies may contain:

- structured text
- alerts
- machine-generated messages

Automation can extract:

- order numbers
- alert severity
- system identifiers

---

# Example Email Content Extraction

```python
for part in msg.walk():
    if part.get_content_type() == "text/plain":
        body = part.get_payload(decode=True).decode()
        print(body)
```

---

# Section: Sending Automated Email

Automation systems often __send notifications__.

Examples:

- monitoring alerts
- workflow approvals
- batch job completion
- error reporting

---

# Email Sending Architecture

\begin{tikzpicture}[
node distance=3cm,
box/.style={draw, rectangle, rounded corners, minimum width=3cm, minimum height=1cm}
]

\node[box] (system) {Automation Script};
\node[box, right=1cm of system] (smtp) {SMTP Server};
\node[box, right=1cm of smtp] (user) {Recipient};

\draw[->] (system) -- (smtp);
\draw[->] (smtp) -- (user);

\end{tikzpicture}

---

# SMTP: Simple Mail Transfer Protocol

SMTP is the protocol used for **sending email**.

Key concepts:

- SMTP server
- authentication
- message formatting

---

# Python Email Sending Example

```python
import smtplib
from email.message import EmailMessage
msg = EmailMessage()
msg["Subject"] = "Automation Alert"
msg["From"] = "bot@example.com"
msg["To"] = "admin@example.com"
msg.set_content("The nightly job completed successfully.")
with smtplib.SMTP_SSL("smtp.gmail.com", 465) as smtp:
    smtp.login("bot@example.com", "password")
    smtp.send_message(msg)
```

---

# Section: Receiving SMS Messages

SMS is widely used for __high priority alerts__.

Examples:

- security alarms
- infrastructure outages
- authentication codes
- delivery notifications

Computers cannot directly receive SMS without an _SMS gateway_.

---

# SMS Gateway Concept (Send & Receive)

An SMS gateway converts:

$$\text{Cellular network messages} \leftrightarrow \text{Internet requests}$$

Example providers:

- Twilio
- Nexmo
- Plivo

---

# SMS Reception Architecture

\begin{tikzpicture}[
node distance=3cm,
box/.style={draw, rectangle, rounded corners, minimum width=3cm, minimum height=1cm}
]

\node[box] (phone) {Mobile Phone};
\node[box, below of=phone] (provider) {Automated Alert Service};
\node[box, right=1cm of phone] (gateway) {SMS Gateway};
\node[box, right=1cm of gateway] (server) {Webhook Server};

\draw[->] (phone)    -- (gateway);
\draw[->] (provider) -- (gateway);
\draw[->] (gateway)  -- (server);

\end{tikzpicture}

---

# Webhooks

SMS services typically use $\textit{webhooks}$.

A webhook is:

$$\textit{An HTTP request automatically sent to a listening server(s)}$$
$$\textit{immediately after a triggering event occurs}$$

Your automation system runs a __web server__ to listen for and receive webhook events.

---

# Webhooks setup

1. You setup a listening server which waits to receive webhook events

2. You register you to receive webhook events and provide:
    - Your server URL
    - Your port number
    - Your desired events

3. The service sends webhook events to your server to be processed

---

# Python SMS Receiver Example

Set up a listening server using `Flask`.

```python
from flask import Flask, request
app = Flask(__name__)
@app.route("/sms", methods=["POST"])
def receive_sms():
    sender = request.form.get("From")
    message = request.form.get("Body")
    print("SMS from:", sender)
    print("Message:", message)
    return "OK"
app.run(port=5000)
```

Your server listens for webhook events on: `    example.com/sms:5000`

The SMS provider sends HTTP requests to: ` example.com/sms:5000`

---

# Section: Sending SMS Messages

Automation systems send SMS for:

- emergency alerts
- verification codes
- workflow notifications
- monitoring alerts

Typically implemented using __SMS APIs__.

---

# SMS Sending Architecture

\begin{tikzpicture}[
node distance=3cm,
box/.style={draw, rectangle, rounded corners, minimum width=3cm, minimum height=1cm}
]

\node[box] (system) {Automation Script};
\node[box, right=1cm of system] (gateway) {SMS Gateway API};
\node[box, right=1cm of gateway] (phone) {Mobile Phone};

\draw[->] (system) -- (gateway);
\draw[->] (gateway) -- (phone);

\end{tikzpicture}

---

# Python SMS Sending Example (Twilio)

```python
from twilio.rest import Client
account_sid = "YOUR_ACCOUNT_SID"
auth_token = "YOUR_AUTH_TOKEN"
client = Client(account_sid, auth_token)
message = client.messages.create(
    body="Automation alert: server offline",
    from_="+15551234567",
    to="+15557654321"
)
print(message.sid)
```

---

# Integrating Multiple Subscriptions

Automation systems often combine multiple inputs.

Example workflow:

1. Monitor RSS feed
2. Detect critical update
3. Send email alert
4. Send SMS alert

---

# Example Automation Pipeline

\begin{tikzpicture}[
node distance=2.5cm,
box/.style={draw, rectangle, rounded corners, minimum width=2.5cm, minimum height=1cm}
]

\node[box] (rss) {RSS Feed};
\node[box, right=1cm of rss] (script) {Python Monitor};
\node[box, right=1cm of script] (email) {Email Alert};
\node[box, below=1cm of email] (sms) {SMS Alert};

\draw[->] (rss) -- (script);
\draw[->] (script) -- (email);
\draw[->] (script) -- (sms);

\end{tikzpicture}

---

# Reliability Considerations

Automation systems must handle:

- network failures
- API rate limits
- authentication failures
- duplicate messages

Strategies:

- retry logic
- persistent state
- logging
- alert escalation

---

# Security Considerations

Risks include:

- API credential leakage
- spoofed webhook messages
- spam attacks

Best practices:

- use HTTPS
- verify webhook signatures
- store secrets securely
- rotate API keys

---

# Multi Factor Authentication

Multi factor authentication requirements by services can make automation challenging.

__Solutions:__

- Cached Manual Authentication (Cookies sharing)
- Federated Authentication (OAuth2)
- Hardware Authentication (YubiKey)

---

# Summary

Subscription monitoring and processing enables automation systems to respond to, and initiate, **external events**.

| Technology | Theoretical Type Signature |
|:----|:------|
| RSS feed monitoring | $\mathtt{process} \colon \underline{\mathtt{RSS\_feed}}          \;\to \mathtt{output}$ |
| email reception     | $\mathtt{process} \colon \underline{\mathtt{email}}\phantom{000}   \to \mathtt{output}$ |
| email sending       | $\mathtt{process} \colon \mathtt{input}\phantom{000} \to \underline{\mathtt{email}}$  |
| SMS reception       | $\mathtt{process} \colon \underline{\mathtt{SMS\_text}}          \;\to \mathtt{output}$ |
| SMS sending         | $\mathtt{process} \colon \mathtt{input}\phantom{000} \to \underline{\mathtt{SMS\_text}}$ |


---

# End of Lecture

$$\text{\huge Questions?}$$
