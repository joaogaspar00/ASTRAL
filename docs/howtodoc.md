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




## Adding a New Glossary Entry

To create a new glossary entry:

1. Open the file `docs/includes/abbreviation_list.md`.
2. Add your entry using the following format:
``` markdown
*[ABBR]: abbreviation designation
```
3. Open the file `docs/abbreviation.md`.
4. Add a new line with the same abbreviation and designation