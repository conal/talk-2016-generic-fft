## Generic FFT

A [talk given at the Silicon Valley Haskell meetup](https://www.meetup.com/haskellhackers/events/233268893/), August 31, 2016.

*   [Slides (PDF)](http://conal.net/talks/generic-fft.pdf).
*   *Video to be posted*

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
