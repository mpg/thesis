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

% nomenclature [[2
%
\makenomenclature

\newcommand*\nom@type[2]{%
  \newcommand*#1[2]{%
    \nomenclature[#2-##1--]{$##2$}}}

\nom@type \noms A % first symbols
\nom@type \nomn B % then numeric
\nom@type \nomg C % then greek letter
\nom@type \noma D % finally alphabetic stuff

% placeholders for descriptions
\newcommand*\nom@ph[2]{%
  \newcommand#1{\ensuremath{\text{\color{gray}$#2$}}\xspace}}

\nom@ph \PH   \bullet
\nom@ph \PHi  \star

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
\newcommand*\marginnote[1]{\marginpar[\raggedleft #1]{\raggedright #1}}
\newcommand*\worknote[1]{\marginnote{\leavevmode\color{black!50}\itshape #1}}
\newcommand\todo{\worknote{\textsc{todo}}}
\newcommand\todom{\tag{\textsc{todo}}}
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

% shortcut macros [[2
%
\newcommand \NT  {\bsc{Néron}-\bsc{Tate}\xspace}
\newcommand \MoW {\bsc{Mordell}-\bsc{Weil}\xspace}

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
\newcommand*\I[1]{\std{Id}_{#1}}
\newcommand*\ind[1]{\std{1}_{#1}}

\noma{Id}{\I\PH}{Fonction identité sur l'ensemble \PH}
\nomn{1}{\ind\PH}{Fonction indicatrice de l'ensemble \PH}

% less standard but still usefull sets [[2
%
\newcommand\Qbar{\overline{\Q}}
\newcommand\cdn{\boldsymbol{k}}
\newcommand\Cdn{\boldsymbol{K}}

\noma{Q}{\Qbar}{Une clôture algébrique fixée de $\Q$}
\noma{k}{\cdn}{Un corps de nombres}
\noma{K}{\Cdn}{Une extension finie de $\cdn$}

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
\noma{d}{\diff\PH}{Différentielle par rapport à \PH}

\newcommand{\p}[1]{{\boldsymbol{#1}}} % point (par opposition à coordonnées)

% compléments de macros maths
%
\newcommand*\lgr[1]{\abs{#1}}
\newcommand*\vlg[1]{\abs{#1}}
\newcommand*\der[1]{\partial_{#1}}
\newcommand*\ncoef[1]{\mathcal N(#1)}
\newcommand*\maxbin[1]{m(#1)}

\noms{n}{\lgr\PH}{Longueur du multi-indice \PH}
\noms{n}{\vlg\PH}{Vecteur des longueurs du multi-multi-indice \PH}
\noma{d}{\der\PH}{Dérivée divisée par rapport à \PH}
\noma{N}{\ncoef\PH}{Nombre de coefficients du polynôme \PH}
\noma{m}{\maxbin\PH}{Maximum des coefficients binomiaux $\binom\PH{i}$}

% les six normes et mesures étudiées
%
\newcommand*\normsup[1]{\norm{#1}_\infty}
\newcommand*\normlun[1]{\norm{#1}_1}
\newcommand*\normeuc[1]{\norm{#1}_2}
\newcommand*\normhom[1]{\norm{#1}_{\mathrm h}}
\newcommand*\mespph[1]{\mathrm{M}(#1)}
\newcommand*\mahler[2][]{\mathcal M_{#1}(#2)}

\noma{M}{\mespph\PH}{Mesure à la \bsc{Philippon} de la forme \PH}
\noma{M}{\mahler\PH}{Mesure de \bsc{Mahler} de la forme \PH}

\newcommand*\av[2][v]{\abs{#2}_{#1}}
\newcommand*\nv[2][v]{\norm{#2}_{#1}}
\newcommand*\nnv[2][v]{\nnorm{#2}_{#1}}
\newcommand*\nvp[2][v]{\lVert#2\rVert_{#1}} % \nv avec petits délimiteurs

\noms{nv}{\av\PH}{Valeur absolue $v$-adique d'un nombre}
\noms{Nv2}{\nv\PH}{Norme $v$-adique d'un vecteur ou d'une forme}
\noms{Nv3}{\nnv\PH}{Norme $v$-adique d'un multi-vecteur ou d'une forme
  multi-homogène}

\newcommand\dv{{\delta\smash{_v}}}        % sélecteur v ultramétrique ou non
\newcommand\dpv{{\delta'_v}}        % idem plus places divisant 2

\noma{dv1}{\dv}{Vaut $1$ si $v$ est archimédienne, est nul sinon}
\noma{dv2}{\dpv}{Vaut $1$ si $v$ est archimédienne ou divise $2$, nul sinon}

\newcommand{\Dv}{\mathrm{dist}_v}

\noma{Dv}{\Dv}{Distance $v$-adique projective (\todo entre point et variété
  seulement, ou aussi entre points, ou bien ?)}

\newcommand{\A}{\mathcal{A}}
\newcommand{\BA}{\mathfrak{B}}
\newcommand{\OA}{\p{0}}
\newcommand{\coa}{\theta}

\noma{A}{\A}{La variété abélienne ambiante (\todo macro dupliquée)}
\noma{BA}{\BA}{Une sous-variété abélienne fixée de $\A$ (\todo macro
  dupliquée)}

\nomn{0}{\OA}{L'origine de $\A$}
\nomg{theta}{\coa}{Les coordonnées de l'origine de $\A$ dans un plongement de
  \bsc{Mumford} modifié fixé (\todo à quel moment précisément on le fixe, ce
    plongement ?)}

\newcommand{\hn}{\hat{h}}

\noma{hn}{\hn}{Hauteur normalisée de \bsc{Néron}-\bsc{Tate} (\todo macro
  dupliquée ?)}

% objets mathématiques utiles
%
\newcommand\va{\mathcal A}
\newcommand\vai{\mathcal B}
\newcommand\genre{g}
\newcommand\fibre{\mathcal L}

\noma{A}{\va}{La variété abélienne ambiante}
\noma{B}{\vai}{Une sous-variété abélienne fixée de $\va$}
\noma{g}{\genre}{La dimension de $\va$}

\newcommand\point{x}
\newcommand\pointi{y}
\newcommand\pointii{z}
\newcommand\coord{{\mathrm{x}}}
\newcommand\coordi{{\mathrm{y}}}

\noma{x}{\point}{Un point non fixé (\todo vraiment ?) de $\va$}
\noma{y}{\point}{Un autre point non fixé (\todo vraiment ?) de $\va$}
\noma{z}{\point}{Encore un autre point non fixé de $\va$}

\newcommand\place{v}

\noma{v}{\place}{Une place, en général non fixée, de $\cdn$}

\newcommand*\proj[2][]{%
  \Proj\ssup{#2}\ssub{#1}}
\newcommand*\aff[2][]{% TODO: \! exposant ?
  \Aff\ssup{#2}\ssub{#1}}
\newcommand\projd[1][]{%TODO: \! exposant ?
  \Proj^\dimp\ssub{#1}}

\noma{P}{\proj\PH}{L'espace projectif standard de dimension \PH}
\noma{A}{\aff\PH}{L'espace affine standard de dimension \PH}

\newcommand \Haut  {\mathrm H}
\newcommand \Hautl {\mathrm h}
\newcommand \Hautn {\smash{\hat\Hautl}}

\newcommand \haut  [2][] {\Haut \ssub{#1}(#2)}
\newcommand \hautl [2][] {\Hautl\ssub{#1}(#2)}
\newcommand \hautn [1]   {\Hautn         (#1)}

\noma{h}{\haut [\PHi]{\PH}}{Hauteur projective multiplicative de \PH en
  utilisant la norme \PHi aux places archimédiennes}
\noma{h}{\hautl[\PHi]{\PH}}{Hauteur projective logarithmique de \PH en
  utilisant la norme \PHi aux places archimédiennes}
\noma{h}{\hautn[\PHi]{\PH}}{Hauteur normalisée à la \bsc{Néron}-\bsc{Tate} de
  \PH}

\newcommand* \absv  [2][\place] {\abs {#2}\ssub{#1}}
\newcommand* \normv [2][\place] {\norm{#2}\ssub{#1}}
\newcommand* \distv [3][\place] {\mathop{\mathrm{dist}\ssub{#1}}(#2,#3)}

\noms{nv} {\absv\PH }{Valeur absolue $v$-adique d'un nombre}
\noms{Nv2}{\normv\PH}{Norme $v$-adique d'un vecteur ou d'une forme}

\newcommand* \scalaire [2] {\langle#1,#2\rangle}
\newcommand* \angleabs [2] {\widehat{(#1,#2)}}

\noms{angle}{\scalaire\PH\PHi}{Produit scalaire, relativement à la forme
  quadratique de \NT, des points \PH et \PHi de $\va$ ou de son espace de \MoW}
\noms{hat}{\angleabs\PH\PHi}{Angle non orienté, relativement à la forme
  quadratique de \NT, entre les points \PH et \PHi de $\va$ ou de son espace
  de \MoW}

\newcommand*\mv[2][\place]{M_{#1}(#2)}     % mesure homogène en une place v ou autre
\newcommand\B{\mathcal B}       % une sous-v.a.
\newcommand*\lgt[1]{\lVert#1\rVert}     % longueur totale
\newcommand\md{\mathfrak{d}}        % le morphisme « d »
\newcommand*\MW[2][\A]{MW_{\!#1}(#2)}     % l'espace de mordell-weil de #2 sur #1
\newcommand*\hatxs{\smash{\hat x}}      % x chapeau rapetissé
\newcommand*\hatys{\smash{\hat y}}      % y chapeau rapetissé
\newcommand*\cube[1]{\mathcal C(#1)}      % le « cube » \abs{w} \le #1 et w entier

\noma{M}{\mv\PH}{Mesure homogène (\todo laquelle ?) locale en $\place$ de la
  forme \PH}
\noma{B}{\B}{Une sous-variété (\todo fixée ?) de $\va$}
\noms{N}{\lgt\PH}{Longueur totale du multi-multi-indice \PH}
\noma{MW}{\MW\PH}{Espace de \MoW de \PH}

\noma{C}{\cube\PH}{L'ensemble des points à coordonnées entières du cube de
  demi-arête \PH centré en l'origine}

% various "epsilons"
%
\newcommand\epsz{{\eps_0}}
\newcommand\epsi{{\eps_1}}
\newcommand\epsii{{\eps_2}}
\newcommand\epsiii{{\eps_3}}

\nomg{eps0}{\epsz}{Un epsilon (\todo portée à préciser)}
\nomg{eps1}{\epsi}{Un autre epsilon (\todo portée à préciser)}
\nomg{eps2}{\epsii}{Encore un autre epsilon (\todo portée à préciser)}
\nomg{eps3}{\epsiii}{Toujours un autre epsilon (\todo portée à préciser)}

% various notations for vanishing
%
\newcommand\Stairs{\mathcal E}
\newcommand\Vanish{\@ifstar{\mathfrak{\tilde q}}{\mathfrak q}}

\noma{E}{\Stairs}{Dessous de (multi ?) escalier (\todo paramètres à préciser)}
\noma{q1}{\Vanish}{Idéal d'annulation pour la forme auxiliaire plus (ou
  modulo) l'idéal de la variété ambiante (\todo préciser ?)}
\noma{q2}{\Vanish*}{Idéal d'annulation pour la forme auxiliaire}

\newcounter{cst}
\newcommand*\cst[2][, v]{%
  \ensuremath{c\ssub{\ref{#2}#1}}}
\newcommand*\newcst[2][, v]{%
  \refstepcounter{cst}\label{#2}%
  \cst[#1]{#2}}

\noma{cvx}{c_{\PH, \PHi}}{Constante (en général intermédiaire) numéro \PH,
  éventuellement dépendante de la place \PHi}

\newcommand\iq{{\mathfrak q}}

\noma{q0}{iq}{Idéal d'annulation pour la forme auxiliare (\todo dupliqué ;
  quelle version ?)}

\newcommand\vb{{\mathbf e}}
\newcommand\Mbase{{\mathcal M}}
\newcommand\monome{{\mathfrak m}}

\noma{e}{\vb}{Vecteur \todo ??? (de base ?)}
\noma{M}{\Mbase}{Matrice d'une application dans une base donnée (\todo sûr ?
  paramètre ?)}
\noma{m}{\monome}{Un monome (\todo fixé, avec des paramètres ?)}

\newcommand\coi{{\mathfrak b}} % coordonnées de l'origine inversées
\newcommand\divi{E}
\newcommand\dimp{n}

\noma{b}{\coi}{Vecteur dont les composantes sont les inverses de composantes
  de $\coa$ bien choisies}
\noma{E}{\divi}{Le diviseur dont on étudie les approximatons exceptionnelles}
\noma{n}{\dimp}{Dimension de l'espace projectif ambiant (\todo expliciter la
  portée si on change de plongements des fois)}

\newcommand\ph{\ssub} % partie homogène
\newcommand\mat{M} % matrice

\noms{}{\PH\ph\PHi}{Partie homogène de degré \PHi de l'algèbre (multi-)graduée
  ou idéal (multi-)homogène \PH}
\noma{M}{\mat}{Une matrice (\todo qui, où, comment, pourquoi ?)}

% multiprojectif
\newcommand\puiss{m}
\newcommand\fct{i}
\newcommand\fctrange{_{\fct=1}^\puiss}
\newcommand\ch[1]{X\ssub{#1}}
\newcommand\cmh[1]{X\pexp{#1}}
\newcommand\cmmh{\boldsymbol X}
\newcommand\cmhi[1]{Y\pexp{#1}}
\newcommand\cmmhi{\boldsymbol Y}

\noma{m}{\puiss}{Le nombre d'approximations exceptionnelles étudiées,
  donc aussi la puissance de $\va$ dans laquelle ont travaille.}
\noma{i}{\fct}{Un indice entier, variant en général entre $1$ et $\puiss$
  (\todo pas vrai partout!)}
%TODO: \ch etc

% helper macro for optional arguments that are empty by default, [[2
% but have a second default value, accessed using the starred form
%
% \newcs@start@default <name> <arg. nb.> <2nd default> <repl. text>
\newcommand\newc@star@default[1]{%
  \expandafter\newc@star@default@
  \csname \expandafter\@gobble\string#1 \endcsname#1}% TODO: use \cmdstring
\newcommand\newc@star@default@[5]{%
  \newcommand*#1[#3][]{#5}%
  \newcommand*#2{\@ifstar{#1[#4]}{#1}}}
% Maybe to-do: use a \bgroup-\egroup trick to make the macros usable as
% indices/exponents without braces?

% the product sub-variety considered and its attributes [[2
%
\newcommand\Var{Z}
\newc@star@default \var     {1}{\fct} {\Var\pexp{#1}}
\newc@star@default \vardim  {1}{\fct} {{u\ssub{#1}}}
\newc@star@default \vardeg  {1}{\fct} {{D\ssub{#1}}}
\newc@star@default \varht   {1}{\fct} {\Haut\pexp{#1}[\Var]}
\newc@star@default \varfc   {1}{\fct} {\Chow\pexp{#1}[\Var]}
\newc@star@default \varid   {1}{\fct} {\Ideal\pexp{#1}[\Var]}

\noma{Z} {\var    }{La variété produit utilisée dans la preuve de \bsc{Vojta}}
\noma{Zi}{\var*   }{Le $\fct$-ième facteur de $\var$}
\noma{u} {\vardim }{Le vecteur des dimensions des facteurs de $\var$}
\noma{ui}{\vardim*}{La dimension de $\var*$}
\noma{D} {\vardeg }{Le vecteur des degrés de facteurs de $\var$}
\noma{Di}{\vardeg*}{Le degré de $\var*$}
\noma{H} {\varht  }{La hauteur projective multiplicative de $\var$}
\noma{Hi}{\varht* }{La hauteur projective multiplicative de $\var*$}
\noma{f} {\varfc  }{La forme de \bsc{Chow} (\todo normalisée ?) de $\var$}
\noma{fi}{\varfc* }{La forme de \bsc{Chow} (\todo normalisée ?) de $\var*$}
\noma{I} {\varid  }{L'idéal multi-homogène sature de $\var$}
\noma{Ii}{\varid* }{L'idéal multi-homogène sature de $\var*$}

\newc@star@default \excep   {1}{\fct} {e\ssub{#1}}
\newc@star@default \weight  {1}{\fct} {a\ssub{#1}}

\noma{e}{\excep}{La famille d'approximations exceptionnelles considérée}
\noma{a}{\weight}{Le vecteur de poids associé à $\excep$}

% weithed embeding
\newcommand\wemb  [1][\weight] {\varphi\ssub{#1}}
\newcommand\wemba [1][\weight] {\psi\ssub{#1}}

\nomg{phi}{\wemb }{Plongement éclatant associé au vecteur de poids $\weight$}
\nomg{psi}{\wemba}{Morphisme d'allgèbres graduées associé au plongement
  éclatant $\wemb$}

\newcommand\Ideal{\mathcal I}
\newcommand*\ideal[1]{\Ideal_{#1}}
\noma{I}{\ideal\PH}{Idéal (multi-)homogène saturé de la variété plongée \PH}

\newcommand\Ring{\mathcal R}
\newcommand*\ring[1]{\Ring_{#1}}
\noma{R}{\ring\PH}{Anneau des coordonnées (multi-)homogènes de la variété
  plongée \PH}

\newcommand\Korper{\mathcal K}
\newcommand\korper[1]{\Korper(#1)}
\noma{K}{\korper\PH}{Corps des fonctions rationnelles de la variété \PH}

\newcommand\Zeros{\mathcal Z}
\newcommand\zeros[1]{\Zeros(#1)}
\noma{Z}{\zeros\PH}{Lieu des zéros de la (famille de) forme(s) \PH}

\newcommand\Chow{f}
\newcommand\chow[1]{\Chow_{#1}}
\noma{f}{\chow\PH}{Forme de \bsc{Chow} de la variété plongée \PH}

\newcommand\rdiv{\rho_{\text{div}}}
\newcommand\relim{\rho_{\text{elim}}}

\nomg{rho}{\rdiv}{Morphimse de réduction par division dans la construction de
  la forme auxiliaire pour l'inégalité de \bsc{Vojta}}
\nomg{rho}{\relim}{Morphisme de réduction par élimination de variables dans le
  construction de la forme auxiliaire pour l'inégalité de \bsc{Vojta}}

\newcommand\longto{\longrightarrow}
\newcommand\embedin{\hookrightarrow}

\newcommand\opdef{{\mathcal U}}

\noma{U}{\opdef}{Ouvert de définition d'un certain morphisme (\todo préciser)}

% global or long-term notations without a dedicated macro [[2
% (btw, isn't this evil?)
%
\noma{d}{d}{Le degré, divisé par $\delta$, de la forme auxiliaire (\todo ou
  son tiré ou poussé ?)}
\noma{d'}{d'}{Le degré, divisé par $\delta$, de la forme auxiliaire (\todo ou
  son tiré ou poussé ?)}
\nomg{delta}{\delta}{Un entier suffisament divisible et grand, gouvernant
  l'ordre de grandeur du degré de la forme auxiliaire}
\noma{C}{C', C'', C'''}{Conditions variées sur les degrés, servant à définir
  des sous-espaces vectoriels de partie homogènes d'algèbres de polynômes}
\nomg{lambda}{\lambda}{Souvent un multi-multi-indice dans la définition de
  dessous-d'escalier-oïdes}

\noma{r}{r}{La correction de degré d'un tiré ou poussé de la forme auxiliaire
  (\todo à préciser)}

% [[1
% vim: ft=tex fdm=marker foldmarker=[[,]] foldlevel=1
