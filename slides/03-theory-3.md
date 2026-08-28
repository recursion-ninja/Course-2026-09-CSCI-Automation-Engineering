---
title: Lecture 3
subtitle: Data Transformations
date: 2026-02-04
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

# What is Data Transformation?

$$\mathtt{transform} \colon \mathtt{input} \rightarrow \mathtt{output}$$

---

# Data Transformation Goal

$$\mathtt{perfection} \colon \mathtt{messy\_garbage} \rightarrow \mathtt{perfectly\_formatted}$$


---

# Breaking down data transformations

- Do many small easy transforms

- Combine into complicated transform

- Nest transforms as needed

---

# Fold over data

A **Fold** takes:

- a collection of values

- a rule for combining one value with an accumulated result

- turns the whole collection into one final value

---


$$\mathtt{fold} \colon \Parens{\alpha \rightarrow \mathtt{acc} \rightarrow \mathtt{acc}} \rightarrow \mathtt{acc} \rightarrow \mathtt{List}\;\alpha \rightarrow \mathtt{acc}$$


- `acc`: the accumulator (what we’re building)

- $\alpha$: one element from the list

- $\mathtt{List}\;\alpha$: the input data

- `acc`: the result


---

# Example of Fold


```
step : ℕ → ℕ
step x acc = x + acc

= fold step 0 [1,2,3,4]
= fold step (step 1 0) [2,3,4]
= fold step (step 2 (step 1 0)) [3,4]
= fold step (step 3 (step 2 (step 1 0))) [4]
= fold step (step 4 (step 3 (step 2 (step 1 0)))) []
= step 4 (step 3 (step 2 (step 1 0)))
= 10
```

---

# Abstracting Folds

# Constraint classes: `Foldable`

## Foldable
```
class Foldable t where
    fold : (α → β → β) → β → t α → β
    foldMap : Monoid m => (α → m) → t α → m
```

---

# Constraint classes: `Foldable`

## Foldable
```
class Foldable t where
    fold : (α → β → β) → β → t α → β
    foldMap : Monoid m => (α → m) → t α → m
```

- Mapping Correspondence
  $$\mathtt{foldMap}\;f \equiv \mathtt{fold} \Parens{\lambda x\;\;\mathtt{acc} \rightarrow x \oplus \mathtt{acc}} \mathtt{zed} \circ \mathtt{fmap}\;f$$


---

"Real world" Example #1

$$\mathtt{updates} \colon \mathtt{Foldable}\; t \Rightarrow t\; \mathtt{Transaction} \rightarrow \mathtt{BalanceChanges}$$

```
type User = String
type Amount = Int

data Transaction = Transaction
  { user   :: User
  , amount :: Amount
  }

type BalanceChanges = Map User Amount
```

---


"Real world" Example #1

$$\mathtt{updates} \colon \mathtt{Foldable}\; t \Rightarrow t\; \mathtt{Transaction} \rightarrow \mathtt{BalanceChanges}$$

```
step : Transaction → BalanceChanges → BalanceChanges
step(x, balances) =
  Map.insertWith (+) (user x) (amount x) balances

updates : List Transaction → BalanceChanges → BalanceChanges
updates = fold step Map.empty
```

---

"Real world" Example #2

$$\mathtt{String} \rightarrow \mathtt{WordFrequencies}$$

```
type WordFrequencies = Map String ℕ
```

1. Normalize text (lowercase)

2. Split into words

3. Update frequency map per word


---


"Real world" Example #2

$$\mathtt{wordFrequencies} \colon \mathtt{String} \rightarrow \mathtt{WordFrequencies}$$

```
normalize : String → String
normalize(str) =
  fmap toLower ○ fmap (\c → if isAlpha c then c else ' ') str
```

---

"Real world" Example #2

$$\mathtt{wordFrequencies} \colon \mathtt{String} \rightarrow \mathtt{WordFrequencies}$$

```
words : String → List String
words(str) =
  fold step Nil str
  where
    step : Char → List String → List String
    step(c, acc)
      | c == ' '  = acc
      | otherwise =
          case acc of
            Nil     → (c :: Nil) :: Nil
            w :: ws → (c ::   w) :: ws
```


---


"Real world" Example #2

$$\mathtt{String} \rightarrow \mathtt{WordFrequencies}$$

```
wordFrequencies :: String → WordFrequencies
wordFrequencies(str) =
    fold step Map.empty ○ words ○ normalize str
```

---

"Real world" Example #3

$$\mathtt{longest} \colon \mathtt{List}\Parens{\mathtt{List}\;\alpha} \rightarrow \mathbb{N}$$

How long is the longest list?

```
len : List a → ℕ
len(list) = fold (λx acc → 1 + acc) 0 list

longest List (List a) → ℕ
longest(list_list) =
  fold (λx acc → max (len x) acc) 0 list_list
```


---

# Foldable structures

| Type |
|:--|
| $\mathtt{List}\;\alpha$ |
| $\mathtt{Set}\;\alpha$  |
| $\mathtt{Map}\;k\;v$    |
| $\mathtt{Tree}\;\alpha$ |
| $\mathtt{Graph}\;e\;v$  |
| $\mathtt{Optional}\;\alpha$ |

---

# *What can we implement for *any* `Foldable`?

| Name |Type |
|:---|:----|
| `isEmpty`  | `t a → Bool` |
| `length`   | `t a → Nat` |
| `contains` | `t a → a → Bool` |
| `maximum`  | `t a → a` |
| `minimum`  | `t a → a` |
|


---

# `Foldable` summary

- Combine many data transformations together

- Break down how you think into small, simple steps

- Reuse code over multiple data-types

- Swap out your implementation data-types with equivalent classes
