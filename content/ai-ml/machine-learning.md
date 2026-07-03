---
tags: [ml]
related: [deep-neural-networks, mathematics, mml-book]
last-updated: 2026-06-22
---

# Machine Learning

## Overview
Machine learning is the study of algorithms that improve through experience. Rather than being programmed with explicit rules, ML systems learn patterns from data. The three core paradigms are supervised learning (labeled examples → prediction function), unsupervised learning (structure in unlabeled data), and reinforcement learning (reward-driven policy improvement). This is one of Tanish's zero-base subjects for M.Tech Semester 1.

---

## Key Concepts

### The Core Problem
Given input data **X** and (for supervised learning) labels **y**, learn a function f such that f(**X**) ≈ **y** for unseen data. The challenge is **generalization** — the model must perform well on examples it was never trained on, not just memorize the training set.

### Types of Learning

| Type | Labels? | Goal | Examples |
|------|---------|------|---------|
| Supervised | Yes | Learn f: X → y | Classification, Regression |
| Unsupervised | No | Find structure in X | Clustering, Dimensionality reduction |
| Reinforcement | Rewards | Learn policy | Game playing, Robotics |

### The ML Pipeline
1. Collect and clean data
2. Feature engineering (hand-crafted) or feature learning (deep networks do this automatically)
3. Choose model class
4. Train: minimize a loss function over training data
5. Evaluate: held-out test set; use cross-validation to select hyperparameters
6. Deploy

### Bias-Variance Tradeoff
A fundamental tension in all of ML:
- **High bias (underfitting):** model too simple, misses real patterns in training data
- **High variance (overfitting):** model too complex, memorizes training noise, fails on new data
- **Goal:** find the sweet spot — complex enough to capture signal, constrained enough to generalize

Regularization (L1/L2 penalty on weights, dropout in DNNs) is how we control this tradeoff.

### Loss Functions
A loss function measures how wrong the model's predictions are:
- **MSE (Mean Squared Error):** regression problems; penalizes large errors quadratically
- **Cross-entropy:** classification; penalizes confident wrong predictions harshly
- **Hinge loss:** SVMs; used for maximum-margin classification

### Optimization
Training = minimizing the loss function over the parameter space.
- **Gradient descent:** iteratively step in the direction opposite to the gradient: `θ ← θ - η∇L`
- **SGD (Stochastic GD):** update on single examples or mini-batches; noisy but fast
- **Adam:** adaptive learning rates per parameter; default choice for deep networks
- Learning rate η is the most important hyperparameter to tune

### Core Algorithms (Semester 1 scope)

**Linear Regression**
Minimize sum of squared residuals. Closed-form solution exists: `θ* = (XᵀX)⁻¹Xᵀy`. Works when features and target have a linear relationship.

**Logistic Regression**
Despite the name — classification, not regression. Models P(y=1|x) = σ(wᵀx + b) where σ is the sigmoid function. Trained via maximum likelihood (equivalent to minimizing cross-entropy).

**Support Vector Machines (SVM)**
Find the hyperplane that maximizes the margin between classes. Hard-margin SVM requires linear separability; soft-margin SVM allows misclassifications (C controls tradeoff). Kernel trick extends SVMs to nonlinear boundaries by implicitly mapping to higher-dimensional space.

**Decision Trees**
Recursively partition the feature space by choosing splits that maximize information gain (or minimize Gini impurity). Highly interpretable. Tend to overfit if grown deep — regularize by limiting depth or requiring minimum samples per leaf.

**Ensemble Methods**
- **Random Forests (Bagging):** train many trees on random subsets of data + features; average predictions. Reduces variance.
- **Gradient Boosting:** train trees sequentially, each correcting the residuals of the previous. XGBoost/LightGBM are dominant implementations. Strong performance on tabular data.

**k-Means Clustering**
Assign n data points to k clusters by minimizing within-cluster sum of squared distances to centroids. Iterative: assign → update centroids → assign → ... Sensitive to initialization; run multiple times with different starting points.

---

## Implementation Protocol
For every algorithm covered in the semester:
1. Understand the math — derive the update rule or objective
2. Implement from scratch in NumPy (no sklearn)
3. Verify against sklearn on a standard dataset
4. Only then use sklearn in production code

---

## Open Questions
- [ ] What is the geometric interpretation of the regularization term in the loss function?
- [ ] Formal relationship between SVM margin maximization and Lagrange multipliers?
- [ ] When does gradient boosting overfit vs. when does it keep improving with more trees?
- [ ] How does the kernel trick work mathematically — what's the reproducing kernel Hilbert space?

---

## Sources
*(none ingested yet — seed page primed from CLAUDE.md context)*

## Cross-references
- [[deep-neural-networks]] — DNNs are a subclass of ML; the dominant paradigm for unstructured data
- [[mathematics]] — Linear Algebra and Calculus are the mathematical backbone of everything above
- [[mml-book]] — Ch.8–12 apply the mathematical foundations to ML algorithms
- [[plm-and-cad]] — potential application: ML classifier to replace rule-based NLP in description standardization
