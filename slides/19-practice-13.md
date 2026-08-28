---
title: Lecture 19
subtitle: "Process Automation in the Age of A.I."
date: 2026-04-27
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

# Overview

- What is process automation?
- Humans vs. machines: strengths and weaknesses
- Comparative advantage (from economics)
- Designing hybrid human–machine systems
- LLMs in code generation and collaboration
- Case studies and best practices

---

# What is Process Automation?

- Use of software/hardware to execute tasks with minimal human intervention
- Applies to:
  - Business workflows
  - Data processing pipelines
  - DevOps and CI/CD
- Goal: improve **efficiency**, **consistency**, and **scalability**

---

# Why Automate?

- Reduce human error
- Increase throughput
- Enable reproducibility
- Free humans for higher-level work

> Key idea: Automation is not about replacing humans—it is about **reallocating effort**

---

# Human Strengths

Humans excel at:

- Creativity and innovation
- Ambiguous problem solving
- Ethical reasoning
- Contextual understanding
- Communication and collaboration

---

# Machine Strengths

Machines excel at:

- Repetition and consistency
- High-speed computation
- Large-scale data processing
- Deterministic execution
- Memory and recall

---

# Mismatch = Inefficiency

Bad system design occurs when:

- Humans do repetitive data entry
- Machines make subjective decisions
- Humans manually execute deterministic workflows

---

# Core Principle

1. > **Let humans do what humans are best at.**

2. > **Let machines do what machines are best at.**

---

# Introducing Comparative Advantage

- Concept from economics
- Traditionally applied to trade between countries
- Explains **efficient specialization**

---

# Comparative Advantage (Definition)

Even if one party is better at everything:

- Efficiency is maximized when each focuses on tasks with the **lowest opportunity cost**

---

# Example (Economics)

Two countries:

- Country A: good at producing both wine and cloth
- Country B: worse at both

Still:

- A specializes in what it is *relatively* best at
- B specializes in what it is *least bad* at

---

# Translating to Automation

Replace:

- Countries → Humans vs Machines
- Goods → Tasks

---

# Example: Comparative Advantage with Real Numbers

::: columns
:::: column
Consider output per hour:

|            | Feature | Tests |
|------------|--------|-------|
| Human      | 4      | 8     |
| A.I. (LLM) | 6      | 24    |

::::
:::: column

## Step 1: Absolute Advantage

- Machine is better at both tasks
- (Higher output in both categories)

::::
:::

---

::: columns
:::: column
Consider output per hour:

|            | Feature | Tests |
|------------|--------|-------|
| Human      | 4      | 8     |
| A.I. (LLM) | 6      | 24    |

::::
:::: column

## Step 2: Opportunity Cost

- Human:
  - 1 Code Feature = 2 Unit Tests
  - 1 Unit Test = 0.5 Code Features

- Machine:
  - 1 Code Feature = 4 Unit Tests
  - 1 Unit Test = 0.25 Code Features

::::
:::

---

::: columns
:::: column
Consider output per hour:

|            | Feature | Tests |
|------------|--------|-------|
| Human      | 4      | 8     |
| A.I. (LLM) | 6      | 24    |

::::
:::: column

## Step 3: Comparative Advantage

- Human has lower cost in **Code Features** (2 < 4)
- Machine has lower cost in **Unit Tests** (0.25 < 0.5)

::::
:::

---

| Human   | A.I.    | Features | Tests |
|---------|---------|----------|-------|
| Feature | Feature |  10      | 0     |
| Feature | Test    |   4      | 24    |
| Test    | Feature |   6      | 8     |
| Test    | Test    |   0      | 32    |

*How many features are with how many tests?*

---

$$4*8 + 6y = 24*(8-y)$$
$$32 + 6y = 192 - 24y$$
$$30y = 160$$
$$y = \frac{16}{3}$$

|            | Features  | Tests |
|------------|:----------|:------|
| Human      | 4*8*      | 8*0   |
| A.I. (LLM) | 6*(16/3)  | 24*(8/3) |
| Total      |  64       | 64 |

---

## Conclusion

> Even though the machine is better at everything,
efficiency improves when:

- Human specializes in **Code Features**
- Machine specializes in **Unit Tests**

---

# Comparative Advantage in Automation

| Task Type                 | Best Agent |
|---------------------------|------------|
| Repetitive computation    | Machine    |
| Pattern recognition       | Machine    |
| Ambiguous decision-making | Human      |
| Creative problem-solving  | Human      |

---

# Opportunity Cost in Engineering

- If a developer spends time:
  - Writing boilerplate code → high opportunity cost
  - Designing system architecture → low opportunity cost

---

# Enter Large Language Models (LLMs)

- Neural networks trained on large corpora
- Capable of:
  - Code generation
  - Natural language understanding
  - Reasoning (approximate)

---

# LLMs as Automation Tools

LLMs automate:

- Code scaffolding
- Documentation generation
- Refactoring suggestions
- Test case generation

---

# Comparative Advantage: Humans vs LLMs

| Task                     | Best Agent |
|--------------------------|------------|
| Writing boilerplate      | LLM        |
| Designing architecture   | Human      |
| Debugging edge cases     | Human      |
| Generating examples      | LLM        |

---

# LLMs in Code Generation

Strengths:

- Speed
- Pattern recognition
- Knowledge recall

Weaknesses:

- Hallucinations
- Lack of deep understanding
- Poor edge-case reasoning

---

# Human + LLM Collaboration

Effective workflow:

1. Human defines problem
2. LLM generates draft
3. Human reviews and corrects
4. LLM iterates

---

We think in categories to colaborate with others, human or A.I.

- Human define the nodes and edges
- A.I. implements the edges as data transforms
- Human vefifies and glues the program together

\begin{tikzpicture}[>=stealth, node distance=3cm]
  % Nodes (Categories)
  \node (A) {$\mathtt{A}$};
  \node (B) [right of=A] {$\mathtt{B}$};
  \node (C) [below of=A] {$\mathtt{C}$};
  \node (D) [right of=C] {$\mathtt{D}$};
  \node (E) [right of=B] {$\mathtt{E}$};

  % Morphisms
  \draw[->] (A) to[bend left=20] node[above] {$f$} (B);
  \draw[->] (B) to[bend left=20] node[below] {$g$} (A);

  \draw[->] (A) to node[left] {$h$} (C);
  \draw[->] (B) to node[right] {$i$} (D);

  \draw[->] (C) to[bend left=20] node[above] {$j$} (D);
  \draw[->] (D) to[bend left=20] node[below] {$k$} (C);

  \draw[->] (B) to node[above] {$l$} (E);
  \draw[->] (D) to node[below] {$m$} (E);

\end{tikzpicture}


---

# Future of Automation

- Increasing human-AI collaboration
- More adaptive systems
- Greater emphasis on oversight

---

# Key Takeaways

- Automation is about **task allocation**
- Comparative advantage applies to humans vs machines
- LLMs are powerful but imperfect tools
- Hybrid systems outperform purely manual or automated ones

---

# Exercise

- Take a simple process (e.g., grading, scheduling)
- Break it into tasks
- Assign each to:
  - Human
  - Machine
  - Hybrid

---

# Closing Thought

> The best systems are not fully automated—
they are **intelligently partitioned**.

---

# End of Lecture

$$\text{\huge Questions?}$$
