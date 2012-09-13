% !TEX root = main

% personal class for thesis preliminary notes [[2
%
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{mpg-preth}

% non-math [[1
% --------

% booleans for options, default values [[2
%
\newif\if@private       \@privatetrue
\newif\if@domark        \@domarktrue
\newif\if@cover         \@coverfalse
\setlength{\overfullrule}{5pt}

% option declarations [[2
%
\DeclareOption {full}   {\let\includeonly\@gobble}
\DeclareOption {pph}    {\@privatefalse}
\DeclareOption {nomark} {\@domarkfalse}
\DeclareOption {cover}  {\@covertrue}
\DeclareOption {final}  {
  \let\includeonly\@gobble \@privatefalse \@domarkfalse
  \setlength{\overfullrule}{0pt}
}
\ProcessOptions \relax

% use Koma with custom encoding and fonts and colors [[2
%
\if@cover
\PassOptionsToClass{oneside}{scrbook}
\else
\PassOptionsToClass{twoside, BCOR=1cm}{scrbook}
\fi
\LoadClass[a4paper, 11pt]{scrbook}
% add french to global options
\edef\@classoptionslist{\@classoptionslist,french}
\usepackage[utf8]{inputenc}
\usepackage[T1]{fontenc}
\usepackage[sc, osf]{mathpazo} \linespread{1.05}
\usepackage{amssymb}
\renewcommand\sfdefault{iwona}
\rmfamily
\DeclareFontShape{T1}{pplj}{bx}{sc}{<->ssub*pplj/bx/n}{}

\usepackage{xcolor}
\colorlet{mark}{black!50}
\colorlet{keys}{green}
\colorlet{todo}{red}
\colorlet{later}{blue}
\colorlet{out}{gray}

% load various useful packages [[2
%
\usepackage{scrpage2}
\usepackage{mathtools, amsthm}
\usepackage{mathstyle}
\catcode`\^12\catcode`\_12\relax % xy wants to see the real catcodes
\usepackage[all]{xy}
\catcode`\^7\catcode`\_8\relax % make other packages happy
\usepackage{ifmtarg, fixltx2e, mparhack, xargs, xspace, cmdstring, ted, trace}
\usepackage{siunitx, varioref, etex}
\usepackage{afterpage, pdflscape, tikz}
\usetikzlibrary{arrows,positioning,fit,decorations.pathmorphing,shapes.misc}
\usepackage{enumitem}
\usepackage{git-info, eso-pic}
\usepackage{csquotes}
\usepackage[
  bibencoding=ascii,
  style=alphabetic, sorting=nyt, sortcites=true, firstinits=true,
  doi=false, isbn=false, url=true,
  autopunct=true, babel=hyphen,
  hyperref=true, backref=false]{biblatex}
\usepackage[expansion=false, babel=true]{microtype}
% cannot use "french" here since it's already a global option (?!)
\usepackage[latin, british, francais]{babel}
\usepackage{nameref}  % must load nameref, varioref and hyperref in this order
\usepackage{varioref} % to get a working \vref
\usepackage[colorlinks=true, bookmarks=false]{hyperref}
\hypersetup{urlcolor=black, linkcolor=black, citecolor=black}
\newcommand\oref{\ref} % for explicite non-\vref

% equation number in headers [[2
%
\newmarks\eqmark

%% \pagestyle{scrheadings}
%% \rehead[]{eq deb : \firstmarks\eqmark}
%% \lohead[]{eq fin : \botmarks\eqmark}
%% 
%% \newtagform{am}[\ameq]{(}{)}
%% \newcommand*\ameq [1] {%
%%   \if@display
%%     \marks\eqmark{#1}%
%%   \fi
%%   #1%
%% }
%% \usetagform{am}

% showkeys [[2
%
\if@private
  \usepackage[notref, notcite, color]{showkeys}
  \colorlet{labelkey}{keys}
  \renewcommand\showkeyslabelformat [1] {%
    \normalfont\scriptsize\ttfamily #1%
  }
\fi

% use git information (implement 'nomark' option) [[2
%
\if@domark
  \AddToShipoutPicture{%
    \AtPageLowerLeft{%
      \parbox[b]{\paperwidth}{%
        \centering \itshape \color{mark}%
        \gitinfo{@head}{dt}%
        \par \kern2cm
      }%
    }%
  }
\fi

% inline include [[2
%
\newcommand \inlineinclude [2] {%
  % from latex.ltx's \@include
  \clearpage
  \if@filesw
    \immediate\write\@mainaux{\string\@input{#1.aux}}%
  \fi
  \@tempswatrue
  \if@partsw
    \@tempswafalse
    \edef\reserved@b{#1}%
    \@for\reserved@a:=\@partlist\do
      {\ifx\reserved@a\reserved@b\@tempswatrue\fi}%
  \fi
  \if@tempswa
    \let\@auxout\@partaux
    \if@filesw
      \immediate\openout\@partaux #1.aux
      \immediate\write\@partaux{\relax}%
    \fi
    #2% was: \@input@{#1.tex}%
    \clearpage
    \@writeckpt{#1}%
    \if@filesw
      \immediate\closeout\@partaux
    \fi
  \else
    \deadcycles\z@
    \@nameuse{cp@#1}%
  \fi
  \let\@auxout\@mainaux}

% generic title information [[2
%
\author{Manuel \bsc{Pégourié-Gonnard}}
\date{}
\hypersetup{pdfauthor={Manuel Pégourié-Gonnard}}

% bibliography settings [[2
%
\bibliography{these}
\defbibheading{bibempty}{}

% frenchb (+xspace) settings [[2
%
\frenchbsetup{og=«,fg=»,
  AutoSpacePunctuation=false,
  ThinColonSpace=true,
  SuppressWarning=true,
}

% nbsp treated as a normal space (to let frenchb do its job)
\DeclareUnicodeCharacter{00A0}{ }

% don't eat space before high punctuation
\xspaceremoveexception{:}
\xspaceremoveexception{;}
\xspaceremoveexception{?}
\xspaceremoveexception{!}

% marginal notes and todos [[2
%
\newcommand*\marginnote [1] {\marginpar[\raggedleft #1]{\raggedright #1}}
\newcommandx*\worknote  [3][1=todo, 3] {%
  \marginnote{\leavevmode\color{#1}\itshape #2}%
  \@ifnotmtarg{#3}{\textcolor{#1}{#3}}%
}
\newenvironment{parnote}{\quotation\color{later}}{\endquotation}

\newcommand*\todo [1][] {\worknote{\textsc{todo} #1}}
\newcommand \todom      {\tag*{\color{todo}\textsc{todo}}}
\newcommand \later      {\worknote[later]{(à détailler ultérieurement)}}
\newcommand \todots [1][] {{\color{todo}\cdots}} % #1 for use in the source

% temporary or outdated stuff [[2
%
\newcommand \startout [1][] {%
  \worknote[later]{(ne pas relire pour l'instant) #1}
  \let\normal@default@color\default@color
  \expandafter\let\expandafter\default@color\csname\string\color@out\endcsname
  \normalcolor}
\newcommand \stopout {%
  \let\default@color\normal@default@color
  \normalcolor}
\newcommand \stuffout [1] {%
  {\color{out}#1}}


% languages and special text items [[2
%
\newcommand*\lat [1] {\emph{#1}}
\newcommand*\eng [1] {\foreignlanguage{english}{\emph{#1}}}

% mathtools settings
%
\mathtoolsset{showonlyrefs,showmanualtags}

% lists [[2
%
\newenvironment{enumthm}
  {\begin{enumerate}[label=(\textit{\roman*})]}
  {\end{enumerate}}

\setlist[itemize]{nosep}

% theorem-like environments [[2
%
\newtheorem {thm}        {Théorème}
\newtheorem {prop} [thm] {Proposition}
\newtheorem {lem}  [thm] {Lemme}
\newtheorem {coro} [thm] {Corollaire}
\newtheorem {fact} [thm] {Fait}
\newtheorem {sco}  [thm] {Scolie}
\newtheorem {hypo} [thm] {Hypothèses}
\newtheorem {conj} [thm] {Conjecture}

\theoremstyle{definition}
\newtheorem {tdef} [thm] {Définition}
\newtheorem {nota} [thm] {Notations}
\newtheorem {rem}  [thm] {Remarque}

\newtheorem*{ide@s}      {Idées}
\newenvironment{ideas}{\ide@s\color{later}}{\endide@s}


% numbering [[2
%
\numberwithin{equation}{chapter}
\numberwithin{thm}{section}

% list of automatic constants [[2
%
\tocbasicautomode
\addtotoclist{loc}
\newcommand*\l@constant {\l@figure}

% input macros [[1
\input macros

% [[1
% vim: ft=tex fdm=marker fmr=[[,]] fdl=1 spell spelllang=fr,en
