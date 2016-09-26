%% -*- latex -*-

% Presentation
%\documentclass[aspectratio=1610]{beamer} % Macbook Pro screen 16:10
% \documentclass{beamer} % default aspect ratio 4:3
\documentclass[handout]{beamer}

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
\usepackage[many]{tcolorbox}

\tcbset{enhanced,boxrule=0.5pt,colframe=black!50!blue,colback=white,boxsep=-2pt,drop fuzzy shadow}

\usepackage[absolute,overlay]{textpos}  % ,showboxes

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
\setlength{\blanklineskip}{1.5ex}
\setlength\mathindent{4ex}

%%%%

% \setbeameroption{show notes} % un-comment to see the notes

\setstretch{1.2}

\graphicspath{{Figures/}}

\definecolor{shadecolor}{rgb}{0.95,0.95,0.95}

\begin{document}

%% \partframe{\href{https://www.youtube.com/watch?v=k8FXF1KjzY0&list=PL6c1MWlBF2oY2vSJcylt6QkO2Gxz7RjsL}{Prelude}}

\frame{\titlepage}

%% \partframe{\href{http://i.imgur.com/BuO2INb.gif}{Paths from circles}}

%% \framet{Ptolemaic view of the universe}{\wfig{3in}{epicycles}}

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
  \item Frequency/speed, $f$
  \item Radius, $r$
  \item Starting angle, $a$
  \end{itemize}
\item Combine several motions: center of each follows path of previous.
\item Observe final motion.
\item \href{http://i.imgur.com/BuO2INb.gif}{Another example}
\end{itemize}
}

\framet{Paths from circular motions}{

%% \vspace{-3ex}

$$x(t) = \sum_{(f,r,a) \in S} (r \cos (2 \pi f t + a), r \sin (2 \pi f t + a))$$

\pause\ 

More succinct in complex polar form:
$$ x(t) = \sum_{(f,r,a) \in S} r \, e ^ {i (2 \pi f t + a)} $$

\pause
Yet more succinct with $X = r e^{i a}$:
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

\framet{Some other uses of the Fourier transform}{

\begin{itemize}\itemsep2ex
\item Hearing (roughly)
\item Geocentrism (Ptolemy's \href{https://en.wikipedia.org/wiki/Deferent_and_epicycle}{deferent \& epicycle})
\item Sound \& image compression
\item Audio equalization
\item Solving differential equations
\item Convolution, for signal processing, probability, neural networks
\item Derivatives of signals
\end{itemize}


}


\framet{Discrete Fourier Transform (DFT)}{
\vspace{0.5in}

{\Large
$$
X_k =  \sum\limits_{n=0}^{N-1} x_n e^{\frac{-i2\pi kn}{N}}
{ \qquad k = 0,\ldots,N-1}
$$
}

%\vspace{0.75in}
~

Direct implementation does $O(N^2)$ work.
\vspace{0.5in}
}

\TPGrid{364}{273} %% roughly page size in points

%% \setlength{\fboxsep}{0pt}

\newcommand{\upperDFT}{
%if False
\begin{textblock}{100}[1,0](348,13)
{\colorbox{shadecolor}{{\large $X_k = \sum\limits_{n=0}^{N-1} x_n e^{\frac{-i2\pi kn}{N}}$}}}
\end{textblock}
%else
\begin{textblock}{120}[1,0](348,9)
\begin{tcolorbox}
\large $X_k = \sum\limits_{n=0}^{N-1} x_n e^{\frac{-i2\pi kn}{N}}$
\end{tcolorbox}
\end{textblock}
%endif
}


\framet{DFT in Haskell}{\upperDFT 

\pause

> dft :: forall f a. ... => Unop (f (Complex a))
> dft xs = omegas (size @f) $@ xs
> 
> omegas :: ... => Int -> g (f (Complex a))
> omegas n = powers <$> powers (exp (- i * 2 * pi / fromIntegral n))

\pause
\vspace{-2ex}
\hrule

%% Utility:

> powers :: ... => a -> f a
> powers = fst . lscanAla Product . pure
>
> ($@) :: ... => n (m a) -> m a -> n a   -- matrix $\times$ vector
> mat $@ vec = (<.> vec) <$> mat
>
> (<.>) :: ... => f a -> f a -> a        -- dot product
> u <.> v = sum (liftA2 (*) u v)

%% No arrays!

}



%if False

\framet{|(<.>) :: RPow Pair N3 R -> RPow Pair N3 R -> R|}{
\vspace{-7ex}
\wfig{4.8in}{circuits/dot-r3-d}
}

\framet{|(<.>) :: RPow Pair N3 C -> RPow Pair N3 C -> C|}{
\vspace{-1ex}
\wfig{4in}{circuits/dot-r3-c}
}

\framet{|powers :: R -> RPow Pair N4 R| --- unoptimized}{
\vspace{-2ex}
\wfig{3.8in}{circuits/powers-rt4-no-opt}
}
\framet{|powers :: R -> RPow Pair N4 R| --- optimized}{
\vspace{-2ex}
\wfig{4.8in}{circuits/powers-rt4}
}
\framet{|powers :: C -> RPow Pair N4 C|}{
\vspace{-2.2ex}
\wfig{3.8in}{circuits/powersp-rb4-c}
}
\framet{|powers :: C -> RPow Pair N3 C|}{
\vspace{-2.8ex}
\wfig{4.25in}{circuits/powersp-rb3-c}
}

%% \framet{|twiddles :: RPow Pair N2 (RPow Pair N3 C)|}{
%% \vspace{-2.8ex}
%% \wfig{4.25in}{circuits/twiddles-rb2-rb3}
%% }

%% \framet{|dft :: RPow Pair N1 C -> RPow Pair N1 C|}{
%% \vspace{-1ex}
%% \wfig{4in}{circuits/dft-rb1}
%% }

\framet{|dft :: RPow Pair N2 C -> RPow Pair N2 C|}{
\vspace{-1ex}
\wfig{4.2in}{circuits/dft-rb2}
}

\framet{|dft :: RPow Pair N3 C -> RPow Pair N3 C|}{
\vspace{-2ex}
\wfig{4.2in}{circuits/dft-rb3-scaled}
}

%endif

\framet{Fast Fourier transform (FFT)}{\upperDFT

\begin{itemize}\itemsep4ex
\item DFT in $O(N \log N)$ work
\item Better numeric properties than naive DFT
\item Long history:
  \begin{itemize}
  \item Gauss: 1805
  \item Danielson \& Lanczos: 1942
  \item Cooley \& Tukey: 1965
  \end{itemize}
\end{itemize}
}

\framet{A summation trick}{\upperDFT

For composite bounds:
\vspace{4ex}

$$
\sum_{n = 0}^{N_1 N_2 -1}{F(n)} \; = \;
\sum_{n_1 = 0}^{N_1-1}\, \sum_{n_2 = 0}^{N_2-1} F(N_1 n_2 + n_1)
$$

%% Apply to DFT:
%% $$X_k =  \sum_{n=0}^{N-1} x_n e^{\frac{-i2\pi kn}{N}} \qquad 0 \le k < N$$

}

\definecolor{wow}{rgb}{1,0,0}

\framet{Factoring DFT --- math}{\upperDFT

\vspace{2ex}

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

\framet{Factoring DFT --- math}{\upperDFT

\vspace{2ex}

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
\vspace{-1.25ex}
\end{shaded*}
}

\framet{Factoring DFT --- pictures}{

\wfig{3.25in}{cooley-tukey-general}
\begin{center}
\vspace{-5ex}
\sourced{https://en.wikipedia.org/wiki/Cooley\%E2\%80\%93Tukey_FFT_algorithm\#General_factorizations}
\end{center}

\vspace{-2ex}
\pause
How might we implement in Haskell?
}

\setlength{\fboxsep}{1.5pt}

%% \definecolor{white}{rgb}{1,1,1}

\newcommand{\upperCT}{
%if True
\begin{textblock}{153}[1,0](353,7)
\begin{tcolorbox}
\wpicture{1.9in}{cooley-tukey-general}
\end{tcolorbox}
\end{textblock}
%else
\begin{textblock}{149}[1,0](353,12)
\colorbox{white}{\fbox{\wpicture{2in}{cooley-tukey-general}}}
\end{textblock}
%endif
}

\framet{Factoring DFT --- Haskell}{\upperCT

\vspace{4ex}
\pause

Factor types, not numbers!

%% \vspace{1ex}

> newtype (g :.: f) a = Comp1 (g (f a))

\pause
\vspace{-4ex}

> instance (Sized g, Sized f) => Sized (g :.: f) where
>   size = size @g * size @f

\vspace{-4ex}

\pause
Also closed under composition:
% |Functor|, |Applicative|, |Foldable|, |Traversable|.

\vspace{-1.5ex}
\begin{itemize}
\item |Functor|
\item |Applicative|
\item |Foldable|
\item |Traversable|
\end{itemize}

%% \vspace{1ex}
%% Exercise: work out the instances.

}

\framet{Factoring DFT --- Haskell}{\upperCT

\vspace{2ex}

> class FFT f where
>   type FFO f :: * -> *
>   fft :: f C -> FFO f C

\pause\vspace{-2ex}

> instance NOP ... => FFT (g :.: f) where
>   type FFO (g :.: f) = FFO f :.: FFO g
>   fft = Comp1 . ffts' . transpose . twiddle . ffts' . unComp1

> ffts' :: ... => g (f C) -> FFO g (f C)
> ffts' = transpose . fmap fft . transpose
>
> twiddle :: ... => g (f C) -> g (f C)
> twiddle = (liftA2.liftA2) (*) (omegas (size @(g :.: f)))

}

%if False
\framet{Typing}{

> ffts' :: ... => g (f C) -> FFO g (f C)
> ffts' = transpose . fmap fft . transpose
>
> transpose  :: g (f C)      -> f (g C)
> fmap fft   :: f (g C)      -> f (FFO g C)
> transpose  :: f (FFO g C)  -> FFO g (f C)

> instance NOP ... => FFT (g :.: f) where
>   type FFO (g :.: f) = FFO f :.: FFO g
>   fft = Comp1 . ffts' . transpose . twiddle . ffts' . unComp1
>
> ffts'      :: g (f C)      -> FFO g (f C)
> twiddle    :: FFO g (f C)  -> FFO g (f C)
> transpose  :: FFO g (f C)  -> f (FFO g C)
> ffts'      :: f (FFO g C)  -> FFO f (FFO g C)

}
%endif

\framet{Optimizing |fft| for |g :.: f|}{

>     ffts' . transpose . twiddle . ffts'
> ==     
>        transpose . fmap fft . transpose
>     .  transpose
>     .  twiddle
>     .  transpose . fmap fft . transpose
> ==  
>     transpose . fmap fft . twiddle . transpose . fmap fft . transpose
> ==  
>     traverse fft . twiddle . traverse fft . transpose

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

\vspace{6ex}

$$f^n = \overbrace{f \circ \cdots \circ f}^{n \text{~times}}$$

\vspace{6ex}

Example: $\Pair ^ n$ is a depth-$n$, perfect, binary, leaf tree.
}

\framet{Associating functor composition}{
\vspace{10ex}
$$(h \circ g) \circ f \simeq h \circ (g \circ f)$$
 
\vspace{10ex}
 
\pause
Does the same FFT algorithm arise?
}

\framet{Associating functor exponentiation}{

Right-associated/top-down:

> type family RPow h n where
>   RPow h Z      = Par1
>   RPow h (S n)  = h :.: RPow h n

{}

Left-associated/bottom-up:

> type family LPow h n where
>   LPow h Z      = Par1
>   LPow h (S n)  = LPow h n :.: h

%% FFT: \emph{Decimation in Time} (DIT) vs \emph{Decimation in Frequency} (DIF).

}

\framet{|fft @(RPow Pair N0)|}{\vspace{-0.0ex}\wfig{4.8in}{circuits/fft-rb0}}
\framet{|fft @(LPow Pair N0)|}{\vspace{-0.0ex}\wfig{4.8in}{circuits/fft-lb0}}
\framet{|fft @(RPow Pair N1)|}{\vspace{-6.0ex}\wfig{4.8in}{circuits/fft-rb1}}
\framet{|fft @(LPow Pair N1)|}{\vspace{-6.0ex}\wfig{4.8in}{circuits/fft-lb1}}
\framet{|fft @(RPow Pair N2)|}{\vspace{-2.5ex}\wfig{4.6in}{circuits/fft-rb2}}
\framet{|fft @(LPow Pair N2)|}{\vspace{-2.5ex}\wfig{4.6in}{circuits/fft-lb2}}
\framet{|fft @(RPow Pair N3)|}{\vspace{-6.5ex}\wfig{4.8in}{circuits/fft-rb3}}
\framet{|fft @(LPow Pair N3)|}{\vspace{-6.5ex}\wfig{4.8in}{circuits/fft-lb3}}
\framet{|fft @(RPow Pair N4)|}{\vspace{-3.0ex}\wfig{4.5in}{circuits/fft-rb4}}
\framet{|fft @(LPow Pair N4)|}{\vspace{-2.0ex}\wfig{4.5in}{circuits/fft-lb4}}
\framet{|fft @(RPow Pair N5)|}{\vspace{-7.0ex}\wfig{4.9in}{circuits/fft-rb5}}
\framet{|fft @(LPow Pair N5)|}{\vspace{-4.0ex}\wfig{4.9in}{circuits/fft-lb5}}
\framet{|fft @(RPow Pair N6)|}{\vspace{-4.0ex}\wfig{4.7in}{circuits/fft-rb6}}
\framet{|fft @(LPow Pair N6)|}{\vspace{-2.0ex}\wfig{4.7in}{circuits/fft-lb6}}

%% Contrast with DFT
\framet{|dft @(RPow Pair N2)|}{\vspace{-3.0ex}\wfig{4.8in}{circuits/dft-rb2}}
\framet{|fft @(RPow Pair N2)|}{\vspace{-2.5ex}\wfig{4.6in}{circuits/fft-rb2}}
\framet{|dft @(RPow Pair N3)|}{\vspace{-3.5ex}\wfig{4.7in}{circuits/dft-rb3}}
\framet{|fft @(RPow Pair N3)|}{\vspace{-1.5ex}\wfig{4.7in}{circuits/fft-rb3}}
\framet{|dft @(RPow Pair N4)|}{\vspace{-3.5ex}\wfig{4.7in}{circuits/dft-rb4}}
\framet{|fft @(RPow Pair N4)|}{\vspace{-3.0ex}\wfig{4.5in}{circuits/fft-rb4}}


\framet{Generic FFT}{

> class FFT f where
>   type FFO f :: * -> *
>   fft :: f C -> FFO f C

\pause\vspace{-7ex}

> SPACE SPC  default fft  ::  ( Generic1 f, Generic1 (FFO f), FFT (Rep1 f)
>                             , FFO (Rep1 f) ~ Rep1 (FFO f) )
>                         =>  f C -> FFO f C
>            fft xs = to1 . fft xs . from1

using \texttt{GHC.Generics}.

}

\framet{Concluding remarks}{

Type-driven, parallel-friendly algorithm:
\begin{itemize}\itemsep2ex
\item Factor types, not numbers.
\item Well-known algorithms as special cases (DIT \& DIF).
\item Works well with \texttt{GHC.Generics}.
\end{itemize}

\pause
\vspace{2ex}
In contrast to array algorithms:
\begin{itemize}\itemsep2ex
\item Elegantly compositional.
\item Free of index computations.
\item Safe from out-of-bounds errors.
\end{itemize}

}

\nc{\pcredit}[3]{\item \href{#1}{\wpicture{0.75in}{#3}}\ \  #2}

\framet{Picture credits}{

\begin{itemize}\itemsep3ex

%% \pcredit{https://en.wikipedia.org/wiki/Deferent_and_epicycle}{Giovanni Cassini, Roger Long, James Ferguson}{epicycles}

\pcredit{https://works.bepress.com/frank_farris/14/}{Frank A. Farris}{Farris/figs-1-2.pdf}
\pcredit{http://blog.ivank.net/fourier-transform-clarified.html}{Ivan Kuckir}{multi-circle}
\pcredit{https://en.wikipedia.org/wiki/Cooley–Tukey_FFT_algorithm}{Steven G. Johnson}{cooley-tukey-general}

\end{itemize}
}

\date{September 18, 2016}

\partframe{Extras}

\framet{Bushes}{

\ 

> type family Bush n where
>   Bush Z      = Pair
>   Bush (S n)  = Bush n :.: Bush n

\ 

Notes:
\begin{itemize}
\item
Composition-balanced counterpart to |LPow| and |RPow|.
\item
Variation of |Bush| type in \href{http://citeseerx.ist.psu.edu/viewdoc/summary?doi=10.1.1.184.8120}{\emph{Nested Datatypes}} by Bird \& Meertens.
\item
Size $2^{2^n}$, i.e., $2, 4, 16, 256, 65536, \ldots$.
\item
Easily generalizes beyond pairing and squaring.
\end{itemize}

}

\framet{|fft @(Bush N0)|}{\vspace{-6.0ex}\wfig{4.8in}{circuits/fft-bush0}}
\framet{|fft @(Bush N1)|}{\vspace{-7.0ex}\wfig{4.8in}{circuits/fft-bush1}}
\framet{|fft @(Bush N2)|}{\vspace{-7.5ex}\wfig{4.8in}{circuits/fft-bush2}}
\framet{|fft @(Bush N3)|}{\vspace{-8.0ex}\wfig{4.8in}{circuits/fft-bush3}}

\framet{Comparison}{

For 16 complex inputs and results:

\fftStats{
  \stat{|RPow Pair N4|}{74}{40}{74}{197}{8}
  \stat{|LPow Pair N4|}{74}{40}{74}{197}{8}
  \stat{|Bush      N2|}{72}{32}{72}{186}{6}
}

For 256 complex inputs and results:

\fftStats{
  \stat{|RPow Pair N8|}{2690}{2582}{2690}{8241}{20}
  \stat{|LPow Pair N8|}{2690}{2582}{2690}{8241}{20}
  \stat{|Bush      N3|}{2528}{1922}{2528}{7310}{14}
}

}

\end{document}

