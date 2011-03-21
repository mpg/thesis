% !TEX root = main

% personal class for thesis preliminary notes [[2
%
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{mpg-preth}

% non-math [[1
% --------

% booleans for options, default values [[2
%
\newif\if@showbad       \@showbadtrue
\newif\if@domark        \@domarktrue
\newif\if@nomencl       \@nomencltrue
\newif\if@showmac       \@showmactrue
\newif\if@showkeys      \@showkeystrue

% option declarations [[2
%
\DeclareOption {full}   {\let\includeonly\@gobble}
\DeclareOption {pph}    {\@showbadfalse \@showmacfalse \@showkeysfalse}
\DeclareOption {nobad}  {\@showbadfalse}
\DeclareOption {showmac}{\@showmactrue}
\DeclareOption {nomark} {\@domarkfalse}
\DeclareOption {mencl}  {\@nomenclfalse}
\ProcessOptions \relax

% use Koma with custom encoding and fonts [[2
%
\LoadClass[a4paper, twoside, BCOR=1cm, 11pt, titlepage=false]{scrreprt}
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
\usepackage{enumitem}
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

% showkeys pseudo-option [[2
%
\if@showkeys
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
        head: \gitinfo{@head}{dt}%
        \par \kern2cm
        }}}
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
\if@nomencl
  \makenomenclature
\fi

\newcommand*\printmacro [1] {%
  \if@showmac
    \ted@toks{\relax#1\@nil}%
    \Substitute*{\the\ted@toks} {}                     {\string}%
    \Substitute*{\the\ted@toks} {\string\@nil\string}  {}%
    \Substitute*{\the\ted@toks} {\string\PH}           {\PH{}}%
    \Substitute*{\the\ted@toks} {\string\PHi}          {\PHi{}}%
    \makebox[0pt][r]{%
      \color{keys}\ttfamily\footnotesize \the\ted@toks \space}%
  \fi
  $#1$%
}

\newcommand*\nom@type [1] {%
  \expandafter\nom@type@\csname\cmdstring#1@\endcsname#1}
\newcommand*\nom@type@ [4] {%
  \newcommand #2 {\@ifstar{%
      \begingroup \edef\next{\endgroup
        \noexpand#1{\nom@local}%
      }\next
    }{%
      #1{}%
    }%
  }%
  \newcommand*#1 [4] {%
    \nomenclature[#3-##2--]{\printmacro{##3}}{##1##4}}%
  \@namedef{nom@group@@#3}{#4}}

\begingroup \shorthandon{:} \expandafter\endgroup\@firstofone{%
  \newcommand \nom@local {Chapitre \thechapter{} : \noexpand\MakeLowercase}
}

\renewcommand*\nomgroup [1] {%
  \item[\sffamily\bfseries \@nameuse{nom@group@@#1}]
}

\nom@type \noms A {Symboles}
\nom@type \nomn B {Signes numériques}
\nom@type \nomg C {Lettres grecques}
\nom@type \noma D {Lettres latines}
\nom@type \nomc E {Constantes automatiques}

% placeholders for descriptions
\newcommand*\nom@ph [2] {%
  \newcommand#1{\ensuremath{\text{$#2$}}\xspace}}

\nom@ph \PH   \star
\nom@ph \PHi  \bullet

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
%   SuppressWarning=true,
  }

% marginal notes and todos [[2
%
\newcommand*\marginnote [1] {\marginpar[\raggedleft #1]{\raggedright #1}}
\newcommandx*\worknote  [3][1=todo, 3] {%
  \marginnote{\leavevmode\color{#1}\itshape #2}%
  \@ifnotmtarg{#3}{\textcolor{#1}{#3}}%
}

\newcommand \todo  {\worknote{\textsc{todo}}}
\newcommand \todom {\tag*{\color{todo}\textsc{todo}}}
\newcommand \later {\worknote[later]{(à détailler ultérieurement)}}

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
\newtheorem {scho} [thm] {Scholie}

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

\newcommand* \proj [2][] {\Proj \ssup{#2}                 \ssub{#1}}
\newcommand* \aff  [2][] {\Aff  \@ifnotmtarg{#2}{\sp{\!#2}} \ssub{#1}}

\noma{P}{\proj\PH}{L'espace projectif standard de dimension \PH}
\noma{A}{\aff \PH}{L'espace affine standard de dimension \PH}

% standard functions [[2
%
\newcommand*\I     [1][] {\std{Id}\ssub{#1}}
\newcommand*\indic [1]   {\std{1}\ssub{#1}}

\noma{Id} {\I\PH}     {Fonction identité sur l'ensemble \PH}
\nomn{1}  {\indic\PH} {Fonction indicatrice de l'ensemble \PH}

% less standard but still usefull sets [[2
%
\newcommand \Qbar {\overline\Q}
\newcommand \cdn {{\boldsymbol k}}
\newcommand \Cdn {{\boldsymbol K}}

\noma{Q}{\Qbar}{Une clôture algébrique fixée de $\Q$}
\noma{k}{\cdn}{Un corps de nombres}
\noma{K}{\Cdn}{Une extension finie de $\cdn$}

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
\noma{I}{\ideal\PH}{Idéal (multi)homogène saturé de la variété plongée \PH}

\newcommand \Ring {\mathcal R}
\newcommand*\ring [1] {\Ring\sb{#1}}
\noma{R}{\ring\PH}{Anneau des coordonnées (multi)homogènes de la variété
  plongée \PH}

\newcommand \Korper {\mathcal K}
\newcommand*\korper [1] {\Korper(#1)}
\noma{K}{\korper\PH}{Corps des fonctions rationnelles de la variété \PH}

\newcommand \Zeros {\mathcal Z}
\newcommand*\zeros [1] {\Zeros(#1)}
\noma{Z}{\zeros\PH}{Lieu des zéros de la (famille de) forme(s) \PH}

\newcommand \Chow {f}
\newcommand*\chow [1] {\Chow\sb{#1}}
\noma{f}{\chow\PH}{Forme de \bsc{Chow} de la variété plongée \PH}

\newcommand \md {\mathfrak{d}}
\noma{d}{\md}{Le morphisme symétrisant utilisé dans la définition des
  distances projectives}

% missing operators & general symbols [[2
%
\DeclareMathOperator \Diff {d}
\newcommand*\diff[1][] {\Diff\ssup{#1}}

\newcommand*\der [1][] {\partial\ssup{#1}}
\noma{d}{\der\PH}{Dérivée divisée d'ordre \PH}

\DeclareMathOperator \card {Card}

\newcommand*\expb {\mathrm e}

\noma{e}{\expb}{Base des logarithmes népériens}

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
    \noexpand\nomc{\alph{cst}}{\unexpanded{\cst{#2}}}{%
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

\noma{A} {\va}     {La variété abélienne ambiante}
\noma{B} {\vai}    {Une sous-variété abélienne fixée de $\va$}
\nomn{0} {\oa}     {L'origine de $\va$}
\noma{g} {\genre}  {La dimension de $\va$}

\newcommand*\MW[2][\va]{MW\sb{\!#1}(#2)}
\noma{MW}{\MW[\PHi]\PH}{Espace de \MoW de la variété abélienne \PHi sur le
  corps \PH}

\newcommand \mmemb { \Theta }
\nomg{Theta} {\mmemb} {Plongement de \bsc{Mumford modifié}}

\newcommand \placesapx  { \mathcal S }
\newcommand \placerange { \sb{\place \in \placesapx} }

\newcommand*\wtapx [1][\place] { \lambda\ssub{#1} }
\newcommand*\degv  [1][\place] { \Delta \ssub{#1} }

\noma{S} {\placesapx} {Ensemble fini de places de \( \cdn \) auxquelles on
  impose une condition d'approximation}
\nomg{lambda}{\wtapx} {Poids de la place \( \place \) dans la condition
  d'approximation}
\nomg{Delta} {\degv}  {Degré local de \( \cdn \) en \( \place \)}

\newcommand \varapx { E }
\noma{E} {\varapx} {Variété dont on étudie les approximations}

\newcommand \expapx { \eps }
\nomg{eps} {\expapx} {L'exposant d'approximation}

\nomg{alpha}{\alpha}{Un des paramètres de l'énoncé de Vojta et Mumford}
\nomg{beta} {\beta} {Un des paramètres de l'énoncé de Vojta et Mumford}
\nomg{gamma}{\gamma}{Un des paramètres de l'énoncé de Vojta et Mumford}
\nomg{delta}{\delta}{Un des paramètres de l'énoncé de Vojta et Mumford}

% archimedian norms and measures [[2
%
\newcommand*\normsup [1]   {\norm{#1}\sb\infty}
\newcommand*\normlun [1]   {\norm{#1}\sb1}
\newcommand*\normeuc [1]   {\norm{#1}\sb2}
\newcommand*\normhom [1]   {\norm{#1}\sb{\mathrm h}}
\newcommand*\mespph  [2][] {\mathrm  M\ssub{#1}\@ifnotmtarg{#2}{(#2)}}
\newcommand*\mahler  [2][] {\mathcal M\ssub{#1}\@ifnotmtarg{#2}{(#2)}}

\noma{M} {\mespph\PH}{Mesure à la \bsc{Philippon} de la forme \PH}
\noma{M} {\mahler\PH}{Mesure de \bsc{Mahler} de la forme \PH}

% local absolute values, norms, distances, ... [[2
%
\newcommand \place {v}
\noma{v}{\place}{Une place, en général non fixée, de $\cdn$}

\newcommand* \av  [2][\place] {\abs   {#2}\ssub{#1}}
\newcommand* \Onv [2][\place] {\norm  {#2}\ssub{#1}}
\newcommand* \Onnv[2][\place] {\nnorm {#2}\ssub{#1}}
\newcommand* \nv  [3][\place] {\norm  {#3}\sb{#1, #2}}
\newcommand* \nnv [3][\place] {\nnorm {#3}\sb{#1, #2}}
\newcommand* \mvp [2][\place] {\mespph[#1]{#2}}
\newcommand* \mvm [2][\place] {\mahler[#1]{#2}}

\noms{nv1}{\av\PH }{Valeur absolue $\place$-adique d'un nombre}
\noms{nv2}{\nv\PHi\PH }{Norme $\place$-adique d'un vecteur ou d'une forme, en
utilisant norme ou mesure \PHi si $\place$ est archimédienne}
\noms{nv3}{\nnv\PHi\PH}{Norme $\place$-adique d'un multivecteur ou d'une forme
  multihomogène, en utilisant norme ou mesure \PHi si $\place$ est
  archimédienne}
\noma{Mv}{\mvm\PH}{Mesure de \bsc{Mahler} de la forme \PH si
  $\place$ est archimédienne, norme du $\sup$ sinon}
\noma{Mv}{\mvp\PH}{Mesure de \bsc{Philippon} de la forme \PH si
  $\place$ est archimédienne, norme du $\sup$ sinon}

\newcommand \dv  {{\delta\smash{\sb\place}}}
\newcommand \dpv {{\delta'\sb\place}}

\noma{dv1}{\dv }{Vaut $1$ si $\place$ est archimédienne, est nul sinon}
\noma{dv2}{\dpv}{Vaut $1$ si $\place$ est archimédienne ou divise $2$, est nul
  sinon}

\DeclareMathOperator \Dist {dist}
\newcommand*\Distv [1][\place] {\Dist\ssub{\place}}
\newcommand*\distv [3][\place] {\Distv[#1](#2,#3)}

\noma{dist}{\distv\PH\PHi}{Distance $\place$-adique projective entre \PH et
  \PHi}

\newcommand*\mv [2][\place] {M\sb{#1}(#2)}
\noma{M}{\mv\PH}{Mesure homogène locale en $\place$ de la
  forme \PH : c'est la norme du $\sup$ aux places finies et la mesure de
  \bsc{Philippon} aux places infinies}

% embeding-dependant values [[2
%
\newc@ifstar@two \dimp {n} {n+1} {(n+1)}
\newcommand*\projd [1][] {\proj[#1]\dimp}
\newcommand \fibre {\mathcal L}

\noma{n}{\dimp}{Dimension de l'espace projectif ambiant}
\noma{L}{\fibre}{Le fibré donnant « le » plongement projectif}

\newcommand \coa {\theta}
\newcommand \coi  {{\mathfrak b}}

\nomg{theta} {\coa} {Les coordonnées de l'origine de $\va$ dans un plongement
  de \bsc{Mumford} modifié fixé}
\noma{b}     {\coi} {Vecteur dont les composantes sont les inverses de
  composantes de $\coa$ bien choisies}

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
\noma{k}{\ind} {Un indice entier, variant en général entre $0$ et $\dimp$}
\noma{l}{\indi}{Un indice entier, variant en général entre $0$ et $\dimp$}

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
\noms{n}{\lgr\PH}{Longueur du multiindice \PH}

\newcommand*\ncoef  [1] {\mathcal N(#1)}
\newcommand*\maxbin [1] {m(#1)}
\noma{N}{\ncoef\PH}{Nombre de coefficients du polynôme \PH}
\noma{m}{\maxbin\PH}{Maximum des coefficients binomiaux $\binom\PH{i}$}

% multiprojective indices and coordinates [[2
%
% helper macros [[
\newc@star@deftwo@i \gmp  {\fct }{\ind} {\gmp@{#1}{#2}{#3}}
\newc@star@deftwo@i \gmpi {\fcti}{\ind} {\gmp@{#1}{#2}{#3}}
\newcommand*\gmp@ [3] {%
  \@ifnotmtarg{#1}{%
    \@ifmtarg{#2}{\boldsymbol}{}{%
      #1}}%
  \pexp{#2}[{#3}]}
\newcommand \mexp {\gmp{}}
\newcommand*\gmmp [1] {
  \underline{\underline{\boldsymbol{#1}}}}
% ]]

\newc@ifstar\puiss    {m} {m-1}
\noma{m}{\puiss}{Le nombre d'approximations exceptionnelles étudiées,
  donc aussi la puissance de $\va$ dans laquelle on travaille.}

\newcommand \fct      {i}
\newcommand \fctrange  {\sb{\fct =1}\sp\puiss}
\noma{i}{\fct} {Un indice entier, variant en général entre $1$ et $\puiss$}

\newcommand \pmp {x}
\newcommand \cmp {\gmp x}
\newcommand \vmp {\gmp X}

\newcommand*\cmh  [1] {\vmp[#1]} % XXX
\newcommand \cmmh     {\vmp\relax} % XXX

\newcommand \imp {\gmp \lambda}
\nomg{lambda}{\lambda}{Un indice multiprojectif, dans
  \( \bigl( \N\sp{\dimp + 1} \bigr)\sp\puiss \)}

\newcommand*\vlg [1] {\abs{#1}}
\newcommand*\lgt [1] {\lVert#1\rVert}

\noms{n}{\vlg\PH}{Vecteur des longueurs du multimultiindice \PH}
\noms{N}{\lgt\PH}{Longueur totale du multimultiindice \PH}

% points and coordinates [[2
%
% FIXME: used inconsistently
\newcommand*\p [1] {{\boldsymbol{#1}}}

% XXX use \pp, \cp; \pmp, \cmp instead
\newcommand \point   {x}
\newcommand \pointi  {y}
\newcommand \pointii {z}
\newcommand \coord   {{\mathbf x}}
\newcommand \coordi  {{\mathbf y}}
\newcommand \coordii {{\mathbf z}}

\noma{x}{\point  }{Un point non fixé de $\va$}
\noma{y}{\pointi }{Un autre point non fixé de $\va$}
\noma{z}{\pointii}{Encore un autre point non fixé de $\va$}

% height functions [[2
%
\newcommand*\Hautm [1][] {\mathrm H \ssub{#1}}
\newcommand*\Hautl [1][] {\mathrm h \ssub{#1}}
\newcommand \Hautn       {\hat\Hautl}

\newcommand*\hautm [2][] {\Hautm[#1](#2)}
\newcommand*\hautl [2][] {\Hautl[#1](#2)}
\newcommand*\hautn [1]   {\Hautn    (#1)}
\newcommand*\normn       {\abs}

\noma{h}{\hautm[\PHi]{\PH}}{Hauteur projective multiplicative de \PH en
                            utilisant la norme \PHi aux places archimédiennes}
\noma{h}{\hautl[\PHi]{\PH}}{Hauteur projective logarithmique de \PH en
                            utilisant la norme \PHi aux places archimédiennes}
\noma{h}{\hautn      {\PH}}{Hauteur de \NT de \PH}
\noms{normn}{\normn\PH}{Norme de \NT de \PH}

\newcommand* \scalaire [2] {\langle#1,#2\rangle}
\newcommand* \angleabs [2] {\widehat{(#1,#2)}}

\noms{angle}{\scalaire\PH\PHi}{Produit scalaire, relativement à la forme
  quadratique de \NT, des points \PH et \PHi de $\va$ ou de son espace de \MoW}
\noms{hat}{\angleabs\PH\PHi}{Angle non orienté, relativement à la forme
  quadratique de \NT, entre les points \PH et \PHi de $\va$ ou de son espace
  de \MoW}

% various "epsilons" [[2
%
% Note: no additional braces, or \expi\sp2 would be typeset incorrectly
\newcommand \epsz   {\eps\sb0}
\newcommand \epsi   {\eps\sb1}
\newcommand \epsii  {\eps\sb2}
\newcommand \epsiii {\eps\sb3}
\newcommand \epsiv  {\eps\sb4}

\nomg{eps0}{\epsz  }{Un epsilon}
\nomg{eps1}{\epsi  }{Un autre epsilon}
\nomg{eps2}{\epsii }{Encore un autre epsilon}
\nomg{eps3}{\epsiii}{Toujours un autre epsilon}
\nomg{eps4}{\epsiv }{Toujours un autre epsilon}

% abelian formulas [[2
%


% Vojta-specific math [[1
% -------------------

% constants in the theorem itself [[2
%
\newcommand \Vbig { \alpha \sb{\mathrm{V}} }
\newcommand \Vfar { \beta  \sb{\mathrm{V}} }
\newcommand \Vcos { \gamma \sb{\mathrm{V}} }

% general situation [[2
%
\newcommand \divi {E}
\noma{E}{\divi}{Le diviseur dont on étudie les approximations exceptionnelles}

\newcommand \Excep { e }
\newcommand \cex   { \gmp\Excep }

\newc@star@default \ex      {\fct }{\puiss } {\Excep\ssub{#1}}
\newc@star@default \exi     {\fcti}{\puiss*} {\Excep'\ssub{#1}}
\newc@star@default \wt      {\fct }{\puiss } {a\ssub{#1}}
\newc@star@default \wts     {\fct }{\puiss } {a\ssub{#1}\sp2}
\newc@star@default \wti     {\fcti}{\puiss*} {a\ssub{#1}}
\newc@star@default \wtis    {\fcti}{\puiss*} {a\ssub{#1}\sp2}

\newcommand \prodwt {\wts[1] \dots \wts[\puiss] (\puiss-1)}

\newc@star@deftwo \poldep {\fct}{\indi} {P\pexp{#1}[#2]}
\noma{P}{\poldep}{Relation de dépendance intégrale des dernières variables
  sur les premières dans un plongement adapté}
% weighted embedding [[2
%
\newc@star@deftwo@i \smpi {\fcti}{\ind} {\gmp@{#1}{#2}{#3}}
\newcommand \mexpi {\smpi{}}

\newcommand \fcti      {j}
\newcommand \fctirange {\sb{\fcti=1}\sp\puiss*}
\noma{j}{\fcti}{Un indice entier, variant en général entre $1$ et $\puiss*$}

\newcommand \vmpi {\smpi Y}
\newcommand*\cmhi [1] {\vmpi[#1]} % XXX
\newcommand \cmmhi    {\vmpi\relax} % XXX

\newcommand*\wemb  [1][\wt] {\varphi\ssub{#1}}
\newcommand*\wemba [1][\wt] {\psi\ssub{#1}}

\nomg{phi}{\wemb }{Plongement éclatant associé au vecteur de poids $\wt$}
\nomg{psi}{\wemba}{Morphisme d'algèbres graduées associé au plongement
  éclatant $\wemb$}

\newcommand*\wembcl {\gmpi S}
\noma{S}{\wembcl}{Formules de combinaisons linéaires utilisées dans \( \wemb \)}


% vanishing conditions [[2
%
\newcommand \Stairs { \mathcal E }
\newcommand \Vanish {\@ifstar {\mathfrak{\tilde q}} {\mathfrak q}}

\newcommand \wt@scale [1][\delta\epsi] { \sb{\wt} \sp{#1} }
\newcommand \stairs {\Stairs\wt@scale}
\newcommand \vanish {\@ifstar {\Vanish*\wt@scale} {\Vanish\wt@scale}}

\noma{E} {\stairs} {Cylindre sur le dessus de multi-escalier défini par les
  poids $\wt$ et le facteur d'échelle $\epsi\delta$}
\noma{q1}{\vanish*}{Idéal d'annulation associé à $\stairs$}
\noma{q2}{\vanish} {Idéal d'annulation $\vanish + \varid$}

\newcommand \wtsum {\@ifstar{ S\sp\wt\sb0 }{ S\sp\wt }}
\newc@star@default \inda {\divi}{\ex} {\Aind\sp\wt\ssub{#1}}

\noma{S}{\wtsum}{Somme pondérée utilisée dans la définition de l'indice
  d'annulation}
\noma{Ind}{\inda[\PHi](\PH)}{Indice, pondéré par \( \wt \),  de \PH en (ou le
  long de) \PHi}

% various (degree) conditions for subsets in lemmas
\newc@ifstar\Dz   { \delta d  }{ \delta d\sb\fct }
\newcommand \Di   {{\delta d'}}
\newcommand \Dii  {{\delta d'}}
\newc@ifstar\Diii { \delta d' + r }{ \delta d'\sb\fct + r\sb\fct }
\newcommand \Ci   { \sb\Di   \sp{C'}   }
\newcommand \Cii  { \sb\Dii  \sp{C''}  }
\newcommand \Ciii { \sb\Diii \sp{C'''} }

% the product sub-variety considered and its attributes [[2
%
\newcommand \Var {Z}
\newc@star@default \var     {\fct}{\puiss} {\Var\pexp{#1}}
\newc@star@default \vdim    {\fct}{\puiss} {{u\ssub{#1}}}
\newc@star@default \vdeg    {\fct}{\puiss} {{D\ssub{#1}}}
\newc@star@default \varfc   {\fct}{\puiss} {\Chow\pexp{#1}[\Var]}
\newc@star@default \varid   {\fct}{\puiss} {\Ideal\pexp{#1}[\Var]}

\noma{Z}{\var    }{La variété produit utilisée dans la preuve de \bsc{Vojta}}
\noma{Z}{\var*   }{Le $\fct$-ième facteur de $\var$}
\noma{u}{\vdim   }{Le vecteur des dimensions des facteurs de $\var$}
\noma{u}{\vdim*  }{La dimension de $\var*$}
\noma{D}{\vdeg   }{Le vecteur des degrés de facteurs de $\var$}
\noma{D}{\vdeg*  }{Le degré de $\var*$}
\noma{f}{\varfc  }{La forme de \bsc{Chow} de $\var$}
\noma{f}{\varfc* }{La forme de \bsc{Chow} de $\var*$}
\noma{I}{\varid  }{L'idéal multihomogène saturé de $\var$}
\noma{I}{\varid* }{L'idéal multihomogène saturé de $\var*$}

% local indices for extrapolation [[2
%
\newc@star@default \indv  {\fct }{\puiss} {\ind \sb{\place \slast{#1}}}
\newc@star@default \indiv {\fcti}{\puiss} {\indi\sb{\place \slast{#1}}}
\newc@star@default \indig {\fcti}{\puiss} {\indi\sb{{#1}}}


% misc (ok) [[2
%
\newcommand \rdiv  { \rho\sb{\mathrm{div }} }
\newcommand \relim { \rho\sb{\mathrm{elim}} }

\nomg{rho}{\rdiv}{Morphisme de réduction par division dans la construction de
  la forme auxiliaire pour l'inégalité de \bsc{Vojta}}
\nomg{rho}{\relim}{Morphisme de réduction par élimination de variables dans le
  construction de la forme auxiliaire pour l'inégalité de \bsc{Vojta}}

% misc (???)  [[2
%
\newcommand \vb {{\mathbf e}}
\newcommand \Mbase {{\mathcal M}}

\noma{e}{\vb}{Vecteur (de base ?)}
\noma{M}{\Mbase}{Matrice d'une application dans une base donnée}

\newcommand \monome {{\mathfrak m}}
\noma{m}{\monome}{Un monome}

\newcommand\mat{M} % matrice
\noma{M}{\mat}{Une matrice}

\newcommand\opdef{{\mathcal U}}
\noma{U}{\opdef}{Ouvert de définition d'une certaine famille de formes,
  précisé localement}

% Vojta-wide notations without a dedicated macro [[2
% (btw, isn't this evil?)
%
\noma{d}{d}{Le degré, divisé par $\delta$, de la forme auxiliaire vue sur
  l'image par le plongement éclatant}
\noma{d}{d'}{Le degré, divisé par $\delta$, de la forme auxiliaire vue sur la
  variété}
\nomg{delta}{\delta}{Un entier suffisamment divisible et grand, gouvernant
  l'ordre de grandeur du degré de la forme auxiliaire}
\noma{C}{C', C'', C'''}{Conditions variées sur les degrés, servant à définir
  des sous-espaces vectoriels de partie homogènes d'algèbres de polynômes}

\noma{F}{F}{La forme auxiliaire vue sur \( \wemb(\var) \)}
\noma{F'}{F'}{La forme auxiliaire vue sur \( \var \)}
\noma{R}{R}{Facteur parasitant la forme auxiliaire}
\noma{G}{G}{La forme auxiliaire multipliée par \( R \) et réduite}
\noma{r}{r}{Degré du facteur parasitant la forme auxiliaire}

% Local notations without dedicated macro [[2
%
\nomg{alpha}{\alpha}{Parfois utilisé localement comme indice ou (multi)degré}
\nomg{beta} {\beta} {Parfois utilisé localement comme indice ou (multi)degré}
\noma{f} {f} {Parfois un multiindice, élément de \( \N\sp\puiss \)}
\nomg{Delta}{\Delta}{Parfois un multidegré, élément de \( \N\sp\puiss \)}
\noma{p}{p}{Parfois un entier ou un (multi)multiindice}
\noma{q}{q}{Parfois un entier ou un (multi)multiindice}

% Parametrisation [[2
%
\newcommand \psmp   {\gmp t}
\newcommand \psp    {\gp  t}
\newcommand \pden   {U}
\newcommand \forme  {H}
\newcommand \dermp  {\gmp\kappa}
\newcommand \derp   {\gp \kappa}

\newc@ifstar \pmor  {\tau} {\tilde\tau}
\newcommand  \pmnum {\Delta}
\newcommand  \pmden {\Gamma}

\newcommand \pdiff {\@ifstar{\Delta}{\Delta\sb\dv}}

% misc [[2
%
\newcommand \hclab {\@ifstar{ c\sb{\va, \place} }{ c\sb{\va} }}

% unsorted math stuff [[1
% -------------------

\newcommand*\hatxs {\smash{\hat x}}
\newcommand*\hatys {\smash{\hat y}}

\newcommand*\cube [1] {\mathcal C(#1)}
\noma{C}{\cube\PH}{L'ensemble des points à coordonnées entières du cube de
  demi-arête \PH centré en l'origine}

% [[1
% vim: ft=tex fdm=marker fmr=[[,]] fdl=1 spell spelllang=fr,en
