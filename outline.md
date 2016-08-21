## Talk outline

*   Drawings and animations
*   Reflection:
    *   Which motions can be generated in this way?
    *   How to generate the frequency components from a motion?
*   Formula to construct a curve from frequency components (inverse Fourier transform).
    *   Pick a convenient notation: complex numbers in polar form ($\rho\, e^{i \theta}$).
    *   Then sampled.
*   Answer to the generation question: the Fourier transform.
*   Discrete Fourier transform (DFT):
    *   Math formula
    *   $O(n^2)$ work
*   Haskell DFT:
    *   Simple formulation
    *   Use `C`, noting generalization to `RealFloat a => Complex a`.
    *   Circuits: `(<.>)`, `powers`, `twiddles`, `dft`
*   Fast Fourier transform (FFT):
    *   DFT in $O(n \log n)$
    *   Better numeric properties than naive DFT
    *   Some FFT history:
        *   Gauss: 1805
        *   Danielson & Lanczos: 1942
        *   Cooley & Tukey: 1965
*   How FFT works
    *   A summation trick (composite size)
    *   Lift the formulation from [General factorizations](https://en.wikipedia.org/wiki/Cooley%E2%80%93Tukey_FFT_algorithm#General_factorizations) on the Cooley-Tukey FFT Wikipedia page.
    *   Picture from same source
*   Generic FFT in Haskell:
    *   Follow the WP picture:
        *   Note reshaping (functor change)
        *   Direct translation to Haskell
    *   Optimize transpositions
    *   Generic formulation: `Traversable`, functor composition.
*   Some type instances with figures:
    *   Where to introduce functor exponentiation?
    *   Top-down trees: binary & other
    *   Bottom-up trees: binary & other
    *   Vectors?
    *   Other?



*   Concluding remarks:
    *   Generic (type-driven), parallel-friendly algorithm
    *   Some well-known algorithms as special cases
    *   Move factorization into the types.
    *   No arrays! Why not?
        *   Poorly composable
        *   Index computations
        *   Out-of-bounds errors


* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *


*   DFT: given complex $\xs = x_0,\ldots,x_{n-1}$, compute
    $$\dft_k \xs = \sum_{j=0}^{n-1} x_j \omega_n^{k j} \quad\mbox{for}\; k = 0,\dots,n-1 \mbox{, where}\;\omega_n = e^{- i 2 \pi / n}$$
    Implemented directly, $O(n^2)$.
*   FFT is $\dft$ in $O(n \log n)$.
*   Danielson-Lanczos Lemma.
    If $n$ is even, then

$$\sum_{j=0}^{n-1} x_j \om{n}{k j}$$
$$\eql \sum_{\mbox{even}\;j=0}^{n-1} x_j \om{n}{k j} + \sum_{\mbox{odd}\;j=0}^{n-1} x_j \om{n}{k j}$$
$$\eql \sum \limits_{j'=0}^{n/2-1} x_{2j'} \om{n}{k(2j')} + \sum \limits_{j'=0}^{n/2-1} x_{2j'+1} \om{n}{k(2j'+1)}$$
$$\eql \sum \limits_{j'=0}^{n/2-1} x_{2j'} \om{n}{k(2j')} + \om{n}k  \sum \limits_{j'=0}^{n/2-1} x_{2j'+1} \om{n}{k(2j')}$$
$$\eql \sum \limits_{j'=0}^{n/2-1} x_{2j'} \om{n/2}{k j'} + \om{n}k  \sum \limits_{j'=0}^{n/2-1} x_{2j'+1} \om{n/2}{k j'}$$
$$= \quad \dft_k (\evens \xs) \, +\, \om{n}k \dft_k (\odds \xs)$$
$$\eql E_k + \om{n}k O_k$$

