---
title: Lecture 11
subtitle: "Web Scraping"
date: 2026-03-16
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


# Motivation for Web Scraping

## Why Scrape Websites?

Real-world processes require collecting information from websites.

Examples include:

- Monitoring product prices
- Collecting job listings
- Monitoring regulatory updates
- Collecting news articles
- Monitoring shipment status
- Tracking financial indicators

Without automation, humans must repeatedly check webpages.

---

## Manual Data Collection

Typical human workflow:

1. Open a browser
2. Navigate to a webpage
3. Locate information
4. Copy the data
5. Paste into spreadsheet or system
6. Repeat regularly

This process is repetitive and error-prone.

---

## Automated Data Collection

Automated workflow:

1. Script downloads webpage
2. Script locates data
3. Script extracts data
4. Script stores results
5. Script triggers additional automation

Automation replaces manual steps.

---

## Web Scraping Pipeline

\begin{tikzpicture}[node distance=2.8cm, >=Stealth]

\node[draw, rectangle] (web) {Website};
\node[draw, rectangle, right=1cm of web] (scraper) {Scraper};
\node[draw, rectangle, right=1cm of scraper] (parser) {Parser};
\node[draw, rectangle, right=1cm of parser] (storage) {Database};
\node[draw, rectangle, below of=storage] (automation) {Automation Action};

\draw[->] (web) -- (scraper);
\draw[->] (scraper) -- (parser);
\draw[->] (parser) -- (storage);
\draw[->] (storage) -- (automation);

\end{tikzpicture}

---

# HTML Fundamentals

## HyperText Markup Language

HTML defines the **structure of web pages**.

- Headings
- Paragraphs
- Images
- Links
- Tables
- Forms

HTML does **not** control program logic. It only describes page structure.

---

Key idea: HTML consists of **nested elements**.

## Example HTML Document

```html
<html>
  <head>
    <title>Example Page</title>
  </head>

  <body>
    <h1>Hello World</h1>
    <p>This is a paragraph.</p>
  </body>
</html>
```


---

## The Document Object Model (DOM) Tree

Browsers convert HTML into a **Document Object Model (DOM)** tree.

\begin{tikzpicture}[level distance=1.5cm,
  sibling distance=3cm]

\node {html}
  child { node {head}
      child { node {title} }
  }
  child { node {body}
      child { node {h1} }
      child { node {p} }
  };

\end{tikzpicture}

Automation tools navigate this tree to locate elements.

---

## HTML Elements

Common elements used in scraping:

| Element | Purpose |
|------|------|
| `h1`–`h6` | Headings |
| `p` | Paragraph |
| `a` | Hyperlink |
| `div` | Structural container |
| `span` | Inline container |
| `table` | Tabular data |

Example:

```html
<div class="product">
  <h2>Keyboard</h2>
  <span class="price">$49</span>
</div>
```

---

## Attributes

Elements can contain attributes.

Example:

```html
<a href="https://example.com" class="nav-link">Home</a>
```

Important attributes for scraping:

- `id`
- `class`
- `href`
- `src`
- `name`

These attributes allow automation tools to identify elements.

---

# Parsing HTML with Python

## Common Python Scraping Libraries

Popular tools include:

| Library | Purpose |
|------|------|
| `requests` | Download webpages |
| `BeautifulSoup` | Parse HTML |
| `lxml` | Fast HTML parser |
| `Selenium` | Browser automation |

For simple pages, `requests` + `BeautifulSoup` is sufficient.

---

## Downloading a Webpage

Example using Python `requests`:

```python
import requests

url = "https://example.com"

response = requests.get(url)

html = response.text

print(html[:500])
```

This retrieves the raw HTML sent by the server.

---

## Parsing HTML with BeautifulSoup

```python
from bs4 import BeautifulSoup
import requests

url = "https://example.com"

html = requests.get(url).text

soup = BeautifulSoup(html, "html.parser")

print(soup.title.text)
```

BeautifulSoup converts HTML into a searchable object structure.

---

## Extracting Elements

Extract all hyperlinks:

```python
links = soup.find_all("a")

for link in links:
    print(link.get("href"))
```

Extract elements by class:

```python
prices = soup.find_all("span", class_="price")
```

---

# Static vs Dynamic Websites

## Static Webpages

Static pages:

- Server sends full HTML
- Data is immediately visible
- Easy to scrape

Process:

1. Download HTML
2. Parse elements
3. Extract data

---

## Dynamic Webpages

Dynamic pages use JavaScript.

Frameworks include:

- React
- Angular
- Vue

JavaScript modifies the page **after it loads**.

Traditional scrapers cannot see these updates.

---

## Rendering Process

\begin{tikzpicture}[node distance=3cm, >=Stealth]

\node[draw, rectangle] (server) {Server HTML};
\node[draw, rectangle, right=1cm of server] (browser) {Browser};
\node[draw, rectangle, below of=browser] (dom0) {Initial DOM};
\node[draw, rectangle, below of=dom0] (js) {JavaScript Execution};
\node[draw, rectangle, right=1cm of js] (dom1) {Final DOM};

\draw[->] (server) -- (browser);
\draw[->] (browser) -- (dom0);
\draw[->] (dom0) -- (js);
\draw[->] (js) -- (dom1);
\end{tikzpicture}

Solution: automate a real browser.

---

# Selenium Browser Automation

## What is Selenium?

Selenium is a **browser automation framework**.

It allows programs to control browsers like a human.

Capabilities include:

- Opening pages
- Clicking buttons
- Filling forms
- Executing JavaScript
- Navigating between pages

---

## Selenium Architecture

\begin{tikzpicture}[node distance=3cm, >=Stealth]

\node[draw, rectangle] (script) {Python Script};
\node[draw, rectangle, right=1cm of script] (driver) {WebDriver};
\node[draw, rectangle, right=1cm of driver] (browser) {Browser};
\node[draw, rectangle, right=1cm of browser] (web) {Website};

\draw[->] (script) -- (driver);
\draw[->] (driver) -- (browser);
\draw[->] (browser) -- (web);

\end{tikzpicture}

WebDriver acts as the control interface.

---

This launches a real browser session.

## Basic Selenium Example

```python
from selenium import webdriver

driver = webdriver.Chrome()

driver.get("https://example.com")

print(driver.title)

driver.quit()
```

---

# Locating Elements

## Why Element Location Matters

Automation must identify elements before interacting with them.

Common selection methods:

- ID
- Class name
- Tag name
- CSS selector
- XPath

---

## Example HTML

```html
<button id="login-btn" class="primary">
  Login
</button>
```

Possible selectors include:

- `id="login-btn"`
- `.primary`
- `button`

---

## Selenium Element Location

Locate element by ID:

```python
from selenium.webdriver.common.by import By

# Locate element by ID:
button = driver.find_element(By.ID, "login-btn")

button.click()

# Locate element by class:
button = driver.find_element(By.CLASS_NAME, "primary")
```

---

## CSS Selectors

CSS selectors allow flexible element queries.

Example:

```python
driver.find_element(By.CSS_SELECTOR, "div.product span.price")
```

This selects:

- `span.price`
- inside `div.product`

---

## XPath Selectors

XPath navigates the DOM tree.

Example:

```python
driver.find_element(By.XPATH, "//div[@class='product']//span")
```

XPath is useful for complex structures.

---

# Interacting with Elements

## Clicking Elements

```python
button = driver.find_element(By.ID, "submit")

button.click()
```

This simulates a user click.

---

## Typing into Form Fields

```python
username = driver.find_element(By.ID, "username")
password = driver.find_element(By.ID, "password")

username.send_keys("prof-washburn")
password.send_keys("supa_secure_plaintext")
```

---

## Submitting a Form

```python
driver.find_element(By.ID, "login-btn").click()
```

or

```python
password.submit()
```

---

## Waiting for Page Elements

Dynamic content may require waiting.

```python
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

wait = WebDriverWait(driver, 10)

element = wait.until(
    EC.presence_of_element_located((By.ID, "price"))
)
```

---

# Mimicking User Workflows

## Workflow Automation

Automation scripts often mimic real user behavior.

Example workflow:

1. Open site
2. Login
3. Navigate to page
4. Extract information
5. Save results

---

## Workflow Diagram

\begin{tikzpicture}[node distance=2.5cm, >=Stealth]

\node[draw, rectangle] (start) {Start};
\node[draw, rectangle, right=1cm of start] (login) {Login};
\node[draw, rectangle, right=1cm of login] (navigate) {Navigate};
\node[draw, rectangle, right=1cm of navigate] (scrape) {Extract Data};
\node[draw, rectangle, right=1cm of scrape] (save) {Save Data};

\draw[->] (start) -- (login);
\draw[->] (login) -- (navigate);
\draw[->] (navigate) -- (scrape);
\draw[->] (scrape) -- (save);

\end{tikzpicture}

---

## Example Automation Script

```python
from selenium import webdriver
from selenium.webdriver.common.by import By

driver = webdriver.Chrome()
driver.get("https://example.com/login")

driver.find_element(By.ID, "username").send_keys("user")
driver.find_element(By.ID, "password").send_keys("password")
driver.find_element(By.ID, "login-btn").click()

driver.get("https://example.com/products")

price = driver.find_element(By.CLASS_NAME, "price").text
print(price)

driver.quit()
```

---

# Saving Scraped Data

## Common Storage Formats

Scraped data may be stored in:

- CSV files
- JSON files
- SQL databases
- Data warehouses

---

## Writing Data to CSV

```python
import csv

with open("prices.csv", "w") as f:
    writer = csv.writer(f)

    writer.writerow(["Product", "Price"])
    writer.writerow(["Keyboard", "$49"])
```

---

# Ethical and Legal Considerations

## Responsible Scraping

Before scraping a website, check:

- Terms of service
- `robots.txt` policies
- Rate limits

Avoid:

- Overloading servers
- Circumventing authentication
- Collecting personal data without permission

---

## Good Automation Practices

Best practices include:

- Use rate limiting
- Log activity
- Handle errors gracefully
- Cache results when possible
- Monitor automation failures

---

# Summary

## Key Takeaways

Web scraping enables powerful automation.

Key concepts:

- Understanding HTML structure
- Parsing webpages with Python
- Handling dynamic content
- Using Selenium for browser automation
- Locating and interacting with elements
- Mimicking real user workflows
- Storing extracted data responsibly

---

# End of Lecture

$$\text{\huge Questions?}$$
