---
title: Lecture 2
subtitle: Abstract Constraints
date: 2026-02-02
theme: "Frankfurt"
colortheme: "beaver"
fonttheme: "professionalfonts"
mainfont: Font-Regular.otf
mainfont: DejaVuSerif.ttf
sansfont: DejaVuSans.ttf
monofont: DejaVuSansMono.ttf
mathfont: texgyredejavu-math.otf
header-includes: |
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

# Anonymous functions

$$\mathtt{example}\Parens{x,\,y\;} = 2 * x + y$$
$$\phantom{000000}\;\lambda\lparen\;x,\,y\;\rparen = 2 * x + y$$
$$\phantom{0000000}\;\lambda\phantom{\lparen}\;x\phantom{,}\,y\;\phantom{\rparen} \rightarrow 2 * x + y$$

---

# Functions as arguments

$$\mathtt{map} \colon \lparen\;\alpha \rightarrow \beta\;\rparen \rightarrow \mathtt{List}\;\alpha \rightarrow \mathtt{List}\;\beta$$

$\mathtt{increment} \colon \mathbb{N} \rightarrow \mathbb{N}$

$\mathtt{increment}\lparen\;x\;\rparen = x + 1$

1. $\mathtt{map}\quad\mathtt{increment}\quad\quad\quad\!\lparen\;[\;1,\,1,\,2,\,3,\,5,\,8\;]\;\rparen$
2. $\mathtt{map}\quad\lparen\;\lambda x \rightarrow x + 1\;\rparen\quad\lparen\;[\;1,\,1,\,2,\,3,\,5,\,8\;]\;\rparen$


# Some common datatypes

$\mathtt{List}\;\alpha = \begin{cases}
  \mathtt{Nil}\\
  \alpha \Cons \mathtt{List}\;\alpha
  \end{cases}$

$\mathtt{BinTree}\;\alpha = \begin{cases}
  \mathtt{Leaf}\;\alpha\\
  \mathtt{Branch}\;\Parens{\mathtt{BinTree}\;\alpha}\;\alpha\;\Parens{\mathtt{BinTree}\;\alpha} \\
  \end{cases}$

$\mathtt{RoseTree}\;\alpha = \mathtt{Node}\; \alpha\; \Parens{\mathtt{List}\Parens{\mathtt{RoseTree}\;\alpha}}$

$\mathtt{Map}\;k\;v = \mathtt{BinTree}\;\Tuple{k,\,v}$

$\mathtt{Set}\;\alpha = \mathtt{BinTree}\;\alpha$

$\mathtt{Bag}\;\alpha = \mathtt{Map}\;\Tuple{\alpha, \mathbb{N}}$



---

# Mapping over data structures

$$\mathtt{List}\;\alpha = \begin{cases}
  \mathtt{Nil}\\
  \alpha \Cons \mathtt{List}\;\alpha
  \end{cases}$$

$\mathtt{List.map} \colon \Parens{\alpha \rightarrow \beta} \rightarrow \mathtt{List}\;\alpha \rightarrow \mathtt{List}\;\beta$
```
List.map( f, list ) = case list of
  Nil     -> Nil
  x :: xs -> f x :: List.map f xs
```

---

# Mapping over data structures

$$\mathtt{BinTree}\;\alpha = \begin{cases}
  \mathtt{Leaf}\;\alpha\\
  \mathtt{Branch}\;\Parens{\mathtt{BinTree}\;\alpha}\;\alpha\;\Parens{\mathtt{BinTree}\;\alpha} \\
  \end{cases}$$

$\mathtt{BinTree.map} \colon \Parens{\alpha \rightarrow \beta} \rightarrow \mathtt{BinTree}\;\alpha \rightarrow \mathtt{BinTree}\;\beta$
```
BinTree.map( f, btree ) = case btree of
  Leaf x           -> Leaf (f x)
  Branch lhs x rhs ->
      Branch (BinTree.map f lhs) (f x) (BinTree.map f rhs)
```

---

# Mapping over data structures

$$\mathtt{RoseTree}\;\alpha = \mathtt{Node}\; \alpha\; \Parens{\mathtt{List}\Parens{\mathtt{RoseTree}\;\alpha}}$$

$\mathtt{RoseTree.map} \colon \Parens{\alpha \rightarrow \beta} \rightarrow \mathtt{RoseTree}\;\alpha \rightarrow \mathtt{RoseTree}\;\beta$
```
RoseTree.map( f, (Node v list) ) = ...









```

---

# Mapping over data structures

$$\mathtt{RoseTree}\;\alpha = \mathtt{Node}\; \alpha\; \Parens{\mathtt{List}\Parens{\mathtt{RoseTree}\;\alpha}}$$

$\mathtt{RoseTree.map} \colon \Parens{\alpha \rightarrow \beta} \rightarrow \mathtt{RoseTree}\;\alpha \rightarrow \mathtt{RoseTree}\;\beta$
```
RoseTree.map( f, (Node v list) ) =
  Node (f v) ○ List.map (RoseTree.map f) list
```

---

# Constraint classes

The concept of "mapping" is common

Map without caring what specifically you are mapping

- type-classes
- interfaces
- mixins


---

# Constraint classes: Functor

## Functor
```
class Functor t where
    fmap : (α -> β) -> t α -> t β
```

## Instances
```
instance Functor List where
    fmap(f, list) = case list of
        Nil     -> Nil
        x :: xs -> f x :: fmap f xs

instance Functor BinTree where
    fmap(f, btree) = case btree of
        Leaf x           -> Leaf (f x)
        Branch lhs x rhs ->
            Branch (fmap f lhs) (f x) (fmap f rhs)
```

---

# Increment any Functor

$$\mathtt{oneMore} \colon \mathtt{Functor}\; t \Rightarrow t\;\mathbb{N} \rightarrow t\;\mathbb{N}$$
$$\mathtt{oneMore} = \mathtt{fmap}\quad\Parens{\lambda x \rightarrow x + 1}$$

## Constraint classes in type signatures

- Constraints on types go to the left of $\Rightarrow$
- Function parameters under constraint to the right of $\Rightarrow$
- In ASCII `=>` is equal to $\Rightarrow$

---

# Constraint laws

- Whenever a constraint class is introduced, algebraic laws are required

- Without laws, constraints have no meaning!

## Functor laws

- Identity:
  $$\mathtt{fmap}\;\mathtt{id} == \mathtt{id}$$
- Composition
  $$\mathtt{fmap}\;f \circ \mathtt{fmap}\;g \equiv \mathtt{fmap}\;\Parens{f \circ g}$$


# Abstract constraints make thinking easier

- Don't decide on what data structure to use

- Focus on *what* you transformation operations you need, not *how* to transform the data


# More abstractions

## Equatable
```
class Equatable α where
    (==) : α -> α -> Bool
```
- Reflexivity

  $x == x$

- Symmetry

  $x == y \equiv y == x$

- Transitivity

  $x == y \land y == z \implies x == z$

- Extensionality

  $\forall \mathtt{Eq}\;\beta \Rightarrow f \colon \alpha \rightarrow \beta\;; x == y \implies f x == f y$


---

# More abstractions

## Orderable
```
class Orderable α where
    compare : α -> α -> Ordering
    type: Ordering = Less | Same | More
```
- Comparability

  $\mathtt{compare}\Parens{x,\,y} \not = \mathtt{Less} \lor  \mathtt{compare}\Parens{y,\,x} \not = \mathtt{Less}$

- Transitivity

$\mathtt{compare}\Parens{x,\,y} \not = \mathtt{Less} \land \mathtt{compare}\Parens{y,\,z} \not = \mathtt{Less} \implies \mathtt{compare}\Parens{x,\,z} \not = \mathtt{Less}$

- Reflexivity

  $\mathtt{compare}\Parens{x,\,x} = \mathtt{Same}$

- Antisymmetry

  $\mathtt{compare}\Parens{x,\,y} \not = \mathtt{Less} \land \mathtt{compare}\Parens{x,\,y} \not = \mathtt{Less} \implies \mathtt{compare}\Parens{x,\,y} = \mathtt{Same}$

---

# More abstractions

## Semigroup
```
class Semigroup α where
    ⊕ : α -> α -> α
```
- Associativity $\oplus$:
  $$a \oplus \Parens{b \oplus c} \equiv \Parens{a \oplus b} \oplus c$$


*What are some examples of Semigroups?*

---

# Semigroups

| Type | $\oplus$ semantics |
|:--|:-----|
| $\mathbb{N}$            | addition |
| $\mathtt{List}\;\alpha$ | concatenation |
| $\mathtt{Set}\;\alpha$  | union |
| $\mathtt{Map}\;k\;v$    | merging (with bias) |

---

# More abstractions

## Monoid
```
class Semigroup α => Monoid α where
    zed : α
```
- Identity `zed`:
  $$a \oplus \mathtt{zed} \equiv \mathtt{zed} \oplus a \equiv a$$


*What are some examples of Monoids?*

---

# More abstractions

## Group
```
class Monoid α => Group α where
    inv : α -> α
```
- Inverse annihilation:
  $$a \oplus \mathtt{inv}\;a \equiv \mathtt{inv}\;a  \oplus a \equiv \mathtt{zed}$$


*What are some examples of Groups?*


---

## Semiring
```
class Monoid α => Semiring α where
    one : α
    ⊗  : α -> α -> α
```
- Associativity $\otimes$:
  $$a \otimes \Parens{b \otimes c} \equiv \Parens{a \otimes b} \otimes c$$
- Identity `one`:
  $$a \otimes \mathtt{one} \equiv \mathtt{one} \otimes a \equiv a$$
- Annihilation of `zed` :
  $$a \otimes \mathtt{zed} \equiv \mathtt{zed} \otimes a \equiv \mathtt{zed}$$
- Distributivity :
  $$a \otimes \Parens{b \oplus c} \equiv \Parens{a \otimes b} \oplus \Parens{a \otimes c}$$


---


# *What are some examples of Semirings?*

| Type | $\oplus$ | $\otimes$ | `zed` | `one` |
|:---|:----|:----|:--:|:---:|
| $\mathbb{N}$            | addition    | multiplication | $0$ | $1$ |
| $\mathtt{Set}\;\alpha$  | union       | intersection   | $\emptyset$ | $\mathcal{U}$ |
| $\mathtt{Bag}\;\alpha$  | merging     | convolution    | $\emptyset$ | $\SetNote{\mathtt{zed}}$ |
| $\mathtt{Graph}$        | union $E$   | transitive     | $E=\emptyset$ | self-loops |
| $P\!\Parens{X}$         | alternative | conditional    | $P\lparen x\rparen\!=\!0$ | $P\lparen x\rparen\!=\!1$ |



---


# Sometimes Semiring Surprise You

## Tropical Analysis

$\mathtt{Tropical} = \begin{cases}
  \mathtt{Infinity}\\
  \mathtt{Finite}\;\mathbb{Q}\\
  \end{cases}$

```
instance Semiring Tropical where
  zero = Infinity
  one  = Finite 0

  ⊕ (Infinity, x) = x
  ⊕ (x, Infinity) = x
  ⊕ (Finite x, Finite y) = Finite (min x y)

  ⊗ (Infinity, _) = Infinity
  ⊗ (_, Infinity) = Infinity
  ⊗ (Finite x, Finite y) = Finite (x + y)
```


---

# Constraint Classes Summary

- Abstractly define what you need for the function

- Skip the *how*, focus on *what* is changing

- Reuse code over multiple data-types

- Swap out your implementation data-types with equivalent classes
