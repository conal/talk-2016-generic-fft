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

\begin{document}

\frame{\titlepage}

%% \partframe{The story so far}

\framet{First slide}{
}

\end{document}
