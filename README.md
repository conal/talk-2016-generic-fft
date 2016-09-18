## Generic FFT

A [talk given at the Silicon Valley Haskell meetup](https://www.meetup.com/haskellhackers/events/233268893/), August 31, 2016.

*   [Slides (PDF)](http://conal.net/talks/generic-fft.pdf)
*   [Video](https://www.youtube.com/watch?v=Qam6t9EN5SQ)

### Abstract

The Fast Fourier Transform (FFT) is a fundamentally important algorithm that reduces the cost of the Discrete Fourier Transform (DFT) from $O(n^2)$ to $O(n \log n)$.
First discovered by Gauss in 1805, the algorithm was rediscovered and first popularized by Cooley & Tukey only as recently as 1965.
This talk presents a simple, parallel-friendly FFT implementation constructed in a type-generic manner in Haskell, so that it forms an infinite family of type-specific algorithms.
The development shares some of the flavor of [parallel-friendly generic scan](https://github.com/conal/talk-2013-understanding-parallel-scan), which makes a guest appearance to compute "twiddle factors" simply and efficiently.
Just as with parallel scan, specializing the generic algorithm to "top-down" and "bottom-up" trees yields well-known algorithms.
For FFT, these algorithms are known as "decimation in time" and "decimation in frequency".
While the usual description of these algorithms is rather complicated, our formulation is quite simple and general.
A key idea is to replace numeric factorization with functor factorization, i.e., numerical multiplication by functor composition.
In doing so, index computations are eliminated in favor of common operations from our standard type classes, particularly `Functor` and `Traversable`.

### Erratum

The definition of DFT (which is the specification for FFT) in the talk was wrong, building from the $N^2$-th root of unity instead of the $N$-th root.
I had tried to reuse too much between DFT and FFT.
I've fixed the Haskell code for DFT (slide 7) and the corresponding pictures (slides 34, 36, 38).

### Extras

The talk shows FFT for top-down and bottom-up perfect binary leaf trees trees (right- and left-associated `Pair` compositions). Later, I tried out a different data type---a sort of balanced counterpart to left- and right-associated composition:

``` haskell
type family Bush n where
  Bush Z     = Pair
  Bush (S n) = Bush n :.: Bush n
```

The work and "depth" (ideal parallel time) beats both bottom-up and top-down binary trees (DIF and DIT).

To do: coalesce the accidentally distinct redundant constants (different numeric approximations of the same real value), and compare again.

I've added a few new slides to the end of the talk, starting on slide 43.
