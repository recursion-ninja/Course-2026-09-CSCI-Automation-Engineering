---
title: Lecture 07
subtitle: Computerized Process Automation with Human Input Devices
date: 2026-03-02
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
 - \usetikzlibrary{arrows.meta, positioning}
---

---

# What is process input?

$$\mathtt{process} \colon \underline{\underline{\mathtt{input}}} \to \mathtt{output}$$

---

# How does a human provide process input?

Humans sending input to a computer probably looks like one of these.

\includegraphics[height=0.2\paperheight]{INPUT-keyboard.jpg}
\includegraphics[height=0.2\paperheight]{INPUT-mouse.png}
\includegraphics[height=0.2\paperheight]{INPUT-touch-screen.jpg}
\newline
\includegraphics[height=0.2\paperheight]{INPUT-steering-wheel.jpg}
\includegraphics[height=0.2\paperheight]{INPUT-joystick.png}
\includegraphics[height=0.2\paperheight]{INPUT-gamepad.jpeg}

---

# Humans use "Human Interface Devices" (HID)

Examples:

- Keyboard
- Mouse
- Touchscreen
- Microphone
- Camera
- Game controller
- Biometric reader

Purpose:

Allow humans to control computer systems.

---

# Human Input Device (HID) Architecture

\begin{tikzpicture}[
node distance=2.5cm,
every node/.style={draw, rectangle, minimum width=3.0cm, minimum height=1cm,outer sep=0.5cm}
]

\node (human) {Human};
\node (device) [below of=human] {Input Device};
\node (driver) [right=1cm of device] {Device Driver};
\node (os) [right=1cm of driver] {Operating System};
\node (app) [below of=os] {Application};

\draw[->] (human) -- (device);
\draw[->] (device) -- (driver);
\draw[->] (driver) -- (os);
\draw[->] (os) -- (app);

\end{tikzpicture}

---

# Keyboard Example: Pressing a Key

When you press the "A" key:

1. Keyboard hardware detects press
2. Keyboard firmware generates scan code
3. USB transmits scan code
4. Device driver receives scan code
5. Operating system converts scan code to event
6. Application receives event

---

# Input Events

Operating systems use abstract input events.

Examples:

- KEYDOWN(A)
- KEYUP(A)
- MOUSEMOVE(x,y)
- CLICK(left)

Applications respond to events, not hardware directly.

---

# Event Queue Architecture

\begin{tikzpicture}[
node distance=4cm,
every node/.style={draw, rectangle, minimum width=3cm, minimum height=1cm}
]

\node (device) {Input Device};
\node (queue) [right of=device] {Event Queue};
\node (app) [right of=queue] {Application};

\draw[->] (device) -- (queue);
\draw[->] (queue) -- (app);

\end{tikzpicture}

---

# Critical Insight

If hardware can generate input events...

Software can generate input events too.

This enables:

- Automation
- Accessibility tools
- Testing frameworks
- Macros

And also:

- Malware
- Keystroke injection attacks

---

# Two Categories of Input Simulation

## Software-Level Simulation

Software tells OS to generate input events.

Examples:

- AutoHotKey
- xdotool
- AppleScript
- Selenium

---

## Hardware-Level Simulation

Device pretends to be keyboard.

Examples:

- Arduino Leonardo
- USB Rubber Ducky
- Malicious USB device

OS trusts the device automatically.

---

# Demonstration 1: AutoHotKey

AutoHotKey is a scripting language for input automation.

Example script:

```ahk
; demo.ahk
^j::
Send, Hello students!
Send, {Enter}
Send, This text was generated automatically.
Send, {Enter}
Send, Automation is powerful.
return
```

Press CTRL+J → automatic typing occurs.

---

# AutoHotKey Architecture

\begin{tikzpicture}[
node distance=4cm,
every node/.style={draw, rectangle, minimum width=3cm, outer sep=0.5cm, minimum height=1cm}
]

\node (script) {AutoHotKey Script};
\node (os) [below of=script] {Operating System};
\node (app) [right=2cm of os] {Application};

\draw[->] (script) -- (os);
\draw[->] (os) -- (app);

\end{tikzpicture}

---

# Demonstration 2: Selenium Automation

Selenium automates web browsers.

Capabilities:

- Typing text
- Clicking buttons
- Navigating pages

---

# Selenium Architecture

\begin{tikzpicture}[
node distance=4cm,
every node/.style={draw, rectangle, minimum width=3cm, minimum height=1cm}
]

\node (script) {Python Script};
\node (driver) [right of=script] {Browser Driver};
\node (browser) [right of=driver] {Browser};

\draw[->] (script) -- (driver);
\draw[->] (driver) -- (browser);

\end{tikzpicture}

---

# Selenium Example Script

```python
from selenium import webdriver
from selenium.webdriver.common.by import By
import time

driver = webdriver.Firefox()
driver.get("https://example.com")

time.sleep(2)

body = driver.find_element(By.TAG_NAME, "body")
body.send_keys("Hello from Selenium automation!")

time.sleep(5)

driver.quit()
```

---

# Hardware Input Simulation

USB devices can impersonate keyboards.

Operating system cannot distinguish:

- Real keyboard
- Fake keyboard

---

# USB Injection Architecture

\begin{tikzpicture}[
node distance=4cm,
every node/.style={draw, rectangle, minimum width=3.5cm, minimum height=1cm}
]

\node (device) {Malicious USB Device};
\node (os) [below of=device] {Operating System};
\node (app) [right=2cm of os] {Application};

\draw[->] (device) -- (os);
\draw[->] (os) -- (app);

\end{tikzpicture}

---

# Demonstration 3: USB Keystroke Injection

Arduino Leonardo example:

```c
#include <Keyboard.h>

void setup() {
    Keyboard.begin();
    delay(2000);
    Keyboard.print("echo Device compromised");
    Keyboard.press(KEY_RETURN);
    Keyboard.releaseAll();
    Keyboard.end();
}
```

This executes automatically when plugged in.

---

# Why This Attack Works

USB protocol has no authentication.

Operating system trusts all keyboards implicitly.

This is a fundamental security limitation.

---

# HID Legitimate Uses

Input simulation enables:

- Automated testing
- Accessibility tools
- Workflow automation
- Repetitive task automation

Widely used in industry.

---

# Malicious Uses

Input simulation can enable:

- Malware installation
- Credential theft
- Unauthorized commands
- Privilege escalation

---

# Ethical Considerations

Automation tools are powerful.

- We can remove humans from _productive_ processes!

- We can remove humans from _destructive_ processes...

Use responsibly.

Always obtain authorization.

Never perform unauthorized attacks.

---

# Summary

Human input devices generate events.

Operating systems abstract input events.

Software and hardware can simulate input.

Simulation enables automation, both for good and ill.

---

# End of Lecture

Questions?
