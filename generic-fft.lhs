%% -*- latex -*-

%% %let atwork = True

% Presentation
\documentclass{beamer}
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

\framet{Paths from circles}{

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
  \item Radius
  \item Speed/frequency
  \item Starting angle
  \end{itemize}
\item Combine several motions: center of each follows path of previous.
\item Observe final motion.
\item \href{http://i.imgur.com/BuO2INb.gif}{Another example}
\end{itemize}

}

%% \framet{More motion}{\href{http://i.imgur.com/BuO2INb.gif}{Square wave}}

\framet{Questions}{

\begin{itemize}
\item Which motions can be generated in this way?
\item How to generate the circular components for a given motion?
\end{itemize}

}


\nc{\pcredit}[3]{\item \href{#1}{\wpicture{0.75in}{#3}} #2}

\framet{Picture credits}{

\begin{itemize}

\pcredit{https://works.bepress.com/frank_farris/14/}{Frank A. Farris}{Farris/figs-1-2.pdf}

\end{itemize}
}

\end{document}
