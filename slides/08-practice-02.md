---
title: Lecture 08
subtitle: Data Transformations
date: 2026-03-04
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

# Lecture Goals

By the end of this lecture, you should be able to:

- Model domain data with **correct representations**
- Make **invalid states impossible**
- Explain and apply **“Parse, Don’t Validate”**
- Use **folds** to structure transformations
- Design **nested folds** for hierarchical automation

---

# Motivation

In computerized process automation, humans:

- Enter data
- Correct data
- Approve or reject data
- Aggregate and summarize data
- Trigger automated downstream actions

Automation fails when:

- Data is loosely represented
- Validation is ad hoc
- Invalid states leak into later phases
- Transformations are informal or imperative

---

# Running Example (Used Throughout)

## Multi-Department Expense Approval System

A company automates expense reporting.

Each input line (human-generated):

```
Department,EmployeeId,EmployeeName,ExpenseDate,Category,Amount,ApprovalStatus
```

Example:

```
Engineering,42,Alice,2026-02-01,Travel,350.00,Approved
Engineering,42,Alice,2026-02-03,Meals,40.50,Approved
HR,17,Bob,2026-02-02,Travel,200.00,Rejected
```

---

# Business Requirements

The system must:

1. Reject malformed rows
2. Reject invalid amounts
3. Prevent approval of non-positive expenses
4. Compute per-employee totals
5. Compute per-department totals
6. Compute company totals
7. Produce a structured report


---

Transformation pipeline:

```
Raw Text
  → Parsed Rows
    → Structured Expenses
      → Grouped by Employee
        → Grouped by Department
          → Company Summary
```

---

# Data Representation Correctness

Consider this weak model:

```haskell
data Expense = Expense
  { amount : Double
  , status : String
  }
```

Problems:

- `Double` allows negative amounts
- `String` allows `"APPROVEDDD"`
- Nothing prevents inconsistent states

The type system is not enforcing business rules.

---

# Make Invalid States Impossible

Instead:

```haskell
newtype PositiveCents = PositiveCents UInt64

data ApprovalStatus
  = Approved
  | Rejected
  | Pending
```

Now:

- Status is constrained
- Amount must be constructed safely
- Arbitrary strings are impossible

---

# Smart Constructors

```haskell
mkPositiveCents : Double -> Optional PositiveCents
mkPositiveCents x
  | x > 0     = Some (PositiveCents (floor (x * 100)))
  | otherwise = None
```

If construction fails, the value never exists.

Invalid data does not enter the system.

---

# Strong Domain Modeling

```haskell
newtype Department   = Department   Text
newtype EmployeeId   = EmployeeId   UInt
newtype EmployeeName = EmployeeName Text

data Category
  = Travel
  | Meals
  | Supplies

data Expense = Expense
  { expenseDate : Day
  , category    : Category
  , amount      : PositiveCents
  , status      : ApprovalStatus
  }
```

---

# Parse, Don’t Validate

Instead of:

```haskell
validate : RawExpense -> Either Error Expense
```

We do:

```haskell
parseRow
  : Text
  -> Either ParseError
       (Department, EmployeeId, EmployeeName, Expense)
```

If parsing succeeds:

- The result is correct by construction.
- No further validation is required.
- The rest of the pipeline assumes invariants.

---

# The Parse Boundary

All invalidity must stop here:

```haskell
parseInput
  : Text
  -> Either ParseError [ParsedRow]
```

After this:

- No loose strings
- No re-checking invariants
- No defensive programming

Automation operates on trusted structure.

---

# Diagram: Data Flow

\begin{tikzpicture}[node distance=2cm, outer sep=0.5cm, auto]
\node (raw) [draw] {Raw Text};
\node (parsed) [draw, below of=raw] {Parsed Domain Values};
\node (grouped) [draw, right=1.5cm of parsed] {Grouped Structure};
\node (report) [draw, below of=grouped] {Company Report};

\draw[->] (raw) -- (parsed);
\draw[->] (parsed) -- (grouped);
\draw[->] (grouped) -- (report);
\end{tikzpicture}


Each arrow is a **total transformation**.

---

# Transforming With Folds

We will use the following fold:

```haskell
fold : Foldable f
     => (a -> b -> b)
     -> b
     -> f a
     -> b
```

A fold:

- Processes a collection
- Accumulates structure
- Eliminates mutation
- Makes transformation explicit

---

# Step 1 — Fold Rows into Employee Structure

Parsed row type (Start):

```haskell
type ParsedRow = (Department, EmployeeId, EmployeeName, Expense)
```

Accumulator (End Goal):

```haskell
type EmployeeMap = Map Department (Map EmployeeId EmployeeReport)
```

Report data-type:

```haskell
data EmployeeReport =
  EmployeeReport
    { employeeName  : EmployeeName
    , approvedTotal : PositiveCents
    , rejectedTotal : PositiveCents
    }
```
---

# First Fold

```haskell
accumulateRow : ParsedRow -> EmployeeMap -> EmployeeMap
accumulateRow (dept, eid, name, expense) acc =
  case status expense of
    Approved -> insertApproved acc dept eid name expense
    Rejected -> insertRejected acc dept eid name expense
    Pending  -> acc
```

Using `fold`:

```haskell
employeeMap : [ParsedRow] -> EmployeeMap
employeeMap rows =
  fold accumulateRow Map.empty rows
```

This fold builds a nested map.

---

# Hierarchical Structure

After fold #1:

```
Map Department (Map EmployeeId EmployeeReport)
```

Now we must:

- Compute department totals
- Compute company totals

This requires nested folds.

---

# Step 2 — Fold Employees into Department Reports

Department report:

```haskell
data DepartmentReport =
  DepartmentReport
    { deptEmployees : Map EmployeeId EmployeeReport
    , deptApproved  : PositiveCents
    }
```

Compute department totals:

```haskell
computeDepartment : Map EmployeeId EmployeeReport -> DepartmentReport
computeDepartment emps =
 fold step (DepartmentReport emps 0) emps
 where
  step emp acc =
   acc { deptApproved = deptApproved acc + approvedTotal emp }
```

---

# Step 3 — Fold Departments into Company Report

```haskell
data CompanyReport =
  CompanyReport
    { departments   : Map Department DepartmentReport
    , totalApproved : PositiveCents
    }
```

Global fold:

```haskell
computeCompany : Map Department DepartmentReport -> CompanyReport
computeCompany depts =
 fold step (CompanyReport depts 0) depts
 where
  step deptRep acc =
   acc { totalApproved = totalApproved acc + deptApproved deptRep }
```

---

# Nested Fold Diagram

\begin{tikzpicture}[node distance=1.6cm, auto]
\node (rows) [draw] {[ParsedRow]};
\node (emp) [draw, below of=rows] {EmployeeMap};
\node (dept) [draw, below of=emp] {DepartmentReports};
\node (company) [draw, below of=dept] {CompanyReport};

\draw[->] (rows) -- node[right]{fold} (emp);
\draw[->] (emp) -- node[right]{nested fold} (dept);
\draw[->] (dept) -- node[right]{further nested fold} (company);
\end{tikzpicture}

The structure of folds mirrors business hierarchy.

---

# Strengthening Totals

We should avoid raw use well-named types.

```haskell
newtype ApprovedTotal = ApprovedTotal PositiveCents
```

Now:

- Negative totals impossible
- Accidental mixing prevented
- Business invariants encoded

---

# Deeper Invariants

Should a department be empty?

If not:

```haskell
Map Department (NonEmpty EmployeeReport)
```

Should an approved expense have zero amount?

Impossible — already prevented by `PositiveCents`.

The type system reflects business logic.

---

# Full Transformation Pipeline

```haskell
transform : Text  -> Either ParseError CompanyReport
transform input = do
  rows <- traverse parseRow (lines input)
  let empMap = fold accumulateRow Map.empty rows
      deptReports = fmap computeDepartment empMap
      companyReport = computeCompany deptReports
  return companyReport
```

Notice:

- Parsing eliminates invalidity.
- Folds encode structure.
- No validation phase exists.
- Every transformation is total.

---

# Why This Matters in Automation

Without these principles:

- Totals disagree
- Reports contradict
- Audits fail
- Manual overrides appear

With these principles:

- Invariants enforced once
- Transformations compositional
- Business logic visible in types
- Refactoring becomes safe

---

# Conceptual Comparison

Imperative approach:

- Mutable state
- Counters
- Conditionals scattered
- Validation separate from representation

Functional structured approach:

- Invariants in types
- Parse boundary clear
- Transformations explicit
- Nested folds mirror hierarchy

---

# Summary

1. **Correct data representation prevents classes of bugs.**
2. **Make invalid states impossible via types.**
3. **Parse, Don’t Validate — eliminate invalidity at the boundary.**
4. **Folds encode deterministic transformations.**

---

# Closing Questions

1. What would break if invalid states were allowed deeper in the pipeline?
2. What invariants in real automation systems are not encoded in types?
