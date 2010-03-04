\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{mpg-preth}

% booleans for options, default values
%
\newif\if@webversion    \@webversionfalse
\newif\if@showbad       \@showbadtrue
\newif\if@domark        \@domarktrue

% options
%
\DeclareOption {web}    {\@webversiontrue}
\DeclareOption {nobad}  {\@showbadfalse}
\DeclareOption {nomark} {\@domarkfalse}
\ProcessOptions \relax

% use Koma-article with custom encoding and fonts
%
\LoadClass[a4paper, 11pt, twoside, BCOR=1cm]{scrartcl}
\usepackage[utf8]{inputenc}
\usepackage[T1]{fontenc}
\usepackage[sc, osf]{mathpazo} \linespread{1.05}
\usepackage{amssymb}
\renewcommand\sfdefault{iwona}

% load various usefull packages
%
\usepackage{mathtools, amsthm}
\usepackage[all]{xy}
\usepackage{ifmtarg, fixltx2e, mparhack, xargs, xspace}
\usepackage{enumitem}
\usepackage{git-info, eso-pic, xcolor}
\usepackage{csquotes}
\usepackage[style=alphabetic, sorting=nyt, sortcites=true,
  autopunct=true, babel=hyphen,
  hyperref=true, backref=false]{biblatex}
\usepackage[expansion=false, babel=true]{microtype}
\usepackage[british, frenchb]{babel}
\if@webversion\else \PassOptionsToPackage{bookmarks=false}{hyperref} \fi
\usepackage[colorlinks=true]{hyperref}

% hyperref settings (web option)
%
\if@webversion
  \hypersetup{urlcolor=blue, linkcolor=red, citecolor=green,
    bookmarksnumbered=true}
\else
  \hypersetup{urlcolor=black, linkcolor=black, citecolor=black}
\fi

% overfullrule (nobad option)
%
\setlength{\overfullrule}{\if@showbad 5\else 0\fi pt}

% use git information (nomark option)
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

% generic title information
%
\author{Manuel \bsc{Pégourié-Gonnard}}
\subtitle{Notes de travail}
\date{}
\hypersetup{pdfauthor={Manuel Pégourié-Gonnard}}

% bibliography settings
%
\bibliography{these}
\defbibheading{bibempty}{}

% frenchb settings
%
\frenchbsetup{og=«,fg=»,
  AutoSpacePunctuation=false,
  SuppressWarning=true}

% misc unsorted stuff from now on
% -------------------------------

\newcommand*\notemarge[1]{\marginpar[\raggedleft #1]{\raggedright #1}}
\newcommand\todotext{\textsc{todo}}
\newcommand*\todo[1][]{%
  \leavevmode\notemarge{\todotext}%
\@ifnotmtarg{#1}{\emph{#1}}}
\newcommand*\todom[1][]{\tag{\todotext%
  \@ifnotmtarg{#1}{ : #1}}}

\newenvironment{enumthm}
  {\begin{enumerate}[label=(\textit{\roman*})]}
  {\end{enumerate}}

\newcommand*\lat[1]{\emph{#1}}
\newcommand*\eng[1]{%
  \foreignlanguage{english}{\emph{#1}}}
\newcommand*\defn[1]{\emph{#1}}
\newcommand*\pmm[1]{\text{ #1}}

\newcommand*\ssub[1]{%
  \@ifnotmtarg{#1}{_{#1}}}
\newcommand*\ssup[1]{%
  \@ifnotmtarg{#1}{^{#1}}}
\newcommandx*\pexp[2][2]{%
  \@ifmtarg{#2}{%
    \@ifnotmtarg{#1}{\cramped{^{(#1)}}}%
    }{%
    \@ifnotmtarg{#1}{^{(#1)}}_{#2}}}

\newcommand\suchthat{\ \middle\vert\ }

\newcommand*\std[1]{\mathbf{#1}} \newcommand\N{\std N} \newcommand\Z{\std Z}
\newcommand\Q{\std Q} \newcommand\R{\std R} \newcommand\C{\std C}
\newcommand\Proj{\std{P}} \newcommand\Aff{\std{A}}
\newcommand\Qbar{\overline{\Q}}
\newcommand\cdn{\boldsymbol{k}} \newcommand\Cdn{\boldsymbol{K}}
\newcommand*\I[1]{\std{Id}_{#1}} \newcommand*\ind[1]{\std{1}_{#1}}
\renewcommand\ge{\geqslant} \renewcommand\le{\leqslant}
\newcommand\orbrack{\mathopen\rbrack} \newcommand\clbrack{\mathopen\lbrack}

\newcommand*\abs[1]{\left\lvert#1\right\rvert}
\newcommand*\norm[1]{\left\lVert#1\right\rVert}
\newcommand*\nnorm[1]{%
  \left\lvert\hspace{-1pt}\left\lvert\hspace{-1pt}%
  \left\lvert#1\right\rvert
  \hspace{-1pt}\right\rvert\hspace{-1pt}\right\rvert}

\newcommand\eps{\varepsilon}
\newcommand\truc{{\,\cdot\,}}
\DeclareMathOperator\disc{Disc}
\DeclareMathOperator\ord{ord}
\DeclareMathOperator\Div{div}

\newcommand\zeros{\mathcal Z}
\newcommand\ideal{\mathcal I}

\newcommand\mmax{{\mathrm{max}}}

\newcommand\diff{\mathrm d}

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

% ---------------------------------------------------------------------------- %
%                          anciennement pre-normes
% ---------------------------------------------------------------------------- %

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
% \newcommand*\mahler[1]{\mathcal{M}(#1)}
\newcommand*\mahler[2][]{\mathcal M_{#1}(#2)}   % mesure de Mahler

% ---------------------------------------------------------------------------- %
%                          anciennement pre-mumpt
% ---------------------------------------------------------------------------- %

% \newcommand{\av}[2][v]{\left\lvert#2\right\rvert_{#1}}
% \newcommand{\nv}[2][v]{\left\lVert#2\right\rVert_{#1}}
% \newcommand{\nnv}[2][v]{%
%   \left\lvert\hspace{-1pt}%
%   \left\lvert\hspace{-1pt}%
%   \left\lvert#2\right\rvert%
%   \hspace{-1pt}\right\rvert%
%   \hspace{-1pt}\right\rvert_{#1}}
% \newcommand{\nvp}[2][v]{\|#2\|_{#1}}
\newcommand*\av[2][v]{\abs{#2}_{#1}}      % valeur absolue v-adique, ou indice en option
\newcommand*\nv[2][v]{\norm{#2}_{#1}}       % norme v-adique, idem
\newcommand*\nnv[2][v]{\nnorm{#2}_{#1}}     % norme v-adique d'une famille, idem
\newcommand*\nvp[2][v]{\lVert#2\rVert_{#1}}     % norme idem mais en forçant une petite taille
% \newcommand{\dv}{{\delta_v}}
\newcommand\dv{{\delta\smash{_v}}}        % sélecteur v ultramétrique ou non
\newcommand{\Dv}{\mathrm{dist}_v}
\newcommand{\A}{\mathcal{A}}
\newcommand{\p}[1]{{\boldsymbol{#1}}}
\newcommand{\OA}{\p{0}}
\newcommand{\coa}{\theta}
\newcommand{\BA}{\mathfrak{B}}
\newcommand{\hn}{\hat{h}}
% \newcommand{\lgr}[1]{{|#1|}}
% \newcommand{\vlg}[1]{\lgr #1}

% ---------------------------------------------------------------------------- %
%                          anciennement pre-idee
% ---------------------------------------------------------------------------- %

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

\DeclareMathOperator\Haut{H}
\newcommand\haut[1]{%
  \Haut(#1)}
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

% ---------------------------------------------------------------------------- %
%                          anciennement pre-mumgrp
% ---------------------------------------------------------------------------- %

% \newcommand*\av[2][v]{\abs{#2}_{#1}}      % valeur absolue v-adique, ou indice en option
% \newcommand*\nv[2][v]{\norm{#2}_{#1}}       % norme v-adique, idem
% \newcommand*\nnv[2][v]{\nnorm{#2}_{#1}}     % norme v-adique d'une famille, idem
% \newcommand*\nvp[2][v]{\lVert#2\rVert_{#1}}     % norme idem mais en forçant une petite taille
\newcommand*\mv[2][v]{M_{#1}(#2)}     % mesure homogène en une place v ou autre
% \newcommand*\mahler[2][]{\mathcal M_{#1}(#2)}   % mesure de Mahler
% \newcommand\dv{{\delta\smash{_v}}}        % sélecteur v ultramétrique ou non
\newcommand\dpv{{\delta'_v}}        % idem plus places divisant 2
% \newcommand\Dv{\mathrm{dist}_v}       % distance v-adique projective
% \newcommand\A{\mathcal A}         % la variété abélienne
\newcommand\B{\mathcal B}       % une sous-v.a.
% \newcommand*\p[1]{\boldsymbol{#1}}      % un point ; on notera en « normal » ses coordonnées
% \newcommand\OA{\p 0}          % l'origine de la variété
% \newcommand\coa{\theta}         % des coordonnées de l'origine
% \newcommand\BA{\mathfrak b}         % vecteur "B" avec coordonnées inverses de l'origine
% \newcommand\hn{\smash{\hat h}}        % la hauteur normalisée
% \newcommand*\lgr[1]{{\lvert#1\rvert}}     % longueur d'un multi-indice
% \newcommand*\vlg[1]{\lgr#1}         % multi-longueur partielles d'un multi-multi-indice
\newcommand*\lgt[1]{\lVert#1\rVert}     % longueur totale
\newcommand\md{\mathfrak{d}}        % le morphisme « d »
\newcommand*\MW[2][\A]{MW_{\!#1}(#2)}     % l'espace de mordell-weil de #2 sur #1
\newcommand*\hatxs{\smash{\hat x}}      % x chapeau rapetissé
\newcommand*\hatys{\smash{\hat y}}      % y chapeau rapetissé
\newcommand*\cube[1]{\mathcal C(#1)}      % le « cube » \abs{w} \le #1 et w entier

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

% ---------------------------------------------------------------------------- %
%                          anciennement pre-siegel
% ---------------------------------------------------------------------------- %

% \newcommand\va{{\mathcal A}}
\newcommand\coi{{\mathfrak b}} % coordonnées de l'origine inversées
% \newcommand\point{x}
% \newcommand\pointi{y}
% \newcommand\coord{{\mathrm{x}}}
% \newcommand\coordi{{\mathrm{y}}}
% \newcommand\genre{g}
% \newcommand\fibre{{\mathcal L}}
% \newcommand\place{v}
\newcommand\divi{E}
\newcommand\dimp{n}

\newcommand\ph{\ssub} % partie homogène
\newcommand\mat{M} % matrice

% multiprojectif
\newcommand\puiss{m}
\newcommand\fct{i}
\newcommand\ch[1]{X\ssub{#1}}
\newcommand\cmh[1]{X\pexp{#1}}

% la sous-variété produit et ses attribus
\newcommand\varname{Z}
\newcommand\var[1][]{\varname\pexp{#1}}
\newcommand\vardim[1][]{{u\ssub{#1}}}
\newcommand\vardeg[1][]{{D\ssub{#1}}}
\newcommand\varht[1][]{\Haut\pexp{#1}[\varname]}
\newcommand\varfc[1][]{\Chow\pexp{#1}[\varname]}
\newcommand\varid[1][]{\Ideal\pexp{#1}[\varname]}

% \newcommand*\proj[2][]{%
%   \Proj\ssup{#2}\ssub{#1}}
% \newcommand*\aff[2][]{%
%   \Aff\ssup{#2}\ssub{#1}}

\newcommand\Chow{f}

% \newcommand\Haut{h}
% \newcommand\haut[1]{%
%   \Haut(#1)}
% \newcommand\hautn[1]{%
%   \mathop{\smash{\hat \Haut}}(#1)}

\newcommand\Ideal{\mathcal I}
\let\ideal\relax % en attendant de rendre mes trucs cohérents
\newcommand*\ideal[1]{%
  \Ideal\ssub{#1}}

% \newcommand*\absv[2][\place]{%
%   \abs{#2}\ssub{#1}}
% \newcommand*\normv[2][\place]{%
%   \norm{#2}\ssub{#1}}
% \newcommand*\distv[3][\place]{%
%   \mathop{\mathrm{dist}\ssub{#1}}(#2,#3)}
% 
% \newcommand*\scalaire[2]{%
%   \langle#1,#2\rangle}
% \newcommand*\angleabs[2]{%
%   \widehat{(#1,#2)}}

% vim: ft=tex
