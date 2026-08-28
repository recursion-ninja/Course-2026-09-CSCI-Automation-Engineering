---
title: Lecture 12
subtitle: "Automated Web Form Submission"
date: 2026-03-18
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

# Automated Web Form Submission

## Lecture Overview

- Automating interaction with web forms
- Why programmatic form submission is useful
- Theory of browser automation
- Selenium for Python
- Inspecting browser POST requests
- Submitting forms using raw HTTP requests
- Key tasks:
  - Programmatic authentication
  - Locating form elements
  - Filling form fields
  - Form submission
  - Performing submission at an exact time

---

# Motivation

## Why Automate Web Forms?

Many business processes rely on web forms.

Examples:

- Submitting regulatory reports
- Entering inventory updates
- Uploading daily metrics
- Academic course registration
- Ticket purchasing systems
- Automated testing of web applications

Manual interaction becomes inefficient when:

- Tasks are repetitive
- Timing is critical
- Data originates from another system

Automation converts **human interaction workflows** into **computerized workflows**.

---

# Web Automation in Process Automation

## Where Web Automation Fits

Web automation acts as a **bridge** between systems that lack APIs.

Advantages:

- Works with almost any website
- Requires no cooperation from the site operator
- Can replicate human behavior precisely

Disadvantages:

- Fragile if site layout changes
- Must handle login sessions and cookies
- Slower than direct API calls

---

# Selenium

## Selenium Browser Automation

Selenium is a widely used browser automation framework.

Capabilities:

- Launch browsers programmatically
- Interact with page elements
- Simulate user input
- Wait for dynamic content
- Extract page data

---

# Running Example

## Scenario

Example task:

Automate submission of a **daily status report form**.

Fields include:

- Username
- Password
- Date
- Status text
- Confirmation checkbox

The automation script should:

1. Log into the website
2. Navigate to the form
3. Fill out the fields
4. Submit the form
5. Do so exactly at **9:00 AM**

---

# Selenium Initialization

This code:

- launches Chrome
- navigates to the login page

## Starting the Browser

```python
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys

driver = webdriver.Chrome()

driver.get("https://example.com/login")
```

---

# Understanding the DOM

## The Document Object Model

Web pages are hierarchical documents.

\begin{center}
\begin{tikzpicture}[
node distance=1.5cm,
every node/.style={draw, rectangle}
]

\node (html) {HTML};
\node (body) [below of=html] {BODY};
\node (form) [below of=body] {FORM};
\node (input1) [below left=1.5cm of form] {Username Field};
\node (input2) [below right=1.5cm of form] {Password Field};
\node (button) [below of=form] {Submit Button};

\draw (html) -- (body);
\draw (body) -- (form);
\draw (form) -- (input1);
\draw (form) -- (input2);
\draw (form) -- (button);

\end{tikzpicture}
\end{center}

Automation scripts interact with DOM elements.

---

# Programmatic Authentication

## Logging Into a Website

Authentication typically involves:

- locating login fields
- entering credentials
- clicking a login button

---

# Authentication Example

## Selenium Login Script

```python
from selenium import webdriver
from selenium.webdriver.common.by import By

driver = webdriver.Chrome()
driver.get("https://example.com/login")

username = driver.find_element(By.ID, "username")
password = driver.find_element(By.ID, "password")
username.send_keys("prof-washburn")
password.send_keys("you-will-never-guess")

login_button = driver.find_element(By.ID, "login-button")
login_button.click()
```

---

# Session Persistence

## Maintaining Login State

After login, websites maintain state using:

- cookies
- session identifiers

Selenium automatically maintains cookies while the browser session remains active.

Example:

```python
driver.get("https://example.com/report-form")
```

---

# Locating Form Elements

## Strategies for Finding Elements

Selenium provides multiple element selectors:

- ID
- Name
- CSS selector
- XPath
- Class name
- Tag name

Example:

```python
driver.find_element(By.ID, "username")
```

---

# Example HTML Form

## Example Form Structure

```html
<form id="report-form">
  <input id="date" type="text">
  <textarea id="status"></textarea>
  <input id="confirm" type="checkbox">
  <button id="submit">Submit</button>
</form>
```

---

# Filling Out Form Fields

## Sending Input

Selenium simulates typing.

```python
date_field = driver.find_element(By.ID, "date")
status_box = driver.find_element(By.ID, "status")

date_field.send_keys("2026-03-18")

status_box.send_keys(
    "Daily automation completed successfully."
)
```

---

# Handling Checkboxes

## Checkbox Interaction

```python
confirm = driver.find_element(By.ID, "confirm")

if not confirm.is_selected():
    confirm.click()
```

---

# Submitting Forms

## Submission

```python
submit_button = driver.find_element(By.ID, "submit")
submit_button.click()

# This triggers the same behavior as a user clicking the button.
```

---

# Waiting for Dynamic Content

## Explicit Waits

```python
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

wait = WebDriverWait(driver, 10)

submit_button = wait.until(
    EC.element_to_be_clickable((By.ID, "submit"))
)
```

---

# Performing Submission at an Exact Time

## Timing Workflow

\begin{center}
\begin{tikzpicture}[
node distance=2cm,
box/.style={draw, rectangle, rounded corners}
]

\node[box] (start) {Start Script};
\node[box, right=2cm of start] (wait) {Wait Until Target Time};
\node[box, below of=wait] (fill) {Fill Form};
\node[box, right=2cm of fill] (submit) {Submit Form};

\draw[->] (start) -- (wait);
\draw[->] (wait) -- (fill);
\draw[->] (fill) -- (submit);

\end{tikzpicture}
\end{center}

---

# Python Timing Example

```python
import datetime
import time

target = datetime.datetime(2026,3,18,9,0,0)

while datetime.datetime.now() < target:
    time.sleep(0.5)

print("Submitting form now")
```
---


# Complete Selenium Example

```python
from selenium import webdriver
from selenium.webdriver.common.by import By
import datetime
import time

driver = webdriver.Chrome()
driver.get("https://example.com/login")

driver.find_element(By.ID,"username").send_keys("alice")
driver.find_element(By.ID,"password").send_keys("mypassword")
driver.find_element(By.ID,"login-button").click()
```

---

# Complete Selenium Example (Continued)

```python
driver.get("https://example.com/report-form")
driver.find_element(By.ID,"date"  ).send_keys("2026-03-18")
driver.find_element(By.ID,"status").send_keys("Success!")

confirm = driver.find_element(By.ID,"confirm")
if not confirm.is_selected():
    confirm.click()

target = datetime.datetime(2026,3,18,9,0,0)
while datetime.datetime.now() < target:
    time.sleep(0.5)

driver.find_element(By.ID,"submit").click()
```

---

# Inspecting Form Submission Requests

## Understanding What the Browser Sends

When a form is submitted, the browser sends an **HTTP POST request**.

To inspect it:

1. Open browser developer tools
2. Navigate to **Network tab**
3. Submit the form manually
4. Locate the POST request

Information revealed includes:

- request URL
- form parameters
- cookies
- headers

---

# Example Captured POST Request

## Network Inspector Example

Example request captured from the browser:

```
POST /submit-report HTTP/1.1
Host: example.com
Content-Type: application/x-www-form-urlencoded
Cookie: session=abc123

date=2026-03-18&
status=Daily+automation+completed&
confirm=on
```

This shows exactly what the browser transmitted.

---

# Visualizing the Request

\begin{center}
\begin{tikzpicture}[
box/.style={draw, rectangle, rounded corners, minimum width=3cm, minimum height=1cm},
arrow/.style={->}
]

\node[box] (browser) {Browser};
\node[box, right=4.5cm of browser] (server) {Web Server};

\draw[arrow] (browser) -- node[above]{POST /submit-report} (server);

\end{tikzpicture}
\end{center}

A browser submission is simply an HTTP request.

---

# Direct HTTP Form Submission

## Bypassing the Browser

Instead of automating a browser, we can send the same POST request directly.

Advantages:

- faster
- less fragile
- lower resource usage

Disadvantages:

- harder when JavaScript logic is involved
- must manually manage cookies and tokens

---

# Python Requests Library

## Installing

```bash
pip install requests
```

Basic usage:

```python
import requests

response = requests.get("https://example.com")
```

---

# Constructing the POST Request

## Reproducing the Browser Request

```python
import requests

url = "https://example.com/submit-report"

data = {
    "date": "2026-03-18",
    "status": "Daily automation completed",
    "confirm": "on"
}

response = requests.post(url, data=data)

print(response.status_code)
```

---

# Handling Login with Requests

Many forms require authentication.

`requests` provides persistent sessions.

## Session Objects

```python
import requests

session = requests.Session()
login_data = {
    "username": "alice",
    "password": "mypassword"
}
session.post(
    "https://example.com/login",
    data=login_data
)
```

---

# Submitting the Form via Requests

## Full Example

```python
import requests

session = requests.Session()

login_data = {
    "username": "alice",
    "password": "mypassword"
}

session.post(
    "https://example.com/login",
    data=login_data
)

form_data = {
    "date": "2026-03-18",
    "status": "Daily automation completed successfully",
    "confirm": "on"
}

response = session.post(
    "https://example.com/submit-report",
    data=form_data
)

print(response.text)
```

---

# Selenium vs Requests

## Comparison

| Approach | Advantages | Disadvantages |
|---|---|---|
| Selenium | Works with complex JS sites | Slower |
| Requests | Fast and lightweight | Harder with dynamic sites |

Best practice:

- use **requests when possible**
- use **Selenium when necessary**

---

# Summary

## Key Takeaways

Automated web form submission is a powerful technique for process automation.

Two main strategies exist:

1. **Browser automation (Selenium)**
2. **Direct HTTP requests (requests library)**

Understanding how browsers submit POST requests allows automation scripts to replicate form submissions efficiently.

---

# Discussion Questions

1. When should direct HTTP requests be used instead of Selenium?
2. What risks exist when automating web submissions?
3. How could this automation be deployed on a server?
4. What safeguards should be implemented to prevent automation failures?

---

# End of Lecture

$$\text{\huge Questions?}$$
