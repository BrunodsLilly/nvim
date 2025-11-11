# LaTeX Equation Workflow in Neovim

Complete guide for writing and rendering mathematical equations and chemical formulas in your Zettelkasten.

---

## Quick Start

### 1. Write an Equation in Markdown

```markdown
# My Math Note

The famous equation is $E = mc^2$.

For display math:
$$
\int_{-\infty}^{\infty} e^{-x^2} dx = \sqrt{\pi}
$$
```

### 2. View the Equation

**Option A: Browser Preview** (Recommended - Works Now)
```vim
<leader>mp  " Toggle browser preview with beautiful KaTeX rendering
```

**Option B: In-Buffer Image Rendering** (Requires Setup)
Renders LaTeX equations as actual images directly in your buffer using Kitty terminal.

**Setup Required** (one-time):
```bash
cd ~/.config/nvim
./scripts/setup-latex-images.sh
```

Then restart Neovim and run `:Lazy sync`. See `LATEX_IMAGE_SETUP.md` for details.

**Option C: In-Buffer Text Rendering** (Basic)
```vim
<leader>mr  " Toggle markdown rendering (basic Unicode approximation)
```

---

## Equation Syntax

### Inline Math
```markdown
This is inline: $a^2 + b^2 = c^2$
```

### Display Math
```markdown
$$
\frac{-b \pm \sqrt{b^2 - 4ac}}{2a}
$$
```

---

## LaTeX Snippets (Type and Press Tab)

### Basic Math

| Trigger | Result | Description |
|---------|--------|-------------|
| `$$` | Display math block | Block equation |
| `$` | Inline math | Inline equation |
| `frac` | `\frac{num}{den}` | Fraction |
| `int` | `\int_{a}^{b} f(x) dx` | Integral |
| `sum` | `\sum_{i=1}^{n} a_i` | Summation |
| `lim` | `\lim_{x \to \infty} f(x)` | Limit |

### Matrices

```markdown
# Type: matrix<Tab>
$$
\begin{pmatrix}
  a & b \\
  c & d
\end{pmatrix}
$$
```

### Aligned Equations

```markdown
# Type: align<Tab>
$$
\begin{aligned}
  x + y &= 5 \\
  2x - y &= 1
\end{aligned}
$$
```

### Piecewise Functions

```markdown
# Type: cases<Tab>
$$
f(x) = \begin{cases}
  x^2 & \text{if } x \geq 0 \\
  -x^2 & \text{if } x < 0
\end{cases}
$$
```

---

## Chemistry Formulas

### Chemical Formulas

```markdown
Water molecule: $\ce{H2O}$

Sulfuric acid: $\ce{H2SO4}$

Complex: $\ce{[Cu(NH3)4]^2+}$
```

### Chemical Reactions

```markdown
# Type: rxn<Tab>
$$
\ce{2H2 + O2 -> 2H2O}
$$

# More complex:
$$
\ce{CH4 + 2O2 -> CO2 + 2H2O}
$$

# With states:
$$
\ce{AgNO3(aq) + NaCl(aq) -> AgCl(s) + NaNO3(aq)}
$$
```

### Equilibrium

```markdown
$$
\ce{N2 + 3H2 <=> 2NH3}
$$
```

---

## Common LaTeX Patterns

### Greek Letters
```latex
$\alpha, \beta, \gamma, \delta, \epsilon, \theta, \lambda, \mu, \pi, \sigma, \omega$
$\Gamma, \Delta, \Theta, \Lambda, \Sigma, \Omega$
```

### Operators
```latex
$\sum, \prod, \int, \oint, \partial, \nabla, \infty$
```

### Relations
```latex
$\leq, \geq, \neq, \approx, \equiv, \propto$
```

### Arrows
```latex
$\rightarrow, \leftarrow, \Rightarrow, \Leftarrow, \leftrightarrow$
```

### Sets
```latex
$\in, \notin, \subset, \subseteq, \cup, \cap, \emptyset$
```

### Blackboard Bold (Number Sets)
```latex
$\mathbb{R}, \mathbb{N}, \mathbb{Z}, \mathbb{Q}, \mathbb{C}$

# Or use shortcuts (already configured):
$\RR, \NN, \ZZ, \QQ, \CC$
```

---

## Advanced Examples

### Calculus

```markdown
## Fundamental Theorem of Calculus

$$
\int_a^b f'(x) \, dx = f(b) - f(a)
$$

## Taylor Series

$$
f(x) = \sum_{n=0}^{\infty} \frac{f^{(n)}(a)}{n!}(x-a)^n
$$

## Multivariable

$$
\frac{\partial^2 u}{\partial x^2} + \frac{\partial^2 u}{\partial y^2} = 0
$$
```

### Linear Algebra

```markdown
## Eigenvalue Equation

$$
A\mathbf{v} = \lambda\mathbf{v}
$$

## Matrix Multiplication

$$
\begin{pmatrix}
  a & b \\
  c & d
\end{pmatrix}
\begin{pmatrix}
  x \\
  y
\end{pmatrix}
=
\begin{pmatrix}
  ax + by \\
  cx + dy
\end{pmatrix}
$$
```

### Statistics

```markdown
## Normal Distribution

$$
f(x) = \frac{1}{\sigma\sqrt{2\pi}} e^{-\frac{1}{2}\left(\frac{x-\mu}{\sigma}\right)^2}
$$

## Bayes' Theorem

$$
P(A|B) = \frac{P(B|A)P(A)}{P(B)}
$$
```

### Thermodynamics

```markdown
## First Law

$$
\Delta U = Q - W
$$

## Ideal Gas Law

$$
PV = nRT
$$
```

---

## Zettelkasten Integration

### Creating an Equation Note

```vim
<leader>zn  " New note
```

Choose template: `equation-note.md`

### Equation Note Structure

```markdown
# Title: Schrodinger Equation

Date: 2024-01-15
Type: Math/Science Note
Tags: #equation #quantum #physics

## Equation

$$
i\hbar\frac{\partial}{\partial t}\Psi = \hat{H}\Psi
$$

## Variables

| Symbol | Meaning | Units |
|--------|---------|-------|
| $\Psi$ | Wave function | - |
| $\hbar$ | Reduced Planck constant | J·s |
| $\hat{H}$ | Hamiltonian operator | J |

## Intuition

The Schrodinger equation describes how quantum states evolve over time...

## Related Concepts

- [[permanent/wave-particle-duality]]
- [[permanent/quantum-operators]]

---

Created: 2024-01-15
Tags: #equation #quantum
Links: [[index|Home]]
```

---

## Keybindings Reference

| Key | Action | Description |
|-----|--------|-------------|
| `<leader>mp` | Browser preview | Full KaTeX rendering with chemistry |
| `<leader>mP` | Start preview | Force start browser preview |
| `<leader>ms` | Stop preview | Close browser preview |
| `<leader>mr` | Toggle render | In-buffer markdown rendering |
| `<Tab>` | Expand snippet | In insert mode, expand LaTeX snippet |
| `<S-Tab>` | Previous field | Jump to previous snippet field |

---

## Workflow Examples

### Workflow 1: Quick Note with Simple Equation

1. Create daily note: `<leader>zd`
2. Write quick equation: `$F = ma$`
3. Toggle rendering: `<leader>mr` (see Unicode approximation)
4. Continue taking notes

### Workflow 2: Complex Derivation

1. Create equation note: `<leader>zn` → `equation-note.md`
2. Write complex equations with display math blocks
3. Preview in browser: `<leader>mp`
4. Refine equations while seeing rendered output
5. Extract principle to permanent note

### Workflow 3: Chemistry Lab Notes

1. Create daily note: `<leader>zd`
2. Document reaction: `$\ce{A + B -> C}$`
3. Add stoichiometry calculations
4. Preview with `<leader>mp` to verify formulas
5. Link to related experiments

---

## Troubleshooting

### Browser Preview Not Working

1. **Install npm dependencies:**
   ```bash
   ~/.config/nvim/scripts/fix-markdown-preview.sh
   ```

2. **Or manually:**
   ```bash
   cd ~/.local/share/nvim/lazy/markdown-preview.nvim/app
   npm install
   ```

3. **Restart Neovim**

### Equations Not Rendering

1. **Check file type:**
   ```vim
   :set filetype?
   ```
   Should be `markdown` or `vimwiki`

2. **Force preview:**
   ```vim
   :MarkdownPreview
   ```

3. **Check for errors:**
   ```vim
   :messages
   ```

### LaTeX Syntax Errors

Common mistakes:

- Missing `$` or `$$` delimiters
- Unescaped special characters: `\{`, `\}`, `\_`
- Mismatched braces: `{` must have `}`
- Wrong command names (case sensitive)

---

## Tips & Best Practices

### 1. Use Macros for Common Symbols

Already configured:
- `\RR` → ℝ (real numbers)
- `\NN` → ℕ (natural numbers)
- `\ZZ` → ℤ (integers)
- `\QQ` → ℚ (rationals)
- `\CC` → ℂ (complex numbers)

### 2. Preview While Writing

Keep browser preview open (`<leader>mp`) while writing complex equations - it auto-updates on save.

### 3. Build a Formula Library

Create permanent notes for commonly used formulas:
- `permanent/taylor-series.md`
- `permanent/integration-by-parts.md`
- `permanent/quadratic-formula.md`

### 4. Link Equations to Concepts

Always connect equations to understanding:
```markdown
## Equation
$$E = mc^2$$

## Intuition
Mass and energy are equivalent - matter is compressed energy.

## Connects To
- [[permanent/special-relativity]]
- [[permanent/conservation-laws]]
```

### 5. Document Derivations

Show your work:
```markdown
## Starting from Newton's Second Law
$$F = ma$$

## Substitute $a = \frac{dv}{dt}$
$$F = m\frac{dv}{dt}$$

## Integrate both sides
$$\int F \, dt = \int m \, dv$$
```

---

## Resources

### LaTeX Reference
- [KaTeX Supported Functions](https://katex.org/docs/supported.html)
- [Detexify](http://detexify.kirelabs.org/classify.html) - Draw symbol to find LaTeX command

### Chemistry (mhchem)
- [mhchem Documentation](https://mhchem.github.io/MathJax-mhchem/)

### Practice
- Create test file: `nvim ~/test-equations.md`
- Try all the examples above
- Build your personal formula library

---

## Your Equation Setup Status

✅ **LaTeX**: Installed (`/Library/TeX/texbin/pdflatex`)
✅ **dvisvgm**: Installed (for SVG rendering)
✅ **render-markdown.nvim**: Configured (in-buffer rendering)
✅ **markdown-preview.nvim**: Configured (browser + KaTeX + mhchem)
✅ **LuaSnip**: Configured (equation snippets)
✅ **Templates**: Created (`equation-note.md`)

### To Activate

1. **Restart Neovim** or run `:Lazy sync`
2. **Test with a markdown file:**
   ```bash
   nvim ~/test-equations.md
   ```
3. **Add an equation:**
   ```markdown
   $$E = mc^2$$
   ```
4. **Preview:** `<leader>mp`

---

*Your complete equation rendering system is ready! Write beautiful math and chemistry in your Zettelkasten.*

**Next:** Start documenting equations and building your formula knowledge base!