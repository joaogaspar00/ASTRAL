# How to write the documentation

## Equations

Add equation with the following structure:

```markdown
$$
E_k = \frac{1}{2} m v^2 \label{eq:equation_ref}
$$
```

which outpus

$$
E_k = \frac{1}{2} m v^2 \label{eq:equation_ref}
$$

and  to make a reference in text to the equation use ```$\left(\ref{eq:equation_ref}\right)$``` to output $\left(\ref{eq:equation_ref}\right)$. 

!!! warning

    For text rendering optimizations it is important to keep the refrence to the equation ```\ref{eq:equation_ref}``` inside ```$\left(...\right)$,```, otherwise the reference may be splitten when a new line is done.

## Use of nomenclature

This guide explains how to create, manage, and reference variables in the ASTRAL software documentation.

### Purpose

The nomenclature table is a central reference for all variables used in ASTRAL. Each variable should have:

- A **unique symbol** (LaTeX-friendly)
- A **unit**
- A **designation / description**
- A **unique ID** for linking

This ensures consistency and easy cross-referencing throughout the documentation.

### How to add a new variable

All variables are stored in `docs/theory/nomenclature.md`.  

```markdown
| Symbol | Unit | Designation |
|--------|------|------------|
| <span id="var" class="highlight-line">$var$</span> | $unit$ | variable number 1 |
```

Explanation:

- <span id=var" class="highlight-line">...</span>: The id is used for internal linking.
- highlight-line class allows CSS highlighting when the variable is referenced.
- ```$var$``` → LaTeX symbol for the variable.
- ```$unit$``` → SI or relevant unit.
- Designation → Full name / description.

To add a new variable:

1. Open `docs/theory/nomenclature.md`.

2. Add a new row following the template:

```markdown
| <span id="var_xN" class="highlight-line">$x_{N}$</span> | unitN | Description of variable N |
```

3. Replace N with a unique number.

4. Replace unitN with the variable’s unit (kg, m/s², N, etc.).

5. Replace Description of variable N with a meaningful designation.

!!! warning
    
    Important: The id must be unique across the table.


### Referencing Variables in Other Pages

You can reference variables from any other Markdown page using a relative link:

!!! example
    ```markdown
    [$U_{inf}$](theory/nomenclature.md#var_Uinf)
    ```

    which ouptuts [$U_{inf}$](theory/nomenclature.md#var_Uinf).

Explanation:

- theory/nomenclature.md → relative path to the table page.
- \#var_210 → id of the variable in the table.

Clicking this link scrolls to the variable in the table and the row is highlighted for visual emphasize.

## Adding a New Glossary Entry

Abbreviations are widely used in technical documentation to simplify complex terms and improve readability. In the ASTRAL project, each abbreviation represents a key conceptused throughout its documentation. By standardizing abbreviations in a dedicated glossary, readers can quickly understand the meaning of terms without interrupting the flow of the text. Each abbreviation in the glossary is linked to its full designation, allowing for easy reference and consistent usage across all pages.

To create a new glossary entry:

1. Open the file `docs/includes/abbreviation_list.md`.
2. Add your entry using the following format:
``` markdown
*[ABBR]: abbreviation designation
```
1. Open the file `docs/abbreviation.md`.
2. Add a new line with the same abbreviation and designation

Whenever an abbreviation is used in the documentation, it is automatically linked to its entry in the glossary. This ensures that readers can always access the full meaning of the term with a single click, enhancing clarity and maintaining consistency throughout the documentation.

For example:

!!! example
    The BET is widely used for preliminary rotor designs

Consult for abbreviation table [here](theory/abbreviations.md).

## Define units

It is possible to define units in your text using a **custom JavaScript macro**. This macro should be configured inside the file `docs/js/mathjax-config.js`, which is loaded by Material for MkDocs to customize MathJax settings.

The goal of this macro is to create a `\unit` command that formats units consistently in **roman (upright) font**, as is standard in scientific notation. This helps maintain clarity and consistency when writing physical quantities, such as Newtons (N), meters per second (m/s), or kilograms per cubic meter (kg/m³).

!!! example "Using the `\unit` macro"
    ```
    $\unit{m/s}$
    ```
    
    **Explanation:**
    
    - `\unit{m/s}`: This is a macro (if defined in MathJax) that outputs the unit **meters per second** in upright font.
    - `$...$`: Dollar signs indicate an **inline math expression**, telling MathJax to render it correctly.
    - The macro separates the **unit** from numbers or variables, maintaining clarity.
    
    **How to use with numbers:**
    
    ```
    $10\ \unit{m/s}$
    ```
    
    Renders as: \(10\ \mathrm{m/s}\)
    
    Here:
    - `10` is the numerical value.
    - `\ ` adds a small space between the number and the unit.
    - `\unit{m/s}` displays the unit in upright font.
    
    **Example in a formula:**
    
    ```
    $v = 20\ \unit{m/s}$
    ```
    
    Renders as: \(v = 20\ \mathrm{m/s}\)
    
    This keeps the formatting consistent for all units in your documentation.