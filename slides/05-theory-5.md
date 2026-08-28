---
title: Lecture 5
subtitle: Streams, Pipes, Backpressure, and Theory
date: 2026-02-11
theme: "Frankfurt"
colortheme: "beaver"
fonttheme: "professionalfonts"
mainfont: Font-Regular.otf
mainfont: DejaVuSerif.ttf
sansfont: DejaVuSans.ttf
monofont: DejaVuSansMono.ttf
mathfont: texgyredejavu-math.otf
header-includes:
  - \usepackage{tikz}
  - \usetikzlibrary{positioning,arrows.meta}
---

# Streams as Data Over Time

A stream is:

> A sequence revealed incrementally.

Instead of:

$$[\,a_0, a_1, a_2, a_3\,]$$

We process:

$$a_0 \to a_1 \to a_2 \to a_3 \to \ldots$$

Key idea:
We never require the entire structure in memory.

---

# Pipes as Structured Transformations

A pipe:

- Consumes values
- Produces values
- Operates incrementally

\begin{center}
\begin{tikzpicture}[>=Stealth, node distance=3cm]
  \node (in) [draw, rectangle] {Input};
  \node (pipe) [draw, rectangle, right=of in] {Pipe};
  \node (out) [draw, rectangle, right=of pipe] {Output};

  \draw[->] (in) -- (pipe);
  \draw[->] (pipe) -- (out);
\end{tikzpicture}
\end{center}

Composition chains these stages.

---

# What Is Backpressure?

Backpressure means:

> A downstream consumer controls the rate of production upstream.

Without backpressure:

- Producers overwhelm consumers
- Memory grows unbounded
- Buffers explode

With backpressure:

- Data flows only when demanded
- Memory remains bounded

---

# Backpressure Diagram

\begin{center}
\begin{tikzpicture}[>=Stealth, node distance=2.5cm]

  \node (source) [draw, rectangle] {Source};
  \node (pipe) [draw, rectangle, right=of source] {Pipe};
  \node (sink) [draw, rectangle, right=of pipe] {Sink};

  \draw[->] (source) -- node[above]{data} (pipe);
  \draw[->] (pipe) -- node[above]{data} (sink);

  \draw[<-] (source) -- node[below]{demand} (pipe);
  \draw[<-] (pipe) -- node[below]{demand} (sink);

\end{tikzpicture}
\end{center}

Data flows right.
Demand flows left.

---

# Why Backpressure Matters

Consider:

- Reading a 10GB file
- Writing to a slow network
- Consuming from a rate-limited API

Backpressure ensures:

- No runaway buffering
- No uncontrolled memory growth
- Predictable performance

---

# Operational View

In `conduit` or `pipes`:

- A downstream stage requests input
- Upstream produces exactly one element
- Control returns downstream

Execution is demand-driven.

---

# Category-Theoretic View

A pipe is morally:

A morphism from stream A to stream B.

But streaming is effectful, so more precisely:

Pipe a b ~ a morphism in a category enriched over effects.

Composition:

Pipe a b $\circ$ Pipe b c = Pipe a c

Associativity holds.

Identity pipe exists.

---

# Pipes Form a Category

Objects: Types of streamed values
Morphisms: Pipes transforming them

Properties:

- Identity: yield
- Composition: (>->) or (.|)
- Associativity: guaranteed by library laws

Thus, streaming stages compose categorically.

---

# Duality: Producers and Consumers

We can think of:

Producer a  ~  free monad generating a stream
Consumer a  ~  fold over a stream

There is a duality:

Producing is unfolding
Consuming is folding

---

# Streams and Folds

A fold has type:

~~~haskell
fold :: (b -> a -> b) -> b -> [a] -> b
~~~

A streaming consumer is essentially:

- An incremental fold
- That processes one element at a time

In conduit:

~~~haskell
sinkList :: ConduitT a o m [a]
~~~

is a fold into a list.

---

# Folds as Algebras

A fold corresponds to:

An algebra for the list functor.

List functor:

F X = 1 + A × X

An algebra:

F B -> B

Streaming evaluates this algebra incrementally.

---

# Streams as Coalgebras

Dually:

A stream producer corresponds to:

A coalgebra:

X -> F X

It unfolds values over time.

Thus:

Producer = Coalgebra
Consumer = Algebra

Streaming connects them.

---

# Composition as Algebraic Structure

Pipes support:

- Category structure
- Monoidal structure (parallel composition)
- Functorial lifting of effects

Conduit and Pipes both:

- Respect associativity
- Enforce structured composition

---

# Backpressure as Controlled Evaluation

Lazy lists rely on:

Implicit demand via evaluation.

Streaming libraries make demand:

- Explicit
- Structured
- Effect-aware
- Resource-safe

Backpressure is controlled evaluation order.

---

# Resource Safety

Conduit guarantees:

- Deterministic finalization
- Proper bracketed resource use
- No leaked file handles

This can be viewed categorically as:

Morphisms preserving resource invariants.

---

# Big Picture

Streams model time.

Pipes model morphisms over time.

Producers are coalgebras.
Consumers are algebras.

Backpressure enforces:

Demand-driven composition.

Streaming libraries unify:

- Category theory
- Algebra / coalgebra duality
- Effectful programming
- Resource safety
- Incremental computation

---

# Conceptual Diagram

\begin{center}
\begin{tikzpicture}[>=Stealth, node distance=2cm]

  \node (coalgebra) [draw, rectangle] {Producer (Coalgebra)};
  \node (pipe) [draw, rectangle, right=of coalgebra] {Pipe (Morphism)};
  \node (algebra) [draw, rectangle, right=of pipe] {Consumer (Algebra)};

  \draw[->] (coalgebra) -- (pipe);
  \draw[->] (pipe) -- (algebra);

\end{tikzpicture}
\end{center}

Unfold → Transform → Fold

---

# Final Summary

Streaming is not just IO optimization.

It is:

- Algebra (folds)
- Coalgebra (unfolds)
- Category theory (composition)
- Operational control (backpressure)
- Practical resource safety

Functional programming makes these structures explicit.
