% personal class for thesis preliminary notes [[2
%
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{mpg-preth}

% Non-math stuff [[1
% --------------

% booleans for options, default values [[2
%
\newif\if@webversion    \@webversionfalse
\newif\if@showbad       \@showbadtrue
\newif\if@domark        \@domarktrue

% options [[2
%
\DeclareOption {web}    {\@webversiontrue}
\DeclareOption {nobad}  {\@showbadfalse}
\DeclareOption {nomark} {\@domarkfalse}
\ProcessOptions \relax

% use Koma-article with custom encoding and fonts [[2
%
\LoadClass[a4paper, 11pt, twoside, BCOR=1cm]{scrartcl}
\usepackage[utf8]{inputenc}
\usepackage[T1]{fontenc}
\usepackage[sc, osf]{mathpazo} \linespread{1.05}
\usepackage{amssymb}
\renewcommand\sfdefault{iwona}

% load various usefull packages [[2
%
\usepackage{mathtools, amsthm}
\usepackage[all]{xy}
\usepackage{ifmtarg, fixltx2e, mparhack, xargs, xspace, trace}
\usepackage{enumitem}
\usepackage{git-info, eso-pic, xcolor}
\usepackage[noprefix, nocfg, french]{nomencl}
\usepackage{csquotes}
\usepackage[style=alphabetic, sorting=nyt, sortcites=true,
  autopunct=true, babel=hyphen,
  hyperref=true, backref=false]{biblatex}
\usepackage[expansion=false, babel=true]{microtype}
\usepackage[british, frenchb]{babel}
\if@webversion\else \PassOptionsToPackage{bookmarks=false}{hyperref} \fi
\usepackage[colorlinks=true]{hyperref}

% hyperref settings (web option) [[2
%
\if@webversion
  \hypersetup{urlcolor=blue, linkcolor=red, citecolor=green,
    bookmarksnumbered=true}
\else
  \hypersetup{urlcolor=black, linkcolor=black, citecolor=black}
\fi

% overfullrule (nobad option) [[2
%
\setlength{\overfullrule}{\if@showbad 5\else 0\fi pt}

% use git information (nomark option) [[2
%
\if@domark
  \AddToShipoutPicture{%
    \AtPageLowerLeft{%
      \parbox[b]{\paperwidth}{%
        \centering \itshape \color{black!30}%
        \jobname.tex $\le$ \gitinfo{@head}{dt}%
        \par \kern2cm
        }}}
\fi

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

% frenchb settings [[2
%
\frenchbsetup{og=«,fg=»,
  AutoSpacePunctuation=false,
%   SuppressWarning=true,
  }

% marginal notes and todos [[2
%
\newcommand*\marginnote[1]{\marginpar[\raggedleft #1]{\raggedright #1}}
\newcommand*\worknote[1]{\marginnote{\color{black!50}\itshape #1}}
\newcommand\todo{\worknote{\textsc{todo}}}
\newcommand\later{\worknote{(à détailler ultérieurement)}}

% languages and special text items [[2
%
\newcommand*\lat[1]{\emph{#1}}
\newcommand*\eng[1]{%
  \foreignlanguage{english}{\emph{#1}}}

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
\newtheorem {lem}  [thm]  {Lemme}
\newtheorem {coro} [thm] {Corollaire}
\newtheorem {fact} [thm] {Fait}
\newtheorem {scho} [thm] {Scholie}
\newtheorem*{flemme}     {À démontrer plus tard}
  \theoremstyle{definition}
\newtheorem {tdef} [thm] {Définition}
  \theoremstyle{remark}
\newtheorem*{rem}        {Remarque}
\newtheorem*{Rem}        {Remarque}

% math stuff [[1
% ----------

% misc [[2
%
\newcommand*\pmm[1]{\text{ #1}}         % ponctuation in math mode
\newcommand\suchthat{\ \middle\vert\ }
\newcommand\truc{{\,\cdot\,}}

% my preferred version of a few symbols [[2
%
\newcommand\eps{\varepsilon}
\renewcommand\ge{\geqslant}
\renewcommand\le{\leqslant}

% supscripts and subscripts [[2
%
\newcommand*\ssub[1]{%
  \@ifnotmtarg{#1}{_{#1}}}
\newcommand*\ssup[1]{%
  \@ifnotmtarg{#1}{^{#1}}}
\newcommandx*\pexp[2][2]{%
  \@ifmtarg{#2}{%
    \@ifnotmtarg{#1}{\cramped{^{(#1)}}}%
    }{%
    \@ifnotmtarg{#1}{^{(#1)}}_{#2}}}

% standard sets [[2
%
\newcommand*\std[1]{{\mathbf{#1}}}
\newcommand     \N      {\std N}
\newcommand     \Z      {\std Z}
\newcommand     \Q      {\std Q}
\newcommand     \R      {\std R}
\newcommand     \C      {\std C}
\newcommand     \Proj   {\std P}
\newcommand     \Aff    {\std A}
\newcommand     \GL     {\std{GL}}

% standard functions [[2
%
\newcommand*    \I[1]   {\std{Id}_{#1}}
\newcommand*    \ind[1] {\std{1}_{#1}}

% less standard but still usefull sets [[2
%
\newcommand\Qbar{\overline{\Q}}
\newcommand\cdn{\boldsymbol{k}}
\newcommand\Cdn{\boldsymbol{K}}

% delimiters [[2
%
\newcommand\orbrack{\mathopen\rbrack}
\newcommand\clbrack{\mathopen\lbrack}
\DeclarePairedDelimiter\abs{\lvert}{\rvert}
\DeclarePairedDelimiter\norm{\lVert}{\rVert}
\newcommand*\nnorm[1]{% argh!
  \left\lvert\hspace{-1pt}\left\lvert\hspace{-1pt}%
  \left\lvert#1\right\rvert
  \hspace{-1pt}\right\rvert\hspace{-1pt}\right\rvert}

% unsorted math stuff [[1
% -------------------

\newcommand\mmax{{\mathrm{max}}}

\newcommand\diff{\mathrm d}

% compléments de macros maths
%
\newcommand*\lgr[1]{\abs{#1}} % longueur
\newcommand*\vlg[1]{\abs{#1}} % vecteur longueur
\newcommand*\der[1]{\partial_{#1}} % dérivée divisée
\newcommand*\ncoef[1]{\mathcal N(#1)} % nombre de coefficients
\newcommand*\maxbin[1]{m(#1)} % max des coefficient binomiaux avec #1 en haut

% les six normes et mesures étudiées
%
\newcommand*\normsup[1]{\norm{#1}_\infty}
\newcommand*\normlun[1]{\norm{#1}_1}
\newcommand*\normeuc[1]{\norm{#1}_2}
\newcommand*\normhom[1]{\norm{#1}_{\mathrm h}}
\newcommand*\mespph[1]{\mathrm{M}(#1)}
\newcommand*\mahler[2][]{\mathcal M_{#1}(#2)}   % mesure de Mahler

\newcommand*\av[2][v]{\abs{#2}_{#1}}      % valeur absolue v-adique, ou indice en option
\newcommand*\nv[2][v]{\norm{#2}_{#1}}       % norme v-adique, idem
\newcommand*\nnv[2][v]{\nnorm{#2}_{#1}}     % norme v-adique d'une famille, idem
\newcommand*\nvp[2][v]{\lVert#2\rVert_{#1}}     % norme idem mais en forçant une petite taille
\newcommand\dv{{\delta\smash{_v}}}        % sélecteur v ultramétrique ou non
\newcommand\dpv{{\delta'_v}}        % idem plus places divisant 2
\newcommand{\Dv}{\mathrm{dist}_v}
\newcommand{\A}{\mathcal{A}}
\newcommand{\p}[1]{{\boldsymbol{#1}}}
\newcommand{\OA}{\p{0}}
\newcommand{\coa}{\theta}
\newcommand{\BA}{\mathfrak{B}}
\newcommand{\hn}{\hat{h}}

% objets mathématiques utiles
%
\newcommand\va{\mathcal A}
\newcommand\vai{\mathcal B}
\newcommand\point{x}
\newcommand\pointi{y}
\newcommand\pointii{z}
\newcommand\coord{{\mathrm{x}}}
\newcommand\coordi{{\mathrm{y}}}
\newcommand\genre{g}
\newcommand\fibre{\mathcal L}
\newcommand\place{v}

\newcommand*\proj[2][]{%
  \Proj\ssup{#2}\ssub{#1}}
\newcommand*\aff[2][]{%
  \Aff\ssup{#2}\ssub{#1}}
\newcommand\projd[1][]{%
  \Proj^\dimp\ssub{#1}}

\newcommand\Haut{\mathrm H}
\newcommand\Hautl{\mathrm h}
\newcommand\Hautn{\smash{\hat\Hautl}}
\newcommand\haut[2][]{%
  \Haut\ssub{#1}(#2)}
\newcommand\hautl[2][]{%
  \Hautl\ssub{#1}(#2)}
\newcommand\hautn[1]{%
  \mathop{\smash{\hat h}}(#1)}

\newcommand*\absv[2][\place]{%
  \abs{#2}\ssub{#1}}
\newcommand*\normv[2][\place]{%
  \norm{#2}\ssub{#1}}
\newcommand*\distv[3][\place]{%
  \mathop{\mathrm{dist}\ssub{#1}}(#2,#3)}

\newcommand*\scalaire[2]{%
  \langle#1,#2\rangle}
\newcommand*\angleabs[2]{%
  \widehat{(#1,#2)}}

\newcommand*\mv[2][v]{M_{#1}(#2)}     % mesure homogène en une place v ou autre
\newcommand\B{\mathcal B}       % une sous-v.a.
\newcommand*\lgt[1]{\lVert#1\rVert}     % longueur totale
\newcommand\md{\mathfrak{d}}        % le morphisme « d »
\newcommand*\MW[2][\A]{MW_{\!#1}(#2)}     % l'espace de mordell-weil de #2 sur #1
\newcommand*\hatxs{\smash{\hat x}}      % x chapeau rapetissé
\newcommand*\hatys{\smash{\hat y}}      % y chapeau rapetissé
\newcommand*\cube[1]{\mathcal C(#1)}      % le « cube » \abs{w} \le #1 et w entier

% various "epsilons"
%
\newcommand\epsz{{\eps_0}}
\newcommand\epsi{{\eps_1}}
\newcommand\epsii{{\eps_2}}
\newcommand\epsiii{{\eps_3}}

% various notations for vanishing
%
\newcommand\Stairs{\mathcal E}
\newcommand\Vanish{\@ifstar{\mathfrak{\tilde q}}{\mathfrak q}}

\newcounter{cst}
\newcommand*\cst[2][, v]{%
  \ensuremath{c\ssub{\ref{#2}#1}}}
\newcommand*\newcst[2][, v]{%
  \refstepcounter{cst}\label{#2}%
  \cst[#1]{#2}}

\newcommand\iq{{\mathfrak q}}

\newcommand\vb{{\mathbf e}}
\newcommand\Mbase{{\mathcal M}}
\newcommand\monome{{\mathfrak m}}

\newcommand\coi{{\mathfrak b}} % coordonnées de l'origine inversées
\newcommand\divi{E}
\newcommand\dimp{n}


\newcommand\ph{\ssub} % partie homogène
\newcommand\mat{M} % matrice

% multiprojectif
\newcommand\puiss{m}
\newcommand\fct{i}
\newcommand\ch[1]{X\ssub{#1}}
\newcommand\cmh[1]{X\pexp{#1}}
\newcommand\cmmh{\boldsymbol X}
\newcommand\cmhi[1]{Y\pexp{#1}}
\newcommand\cmmhi{\boldsymbol Y}


% helper macro optional arguments with second default value using a star [[2
%
\newcommand\newc@star@default[1]{%
  \expandafter\newc@star@default@
  \csname \expandafter\@gobble\string#1 \endcsname#1}
\newcommand\newc@star@default@[5]{%
  \newcommand*#1[#3][]{#5}%
  \newcommand*#2{\@ifstar{#1[#4]}{#1}}}

% the product sub-variety considered and its attributes [[2
%
\newcommand\Var{Z}
\newc@star@default \var     {1}{\fct} {\Var\pexp{#1}}
\newc@star@default \vardim  {1}{\fct} {{u\ssub{#1}}}
\newc@star@default \vardeg  {1}{\fct} {{D\ssub{#1}}}
\newc@star@default \varht   {1}{\fct} {\Haut\pexp{#1}[\Var]}
\newc@star@default \varfc   {1}{\fct} {\Chow\pexp{#1}[\Var]}
\newc@star@default \varid   {1}{\fct} {\Ideal\pexp{#1}[\Var]}

\newc@star@default \excep   {1}{\fct} {e\ssub{#1}}
\newc@star@default \weight  {1}{\fct} {a\ssub{#1}}

% weithed embeding
\newcommand\wemb[1][\weight]{\varphi\ssub{#1}}
\newcommand\wemba[1][\weight]{\psi\ssub{#1}} % associated morphims of algebras

% (homogenous, saturated) ideal of a variety
\newcommand\Ideal{\mathcal I}
\newcommand*\ideal[1]{\Ideal_{#1}}
% ring of (homogenous) coordinates of a variety
\newcommand\Ring{\mathcal R}
\newcommand*\ring[1]{\Ring_{#1}}
% (homogenous) fraction field of a variety
\newcommand\Korper{\mathcal K}
\newcommand\korper[1]{\Korper(#1)}
% zeros of polynomials
\newcommand\Zeros{\mathcal Z}
\newcommand\zeros[1]{\Zeros(#1)}
% Chow form of a variety
\newcommand\Chow{f}
\newcommand\chow[1]{\Chow_{#1}}

% reduction morphisms
\newcommand\rdiv{\rho_{\text{div}}}
\newcommand\relim{\rho_{\text{elim}}}


\newcommand\longto{\longrightarrow}
\newcommand\embedin{\hookrightarrow}

\newcommand\opdef{{\mathcal U}}

% [[1
% vim: ft=tex fdm=marker foldmarker=[[,]] foldlevel=1
