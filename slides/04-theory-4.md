---
title: Lecture 4
subtitle: Data Transformations
date: 2026-02-09
theme: "Frankfurt"
colortheme: "beaver"
fonttheme: "professionalfonts"
mainfont: Font-Regular.otf
mainfont: DejaVuSerif.ttf
sansfont: DejaVuSans.ttf
monofont: DejaVuSansMono.ttf
mathfont: texgyredejavu-math.otf
header-includes: |
  \usepackage{tikz}
  \usetikzlibrary{automata,positioning,arrows.meta}
  \newcommand{\Cons}{%
  \mathrel{::}%
  }
  \newcommand{\Brackets}[1]{\ensuremath{\left[\;#1\;\right]}\xspace}
  \newcommand{\Tuple}[1]{\ensuremath{\left\langle\;#1\;\right\rangle}\xspace}
  \newcommand{\Parens}[1]{\ensuremath{\left(\;#1\;\right)}\xspace}
  \newcommand{\SetNote}[1]{\ensuremath{\left\{\;#1\;\right\}}\xspace}
  \newcommand{\IndexRange}[2]{\ensuremath{\texttt{{[}\,#1,\ #2\,{]}}}\xspace}
  \newcommand{\NumericRange}[2]{\ensuremath{\left[\,#1,\; #2\,\right]}\xspace}
---

# Motivation: Digital Business Processes

- Modern businesses automate *processes*
- Examples:
  - Orders
  - Payments
  - User onboarding
  - Support tickets

**Key question:** what happens *next*?

---

# A Common Problem

- Steps must happen in order
- Some actions are only valid sometimes
- Bugs come from invalid sequences

> “You can’t ship before payment”

---

# Problem 1: Order Processing

- Order created
- Payment
- Shipping
- Completion

What if:
- Payment fails?
- User cancels?

---

# Problem 2: Customer Onboarding

- Account created
- Email verified
- Profile completed
- Account activated

Rules matter.

---

# Why Ad-Hoc Logic Fails

- Many flags
- Nested `if/else`
- Hard to reason about
- Easy to break

We want **structure**.

---

# Finite State Machines

A **Finite State Machine (FSM)**:

- Finite set of states
- Events cause transitions
- Only legal transitions allowed

FSMs model *processes*.

---

# States

A **state** represents:

- Where we are
- What is allowed now

Examples:

- `Paid`
- `Shipped`
- `Active`

---

# Transitions

A **transition**:

- Triggered by an event
- Moves between states

If no transition exists → event is invalid

---

# Formal Definition

An FSM is a 5-tuple:

$$\Parens{Q,\, \Sigma,\, \delta,\, q_0,\, F}$$

- $Q$: states
- $\Sigma$: events
- $q_0$: start state
- $F$: accepting states
- $\delta \colon \Sigma \rightarrow Q \rightarrow Q$: transition function

---

# Onboarding FSM Diagram

\begin{center}
\begin{tikzpicture}[->,>=Stealth,auto,node distance=3cm,thick]
  \tikzstyle{state}=[circle,draw,minimum size=1.3cm]
  \tikzstyle{accepting}=[double distance=1.5pt]

  \node[state] (Created) {Created};
  \node[state] (Verified) [right of=Created] {Verified};
  \node[state] (Profile) [right of=Verified] {Profile};
  \node[state,accepting] (Active) [right of=Profile] {Active};

  \path
    (Created)  edge[bend left] node {verify} (Verified)
    (Verified) edge[bend left] node {moreInfo} (Profile)
    (Profile)  edge[bend left] node {activate} (Active)

    (Created)  edge[dashed,red,bend right] (Profile)
    (Created)  edge[dashed,red,bend right] (Active)
    (Verified) edge[dashed,red,bend right] (Active)

    (Verified) edge[dashed,red,bend left] (Created)
    (Profile)  edge[dashed,red,bend left] (Created)
    (Profile)  edge[dashed,red,bend left] (Verified)

    (Active)   edge[dashed,red,bend left] (Created)
    (Active)   edge[dashed,red,bend left] (Verified)
    (Active)   edge[dashed,red,bend left] (Profile);
\end{tikzpicture}
\end{center}

---

# Onboarding FSM Diagram *(only valid)*

\begin{center}
\begin{tikzpicture}[->,>=Stealth,auto,node distance=3cm,thick]
  \tikzstyle{state}=[circle,draw,minimum size=1.3cm]
  \tikzstyle{accepting}=[double distance=1.5pt]

  \node[state] (Created) {Created};
  \node[state] (Verified) [right of=Created] {Verified};
  \node[state] (Profile) [right of=Verified] {Profile};
  \node[state,accepting] (Active) [right of=Profile] {Active};

  \path
    (Created)  edge[bend left] node {verify} (Verified)
    (Verified) edge[bend left] node {moreInfo} (Profile)
    (Profile)  edge[bend left] node {activate} (Active);

\end{tikzpicture}
\end{center}

---

# FSM Values

\begin{center}
\begin{tikzpicture}[->,>=Stealth,auto,node distance=3cm,thick,scale=0.6, every node/.style={scale=0.6}]
  \tikzstyle{state}=[circle,draw,minimum size=1.3cm]
  \tikzstyle{accepting}=[double distance=1.5pt]

  \node[state] (Created) {Created};
  \node[state] (Verified) [right of=Created] {Verified};
  \node[state] (Profile) [right of=Verified] {Profile};
  \node[state,accepting] (Active) [right of=Profile] {Active};

  \path
    (Created)  edge[bend left] node {verify} (Verified)
    (Verified) edge[bend left] node {moreInfo} (Profile)
    (Profile)  edge[bend left] node {activate} (Active);

\end{tikzpicture}
\end{center}

- $Q$: $\SetNote{\mathtt{Created},\, \mathtt{Verified},\,\mathtt{Profile},\,\mathtt{Active}}$
- $\Sigma$: $\SetNote{\mathtt{verify},\, \mathtt{moreInfo},\,\mathtt{activate}}$
- $q_0$: $\SetNote{\mathtt{Created}}$
- $F$: $\SetNote{\mathtt{Active}}$
- $\delta \colon \Sigma \rightarrow Q \rightarrow Q$:
  $\begin{cases}
   \Parens{\mathtt{Created},\,\mathtt{verify}} \to \mathtt{Verified}\\
   \Parens{\mathtt{Verified},\,\mathtt{moreInfo}} \to \mathtt{Profile}\\
   \Parens{\mathtt{Profile},\,\mathtt{activate}} \to \mathtt{Active}\\
   \text{otherwise} \to \mathtt{undefined}\end{cases}$

---

\begin{center}
\begin{tikzpicture}[->,>=Stealth,auto,node distance=3cm,thick,scale=0.6, every node/.style={scale=0.6}]
  \tikzstyle{state}=[circle,draw,minimum size=1.3cm]
  \tikzstyle{accepting}=[double distance=1.5pt]

  \node[state] (Created) {Created};
  \node[state] (Verified) [right of=Created] {Verified};
  \node[state] (Profile) [right of=Verified] {Profile};
  \node[state,accepting] (Active) [right of=Profile] {Active};

  \path
    (Created)  edge[bend left] node {verify} (Verified)
    (Verified) edge[bend left] node {moreInfo} (Profile)
    (Profile)  edge[bend left] node {activate} (Active);

\end{tikzpicture}
\end{center}

# Transition Table: Onboarding FSM

| State | Event | Next State |
|-------|-------|------------|
| Created  | verify   | Verified |
| Verified | moreInfo | Profile  |
| Profile  | activate | Active   |

---

# Order FSM Diagram

\begin{center}
\begin{tikzpicture}[->,>=Stealth,auto,node distance=3cm,thick,scale=0.85, every node/.style={scale=0.85}]
  \tikzstyle{state}=[circle,draw,minimum size=1.2cm]
  \tikzstyle{accepting}=[double distance=1.5pt]

  \node[state] (New) {New};
  \node[state] (Paid) [right of=New] {Paid};
  \node[state] (Shipped) [right of=Paid] {Shipped};
  \node[state,accepting] (Completed) [right of=Shipped,right=1mm] {Completed};
  \node[state] (Cancelled) [below of=Paid] {Cancelled};

  \path
    (New) edge node {pay} (Paid)
    (Paid) edge node {ship} (Shipped)
    (Shipped) edge[bend left] node {send} (Completed)
    (New) edge node {cancel} (Cancelled)
    (Paid) edge node {cancel} (Cancelled);

\end{tikzpicture}
\end{center}

---

# Walking the Machine

::: columns

:::: {.column width=35%}
We now **execute** the FSM.

Start state:

- `New`

::::

:::: column
\begin{center}
\begin{tikzpicture}[->,>=Stealth,auto,node distance=3cm,thick,scale=0.5, every node/.style={scale=0.5}]
  \tikzstyle{state}=[circle,draw,minimum size=1.2cm]
  \tikzstyle{accepting}=[double distance=1.5pt]

  \node[state] (New)[color=cyan] {New};
  \node[state] (Paid) [right of=New] {Paid};
  \node[state] (Shipped) [right of=Paid] {Shipped};
  \node[state,accepting] (Completed) [right of=Shipped,right=1mm] {Completed};
  \node[state] (Cancelled) [below of=Paid] {Cancelled};

  \path
    (New) edge node {pay} (Paid)
    (Paid) edge node {ship} (Shipped)
    (Shipped) edge[bend left] node {send} (Completed)
    (New) edge node {cancel} (Cancelled)
    (Paid) edge node {cancel} (Cancelled);
\end{tikzpicture}
\end{center}
::::

:::

---

# Order Trace: Step 1

::: columns

:::: {.column width=35%}

Event:

- `pay`

Transition:

- `New → Paid`

::::

:::: column
\begin{center}
\begin{tikzpicture}[->,>=Stealth,auto,node distance=3cm,thick,scale=0.5, every node/.style={scale=0.5}]
  \tikzstyle{state}=[circle,draw,minimum size=1.2cm]
  \tikzstyle{accepting}=[double distance=1.5pt]

  \node[state] (New) {New};
  \node[state] (Paid) [right of=New,color=cyan] {Paid};
  \node[state] (Shipped) [right of=Paid] {Shipped};
  \node[state,accepting] (Completed) [right of=Shipped,right=1mm] {Completed};
  \node[state] (Cancelled) [below of=Paid] {Cancelled};

  \path
    (New) edge[color=cyan] node {pay} (Paid)
    (Paid) edge node {ship} (Shipped)
    (Shipped) edge[bend left] node {send} (Completed)
    (New) edge node {cancel} (Cancelled)
    (Paid) edge node {cancel} (Cancelled);
\end{tikzpicture}
\end{center}
::::

:::

---

# Order Trace: Step 2

::: columns

:::: {.column width=35%}

Event:

- `ship`

Transition:

- `Paid → Shipped`

::::

:::: column
\begin{center}
\begin{tikzpicture}[->,>=Stealth,auto,node distance=3cm,thick,scale=0.5, every node/.style={scale=0.5}]
  \tikzstyle{state}=[circle,draw,minimum size=1.2cm]
  \tikzstyle{accepting}=[double distance=1.5pt]

  \node[state] (New) {New};
  \node[state] (Paid) [right of=New] {Paid};
  \node[state] (Shipped) [right of=Paid, color=cyan] {Shipped};
  \node[state,accepting] (Completed) [right of=Shipped,right=1mm] {Completed};
  \node[state] (Cancelled) [below of=Paid] {Cancelled};

  \path
    (New) edge node {pay} (Paid)
    (Paid) edge[color=cyan] node {ship} (Shipped)
    (Shipped) edge[bend left] node {send} (Completed)
    (New) edge node {cancel} (Cancelled)
    (Paid) edge node {cancel} (Cancelled);
\end{tikzpicture}
\end{center}
::::

:::

---

# Order Trace: Step 3

::: columns

:::: {.column width=35%}

Event:

- `send`

Transition:

- `Shipped → Completed`

::::

:::: column
\begin{center}
\begin{tikzpicture}[->,>=Stealth,auto,node distance=3cm,thick,scale=0.5, every node/.style={scale=0.5}]
  \tikzstyle{state}=[circle,draw,minimum size=1.2cm]
  \tikzstyle{accepting}=[double distance=1.5pt]

  \node[state] (New) {New};
  \node[state] (Paid) [right of=New] {Paid};
  \node[state] (Shipped) [right of=Paid] {Shipped};
  \node[state,accepting] (Completed) [right of=Shipped,right=1mm,color=cyan] {Completed};
  \node[state] (Cancelled) [below of=Paid] {Cancelled};

  \path
    (New) edge node {pay} (Paid)
    (Paid) edge node {ship} (Shipped)
    (Shipped) edge[bend left, color=cyan] node {send} (Completed)
    (New) edge node {cancel} (Cancelled)
    (Paid) edge node {cancel} (Cancelled);
\end{tikzpicture}
\end{center}
::::

:::

---

# Final State

::: columns

:::: {.column width=35%}

Current state:

- `Completed`

- $\checkmark$ Accepting state

::::

:::: column
\begin{center}
\begin{tikzpicture}[->,>=Stealth,auto,node distance=3cm,thick,scale=0.5, every node/.style={scale=0.5}]
  \tikzstyle{state}=[circle,draw,minimum size=1.2cm]
  \tikzstyle{accepting}=[double distance=1.5pt]

  \node[state] (New) {New};
  \node[state] (Paid) [right of=New] {Paid};
  \node[state] (Shipped) [right of=Paid] {Shipped};
  \node[state,accepting] (Completed) [right of=Shipped,right=1mm,color=cyan] {Completed};
  \node[state] (Cancelled) [below of=Paid] {Cancelled};

  \path
    (New) edge node {pay} (Paid)
    (Paid) edge node {ship} (Shipped)
    (Shipped) edge[bend left] node {send} (Completed)
    (New) edge node {cancel} (Cancelled)
    (Paid) edge node {cancel} (Cancelled);
\end{tikzpicture}
\end{center}
::::

:::

---

# Invalid Trace

::: columns

:::: {.column width=35%}

Start state:

- `New`

Event:

- `ship`

::::

:::: column
\begin{center}
\begin{tikzpicture}[->,>=Stealth,auto,node distance=3cm,thick,scale=0.5, every node/.style={scale=0.5}]
  \tikzstyle{state}=[circle,draw,minimum size=1.2cm]
  \tikzstyle{accepting}=[double distance=1.5pt]

  \node[state] (New)[color=cyan] {New};
  \node[state] (Paid) [right of=New] {Paid};
  \node[state] (Shipped) [right of=Paid] {Shipped};
  \node[state,accepting] (Completed) [right of=Shipped,right=1mm] {Completed};
  \node[state] (Cancelled) [below of=Paid] {Cancelled};

  \path
    (New) edge node {pay} (Paid)
    (Paid) edge[color=cyan] node {ship} (Shipped)
    (Shipped) edge[bend left] node {send} (Completed)
    (New) edge node {cancel} (Cancelled)
    (Paid) edge node {cancel} (Cancelled)

    (New) edge[dashed,red,bend left] (Shipped);
\end{tikzpicture}
\end{center}
::::

:::

---

# Invalid Transition

::: columns

:::: {.column width=35%}

$$\delta\Parens{\mathtt{New},\, \mathtt{ship}} = \bot$$

→ Event *rejected*

::::

:::: column
\begin{center}
\begin{tikzpicture}[->,>=Stealth,auto,node distance=3cm,thick,scale=0.5, every node/.style={scale=0.5}]
  \tikzstyle{state}=[circle,draw,minimum size=1.2cm]
  \tikzstyle{accepting}=[double distance=1.5pt]

  \node[state] (New)[color=cyan] {New};
  \node[state] (Paid) [right of=New] {Paid};
  \node[state] (Shipped) [right of=Paid] {Shipped};
  \node[state,accepting] (Completed) [right of=Shipped,right=1mm] {Completed};
  \node[state] (Cancelled) [below of=Paid] {Cancelled};

  \path
    (New) edge node {pay} (Paid)
    (Paid) edge[color=cyan] node {ship} (Shipped)
    (Shipped) edge[bend left] node {send} (Completed)
    (New) edge node {cancel} (Cancelled)
    (Paid) edge node {cancel} (Cancelled)

    (New) edge[dashed,red,bend left] (Shipped);
\end{tikzpicture}
\end{center}
::::

:::

---

# Transition Table: Order FSM

| State   | Event    | Next State |
|--------|----------|------------|
| New    | pay      | Paid       |
| New    | cancel   | Cancelled  |
| Paid   | ship     | Shipped    |
| Paid   | cancel   | Cancelled  |
| Shipped| send     | Completed  |

---

# Why learn about FSMs?

- You can mathamtically describe your automation

- You can reverse-engineer someone else's process

- Well-studied $\implies$ lots of academic papers

- Well-developed $\implies$ lots of libraries

---

# FSMs are Semirings!

## Semiring
```
class Monoid α => Semiring α where
    ⊕   : α -> α -> α
    zed : α
    ⊗   : α -> α -> α
    one : α
```

- $\oplus = \text{Either of the FSMs (run in parallel)}$
- $\mathtt{zed} = \text{FSM accepts nothing}$
- $\otimes = \text{Concatenation}$
  (first FSM's accepting states transition to starting states of second FSM$
- $\mathtt{one} = \text{No-op transition}$

---

FSM extensions:

- Acceptors (what we covered)
- Classifiers (non-binary output)
- Sequencers (counting)
- Transducers (transitions produce an output string)
  - Moore machines
  - Mealy machines

---

# Summary

- FSMs model business processes
- Diagrams + tables = same machine
- Illegal actions are impossible
- Structure replaces fragile logic
- **Good** FSMs are self documenting!

*FSMs make automation reliable*
