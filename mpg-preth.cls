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
\newif\if@showbad       \@showbadtrue
\newif\if@domark        \@domarktrue

% option declarations [[2
%
\DeclareOption {full}   {\let\includeonly\@gobble}
\DeclareOption {pph}    {\@privatefalse}
\DeclareOption {nomark} {\@domarkfalse}
\ProcessOptions \relax

% use Koma with custom encoding and fonts [[2
%
\RequirePackage{pdf14} % be maximally portable
\LoadClass[a4paper, twoside, BCOR=1cm, 11pt, titlepage=false]{scrbook}
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

% load various useful packages [[2
%
\usepackage{mathtools, amsthm}
\usepackage{mathstyle}
\catcode`\^12\catcode`\_12\relax % xy wants to see the real catcodes
\usepackage[all]{xy}
\catcode`\^7\catcode`\_8\relax % make other packages happy
\usepackage{ifmtarg, fixltx2e, mparhack, xargs, xspace, cmdstring, ted, trace}
\usepackage{enumitem, comment}
\usepackage{git-info, eso-pic}
\usepackage[noprefix, nocfg, refpage, french]{nomencl}
\usepackage{csquotes}
\usepackage[style=alphabetic, sorting=nyt, sortcites=true,
  autopunct=true, babel=hyphen,
  hyperref=true, backref=false]{biblatex}
\usepackage[expansion=false, babel=true]{microtype}
\usepackage[british, frenchb]{babel}
\usepackage[colorlinks=true, bookmarks=false]{hyperref}
\hypersetup{urlcolor=black, linkcolor=black, citecolor=black}

% showkeys [[2
%
\if@private
  \usepackage[notref, notcite, color]{showkeys}
  \colorlet{labelkey}{keys}
  \renewcommand\showkeyslabelformat [1] {%
    \normalfont\scriptsize\ttfamily #1%
  }
\fi

% overfullrule (implement 'nobad' option) [[2
%
\setlength{\overfullrule}{\if@showbad 5\else 0\fi pt}

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
\subtitle{Notes de travail}
\date{}
\hypersetup{pdfauthor={Manuel Pégourié-Gonnard}}

% bibliography settings [[2
%
\bibliography{these}
\defbibheading{bibempty}{}

% nomenclature [[2
%
\makenomenclature

% placeholders for descriptions
\newcommand*\nom@ph [2] {%
  \newcommand#1{\ensuremath{\text{$#2$}}\xspace}}
\nom@ph \PH   \star
\nom@ph \PHi  \bullet

% print a macro and its result with placeholders substitution
\newcommand*\printmacro [2] {%
  \if@private
    \ted@toks{\relax#2\@nil}%
    \Substitute*{\the\ted@toks} {}                     {\string}%
    \Substitute*{\the\ted@toks} {\string\@nil\string}  {}%
    \Substitute*{\the\ted@toks} {\string\PH}           {\PH{}}%
    \Substitute*{\the\ted@toks} {\string\PHi}          {\PHi{}}%
    \makebox[0pt][r]{%
      \color{keys}\ttfamily\footnotesize \the\ted@toks \space}%
  \fi
  $#1#2$%
}

% for notations without macro & internal use:
%
% \nomdirect{<group code>}{<sort string>}{<displayed>}[<scope>]{<description>}
\newcommandx*\nomdirect [5][4] {%
  \@bsphack
  \@ifmtarg{#4}{%
    \nom@direct{#1}{#2}{#3}{#5}%
  }{%
    \begingroup \edef\next{\endgroup
      \unexpanded{\nom@direct{#1}{#2}{#3}}{\nom@local{#4}\unexpanded{#5}}%
    }\next
  }%
}
\newcommand*\nom@direct [4] {%
  \begingroup \edef\next{\endgroup
    \noexpand\nomenclature[\@nameuse{nom@groupsort@@#1}-\unexpanded{#2}]%
    {\noexpand\printmacro{\nom@color}\unexpanded{{#3}}}%
    {\nom@color\unexpanded{#4}}%
  }\next
  \nom@color@reset
  \@esphack
}

% scopes
%
% \nom@newscope{<id>}{<code>}
\newcommand \nom@newscope [2] {%
  \@namedef{nom@scope@@#1}{#2}%
}
% using a declared scope
\newcommand \nom@local [1] {%
  \@nameuse{nom@scope@@#1} : \noexpand\MakeLowercase
}
% scopes used
\nom@newscope {chap} {Chapitre \thechapter}
\nom@newscope {sec}  {Section \thesection}
\nom@newscope {sub}  {Sous-section \thesubsection}

% groups
%
% \nom@newgroup{<id>}{<sort key>}{<name>}
\newcommand*\nom@newgroup [3] {%
  \@namedef{nom@groupsort@@#1}{#2}%
  \@namedef{nom@groupname@@#2}{#3}%
}
% typesetting group name in the actual nomenclature (#1 = sort key)
\renewcommand*\nomgroup [1] {%
  \item[\sffamily\bfseries \@nameuse{nom@groupname@@#1}]
}
% group list
\nom@newgroup s A {Symboles}
\nom@newgroup n B {Signes numériques}
\nom@newgroup g C {Lettres grecques}
\nom@newgroup a D {Lettres latines}
\nom@newgroup c E {Constantes automatiques}

% normal usage is indirect (as opposed to \nomdirect}):
% preamble: \nomdef<csname>{<group id>}{<sort string>}
% document: \nomuse[<csname>]{<code>}{<desc>}
% the first token of <code> will be used as <csname> by default
\newcommand*\nomdef [3] {%
  \@namedef{nom@csname@@\cmdstring#1}{{#2}{#3}}%
  % \nomuse{#1\PH\PHi}{test} % debugging only
}
\newcommand*\nomuse [2][] {%
  \@ifmtarg{#1}{%
    \expandafter\nom@use\@car#2\@nil{#2}%
  }{%
    \nom@use{#1}{#2}%
  }%
}
\newcommand \nom@use [2] {%
  \ifcsname nom@csname@@\cmdstring#1\endcsname \else
    \errmessage{\string\nomuse\space without matching \string\nomdef!}%
  \fi
  \begingroup \edef\next{\endgroup
    \noexpand\nomdirect\@nameuse{nom@csname@@\cmdstring#1}%
  }\next{#2}%
}

% possibly disable next nomenclature command, usage:
% \nomprv\nomdirect...
\newcommand \nomprv {}
\newcommand \nom@color {}
\newcommand \nom@color@reset {}
\if@private
  \let \nom@color@normal \nom@color
  \renewcommand \nomprv {%
    \let \nom@color \nom@color@prv
  }
  \newcommand \nom@color@prv {%
    \noexpand\color{keys}%
  }
  \renewcommand \nom@color@reset {%
    \let \nom@color \nom@color@normal
  }
\else
  \let \nom@direct@real \nom@direct
  \renewcommand \nomprv {%
    \let \nom@direct \nom@direct@skip
  }
  \newcommand \nom@direct@skip [4] {%
    \let \nom@direct \nom@direct@real
  }
\fi

% remove \chapter and \preamble from original definition
\renewenvironment{thenomenclature}{%
  \list{}{%
    \labelwidth\nom@tempdim
    \leftmargin\labelwidth
    \advance\leftmargin\labelsep
    \itemsep\nomitemsep
    \let\makelabel\nomlabel}%
  }{%
  \endlist
  \nompostamble}

% use the same style as table of stuff for page numbers
\renewcommand\pagedeclaration[1]{%
  \begingroup \def\vskip##1\p@{}%
  \@dottedtocline{-1}{0pt}{0pt}{}{#1}%
  \endgroup}

% frenchb settings [[2
%
\frenchbsetup{og=«,fg=»,
  AutoSpacePunctuation=false,
  ThinColonSpace=true,
  SuppressWarning=true,
  }

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
\colorlet{out}{gray}
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

% lists for theorems [[2
%
\newenvironment{enumthm}
  {\begin{enumerate}[label=(\textit{\roman*})]}
  {\end{enumerate}}

% theorem-like environments [[2
%
\newtheorem {thm}        {Théorème}
\newtheorem {prop} [thm] {Proposition}
\newtheorem {lem}  [thm] {Lemme}
\newtheorem {coro} [thm] {Corollaire}
\newtheorem {fact} [thm] {Fait}
\newtheorem {scho} [thm] {Scolie}

\theoremstyle{definition}
\newtheorem {tdef} [thm] {Définition}
\newtheorem {rem}  [thm] {Remarque}

\newtheorem*{ide@s}      {Idées}
\newenvironment{ideas}{\ide@s\color{later}}{\endide@s}


% numbering [[2
%
\numberwithin{equation}{chapter}
\numberwithin{thm}{section}

% shortcut macros [[2
%
\newcommand \NT  {\bsc{Néron}-\bsc{Tate}\xspace}
\newcommand \MoW {\bsc{Mordell}-\bsc{Weil}\xspace}
\newcommand \TS  {\bsc{Thue}-\bsc{Siegel}\xspace}

% helpers for math macros [[1
% -----------------------

% special optional arguments for indices [[2
%

% One special optional argument [[3
% - by default, empty
% - normal []-notation available
% - *-form yields a default non-empty value
%
% \newcs@start@default <name> [arg. nb.] [opt. arg. spec (using xargs]
%                             <2nd default> <3rd one> <repl. text>
\newcommand*\star@default@parser[3]{%
  \@ifstar{\@ifstar{#1[#3]}{#1[#2]}}{#1}}

% special argument first
\newcommand*\newc@star@default[1]{%
  \expandafter\newc@star@default@ \csname\cmdstring#1 \endcsname#1}
\newcommandx*\newc@star@default@[7][3=1,4]{%
  \newcommandx*#1[#3][1,#4]{#7}%
  \newcommand*#2{\star@default@parser{#1}{#5}{#6}}}

% one mandatory argument first
\newcommand*\newc@star@default@i[1]{%
  \expandafter\newc@star@default@i@ \csname\cmdstring#1 \endcsname#1}
\newcommandx*\newc@star@default@i@[7][3=2,4]{%
  \newcommandx*#1[#3][2,#4]{#7}%
  \newcommand*#2[1]{\star@default@parser{#1{##1}}{#5}{#6}}}

% Two special optional arguments
% - by default, both empty
% - normal []-notation available
% - *-form yields a default non-empty value,
%   for each arg if there is two stars
%
% \newcs@start@deftwo <name> [arg. nb.] [opt. arg. spec (using xargs]
%                             <default #1> <default #2> <repl. text>
\newcommand\star@deftwo@parser[3]{%
  \@ifstar{\@ifstar{#1[#2][#3]}{#1[#2]}}{#1}}

% optional arguments first
\newcommand*\newc@star@deftwo[1]{%
  \expandafter\newc@star@deftwo@ \csname\cmdstring#1 \endcsname#1}
\newcommandx*\newc@star@deftwo@[7][3=2,4]{%
  \newcommandx*#1[#3][1,2,#4]{#7}%
  \newcommand*#2{\star@deftwo@parser{#1}{#5}{#6}}}

% one mandatory argument first
\newcommand*\newc@star@deftwo@i[1]{%
  \expandafter\newc@star@deftwo@i@ \csname\cmdstring#1 \endcsname#1}
\newcommandx*\newc@star@deftwo@i@[7][3=3,4]{%
  \newcommandx*#1[#3][2,3,#4]{#7}%
  \newcommand*#2[1]{\star@deftwo@parser{#1{##1}}{#5}{#6}}}

% auxiliary macros for \DeclarePairedDelimiters [[2
%
% the parser
\newcommand*\parse@delim [1] {%
  \@ifstar {#1{*}} {\parse@delim@#1}%
}
\newcommandx*\parse@delim@ [2][2] {%
  \@ifmtarg{#2} {#1{}} {#1{[#2]}}%
}
% define commands using this parser to get their first magical argument
% to be used with a macro defined by \DeclarePairedDelimiter
% additional arguments may be defined using xargs syntax
\newcommand \newdelimcommandx {%
  \@ifstar{\new@delim@commandx}{\new@delim@commandx}%
}
\newcommand*\new@delim@commandx [1] {%
  \expandafter\new@delim@commandx@\csname\string#1\endcsname#1%
}
\newcommand*\new@delim@commandx@ [2] {%
  \newcommand #2{\parse@delim#1}%
  \newcommandx*#1%
}

% (multi-)starred macros [[2
%
\newcommand*\newc@ifstar [3] {%
  \newcommand#1{\@ifstar{#3} {#2}}}
\newcommand*\newc@ifstar@two [4] {%
  \newcommand#1{\@ifstar{\@ifstar{#4}{#3}} {#2}}}

% coma-separated list with possibly empty elements [[2
%
\newcommand*\sfirst [1] {\@ifnotmtarg{#1}{#1,}}
\newcommand*\slast  [1] {\@ifnotmtarg{#1}{,#1}}

% non thesis-specific math [[1
% ------------------------

% misc symbols and shortcuts [[2
%
\newcommand*\pmm [1] {\text{ #1}} % ponctuation in math mode
\newcommand \suchthat {\ \middle\vert\ }
\newcommand \truc {{\,\cdot\,}}

\newcommand \longto  {\longrightarrow}
\newcommand \embedin {\hookrightarrow}

\newcommand \eps {\varepsilon}
\renewcommand \ge {\geqslant}
\renewcommand \le {\leqslant}

% supscripts and subscripts [[2
%
\newcommand* \ssub [1] {\@ifnotmtarg{#1}{\sb{#1}}}
\newcommand* \ssup [1] {\@ifnotmtarg{#1}{\sp{#1}}}

% parenthesized superscript with optional subscript
\newcommandx*\pexp [2][2] {%
  \@ifmtarg{#2}{%
    \@ifnotmtarg{#1}{\cramped{\sp{(#1)}}}%
    }{%
    \@ifnotmtarg{#1}{\sp{(#1)}}\sb{#2}}}

% standard sets [[2
%
\newcommand*\std [1] {{\mathbf{#1}}}

\newcommand     \N      {\std N}
\newcommand     \Z      {\std Z}
\newcommand     \Q      {\std Q}
\newcommand     \R      {\std R}
\newcommand     \C      {\std C}
\newcommand     \Proj   {\std P}
\newcommand     \Aff    {\std A}
\newcommand     \GL     {\std{GL}}
\newcommand     \M      {\std{M}}

\newcommand* \proj [2][] {\Proj \ssup{#2}                 \ssub{#1}}
\newcommand* \aff  [2][] {\Aff  \@ifnotmtarg{#2}{\sp{\!#2}} \ssub{#1}}

\nomdef \proj a {P} \@gobbletwo{\proj\PH}{L'espace projectif standard de
  dimension \PH}
\nomdef \aff  a {A} \@gobbletwo{\aff \PH}{L'espace affine standard de
  dimension \PH}

% standard functions [[2
%
\newcommand*\I     [1][] {\std{Id}\ssub{#1}}
\newcommand*\indic [1]   {\std{1}\ssub{#1}}

\nomdef \I     a {Id} \@gobbletwo{\I\PH}{Fonction identité sur l'ensemble \PH}
\nomdef \indic n {1} \@gobbletwo{\indic\PH}{Fonction indicatrice de l'ensemble
  \PH}

% less standard but still usefull sets [[2
%
\newcommand \Qbar {\overline\Q}
\newcommand \cdn {{\boldsymbol k}}
\newcommand \Cdn {{\boldsymbol K}}

\nomdef \Qbar a {Q} \@gobbletwo{\Qbar}{Une clôture algébrique fixée de $\Q$}
\nomdef \cdn a {k} \@gobbletwo{\cdn}{Un corps de nombres}
\nomdef \Cdn a {K} \@gobbletwo{\Cdn}{Une extension finie de $\cdn$}

% delimiters [[2
%
% absolute value & norms [[3
\DeclarePairedDelimiter \abs  {\lvert} {\rvert}
\DeclarePairedDelimiter \norm {\lVert} {\rVert}

% no good delimiter for triple norm, booh
\newcommand \nnorm      {\@ifstar {\nnorm@@@{\left}{\right}} {\nnorm@}}
\newcommand \nnorm@     {\@testopt\nnorm@@{}}
\def        \nnorm@@[#1]{\nnorm@@@{#1}{#1}}
\newcommand \nnorm@@@ [3] {%
  #1\lvert\hspace{-1pt}#1\lvert\hspace{-1pt}#1\lvert
  #3
  #2\rvert\hspace{-1pt}#2\rvert\hspace{-1pt}#2\rvert}

% brackets [[3
\newcommand \orbrack {\mathopen \rbrack}
\newcommand \clbrack {\mathclose\lbrack}

% I know these symbols are in stmaryrd, but it screws up most of my math
% fonts, so let's fake them the good old way
\newcommand \llbrack {\mathopen { \lbrack\mspace{-3.3mu}\lbrack }}
\newcommand \rrbrack {\mathclose{ \rbrack\mspace{-3.3mu}\rbrack }}
\newcommand*\series [1] {\llbrack #1 \rrbrack}

% sets (braces) [[3
\DeclarePairedDelimiter \set {\lbrace} {\rbrace}
\newcommand \minusset {\setminus \set}

% general algebraic geometry [[2
%
\newcommand \Ideal {\mathcal I}
\newcommand*\ideal [1] {\Ideal\sb{#1}}
\nomdef \ideal a {I} \@gobbletwo{\ideal\PH}{Idéal (multi)homogène saturé de la
  variété plongée \PH}

\newcommand \Ring {\mathcal R}
\newcommand*\ring [1] {\Ring\sb{#1}}
\nomdef \ring a {R} \@gobbletwo{\ring\PH}{Anneau des coordonnées
  (multi)homogènes de la variété plongée \PH}

\newcommand \Korper {\mathcal K}
\newcommand*\korper [1] {\Korper(#1)}
\nomdef \korper a {K} \@gobbletwo{\korper\PH}{Corps des fonctions rationnelles
  de la variété \PH}

\newcommand \Zeros {\mathcal Z}
\newcommand*\zeros [1] {\Zeros(#1)}
\nomdef \zeros a {Z} \@gobbletwo{\zeros\PH}{Lieu des zéros de la (famille de)
  forme(s) \PH}

\newcommand \Chow {f}
\newcommand*\chow [1] {\Chow\sb{#1}}
\nomdef \chow a {f} \@gobbletwo{\chow\PH}{Forme de \bsc{Chow} de la variété
  plongée \PH}

\newcommand \md {\mathfrak{d}}
\nomdef \md a {d} \@gobbletwo{\md}{Le morphisme symétrisant utilisé dans la
  définition des distances projectives}

% missing operators & general symbols [[2
%
\DeclareMathOperator \Diff {d}
\newcommand*\diff[1][] {\Diff\ssup{#1}}

\newcommand*\der [1][] {\partial\ssup{#1}}
\nomdef \der a {d} \@gobbletwo{\der\PH}{Dérivée divisée d'ordre \PH}

\DeclareMathOperator \card {Card}

\newcommand*\expb {\mathrm e}

\nomdef \expb a {e} \@gobbletwo{\expb}{Base des logarithmes népériens}

\DeclareMathOperator \Aind {Ind}
\DeclareMathOperator \ord  {Ord}

% automatic constants [[2
%
\AtBeginDocument{\let\mpg@label\label}

% print an automatic constant
\newcounter{cst}
\newcommand*\cst [1] {%
  \ensuremath{ c\sb{ \ref{cst@#1} \@nameuse{cst@@#1} } }}

% define an automatic constant
% Warning: puts a label e:cst-<name>, no other label allowed for this equation
\newcommand*\newcst [2][\place] {%
  \begingroup
  \let\showkeyslabelformat\@gobble
  \refstepcounter{cst}%
  \mpg@label{cst@#2}%
  \endgroup
  \@ifnotmtarg{#1}{%
    \protected@write\@auxout{}{\global\string\@namedef{cst@@#2}{, #1}}%
  }%
  \if@display \label{e:cst-#2}\noeqref{e:cst-#2}\fi
  \begingroup \edef\x{\endgroup
    \noexpand\nomdirect{c}{\alph{cst}}{\unexpanded{\cst{#2}}}{%
      \if@display \unexpanded{définie par~\protect\refeq{e:cst-#2}}\fi}%
  }\x
  \cst{#2}}

\tocbasicautomode
\addtotoclist{loc}
\newcommand*\l@constant {\l@figure}


% thesis-specific math [[1
% --------------------

% general situation (abelian variety, etc) [[2
%
\newcommand \va    {\mathcal A}
\newcommand \vai   {\mathcal B}
\newcommand \oa    {\p{0}}
\newcommand \genre {g}

\nomdef \va a {A} \@gobbletwo{\va}{La variété abélienne ambiante}
\nomdef \vai a {B} \@gobbletwo{\vai}{Une sous-variété abélienne fixée de
  $\va$}
\nomdef \oa n {0} \@gobbletwo{\oa}{L'origine de $\va$}
\nomdef \genre a {g} \@gobbletwo{\genre}{La dimension de $\va$}

\newcommand*\MW[2][\va]{MW\sb{\!#1}(#2)}
\nomdef \MW a {MW} \@gobbletwo{\MW[\PHi]\PH}{Espace de \MoW de la variété
  abélienne \PHi sur le corps \PH}

\newcommand \mmemb { \Theta }
\nomdef \mmemb g {E3} \@gobbletwo{\mmemb}{Plongement de \bsc{Mumford
    modifié}}

\newcommand \placesapx  { \mathcal S }
\newcommand \placerange { \sb{\place \in \placesapx} }

\newcommand*\wtapx [1][\place] { \lambda\ssub{#1} }
\newcommand*\degv  [1][\place] { \Delta \ssub{#1} }

\nomdef \placesapx a {S} \@gobbletwo{\placesapx}{Ensemble fini de places de \(
    \cdn \) auxquelles on impose une condition d'approximation}
\nomdef \wtapx g {l} \@gobbletwo{\wtapx}{Poids de la place \( \place \)
  dans la condition d'approximation}
\nomdef \degv g {D} \@gobbletwo{\degv}{Degré local de \( \cdn \) en \(
    \place \)}

\newcommand \varapx { E }
\nomdef \varapx a {E} \@gobbletwo{\varapx}{Variété dont on étudie les
  approximations}

\newcommand \expapx { \eps }
\nomdef \expapx g {e0} \@gobbletwo{\expapx}{L'exposant d'approximation}

\nomdef \alpha g {a} \@gobbletwo{\alpha}{Un des paramètres de l'énoncé de
  Vojta et Mumford}
\nomdef \beta g {b} \@gobbletwo{\beta}{Un des
  paramètres de l'énoncé de Vojta et Mumford}
\nomdef \gamma g {c} \@gobbletwo{\gamma}{Un des paramètres de l'énoncé de
  Vojta et Mumford}
\nomdef \delta g {d} \@gobbletwo{\delta}{Un des paramètres de l'énoncé de
  Vojta et Mumford}

% archimedian norms and measures [[2
%
\newcommand*\normsup [1]   {\norm{#1}\sb\infty}
\newcommand*\normlun [1]   {\norm{#1}\sb1}
\newcommand*\normeuc [1]   {\norm{#1}\sb2}
\newcommand*\normhom [1]   {\norm{#1}\sb{\mathrm h}}
\newcommand*\mespph  [2][] {\mathrm  M\ssub{#1}\@ifnotmtarg{#2}{(#2)}}
\newcommand*\mahler  [2][] {\mathcal M\ssub{#1}\@ifnotmtarg{#2}{(#2)}}

\nomdef \mespph a {M} \@gobbletwo{\mespph\PH}{Mesure à la \bsc{Philippon} de
  la forme \PH}
\nomdef \mahler a {M} \@gobbletwo{\mahler\PH}{Mesure de \bsc{Mahler} de la
  forme \PH}

% local absolute values, norms, distances, ... [[2
%
\newcommand \place {v}
\nomdef \place a {v} \@gobbletwo{\place}{Une place, en général non fixée, de
  $\cdn$}

\newdelimcommandx \av  [3][3=\place] {\abs#1   {#2}\ssub{#3}}
\newdelimcommandx \nv  [4][4=\place] {\norm#1  {#3}\sb{#2, #4}}
\newdelimcommandx \nnv [4][4=\place] {\nnorm#1 {#3}\sb{#2, #4}}

\nomdef \av  s {n1} \@gobbletwo{\av\PH }{Valeur absolue $\place$-adique d'un
  nombre}
\nomdef \nv  s {n2} \@gobbletwo{\nv\PHi\PH }{Norme $\place$-adique d'un
  vecteur ou d'une forme, en utilisant norme ou mesure \PHi si $\place$ est
  archimédienne}
\nomdef \nnv s {n3} \@gobbletwo{\nnv\PHi\PH}{Norme $\place$-adique d'un
  multivecteur ou d'une forme multihomogène, en utilisant norme ou mesure \PHi
  si $\place$ est archimédienne}

\newcommand* \Onv [2][\place] {\norm  {#2}\ssub{#1}} % XXX needs checking
\newcommand* \Onnv[2][\place] {\nnorm {#2}\ssub{#1}} % XXX needs checking

\newcommand* \mvp [2][\place] {\mespph[#1]{#2}}
\newcommand* \mvm [2][\place] {\mahler[#1]{#2}}

\nomdef \mvm a {Mv} \@gobbletwo{\mvm\PH}{Mesure de \bsc{Mahler} de la forme
  \PH si $\place$ est archimédienne, norme du $\sup$ sinon}
\nomdef \mvp a {Mv} \@gobbletwo{\mvp\PH}{Mesure de \bsc{Philippon} de la forme
  \PH si $\place$ est archimédienne, norme du $\sup$ sinon}

\newcommand \dv  {{\delta\smash{\sb\place}}}
\newcommand \dpv {{\delta'\sb\place}}

\nomdef \dv  a {dv1} \@gobbletwo{\dv }{Vaut $1$ si $\place$ est archimédienne,
  est nul sinon}
\nomdef \dpv a {dv2} \@gobbletwo{\dpv}{Vaut $1$ si $\place$ est archimédienne
  ou divise $2$, est nul sinon}

\DeclareMathOperator \Dist {dist}
\newcommand*\Distv [1][\place] {\Dist\ssub{\place}}
\newcommand*\distv [3][\place] {\Distv[#1](#2,#3)}

\nomdef \distv a {dist} \@gobbletwo{\distv\PH\PHi}{Distance $\place$-adique
  projective entre \PH et \PHi}

\newcommand*\mv [2][\place] {M\sb{#1}(#2)} % XXX duplicates \mvp?
\nomdef \mv a {M} \@gobbletwo{\mv\PH}{Mesure homogène locale en $\place$ de la
  forme \PH : c'est la norme du $\sup$ aux places finies et la mesure de
  \bsc{Philippon} aux places infinies}

% embeding-dependant values [[2
%
\newcommand \dimp {n}
\newcommand*\projd [1][] {\proj[#1]\dimp}
\newcommand \fibre {\mathcal L}

\nomdef \dimp a {n} \@gobbletwo{\dimp}{Dimension de l'espace projectif
  ambiant}
\nomdef \fibre a {L} \@gobbletwo{\fibre}{Le fibré donnant « le » plongement
  projectif}

\newcommand \coa  {\theta}
\newcommand \coi  {{\mathfrak b}}
\newcommand \vaht {\Hautl_\va}
\newcommand \htcmp{\hat{c}_\Theta}

\nomdef \coa g {e3}
\nomdef \coi a {b} \@gobbletwo{\coi}{Vecteur dont les composantes sont les
  inverses de composantes de $\coa$ bien choisies}
\nomdef \vaht a {h}

% projective indices and coordinates [[2
%
% helper macros [[
\newc@star@default@i \gp {\ind}{\dimp} {\gp@{#1}{#2}}
\newcommand*\gp@ [2] {%
  #1\ssub{#2}}
% ]]

\newcommand \ind      {k}
\newcommand \indi     {l}
\newcommand \indrange  {\sb{\ind =0}\sp\dimp}
\newcommand \indirange {\sb{\indi=0}\sp\dimp}
\nomdef \ind a {k} \@gobbletwo{\ind}{Un indice entier, variant en général
  entre $0$ et $\dimp$}
\nomdef \indi a {l} \@gobbletwo{\indi}{Un indice entier, variant en général
  entre $0$ et $\dimp$}

\newcommand*\ch   [1] {\vp[#1]}

\newcommand \pp {x}
\newcommand \ppi{y}
\newcommand \cp {\gp x}
\newcommand \cpi{\gp y}
\newcommand \vp {\gp X}
\newcommand \vpi{\gp Y}
\newcommand \ip {\gp \lambda}

\newcommand \anyvar {V}
\newcommand \anyvp  {\gp W}
\newcommand \anydim {s}
\newcommand \anydeg {\Delta}

\newcommand*\lgr [1] {\abs{#1}}
\nomdef \lgr s {n1} \@gobbletwo{\lgr\PH}{Longueur du multiindice \PH}

\newcommand*\ncoef  [1] {\mathcal N(#1)}
\newcommand*\maxbin [1] {m(#1)}
\nomdef \ncoef a {N} \@gobbletwo{\ncoef\PH}{Nombre de coefficients du polynôme
  \PH}
\nomdef \maxbin a {m} \@gobbletwo{\maxbin\PH}{Maximum des coefficients
  binomiaux $\binom\PH{i}$}

% multiprojective indices and coordinates [[2
%
% helper macros [[
\newc@star@deftwo@i \gmp  {\fct }{\ind} {\gmp@{#1}{#2}{#3}}
\newc@star@deftwo@i \gmpi {\fcti}{\ind} {\gmp@{#1}{#2}{#3}}
\newc@star@deftwo@i \gmpiv{\fcti}{\indiv*}{\gmp@{#1}[\place]{#2}{#3}}
% generic multiprojective symbol:
% #1 = factor number, #2 = optional prefix for this, see \gmpiv for \wembclv
% #3 = coordinate in this factor,
% #4 = symbol
\newcommandx*\gmp@ [4][2] {%
  \@ifnotmtarg{#1}{%
    \@ifmtarg{#3}{\boldsymbol}{}{%
      #1}}%
  % cannot say \pexp{\sfirst{#2}#3}[{#4}] cause it checks if #1 is empty
  \@ifmtarg{#2}{\pexp{#3}[{#4}]}{\pexp{#2\slast{#3}}[{#4}]}
}
\newcommand \mexp {\gmp{}} % FIXME: p\mexp usage is stupid, use \gmp p
% ]]

\newcommand \puiss {m}
\nomdef \puiss a {m}

\newcommand \fct      {i}
\newcommand \fctrange  {\sb{\fct =1}\sp\puiss}
\nomdef \fct a {i} \@gobbletwo{\fct}{Un indice entier, variant en général
  entre $1$ et $\puiss$}

\newcommand \pmp {x}
\newcommand \cmp {\gmp x}
\newcommand \vmp {\gmp X}

\newcommand \imp {\gmp \lambda}
\nomdef \lambda g {l} \@gobbletwo{\lambda}{Un indice multiprojectif, dans
  \( \bigl( \N\sp{\dimp + 1} \bigr)\sp\puiss \)}
\newcommand \im   {\lambda} % indice sur les facteurs
\newcommand \imi  {\mu} % indice sur les facteurs
\newcommand \imii {\nu} % indice sur les facteurs
\newcommand \imin {\mathrm{m}} % pour désigner l'indice minimal

\newcommand*\vlg [1] {\abs{#1}}
\newcommand*\lgt [1] {\lVert#1\rVert}

\nomdef \vlg s {n1} \@gobbletwo{\vlg\PH}{Vecteur des longueurs du
  multimultiindice \PH}
\nomdef \lgt s {n2} \@gobbletwo{\lgt\PH}{Longueur totale du multimultiindice
  \PH}

% points and coordinates [[2
%
% XXX: used inconsistently
\newcommand*\p [1] {{\boldsymbol{#1}}}

% XXX use \pp, \cp; \pmp, \cmp instead
% replacement: check each case for 'p' vs 'mp'
\newcommand \point   {x}
\newcommand \pointi  {y}
\newcommand \pointii {z}
\newcommand \coord   {{\mathbf x}}
\newcommand \coordi  {{\mathbf y}}

\nomdef \point   a {x} \@gobbletwo{\point  }{Un point non fixé de $\va$}
\nomdef \pointi  a {y} \@gobbletwo{\pointi }{Un autre point non fixé de $\va$}
\nomdef \pointii a {z} \@gobbletwo{\pointii}{Encore un autre point non fixé de
  $\va$}

% height functions [[2
%
\newcommand*\Hautm [1][] {H \ssub{#1}}
\newcommand*\Hautl [1][] {h \ssub{#1}}
\newcommand \Hautn       {\hat\Hautl}

\newcommand*\hautm [2][?] {\Hautm[#1](#2)}
\newcommand*\hautl [2][?] {\Hautl[#1](#2)}
\newcommand*\hautn [1]    {\Hautn    (#1)}
\newcommand*\normn        {\abs}

\nomdef \hautm a {h} \@gobbletwo{\hautm[\PHi]{\PH}}{Hauteur projective
  multiplicative de \PH en utilisant la norme \PHi aux places archimédiennes}
\nomdef \hautl a {h} \@gobbletwo{\hautl[\PHi]{\PH}}{Hauteur projective
  logarithmique de \PH en utilisant la norme \PHi aux places archimédiennes}
\nomdef \hautn a {h} \@gobbletwo{\hautn      {\PH}}{Hauteur de \NT de \PH}
\nomdef \normn s {n1} \@gobbletwo{\normn\PH}{Norme de \NT de \PH}

\newcommand* \scalarn [2] {\langle#1,#2\rangle}

\nomdef \scalarn s {angle} \@gobbletwo{\scalarn\PH\PHi}{Produit scalaire,
  relativement à la forme quadratique de \NT, des points \PH et \PHi de $\va$
  ou de son espace de \MoW}

% abelian formulas [[2
%


% Vojta-specific math [[1
% -------------------

% constants in the theorem itself [[2
%
\newcommand \Vbig { \alpha \sb{\mathrm{V}} }
\newcommand \Vfar { \beta  \sb{\mathrm{V}} }
\newcommand \Vcos { \gamma \sb{\mathrm{V}} }
\nomdef \Vbig g {a}
\nomdef \Vfar g {b}
\nomdef \Vcos g {c}

% general situation [[2
%
\newcommand \divi {E}
\nomdef \divi a {E} \@gobbletwo{\divi}{Le diviseur dont on étudie les
  approximations exceptionnelles}

\newcommand \Excep { e }
\newcommand \cex   { \gmp\Excep }
\newcommand \cexi  { \gmpi{\Excep'}} % no space here!
\newcommand \cexa  { \gmp{\tilde\Excep}} % no space here!

\newc@star@default \ex      {\fct }{\puiss  } {\Excep\ssub{#1}}
\newc@star@default \exi     {\fcti}{\puiss-1} {\Excep'\ssub{#1}}

\newc@star@default \wt      {\fct }{\puiss  } {a\ssub{#1}}
\newc@star@default \wts     {\fct }{\puiss  } {a\ssub{#1}\sp2}
\newc@star@default \wti     {\fcti}{\puiss-1} {a\ssub{#1}}
\newc@star@default \wtis    {\fcti}{\puiss-1} {a\ssub{#1}\sp2}

\nomdef \ex a {e}
\nomdef \wt a {a}

\newcommand \prodwt {\wts[1] \dots \wts[\puiss] (\puiss-1)}

\newc@star@deftwo \poldep {\fct}{\indi} {P\pexp{#1}[#2]}
\newc@star@deftwo \pden   {\fct}{\indi} {Q\pexp{#1}[#2]}
\newc@star@default \pdenp {\fct}{}      {Q\ssub{#1}}
\nomdef \poldep a {P} \@gobbletwo{\poldep}{Relation de dépendance intégrale
  des dernières variables sur les premières dans un plongement adapté}

\newcommand \varset {\mathcal V}
\nomdef \varset a {V}

% weighted embedding [[2
%
\newc@star@deftwo@i \smpi {\fcti}{\ind} {\gmp@{#1}{#2}{#3}}
\newcommand \mexpi {\smpi{}}

\newcommand \fcti      {j}
\newcommand \fctirange {\sb{\fcti=1}\sp{\puiss-1}}
\nomdef \fcti a {j} \@gobbletwo{\fcti}{Un indice entier, variant en général
  entre $1$ et $\puiss-1$}

\newcommand \vmpi {\smpi Y}

\newcommand*\wemb  [1][\wt] {\varphi\ssub{#1}}
\newcommand*\wemba [1][\wt] {\psi\ssub{#1}}

\nomdef \wemb  g {z1} \@gobbletwo{\wemb }{Plongement éclatant associé au
  vecteur de poids $\wt$}
\nomdef \wemba g {z3} \@gobbletwo{\wemba}{Morphisme d'algèbres graduées
  associé au plongement éclatant $\wemb$}

\newcommand*\wembcl  {\gmpi  L}
\newcommand*\wembclv {\gmpiv L}
\nomdef \wembcl a {L} \@gobbletwo{\wembcl}{Formules de combinaisons linéaires
  utilisées dans \( \wemb \)}

\newcommand \idealim { \ideala{\wemb(\var)} }

% vanishing conditions [[2
%
\newcommand \Stairs { \mathcal E }
\newcommand \Vanish { \mathfrak q }

\newcommandx*\wt@scale [2][2=\delta\epsi] { \sb{\wt\slast{#1}} \sp{#2} }
\newcommand \stairs {\Stairs\wt@scale{}}
\newcommand \vanish {\Vanish\wt@scale{\divi}}
\newcommand \vanishv{\Vanish\wt@scale{\divi, \var}}

\nomdef \stairs a {E}
\nomdef \vanish a {q}

\newcommand \wtsum {\@ifstar{ S\sp\wt\sb0 }{ S\sp\wt }}
\newc@star@default \inda {\divi}{\ex} {\Aind\sp\wt\ssub{#1}}
\newcommand \indav {\inda[\divi, \var]}

\nomdef \wtsum a {S}
\nomdef \inda a {Ind}

% various (degree) conditions for subsets in lemmas
\newc@ifstar\Dz   { \delta d      }{ \delta d \sb\fct }
\newc@ifstar\Di   { \delta d'     }{ \delta d'\sb\fct }
\newc@ifstar\Dir  { \delta d' + r }{ \delta d'\sb\fct + r\sb\fct }
\newcommand \Ci   { \sb\Di   \sp{C'}   }
\newcommand \Cii  { \sb\Di   \sp{C''}  }
\newcommand \Ciii { \sb\Dir  \sp{C'''} }

% the space were the auxiliary form is to be found
\newcommand \fspace { \mathcal{\tilde F}_{\Dz} }

% the product sub-variety considered and its attributes [[2
%
\newcommand \Var {Z}
\newc@star@default \var     {\fct}{\puiss} {\Var  \ssub{#1}}
\newc@star@default \vdim    {\fct}{\puiss} {{u    \ssub{#1}}}
\newc@star@default \vdeg    {\fct}{\puiss} {{D    \ssub{#1}}}
\newc@star@default \vdegp   {\fct}{\puiss} {{D'   \ssub{#1}}}
\newc@star@default \varfc   {\fct}{\puiss} {\chow {\var[#1]}}
\newc@star@default \varid   {\fct}{\puiss} {\ideal{\var[#1]}}

\newc@star@default \vadapt  {\fct}{\puiss} {\chi   \ssub{#1}}
\newc@star@default \varfca  {\fct}{\puiss} {\chowa {\var[#1]}}
\newc@star@default \varida  {\fct}{\puiss} {\ideala{\var[#1]}}
\newc@star@default \vringa  {\fct}{\puiss} {\ringa {\var[#1]}}

\newcommand \ideala [1] {\tilde\Ideal \sb{#1}}
\newcommand \ringa  [1] {\tilde\Ring  \sb{#1}}
\newcommand \chowa  [1] {\tilde\Chow  \sb{#1}}

\nomdef \var     a {Z}
\nomdef \vdim    a {u}
\nomdef \vdeg    a {D}
\nomdef \vdegp   a {D'}
\nomdef \varfc   a {f}
\nomdef \varid   a {I}
\nomdef \vadapt  g {z2}

% various "epsilons" [[2
%
% Note: no additional braces, or \expi\sp2 would be typeset incorrectly
\newcommand \epsz   {\eps\sb0}
\newcommand \epsi   {\eps\sb1}

\nomdef \epsz   g {e00} \@gobbletwo{\epsz  }{Un epsilon}
\nomdef \epsi   g {e01} \@gobbletwo{\epsi  }{Un autre epsilon}

% for extrapolation [[2
%
% local indices
\newc@star@default \indv  {\fct }{\puiss} {\ind \sb{\place \slast{#1}}}
\newc@star@default \indiv {\fcti}{\puiss} {\indi\sb{\place \slast{#1}}}
\newc@star@default \indig {\fcti}{\puiss} {\indi\sb{{#1}}}

% rational functions
\newcommand*\ratf  [1] {\xi  \sb{#1}}
\newcommand*\ratfi [1] {\zeta\sb{#1}}
\newcommand*\ratfv [1] {\alpha\sb{#1, \place}}
\newcommand*\ratfh [1] {\hautl[]{\alpha\sb{#1}(\cexa)}}

% misc (ok) [[2
%
\newcommand \rdiv  { \rho\sb{\mathrm{div }} }
\newcommand \relim { \rho\sb{\mathrm{elim}} }
\newcommand \rfull { \rho }

\nomdef \rdiv g {r} \@gobbletwo{\rdiv}{Morphisme de réduction par division
  dans la construction de la forme auxiliaire pour l'inégalité de \bsc{Vojta}}
\nomdef \relim g {r} \@gobbletwo{\relim}{Morphisme de réduction par
  élimination de variables dans le construction de la forme auxiliaire pour
  l'inégalité de \bsc{Vojta}}

% misc (???)  [[2
%
\newcommand \vb {{\mathbf e}}
\newcommand \Mbase {{\mathcal M}}

\nomdef \vb a {e} \@gobbletwo{\vb}{Vecteur (de base ?)}
\nomdef \Mbase a {M} \@gobbletwo{\Mbase}{Matrice d'une application dans une
  base donnée}

\newcommand \monome {{\mathfrak m}}
\nomdef \monome a {m} \@gobbletwo{\monome}{Un monome}

\newcommand\mat{M} % matrice
\nomdef \mat a {M} \@gobbletwo{\mat}{Une matrice}

\newcommand\opdef{{\mathcal U}}
\nomdef \opdef a {U} \@gobbletwo{\opdef}{Ouvert de définition d'une certaine
  famille de formes, précisé localement}

% Vojta-wide notations without a dedicated macro [[2
% (btw, isn't this evil?)
%
\nomdef d a {d} \@gobbletwo{d}{Le degré, divisé par $\delta$, de la forme
  auxiliaire vue sur l'image par le plongement éclatant}
\nomdef \delta g {d} \@gobbletwo{\delta}{Un entier suffisamment divisible
  et grand, gouvernant l'ordre de grandeur du degré de la forme auxiliaire}

\nomdef F a {F} \@gobbletwo{F}{La forme auxiliaire vue sur \( \wemb(\var) \)}
\nomdef R a {R} \@gobbletwo{R}{Facteur parasitant la forme auxiliaire}
\nomdef r a {r} \@gobbletwo{r}{Degré du facteur parasitant la forme
  auxiliaire}

% Local notations without dedicated macro [[2
%
\nomdef \alpha g {a} \@gobbletwo{\alpha}{Parfois utilisé localement comme
  indice ou (multi)degré}
\nomdef \beta g {b} \@gobbletwo{\beta}{Parfois utilisé localement comme
  indice ou (multi)degré}
\nomdef f a {f} \@gobbletwo{f}{Parfois un multiindice, élément de \(
    \N\sp\puiss \)}
\nomdef \Delta g {D} \@gobbletwo{\Delta}{Parfois un multidegré, élément de
  \( \N\sp\puiss \)}
\nomdef p a {p} \@gobbletwo{p}{Parfois un entier ou un (multi)multiindice}
\nomdef q a {q} \@gobbletwo{q}{Parfois un entier ou un (multi)multiindice}

% Parametrisation [[2
%
\newcommand \psmp   {\gmp t}
\newcommand \psp    {\gp  t}
\newcommand \forme  {H}
\newcommand \dermp  {\gmp\kappa}
\newcommand \derp   {\gp \kappa}

\newc@ifstar \pmor  {\tau} {\tilde\tau}
\newcommand  \pmnum {\Delta}
\newcommand  \pmden {\Gamma}

\newcommand \pdiff {\@ifstar{\Delta}{\Delta\sb\dv}}

% misc [[2
%
\newcommand \hmclab [1][\Theta] {%
  \@ifstar{ C\sb{#1, \place} }{ C\sb{#1} }}
\newcommand \hlclab [1][\Theta] {%
  \@ifstar{ c\sb{#1, \place} }{ c\sb{#1} }}

% unsorted math stuff [[1
% -------------------

\newcommand*\hatxs {\smash{\hat x}}
\newcommand*\hatys {\smash{\hat y}}

\newcommand*\cube [1] {\mathcal C(#1)}
\nomdef \cube a {C} \@gobbletwo{\cube\PH}{L'ensemble des points à coordonnées
  entières du cube de demi-arête \PH centré en l'origine}

% [[1
% vim: ft=tex fdm=marker fmr=[[,]] fdl=1 spell spelllang=fr,en
