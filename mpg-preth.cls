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

