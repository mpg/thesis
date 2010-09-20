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

\usepackage{xcolor}
\colorlet{dev}{black!50}

% load various usefull packages [[2
%
\usepackage{mathtools, amsthm}
\usepackage[all]{xy}
\usepackage{ifmtarg, fixltx2e, mparhack, xargs, xspace, cmdstring, ted, trace}
\usepackage{enumitem}
\usepackage{git-info, eso-pic}
\usepackage[noprefix, nocfg, french]{nomencl}
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
  \colorlet{refkey}{dev}
  \colorlet{labelkey}{dev}
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
        \centering \itshape \color{dev}%
        head: \gitinfo{@head}{dt}%
        \par \kern2cm
        }}}
\fi

% inline include [[2
%
\newcommand*\inlineinclude [2] {%
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

\newcommand*\noincludeonly [1] {}

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
      \color{dev}\ttfamily \the\ted@toks \space}%
  \fi}

\newcommand*\nom@type [3] {%
  \newcommand*#1[3]{%
    \nomenclature[#2-##1--]{\printmacro{##2}$##2$}{##3}}%
  \@namedef{nom@group@@#2}{#3}}

\renewcommand*\nomgroup [1] {%
  \item[\sffamily\bfseries \@nameuse{nom@group@@#1}]
  }

\nom@type \noms A {Symboles}
\nom@type \nomn B {Signes numériques}
\nom@type \nomg C {Lettres grecques}
\nom@type \noma D {Lettres latines}

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

% frenchb settings [[2
%
\frenchbsetup{og=«,fg=»,
  AutoSpacePunctuation=false,
%   SuppressWarning=true,
  }

% marginal notes and todos [[2
%
\newcommand*\marginnote [1] {\marginpar[\raggedleft #1]{\raggedright #1}}
\newcommand*\worknote   [1] {\marginnote{%
    \leavevmode\color{dev}\itshape #1}}

\newcommand \todo  {\worknote{\textsc{todo}}}
\newcommand \todom {\tag{\textsc{todo}}}
\newcommand \later {\worknote{(à détailler ultérieurement)}}

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

\theoremstyle{remark}
\newtheorem*{rem}        {Remarque}
\newtheorem*{Rem}        {Remarque}

% numbering [[2
%
\numberwithin{equation}{section}
\numberwithin{thm}{chapter}

% shortcut macros [[2
%
\newcommand \NT  {\bsc{Néron}-\bsc{Tate}\xspace}
\newcommand \MoW {\bsc{Mordell}-\bsc{Weil}\xspace}

% helpers for math macros [[1
% -----------------------

% special optional arguments for indices: [[2
%
% - by default, empty
% - normal []-notation available
% - *-form yields a default non-empty value
%
% \newcs@start@default <name> <arg. nb.> <2nd default> <3rd one> <repl. text>
\newcommand*\newc@star@default[1]{%
  \expandafter\newc@star@default@
  \csname \cmdstring#1 \endcsname#1}
\newcommand*\newc@star@default@[6]{%
  \newcommand*#1[#3][]{#6\egroup}%
  \newcommand*#2{\bgroup \@ifstar{\@ifstar{#1[#5]}{#1[#4]}}{#1}}}

% coma-seperated list with possibly empty elements [[2
%
\newcommand*\sfirst [1] {\@ifnomtarg{#1}{#1,}}
\newcommand*\slast  [1] {\@ifnomtarg{#1}{,#1}}

% su{b,per}script-friendly starred macros [[2
%
\newcommand*\newc@ifstar [3] {%
  \newcommand#1{\bgroup\@ifstar{#3\egroup} {#2\egroup}}}
\newcommand*\newc@ifstar@two [4] {%
  \newcommand#1{\bgroup\@ifstar{\@ifstar{#4\egroup}{#3\egroup}} {#2\egroup}}}

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
\newcommand* \ssub [1] {\@ifnotmtarg{#1}{_{#1}}}
\newcommand* \ssup [1] {\@ifnotmtarg{#1}{^{#1}}}

% parenthesized superscript with optional subscript
\newcommandx*\pexp [2][2] {%
  \@ifmtarg{#2}{%
    \@ifnotmtarg{#1}{\cramped{^{(#1)}}}%
    }{%
    \@ifnotmtarg{#1}{^{(#1)}}_{#2}}}

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
\newcommand* \aff  [2][] {\Aff  \@ifnotmtarg{#2}{^{\!#2}} \ssub{#1}}

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
\newcommand \orbrack {\mathopen\rbrack}
\newcommand \clbrack {\mathopen\lbrack}

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

% general algebraic geometry [[2
%
\newcommand \Ideal {\mathcal I}
\newcommand*\ideal [1] {\Ideal_{#1}}
\noma{I}{\ideal\PH}{Idéal (multi)homogène saturé de la variété plongée \PH}

\newcommand \Ring {\mathcal R}
\newcommand*\ring [1] {\Ring_{#1}}
\noma{R}{\ring\PH}{Anneau des coordonnées (multi)homogènes de la variété
  plongée \PH}

\newcommand \Korper {\mathcal K}
\newcommand*\korper [1] {\Korper(#1)}
\noma{K}{\korper\PH}{Corps des fonctions rationnelles de la variété \PH}

\newcommand \Zeros {\mathcal Z}
\newcommand*\zeros [1] {\Zeros(#1)}
\noma{Z}{\zeros\PH}{Lieu des zéros de la (famille de) forme(s) \PH}

\newcommand \Chow {f}
\newcommand*\chow [1] {\Chow_{#1}}
\noma{f}{\chow\PH}{Forme de \bsc{Chow} de la variété plongée \PH}

\newcommand \ph {\ssub}
\noms{}{\PH\ph\PHi}{Partie homogène de (multi)degré \PHi de l'algèbre
  (multi)graduée ou idéal (multi)homogène \PH}

\newcommand \md {\mathfrak{d}}
\noma{d}{\md}{Le morphisme symétrisant utilisé dans la définition des
  distances projectives}

% missing operators & general symbols [[2
%
\DeclareMathOperator \diff {d}
\noma{d}{\diff\PH}{Différentielle par rapport à \PH}

\newcommand*\der [1] {\partial_{#1}}
\noma{d}{\der\PH}{Dérivée divisée par rapport à \PH}

\DeclareMathOperator \card {Card}

\newcommand*\expb {\mathrm e}

\noma{e}{\expb}{Base des logarithmes népériens}

% automatic constants [[2
%
\AtBeginDocument{\let\mpg@label\label}
\newcounter{cst}
\newcommand*\cst [1] {%
  \ensuremath{ c_{ \ref{cst@#1} \@nameuse{cst@@#1} } }}
\newcommand*\newcst [2][\place] {%
  \begingroup
  \let\showkeyslabelformat\@gobble
  \refstepcounter{cst}%
  \mpg@label{cst@#2}%
  \endgroup
  \@ifnotmtarg{#1}{%
    \protected@write\@auxout{}{\global\string\@namedef{cst@@#2}{, #1}}%
  }%
  \cst{#2}}

\noma{cvx}{c_{\PH, \PHi}}{Constante (en général intermédiaire) numéro \PH,
  dépendant éventuellement de la place \PHi}

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

\newcommand*\MW[2][\va]{MW_{\!#1}(#2)}
\noma{MW}{\MW[\PHi]\PH}{Espace de \MoW de la variété abélienne \PHi sur le
  corps \PH}

% archimedian norms and measures [[2
%
\newcommand*\normsup [1]   {\norm{#1}_\infty}
\newcommand*\normlun [1]   {\norm{#1}_1}
\newcommand*\normeuc [1]   {\norm{#1}_2}
\newcommand*\normhom [1]   {\norm{#1}_{\mathrm h}}
\newcommand*\mespph  [1]   {\mathrm{M}(#1)}
\newcommand*\mahler  [2][] {\mathcal M_{#1}(#2)}

\noma{M} {\mespph\PH}{Mesure à la \bsc{Philippon} de la forme \PH}
\noma{M} {\mahler\PH}{Mesure de \bsc{Mahler} de la forme \PH}
\noma{Mv}{\mahler[\place]\PH}{Mesure de \bsc{Mahler} de la forme \PH si
  $\place$ est archimédienne, norme du $\sup$ sinon}

% local absolute values, norms, distances, ... [[2
%
\newcommand \place {v}
\noma{v}{\place}{Une place, en général non fixée, de $\cdn$}

\newcommand* \av  [2][\place] {\abs   {#2}\ssub{#1}}
\newcommand* \Onv [2][\place] {\norm  {#2}\ssub{#1}}
\newcommand* \Onnv[2][\place] {\nnorm {#2}\ssub{#1}}
\newcommand* \nv  [3][\place] {\norm  {#3}_{#1, #2}}
\newcommand* \nnv [3][\place] {\nnorm {#3}_{#1, #2}}

\noms{nv1}{\av\PH }{Valeur absolue $\place$-adique d'un nombre}
\noms{nv2}{\nv\PHi\PH }{Norme $\place$-adique d'un vecteur ou d'une forme, en
utilisant norme ou mesure \PHi si $\place$ est archimédienne}
\noms{nv3}{\nnv\PHi\PH}{Norme $\place$-adique d'un multivecteur ou d'une forme
  multihomogène, en utilisant norme ou mesure \PHi si $\place$ est
  archimédienne}

\newcommand \dv  {{\delta\smash{_\place}}}
\newcommand \dpv {{\delta'_\place}}

\noma{dv1}{\dv }{Vaut $1$ si $\place$ est archimédienne, est nul sinon}
\noma{dv2}{\dpv}{Vaut $1$ si $\place$ est archimédienne ou divise $2$, est nul
  sinon}

\DeclareMathOperator \Dist {dist}
\newcommand*\Distv [1][\place] {\Dist\ssub{\place}}
\newcommand*\distv [3][\place] {\Distv[#1](#2,#3)}

\noma{dist}{\distv\PH\PHi}{Distance $\place$-adique projective entre \PH et
  \PHi}

\newcommand*\mv [2][\place] {M_{#1}(#2)}
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

% (multi)projective indices and coordinates [[2
%
\newc@ifstar\puiss    {m} {m-1}
\newcommand \fct      {i}
\newcommand \fcti     {j}
\newcommand \ind      {k}
\newcommand \indi     {l}

\newcommand \fctrange  {_{\fct =1}^\puiss}
\newcommand \fctirange {_{\fcti=1}^\puiss*}
\newcommand \indrange  {_{\ind =0}^\dimp}
\newcommand \indirange {_{\indi=0}^\dimp}

\noma{m}{\puiss}{Le nombre d'approximations exceptionnelles étudiées,
  donc aussi la puissance de $\va$ dans laquelle ont travaille.}
\noma{i}{\fct} {Un indice entier, variant en général entre $1$ et $\puiss$}
\noma{j}{\fcti}{Un indice entier, variant en général entre $1$ et $\puiss*$}
\noma{k}{\ind} {Un indice entier, variant en général entre $0$ et $\dimp$}
\noma{l}{\indi}{Un indice entier, variant en général entre $0$ et $\dimp$}

\newcommand*\ch   [1] {X\ssub{#1}}
\newcommand*\cmh  [1] {X\pexp{#1}}
\newcommand \cmmh     {\boldsymbol X}
\newcommand*\cmhi [1] {Y\pexp{#1}}
\newcommand \cmmhi    {\boldsymbol Y}

\newcommand*\lgr [1] {\abs{#1}}
\newcommand*\vlg [1] {\abs{#1}}

\noms{n}{\lgr\PH}{Longueur du multiindice \PH}
\noms{n}{\vlg\PH}{Vecteur des longueurs du multimultiindice \PH}

\newcommand*\lgt [1] {\lVert#1\rVert}
\noms{N}{\lgt\PH}{Longueur totale du multimultiindice \PH}

\newcommand*\ncoef  [1] {\mathcal N(#1)}
\newcommand*\maxbin [1] {m(#1)}
\noma{N}{\ncoef\PH}{Nombre de coefficients du polynôme \PH}
\noma{m}{\maxbin\PH}{Maximum des coefficients binomiaux $\binom\PH{i}$}

% points and coordinates [[2
%
\newcommand*\p [1] {{\boldsymbol{#1}}} % point (par opposition à coordonnées)

\newcommand \point   {x}
\newcommand \pointi  {y}
\newcommand \pointii {z}
\newcommand \coord   {{\mathrm{x}}}
\newcommand \coordi  {{\mathrm{y}}}

\noma{x}{\point  }{Un point non fixé de $\va$}
\noma{y}{\pointi }{Un autre point non fixé de $\va$}
\noma{z}{\pointii}{Encore un autre point non fixé de $\va$}

% height functions [[2
%
\newcommand \Hautm [1][] {\mathrm H \ssub{#1}}
\newcommand \Hautl [1][] {\mathrm h \ssub{#1}}
\newcommand \Hautn       {\smash{\hat\Hautl}}

\newcommand*\hautm [2][] {\Hautm[1](#2)}
\newcommand*\hautl [2][] {\Hautl[1](#2)}
\newcommand*\hautn [1]   {\Hautn   (#1)}

\noma{h}{\hautm[\PHi]{\PH}}{Hauteur projective multiplicative de \PH en
                            utilisant la norme \PHi aux places archimédiennes}
\noma{h}{\hautl[\PHi]{\PH}}{Hauteur projective logarithmique de \PH en
                            utilisant la norme \PHi aux places archimédiennes}
\noma{h}{\hautn      {\PH}}{Hauteur de \bsc{Néron}-\bsc{Tate} de \PH}

\newcommand* \scalaire [2] {\langle#1,#2\rangle}
\newcommand* \angleabs [2] {\widehat{(#1,#2)}}

\noms{angle}{\scalaire\PH\PHi}{Produit scalaire, relativement à la forme
  quadratique de \NT, des points \PH et \PHi de $\va$ ou de son espace de \MoW}
\noms{hat}{\angleabs\PH\PHi}{Angle non orienté, relativement à la forme
  quadratique de \NT, entre les points \PH et \PHi de $\va$ ou de son espace
  de \MoW}

% various "epsilons" [[2
%
\newcommand \epsz   {{\eps_0}}
\newcommand \epsi   {{\eps_1}}
\newcommand \epsii  {{\eps_2}}
\newcommand \epsiii {{\eps_3}}

\nomg{eps0}{\epsz  }{Un epsilon}
\nomg{eps1}{\epsi  }{Un autre epsilon}
\nomg{eps2}{\epsii }{Encore un autre epsilon}
\nomg{eps3}{\epsiii}{Toujours un autre epsilon}

% Vojta-specific math [[1
% -------------------

% general situation [[2
%
\newcommand \divi {E}
\noma{E}{\divi}{Le diviseur dont on étudie les approximatons exceptionnelles}

\newc@star@default \excep   {1}{\fct }{\puiss } {e\ssub{#1}}
\newc@star@default \wt      {1}{\fct }{\puiss } {a\ssub{#1}}
\newc@star@default \wts     {1}{\fct }{\puiss } {a\ssub{#1}^2}
\newc@star@default \wti     {1}{\fcti}{\puiss*} {a\ssub{#1}}
\newc@star@default \wtis    {1}{\fcti}{\puiss*} {a\ssub{#1}^2}

\noma{e}{\excep}{La famille d'approximations exceptionnelles considérée}
\noma{a}{\wt}{Le vecteur de poids associé à $\excep$}
% \wt isn't used consistently :/

\newcommand \prodwt {\wts[1] \dots \wts[\puiss] (\puiss-1)}

\newc@star@default \mexp    {1}{\fct }{\puiss } {\pexp{#1}}
\newc@star@default \mexpi   {1}{\fcti}{\puiss*} {\pexp{#1}}

\newcommand        \coeff {\lambda\mexp}
\nomg{lambda}{\lambda}{Un multimultiindice, en général élément de
  \( \bigl( \N^{\dimp + 1} \bigr)^\puiss \)}

% weighted embedding [[2
%
\newcommand*\wemb  [1][\wt] {\varphi\ssub{#1}}
\newcommand*\wemba [1][\wt] {\psi\ssub{#1}}

\nomg{phi}{\wemb }{Plongement éclatant associé au vecteur de poids $\wt$}
\nomg{psi}{\wemba}{Morphisme d'algèbres graduées associé au plongement
  éclatant $\wemb$}

% vanishing conditions [[2
%
\newcommand \Stairs { \mathcal E }
\newcommand \Vanish {\@ifstar {\mathfrak{\tilde q}} {\mathfrak q}}

\newcommand \wt@scale { _{\wt} ^\delta }
\newcommand \stairs {\Stairs\wt@scale}
\newcommand \vanish {\@ifstar {\Vanish*\wt@scale} {\Vanish\wt@scale}}

\noma{E} {\stairs} {Cylindre sur le dessus de multi-escalier défini par les
  poids $\wt$ et le facteur d'échelle $\epsi\delta$}
\noma{q1}{\vanish*}{Idéal d'annulation associé à $\stairs$}
\noma{q2}{\vanish} {Idéal d'annulation $\vanish + \varid$}

% various (degree) conditions for subsets in lemmas
\newcommand \Di   { {\delta d} }
\newcommand \Dii  { {\delta d'} }
\newc@ifstar\Diii {\delta d'_\fct + r\fct} {\delta d' + r}
\newcommand \Ci   { \ph\Dii  ^{C'}   }
\newcommand \Cii  { \ph\Dii  ^{C''}  }
\newcommand \Ciii { \ph\Diii ^{C'''} }

% weight sum of \lamda in the definition of \stairs
\newcommand \sumwtlambda {
  \frac {\coeff[1][0]} {\wt[1]^2} + \dots
  + \frac {\coeff[\puiss-1][0]} {\wt[\puiss-1]^2}
  + \frac {\coeff[\puiss][0]} {\puiss-1} }

% the product sub-variety considered and its attributes [[2
%
\newcommand \Var {Z}
\newc@star@default \var     {1}{\fct}{\puiss} {\Var\pexp{#1}}
\newc@star@default \vdim    {1}{\fct}{\puiss} {{u\ssub{#1}}}
\newc@star@default \vdeg    {1}{\fct}{\puiss} {{D\ssub{#1}}}
\newc@star@default \varfc   {1}{\fct}{\puiss} {\Chow\pexp{#1}[\Var]}
\newc@star@default \varid   {1}{\fct}{\puiss} {\Ideal\pexp{#1}[\Var]}

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

% misc (ok) [[2
%
\newcommand \rdiv  {{ \rho_{\text{\normalfont div}} }}
\newcommand \relim {{ \rho_{\text{\normalfont elim}} }}

\nomg{rho}{\rdiv}{Morphimse de réduction par division dans la construction de
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
\nomg{delta}{\delta}{Un entier suffisament divisible et grand, gouvernant
  l'ordre de grandeur du degré de la forme auxiliaire}
\noma{C}{C', C'', C'''}{Conditions variées sur les degrés, servant à définir
  des sous-espaces vectoriels de partie homogènes d'algèbres de polynômes}

\noma{F}{F}{La forme auxiliaire}
\noma{R}{R}{Facteur parasitant la forme auxiliaire}
\noma{r}{r}{Degré du facteur parasitant la forme auxiliaire}

% Local notations without dedicated macro [[2
%
\nomg{alpha}{\alpha}{Parfois utilisé localement comme indice ou (multi)degré}
\nomg{beta} {\beta} {Parfois utilisé localement comme indice ou (multi)degré}
\noma{f} {f} {Parfois un multiindice, élément de \( \N^\puiss \)}
\nomg{Delta}{\Delta}{Parfois un multidegré, élément de \( \N^\puiss \)}
\noma{p}{p}{Parfois un entier ou un (multi)multiindice}
\noma{q}{q}{Parfois un entier ou un (multi)multiindice}

% unsorted math stuff [[1
% -------------------

\newcommand*\hatxs {\smash{\hat x}}
\newcommand*\hatys {\smash{\hat y}}

\newcommand*\cube [1] {\mathcal C(#1)}
\noma{C}{\cube\PH}{L'ensemble des points à coordonnées entières du cube de
  demi-arête \PH centré en l'origine}

% [[1
% vim: ft=tex fdm=marker fmr=[[,]] fdl=1
