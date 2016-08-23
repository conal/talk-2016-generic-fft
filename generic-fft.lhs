%% -*- latex -*-

% Presentation
%\documentclass[aspectratio=1610]{beamer} % Macbook Pro screen 16:10
\documentclass{beamer} % default aspect ratio 4:3
%\documentclass[handout]{beamer}

\usefonttheme{serif}
\usepackage{framed}

\usepackage{hyperref}
\usepackage{color}

\definecolor{linkColor}{rgb}{0,0.42,0.3}
\definecolor{partColor}{rgb}{0,0,0.8}

\hypersetup{colorlinks=true,urlcolor=linkColor}

\usepackage{graphicx}
\usepackage{color}
\DeclareGraphicsExtensions{.pdf,.png,.jpg}

%% \usepackage{wasysym}
\usepackage{mathabx}
\usepackage{setspace}
\usepackage{enumerate}
\usepackage{tikzsymbols}

\useinnertheme[shadow]{rounded}
% \useoutertheme{default}
\useoutertheme{shadow}
\useoutertheme{infolines}
% Suppress navigation arrows
\setbeamertemplate{navigation symbols}{}

\newcommand\sourced[1]{\href{#1}{\tiny (source)}}

\input{macros}

%include polycode.fmt
%include forall.fmt
%include greek.fmt
%include mine.fmt

\title{Generic FFT}
\author{\href{http://conal.net}{Conal Elliott}}
\institute{Target}
\date{August 31, 2016}
% \date{\emph{Draft of \today}}

\setlength{\itemsep}{2ex}
\setlength{\parskip}{1ex}

% \setlength{\blanklineskip}{1.5ex}

%%%%

% \setbeameroption{show notes} % un-comment to see the notes

\setstretch{1.2}

\graphicspath{{Figures/}}

\definecolor{shadecolor}{rgb}{0.95,0.95,0.95}

\begin{document}

%% \partframe{\href{https://www.youtube.com/watch?v=k8FXF1KjzY0&list=PL6c1MWlBF2oY2vSJcylt6QkO2Gxz7RjsL}{Prelude}}

\frame{\titlepage}

%% \partframe{\href{http://i.imgur.com/BuO2INb.gif}{Paths from circles}}

\framet{Paths from circular motion}{

\vspace{-1.8ex}
\wfig{3in}{Farris/figs-1-2}
\begin{center}
\vspace{-7ex}
\sourced{https://works.bepress.com/frank_farris/14/}
\end{center}
\vspace{-3ex}

\begin{itemize}\itemsep 0.5ex
\item Circular motion:
  \begin{itemize}
  % \item Center
  \item Radius, $r$
  \item Frequency/speed, $f$
  \item Starting angle, $a$
  \end{itemize}
\item Combine several motions: center of each follows path of previous.
\item Observe final motion.
\item \href{http://i.imgur.com/BuO2INb.gif}{Another example}
\end{itemize}

}

\framet{Paths from circular motions}{

%% \vspace{-3ex}

%% $$x(t) = \sum_k (r_k \cos (2 \pi f_k t + a_k), r_k \sin (2 \pi f_k t + a_k))$$

$$\sum_{(f,r,a) \in S} (r \cos (2 \pi f t + a), r \sin (2 \pi f t + a))$$

\ 

More succinct in complex polar form:
$$ \sum_{(f,r,a) \in S} r \, e ^ {i (2 \pi f t + a)} $$

Yet more succinct with $X_k = r_k e^{i a_k}$:
$$x(t) = \sum_{(f,X) \in S} X \, e ^ {i 2 \pi f t}$$

% \mathrm{\ \ (inverse Fourier transform)}

%% Discretize with $f_k = k$ and $t = n/N$, $0 \le k, n < N$: $$x_n = \sum_{0 \le k < N} X_k \, e ^ {i 2 \pi k n/N}$$

}

\framet{Questions}{

\wfig{2in}{multi-circle}
\begin{center}
\vspace{-5ex}
\sourced{http://blog.ivank.net/fourier-transform-clarified.html}
\end{center}
\vspace{-2ex}
\begin{itemize}\itemsep 2ex
\item Which motions can be generated in this way?
\item How to generate the circular components for a given motion?
\end{itemize}

\pause
\emph{Answers}: all periodic functions; the Fourier transform.

}

\framet{Other uses of the Fourier transform}{
}


\framet{Discrete Fourier Transform (DFT)}{
\vspace{1in}
$$
X_k =  \sum\limits_{n=0}^{N-1} x_n e^{\frac{-i2\pi kn}{N}}
\qquad k = 0,\ldots,N-1
$$

\vspace{0.75in}
Direct implementation does $O(n^2)$ work.
\vspace{0.5in}
}

\framet{DFT in Haskell}{

\vspace{-7ex}
\begin{flushright}
\colorbox{shadecolor}{$X_k =  \sum\limits_{n=0}^{N-1} x_n e^{\frac{-i2\pi kn}{N}}$}
\end{flushright}
\vspace{-3ex}

> dft :: ... => f C -> f C
> dft xs = (<.> xs) <$> twiddles

> twiddles :: ... => g (f C)
> twiddles = powers <$> powers (exp (- i * 2 * pi / size @(g :.: f)))

> powers :: ... => a -> f a
> powers = fst . lscanAla Product . pure

> (<.>) :: ... => f a -> f a -> a
> u <.> v = sum (liftA2 (*) u v)

%% No arrays!

}

%if False

\framet{|(<.>) :: RBin N3 R -> RBin N3 R -> R|}{
\vspace{-7ex}
\wfig{4.8in}{circuits/dot-r3-d}
}

\framet{|(<.>) :: RBin N2 C -> RBin N2 C -> C|}{
\vspace{-2ex}
\wfig{3.5in}{circuits/dot-r2-c}
}

\framet{|powers :: R -> RBin N4 R| --- unoptimized}{
\vspace{-2ex}
\wfig{3.8in}{circuits/powers-rt4-no-opt}
}
\framet{|powers :: R -> RBin N4 R| --- optimized}{
\vspace{-2ex}
\wfig{4.8in}{circuits/powers-rt4}
}
\framet{|powers :: C -> RBin N4 C|}{
\vspace{-2.8ex}
\wfig{3.8in}{circuits/powersp-rb4-c}
}
\framet{|powers :: C -> RBin N3 C|}{
\vspace{-2.8ex}
\wfig{4.25in}{circuits/powersp-rb3-c}
}

%% \framet{|twiddles :: RBin N2 (RBin N3 C)|}{
%% \vspace{-2.8ex}
%% \wfig{4.25in}{circuits/twiddles-rb2-rb3}
%% }

\framet{|dft :: RBin N2 C -> RBin N2 C|}{
\vspace{-2ex}
\wfig{3.25in}{circuits/dft-rb2}
}

%endif

\framet{Fast Fourier transform (FFT)}{

\vspace{-12.4ex}
\begin{flushright}
\colorbox{shadecolor}{$X_k =  \sum\limits_{n=0}^{N-1} x_n e^{\frac{-i2\pi kn}{N}}$}
\end{flushright}

\vspace{4ex}

\begin{itemize}\itemsep4ex
\item DFT in $O(n \log n)$ work
\item Better numeric properties than naive DFT
\item Long history:
  \begin{itemize}
  \item Gauss: 1805
  \item Danielson \& Lanczos: 1942
  \item Cooley \& Tukey: 1965
  \end{itemize}
\end{itemize}
}

\framet{A summation trick}{

\vspace{-17.4ex}
\begin{flushright}
\colorbox{shadecolor}{$X_k =  \sum\limits_{n=0}^{N-1} x_n e^{\frac{-i2\pi kn}{N}}$}
\end{flushright}

\vspace{6ex}
For composite bounds:
\vspace{4ex}

$$
\sum_{n = 0}^{N_1 N_2 -1}{F(n)} \:\; = \:\;
\sum_{n_1 = 0}^{N_1-1}\, \sum_{n_2 = 0}^{N_2-1} F(N_1 n_2 + n_1)
$$

%% Apply to DFT:
%% $$X_k =  \sum_{n=0}^{N-1} x_n e^{\frac{-i2\pi kn}{N}} \qquad 0 \le k < N$$

}

\definecolor{wow}{rgb}{1,0,0}

\framet{Factoring DFT --- math}{

\vspace{-6.2ex}
\begin{flushright}
\colorbox{shadecolor}{$X_k =  \sum\limits_{n=0}^{N-1} x_n e^{\frac{-i2\pi kn}{N}}$}
\end{flushright}
\vspace{-3ex}

\href{https://en.wikipedia.org/wiki/Cooley\%E2\%80\%93Tukey_FFT_algorithm\#General_factorizations}{From Wikipedia}:
\begin{shaded*}
{\small When this re-indexing is substituted into the DFT formula for $nk$, the $N_1 n_2 N_2 k_1$ cross term vanishes (its exponential is unity), and the remaining terms give}
$$
X_{N_2 k_1 + k_2} =
      \sum_{n_1=0}^{N_1-1} \sum_{n_2=0}^{N_2-1}
         x_{N_1 n_2 + n_1}
         e^{-\frac{2\pi i}{N_1 N_2} \cdot (N_1 n_2 + n_1) \cdot (N_2 k_1 + k_2)} $$
\vspace{1ex}
$$= 
      \sum_{n_1=0}^{N_1-1} 
        \left[ e^{-\frac{2\pi i}{N} n_1 k_2} \right]
          \left( \sum_{n_2=0}^{N_2-1} x_{N_1 n_2 + n_1}  
                  e^{-\frac{2\pi i}{N_2} n_2 k_2 } \right)
        e^{-\frac{2\pi i}{N_1} n_1 k_1}
$$
\vspace{2ex}
\end{shaded*}
}

\framet{Factoring DFT --- math}{

\vspace{-6.1ex}
\begin{flushright}
\colorbox{shadecolor}{$X_k =  \sum\limits_{n=0}^{N-1} x_n e^{\frac{-i2\pi kn}{N}}$}
\end{flushright}

\vspace{-2.8ex}

\href{https://en.wikipedia.org/wiki/Cooley\%E2\%80\%93Tukey_FFT_algorithm\#General_factorizations}{From Wikipedia}:
\begin{shaded*}
{\small When this re-indexing is substituted into the DFT formula for $nk$, the $N_1 n_2 N_2 k_1$ cross term vanishes (its exponential is unity), and the remaining terms give}
$$
X_{N_2 k_1 + k_2} =
      \sum_{n_1=0}^{N_1-1} \sum_{n_2=0}^{N_2-1}
         x_{N_1 n_2 + n_1}
         e^{-\frac{2\pi i}{N_1 N_2} \cdot (N_1 n_2 + n_1) \cdot (N_2 k_1 + k_2)} $$
\vspace{-2.45ex}
$$= 
    \underbrace{
      \sum_{n_1=0}^{N_1-1} 
        \left[ e^{-\frac{2\pi i}{N} n_1 k_2} \right]
        \overbrace{
          \left( \sum_{n_2=0}^{N_2-1} x_{N_1 n_2 + n_1}  
                  e^{-\frac{2\pi i}{N_2} n_2 k_2 } \right)
        }^{\text{\textcolor{wow}{inner FFTs}}}
        e^{-\frac{2\pi i}{N_1} n_1 k_1}
    }_{\text{\textcolor{wow}{outer FFTs}}}
$$
\vspace{-1.2ex}
\end{shaded*}
}

\framet{Factoring a DFT --- in pictures}{

\wfig{3.25in}{cooley-tukey-general}
\begin{center}
\vspace{-5ex}
\sourced{https://en.wikipedia.org/wiki/Cooley\%E2\%80\%93Tukey_FFT_algorithm\#General_factorizations}
\end{center}

\vspace{-2ex}
\pause
How might we implement in Haskell?
}

%% {Factoring a DFT --- in Haskell}
\framet{Factor functors, not numbers}{

\setlength{\fboxsep}{1pt}
\vspace{-7ex}
\begin{flushright}
\fbox{\wpicture{2in}{cooley-tukey-general}}
\end{flushright}
\vspace{-17ex}

> class FFT f where
>   type FFO f :: * -> *
>   fft :: f C -> FFO f C

> ffts' :: ... => g (f C) -> FFO g (f C)
> ffts' = inTranspose (fmap fft)

> twiddle :: ... => g (f C) -> g (f C)
> twiddle = (liftA2.liftA2) (*) twiddles

> instance SPACE ... => FFT (g :.: f) where
>   type FFO (g :.: f) = FFO f :.: FFO g
>   fft = inComp (ffts' . transpose . twiddle . ffts')

}

\framet{Some details}{

> (<--) :: (c -> d) -> (a -> b) -> ((b -> c) -> (a -> d))
> (h <-- f) g = h . g . f

> newtype (g :.: f) a = Comp1 { unComp1 :: g (f a) }

> inComp :: (g (f a) -> g' (f' a')) -> ((g :.: f) a -> (g' :.: f') a')
> inComp = Comp1 <-- unComp1

> transpose :: (Traversable t, Applicative f) => t (f a) -> f (t a)
> transpose = sequenceA

> inTranspose :: ... => (f (g a) -> f' (g' a)) -> g (f a) -> g' (f' a)
> inTranspose = transpose <-- transpose

}

\framet{Optimizing}{
\begin{center}
Optimize |fft| for |g :.: f|.
\end{center}
}

\framet{Binary FFT}{

Uniform pairs:

> data Pair a = a :# a deriving (Functor,Foldable,Traversable)

> instance Sized Pair where size = 2
>
> instance FFT Pair where
>   type FFO Pair = Pair
>   fft = dft

Equivalently,

> SPACE fft (a :# b) = (a + b) :# (a - b)

}

\framet{Exponentiating functors}{

Binary tree of depth $n$:

$$\overbrace{\Pair \circ \cdots \circ \Pair}^{n \text{~times}}$$

\pause

Right-associated functor exponentiation

> type family RPow h n where
>   RPow h Z     = Par1
>   RPow h (S n) = h :.: RPow h n

Left-associated functor exponentiation

> type family LPow h n where
>   LPow h Z     = Par1
>   LPow h (S n) = LPow h n :.: h


}

\framet{Top-down trees --- decimation in time}{}
\framet{Bottom-up trees --- decimation in frequency}{}
\framet{Generic FFT}{}


\framet{Shaped types}{

Perfect binary tree of depth $n$:

$$\overbrace{P \circ \cdots \circ P}^{n \text{~times}}$$

}


\framet{Concluding remarks}{
\begin{itemize}
\item Generic (type-driven), parallel-friendly algorithm
\item Some well-known algorithms as special cases
\item Move factorization into the types.
\item No arrays! Why not?
  \begin{itemize}
  \item Poorly composable
  \item Index computations
  \item Out-of-bounds errors
  \end{itemize}
\end{itemize}
}

\nc{\pcredit}[3]{\item \href{#1}{\wpicture{0.75in}{#3}} #2}

\framet{Picture credits}{

\begin{itemize}\itemsep3ex

\pcredit{https://works.bepress.com/frank_farris/14/}{Frank A. Farris}{Farris/figs-1-2.pdf}
\pcredit{http://blog.ivank.net/fourier-transform-clarified.html}{Ivan Kuckir}{multi-circle}
% \pcredit{https://en.wikipedia.org/wiki/Cooley%E2%80%93Tukey_FFT_algorithm\#/media/File:Cooley-tukey-general.png}{Steven G. Johnson}{cooley-tukey-general}

\end{itemize}
}

\end{document}
