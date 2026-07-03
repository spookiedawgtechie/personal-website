---
tags: [dnn, ml]
related: [machine-learning, mathematics, ai-safety-alignment]
last-updated: 2026-06-24
---

# Deep Neural Networks

## Overview
Deep neural networks are ML models built from layered nonlinear transformations. Depth enables hierarchical representation: lower layers learn simple features (edges, frequencies), higher layers compose them into complex abstractions (objects, semantics). DNNs are Tanish's hardest subject this semester — zero prior base. The rule here is: go slow, don't fake understanding. If you can't derive backpropagation by hand, you don't understand it yet.

---

## Key Concepts

### The Neuron
The atomic unit:
```
output = activation(w · x + b)
```
- `w`: weight vector (learned)
- `x`: input vector
- `b`: bias scalar (learned)
- `activation`: nonlinear function applied element-wise

### Feedforward Network (MLP)
Layers of neurons stacked in sequence: input → hidden layers → output. Each layer applies a linear transformation then a nonlinearity:
```
h⁽ˡ⁾ = activation(W⁽ˡ⁾ h⁽ˡ⁻¹⁾ + b⁽ˡ⁾)
```
The network is a composition of functions. "Deep" means more than one hidden layer.

### Activation Functions

| Function | Formula | Properties | Use |
|----------|---------|------------|-----|
| Sigmoid | 1/(1+e⁻ˣ) | Squashes to (0,1) | Output layer, binary classification |
| Tanh | (eˣ-e⁻ˣ)/(eˣ+e⁻ˣ) | Squashes to (-1,1), zero-centered | Hidden layers (older) |
| ReLU | max(0, x) | No vanishing gradient for x>0, fast | Default hidden layer choice |
| Softmax | eˣⁱ/Σeˣʲ | Probability distribution over classes | Multi-class output layer |

**Why ReLU won:** sigmoid and tanh cause vanishing gradients in deep networks — during backpropagation, gradients get multiplied by values < 1 at every layer and vanish to zero in early layers, making training stall. ReLU has gradient = 1 for positive inputs, breaking the chain.

### The Training Loop
```
for each batch:
  1. Forward pass:  compute ŷ = f(x; θ)
  2. Compute loss:  L = loss(ŷ, y)
  3. Backward pass: compute ∂L/∂θ via backpropagation
  4. Update:        θ ← θ - η ∂L/∂θ
```

### Backpropagation
The algorithm that makes deep learning computationally feasible. Applies the chain rule recursively from the output layer back to the input to compute ∂L/∂w for every weight.

Chain rule for scalars: `d/dx[f(g(x))] = f'(g(x)) · g'(x)`

For networks: at each layer l, the gradient of the loss w.r.t. layer l's pre-activation is:
```
δ⁽ˡ⁾ = (W⁽ˡ⁺¹⁾ᵀ δ⁽ˡ⁺¹⁾) ⊙ activation'(z⁽ˡ⁾)
```
Then: `∂L/∂W⁽ˡ⁾ = δ⁽ˡ⁾ (h⁽ˡ⁻¹⁾)ᵀ`

**Critical:** if you don't implement this by hand in NumPy before using PyTorch, you will be confused for the rest of the semester. The framework hides the mechanics; derive them first.

### Loss Functions

| Problem | Loss | Why |
|---------|------|-----|
| Binary classification | Binary cross-entropy: -[y log ŷ + (1-y) log(1-ŷ)] | Penalizes confident wrong predictions |
| Multi-class classification | Cross-entropy: -Σ yᵢ log ŷᵢ | Same; y is one-hot |
| Regression | MSE: (1/n) Σ(y - ŷ)² | Penalizes large errors quadratically |

### Regularization in DNNs
- **Dropout:** during training, randomly zero out neurons with probability p. Forces the network to build redundant representations; prevents co-adaptation of neurons. At test time, scale outputs by (1-p).
- **L2 weight decay:** add λ||w||² to loss. Penalizes large weights; shrinks them toward zero.
- **Batch normalization:** normalize layer activations to zero mean and unit variance before passing to the next layer. Stabilizes and accelerates training. Often eliminates need for careful learning rate tuning.

---

## Implementation Milestone (Must-Do Before Framework)

Build a 2-layer network in NumPy that:
1. [ ] Forward pass: matrix multiplications + activations
2. [ ] Computes MSE or cross-entropy loss
3. [ ] Backward pass: backpropagation by hand (no autograd)
4. [ ] SGD weight update
5. [ ] Trains on a toy problem (XOR gate, or 2D classification)
6. [ ] Verify loss decreases over training

Only after this: use PyTorch.

---

## Open Questions
- [ ] Why exactly do vanishing gradients kill sigmoid/tanh but not ReLU — derive it from the gradient formula
- [ ] What does "dying ReLU" mean and when does it happen?
- [ ] What does the loss landscape look like geometrically? Is it convex? What are saddle points?
- [ ] How does batch normalization interact with dropout — should both be used together?

---

## Sources
*(none ingested yet — seed page primed from CLAUDE.md context)*

## Cross-references
- [[machine-learning]] — DNNs are a subclass of ML, best understood after the core ML foundations
- [[mathematics]] — backpropagation is applied calculus (chain rule); weight matrices require linear algebra
- [[ai-safety-alignment]] — interpretability, deception, and "trained not programmed" are all about what these networks actually learn inside
