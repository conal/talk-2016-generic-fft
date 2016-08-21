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
    *   Imagine how to implement in Haskell
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


## Some sources

*   [2D animated version (square waves in $X$ and $Y$)](http://i.imgur.com/BuO2INb.gif)
*   [An Interactive Guide To The Fourier Transform](https://betterexplained.com/articles/an-interactive-guide-to-the-fourier-transform/ "blog post by Kalid Azad"):
    *   Circular motion (2D), not sinusoids (1D).
    *   Euler's formula: $e^{i \theta} = \cos \theta + i \sin \theta$
    *   Interactive animations with FFT and inverse FFT
*   [Ptolemy and Homer (Simpson)](https://www.youtube.com/watch?v=QVuU2YCwHjw): video
*   [Fourier transform for dummies](http://math.stackexchange.com/questions/1002/fourier-transform-for-dummies): epicycles (Ptolemy)
*   [Wheels on Wheels on Wheels---Surprising Symmetry](https://works.bepress.com/frank_farris/14/ "paper by Frank A. Farris")
*   [Fourier Transform Clarified](http://blog.ivank.net/fourier-transform-clarified.html) with some figures of wheels-on-wheels
*   [Animated square wave approximation](http://blog.matthen.com/post/42112703604/the-smooth-motion-of-rotating-circles-can-be-used)
*   [The Math Trick Behind MP3s, JPEGs, and Homer Simpson’s Face](http://nautil.us/blog/the-math-trick-behind-mp3s-jpegs-and-homer-simpsons-face)
*   [FourierToy](http://toxicdump.org/stuff/FourierToy.swf)
*   [Visualizing the Fourier Transform](http://hackaday.com/2015/09/17/visualizing-the-fourier-transform/): figure and 1-minute video
*   [Fourier Transform, Fourier Series, and frequency spectrum](https://www.youtube.com/watch?v=r18Gi8lSkfM): narrated computer graphics video


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

