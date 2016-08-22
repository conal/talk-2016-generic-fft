%% -*- latex -*-

% Presentation
%\documentclass[aspectratio=1610]{beamer} % Macbook Pro screen 16:10
\documentclass{beamer} % default aspect ratio 4:3
%\documentclass[handout]{beamer}

\usefonttheme{serif}

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

\begin{document}

%% \partframe{\href{https://www.youtube.com/watch?v=k8FXF1KjzY0&list=PL6c1MWlBF2oY2vSJcylt6QkO2Gxz7RjsL}{Prelude}}

\frame{\titlepage}

%% \partframe{\href{http://i.imgur.com/BuO2INb.gif}{Paths from circles}}

\framet{Paths from circular motion}{

\vspace{-1.8ex}
\wfig{3in}{Farris/figs-1-2}
\begin{center}
\vspace{-7ex}
\href{https://works.bepress.com/frank_farris/14/}{\tiny (source)}
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

% \mbox{\ \ (inverse Fourier transform)}

%% Discretize with $f_k = k$ and $t = n/N$, $0 \le k, n < N$: $$x_n = \sum_{0 \le k < N} X_k \, e ^ {i 2 \pi k n/N}$$

}

\framet{Questions}{

\vspace{-4ex}
\wfig{2in}{multi-circle}
\begin{center}
\vspace{-5ex}
\href{http://blog.ivank.net/fourier-transform-clarified.html}{\tiny (source)}
\end{center}

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

\vspace{-2ex}

$$X_k =  \sum_{0 \le n < N} x_n e^{-i2\pi kn/N} \qquad 0 \le k < N$$

% Direct implementation does $O(n^2)$ work.

\vspace{-2ex}
\pause
In Haskell:

> dft :: ... => f C -> f C
> dft xs = (<.> xs) <$> twiddles       -- dot product \& map

> twiddles :: ... => g (f C)
> twiddles = powers <$> powers (exp (- i * 2 * pi / size @(g :.: f)))

> powers :: ... => a -> f a
> powers = fst . lscanAla Product . pure

> (<.>) :: ... => f a -> f a -> a
> u <.> v = sum (liftA2 (*) u v)

%% No arrays!

}

%% {|(<.>) @ (RBin N2)|}

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
\begin{itemize}\itemsep3ex
\item DFT in $O(n \log n)$
\item Better numeric properties than naive DFT
\item Some FFT history:
  \begin{itemize}
  \item Gauss: 1805
  \item Danielson \& Lanczos: 1942
  \item Cooley \& Tukey: 1965
  \end{itemize}
\end{itemize}
}

\framet{How FFT works}{
\begin{itemize}
\item A summation trick (composite size)
\item Lift the formulation from \href{https://en.wikipedia.org/wiki/Cooley\%E2\%80\%93Tukey_FFT_algorithm\#General_factorizations}{General factorizations} on the Cooley-Tukey FFT Wikipedia page.
\item Picture from same source
\item Imagine how to implement in Haskell
\end{itemize}
}

\framet{Generic FFT in Haskell}{
\begin{itemize}
\item Follow the WP picture:
  \begin{itemize}
  \item Note reshaping (functor change)
  \item Direct translation to Haskell
  \end{itemize}
\item Optimize transpositions
\item Generic formulation: |Traversable|, functor composition.
\end{itemize}

}

\framet{Some type instances with figures}{
\begin{itemize}
\item Where to introduce functor exponentiation?
\item Top-down trees: binary \& other
\item Bottom-up trees: binary \& other
\item Vectors?
\item Other?
\end{itemize}
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

\framet{Shaped types}{

Perfect binary tree of depth $n$:

$$\overbrace{P \circ \cdots \circ P}^{n}$$

}

\nc{\pcredit}[3]{\item \href{#1}{\wpicture{0.75in}{#3}} #2}

\framet{Picture credits}{

\begin{itemize}\itemsep3ex

\pcredit{https://works.bepress.com/frank_farris/14/}{Frank A. Farris}{Farris/figs-1-2.pdf}
\pcredit{http://blog.ivank.net/fourier-transform-clarified.html}{Ivan Kuckir}{multi-circle}

\end{itemize}
}

\end{document}
