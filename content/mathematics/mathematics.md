---
tags: [math]
related: [machine-learning, deep-neural-networks, mml-book]
last-updated: 2026-06-22
---

# Mathematics

## Overview
Unified page covering the mathematical foundations for ML: Linear Algebra, Multivariate Calculus, and Probability/Statistics. Tanish covered these in B.Tech — the goal is not to re-learn from scratch but to re-anchor familiar tools to their ML applications and catch gaps. The MML book is the primary source; this page synthesizes what's actually needed.

---

## Linear Algebra

### Core Objects

**Vectors** are ordered lists of numbers. In ML, a data point is a vector in ℝⁿ where n is the number of features. Operations:
- Addition: **a** + **b** (element-wise)
- Scalar multiplication: c**a**
- Dot product: **a**·**b** = Σ aᵢbᵢ = |**a**||**b**|cos(θ) — measures similarity/projection

**Matrices** are rectangular arrays of numbers. In ML:
- A dataset of m examples with n features → matrix **X** ∈ ℝᵐˣⁿ
- A linear transformation in ℝⁿ → ℝᵐ is a matrix multiplication
- A neural network layer is: **h** = activation(**W****x** + **b**)

### Key Operations
- **Matrix multiplication:** **(AB)**ᵢⱼ = Σₖ Aᵢₖ Bₖⱼ. Shape rule: (m×k)(k×n) → (m×n). Not commutative.
- **Transpose:** **(Aᵀ)**ᵢⱼ = Aⱼᵢ. Flip rows and columns. **(AB)ᵀ = BᵀAᵀ**.
- **Inverse:** **A**⁻¹**A** = **I**. Exists only for square, full-rank matrices.
- **Trace:** sum of diagonal elements. tr(**AB**) = tr(**BA**).
- **Determinant:** scalar measure of how a matrix scales volumes. det(**A**) = 0 → matrix is singular → no inverse.

### Eigenvalues and Eigenvectors
**A****v** = λ**v** — vector **v** is unchanged in direction by transformation **A**; it only scales by λ.

To find: solve det(**A** - λ**I**) = 0 (characteristic polynomial) → eigenvalues λ. Substitute each λ to get eigenvectors **v**.

**Why they matter in ML:**
- PCA: eigenvectors of the covariance matrix are the principal components
- Quadratic forms: understanding loss surface curvature
- Graph Laplacians: spectral clustering

### Matrix Decompositions

**Eigendecomposition:** **A** = **Q**Λ**Q**⁻¹ (symmetric **A**: **A** = **Q**Λ**Qᵀ**). Λ is diagonal with eigenvalues; **Q** columns are eigenvectors. Only works for square diagonalizable matrices.

**SVD (Singular Value Decomposition):** **A** = **U**Σ**Vᵀ** for any matrix **A** ∈ ℝᵐˣⁿ.
- **U** ∈ ℝᵐˣᵐ: left singular vectors (orthonormal)
- Σ ∈ ℝᵐˣⁿ: diagonal with singular values σ₁ ≥ σ₂ ≥ ... ≥ 0
- **V** ∈ ℝⁿˣⁿ: right singular vectors (orthonormal)

SVD generalizes eigendecomposition to any matrix. The dominant use in ML is **truncated SVD for dimensionality reduction**: keep only the top-k singular values and vectors.

**Cholesky: A** = **LLᵀ** for positive definite **A**. Used in sampling from Gaussians, covariance computations.

### Cross Product as a Dual Vector
The cross product `v × w` is the **dual vector** of the signed-volume function `f(x) = det([x v w])`: the unique `p` with `p·x = volume` for all `x`. Duality forces `p` to be ⟂ to the v–w plane with length = parallelogram area — i.e. exactly the cross product. The `i, j, k`-in-a-determinant trick is this duality in disguise.

### Current Study Position (June 2026)
- MML Ch.2 (Linear Algebra): starting tomorrow
- 3Blue1Brown Linear Algebra playlist: Ch.11 (Cross products via linear transformations) — covered; see "Cross Product as a Dual Vector" above

---

## Calculus

### Derivatives and Gradients

**Derivative:** rate of change of f with respect to x. df/dx.

**Partial derivative:** ∂f/∂xᵢ — derivative holding all other variables fixed.

**Gradient:** ∇f = [∂f/∂x₁, ∂f/∂x₂, ..., ∂f/∂xₙ]ᵀ — vector of all partials. Points in direction of steepest ascent of f. Gradient descent steps opposite to ∇f to minimize.

**Hessian:** **H** = ∇²f — matrix of second-order partials. Describes curvature. H positive definite → local minimum. H negative definite → local maximum. H indefinite → saddle point.

### Chain Rule
The engine of backpropagation:

Scalar case: `d/dx[f(g(x))] = f'(g(x)) · g'(x)`

Vector case (Jacobian): if **y** = f(**x**) where **y** ∈ ℝᵐ, **x** ∈ ℝⁿ, then **J** = ∂**y**/∂**x** ∈ ℝᵐˣⁿ.

Backprop applies chain rule backwards through composed functions (the layers of a neural network).

### Taylor Expansion
f(x + ε) ≈ f(x) + εf'(x) + (ε²/2)f''(x) + ...

Used in: understanding why gradient descent works, second-order optimization methods.

---

## Probability & Statistics

### Distributions
- **Gaussian (Normal):** N(μ, σ²). The default assumption for continuous random variables. Sum of many independent RVs converges to Gaussian (CLT).
- **Bernoulli:** binary outcome. P(X=1) = p.
- **Categorical:** generalization of Bernoulli to K classes.

### Key Quantities
- **Expectation:** E[X] = ∫ x p(x) dx — weighted average
- **Variance:** Var[X] = E[(X - μ)²] = E[X²] - E[X]²
- **Covariance:** Cov(X,Y) = E[(X-μₓ)(Y-μᵧ)] — how X and Y move together
- **Covariance matrix Σ:** Σᵢⱼ = Cov(Xᵢ, Xⱼ). Diagonal → independent features. Used extensively in Gaussian processes, PCA.

### Bayes' Theorem
P(θ|X) = P(X|θ) P(θ) / P(X)

- **Posterior** P(θ|X): what we believe about θ after seeing data X
- **Likelihood** P(X|θ): probability of data given parameters
- **Prior** P(θ): what we believed before seeing data

This is the foundation of Bayesian ML. MLE ignores the prior; MAP includes it.

### MLE vs MAP
- **MLE:** find θ that maximizes P(X|θ) = find θ that makes the data most probable
- **MAP:** find θ that maximizes P(θ|X) ∝ P(X|θ) P(θ) = MLE + prior regularization

L2 regularization in ML = MAP estimation with a Gaussian prior on weights.

### Information Theory (ML-relevant)
- **Entropy:** H(X) = -Σ p(x) log p(x) — average surprise; measures uncertainty
- **Cross-entropy:** H(p, q) = -Σ p(x) log q(x) — entropy of p as measured by q. The standard loss function for classification.
- **KL Divergence:** KL(p||q) = Σ p(x) log p(x)/q(x) — how much q differs from p. Always ≥ 0.

---

## Open Questions
- [ ] Geometric intuition for SVD — what do the singular vectors actually represent?
- [ ] Where exactly does the Jacobian appear in backpropagation for vector-valued layers?
- [ ] How does MML Ch.10 connect eigendecomposition of the covariance matrix to PCA?
- [ ] Is there a clean way to derive the normal equation (XᵀX)⁻¹Xᵀy from first-order conditions?

---

## Sources
*(none ingested yet — seed page primed from CLAUDE.md context)*

## Cross-references
- [[mml-book]] — the primary source covering all of the above
- [[machine-learning]] — where linear algebra and calculus get applied to algorithms
- [[deep-neural-networks]] — backpropagation is the chain rule applied to network layers
