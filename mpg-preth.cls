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
\setlength{\overfullrule}{5pt}

% option declarations [[2
%
\DeclareOption {full}   {\let\includeonly\@gobble}
\DeclareOption {pph}    {\@privatefalse}
\DeclareOption {nomark} {\@domarkfalse}
\DeclareOption {final}  {
  \let\includeonly\@gobble \@privatefalse \@domarkfalse
  \setlength{\overfullrule}{0pt}
}
\ProcessOptions \relax

% use Koma with custom encoding and fonts and colors [[2
%
\LoadClass[a4paper, twoside, BCOR=1cm, 11pt]{scrbook}
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

% frenchb settings [[2
%
\frenchbsetup{og=«,fg=»,
  AutoSpacePunctuation=false,
  ThinColonSpace=true,
  SuppressWarning=true,
}
% nbsp treated as a normal space (to let frenchb do its job)
\DeclareUnicodeCharacter{00A0}{ }

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

\newcommand \sbin [2] {{\textstyle\binom{#1}{#2}}}

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

% standard functions [[2
%
\newcommand*\I     [1][] {\std{Id}\ssub{#1}}
\newcommand*\indic [1]   {\std{1}\ssub{#1}}

% less standard but still usefull sets [[2
%
\newcommand \Qbar {\overline\Q}
\newcommand \cdn {{\boldsymbol k}}
\newcommand \Cdn {{\boldsymbol K}}

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

% integer parts [[3
\DeclarePairedDelimiter \floor {\lfloor} {\rfloor}
\DeclarePairedDelimiter \ceil  {\lceil } {\rceil }

% scalar product [[3
\DeclarePairedDelimiter \scal \langle \rangle

% general algebraic geometry [[2
%
\newcommand \Ideal {\mathcal I}
\newcommand*\ideal [1] {\Ideal\sb{#1}}

\newcommand \Ring {\mathcal R}
\newcommand*\ring [1] {\Ring\sb{#1}}

\newcommand \Korper {\mathcal K}
\newcommand*\korper [1] {\Korper(#1)}

\newcommand \Zeros {\mathcal Z}
\newcommand*\zeros [1] {\Zeros(#1)}

\newcommand \Chow {f}
\newcommand*\chow [1] {\Chow\sb{#1}}

\newcommand \md {\mathfrak{d}}

% missing operators & general symbols [[2
%
\DeclareMathOperator \Diff {d}
\newcommand*\diff[1][] {\Diff\ssup{#1}}

\newcommand*\der [1][] {\partial\ssup{#1}}

\DeclareMathOperator \card {Card}
\DeclareMathOperator \vect {Vect}

\newcommand*\expb {\mathrm e}

\DeclareMathOperator \Aind {Ind}
\DeclareMathOperator \ord  {Ord}

\DeclareMathOperator \supp {Supp}

\newcommand*\parts [1] {\mathcal P(#1)}

\newcommand \torsion {\mathrm{tor}}

\newcommand \miness {\mu^{\mathrm{ess}}}
\newcommand \minessn{\hat\mu^{\mathrm{ess}}}

% automatic constants [[2
%
\AtBeginDocument{\let\mpg@label\label}

% print an automatic constant
\newcounter{cst}
\newcommandx*\cst [2][2] {%
  \ensuremath{ c\sb{
      \ref{cst@#1}
      \@ifmtarg{#2}{
        \@nameuse{cst@@#1}
      }{
        , #2
      }
    }
  }%
}

% define an automatic constant
% Warning: puts a label e:cst-<name>, no other label allowed for this equation
\newcommand*\newcst [2][v] {%
  \begingroup
  \let\showkeyslabelformat\@gobble
  \refstepcounter{cst}%
  \mpg@label{cst@#2}%
  \endgroup
  \@ifnotmtarg{#1}{%
    \protected@write\@auxout{}{\global\string\@namedef{cst@@#2}{, #1}}%
  }%
  \if@display
    \label{e:cst-#2}%
  \fi
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
\newcommand \oa    {\boldsymbol 0}

\newcommand*\MW[2][\va]{MW\sb{\!#1}(#2)}

\newcommand*\nnt {\abs} % norme de Néron-Tate
\newcommand*\scalnt [2] {\scal{#1, #2}} % produit scalaire associé

\newcommand \placesapx  { \mathcal S }
\newcommand \placerange { \sb{v \in \placesapx} }

\newcommand*\wtapx [1][v] { \lambda\ssub{#1} }
\newcommand*\degv  [1][v] { \Delta \ssub{#1} }

\newcommand \grp { \Gamma } % sous-groupe de rang r

% archimedian norms and measures [[2
%
\newcommand*\normsup [1]   {\norm{#1}\sb\infty}
\newcommand*\normlun [1]   {\norm{#1}\sb1}
\newcommand*\normeuc [1]   {\norm{#1}\sb2}
\newcommand*\normhom [1]   {\norm{#1}\sb{\mathrm h}}

\newcommand*\mespph  [2][] {\mathrm  M\ssub{#1}\@ifnotmtarg{#2}{(#2)}}
\newcommand*\mahler  [2][] {\mathcal M\ssub{#1}\@ifnotmtarg{#2}{(#2)}}

% local absolute values, norms, distances, ... [[2
%
\newcommand \Cv {\C_v}

\newdelimcommandx \av  [3][3=v] {\abs#1   {#2}\ssub{#3}}
\newdelimcommandx \nv  [4][4=v] {\norm#1  {#3}\sb{\sfirst{#2} #4}}
\newdelimcommandx \nnv [4][4=v] {\nnorm#1 {#3}\sb{\sfirst{#2} #4}}
% \newcommand \nh {\mathrm h} % usage : \nv\nh P

\newcommand* \mvp [2][v] {\mespph[#1]{#2}}
\newcommand* \mvm [2][v] {\mahler[#1]{#2}}

\newcommand \dv  {{\delta\smash{\sb v}}}
\newcommand \dpv {{\delta'\sb v}}

\DeclareMathOperator \Dist {dist}
\newcommand*\Distv [1][v] {\Dist\ssub{#1}}
\newcommand*\distv [3][v] {\Distv[#1](#2,#3)}

\DeclareMathOperator \Distalg {Dist}
\newcommand*\Distalgv [1][v] {\Distalg\ssub{#1}}
\newcommand*\distalgv [3][v] {\Distalgv[#1](#2,#3)}

% embeding-dependant values [[2
%
\newcommand \vaemb { \Theta }
\newcommand*\projd [1][] {\proj[#1]n}
\newcommand \fibre  {\mathcal L}
\newcommand \fibrei {\mathcal M}

\newcommand \coa  {\theta}
\newcommand \coi  {{\mathfrak b}}
\newcommand \htcmp [1][\vaemb] {\hat{c}\ssub{#1}}

\newcommand \hmclab [1][\vaemb] {%
  \@ifstar{ C\sb{#1, v} }{ C\sb{#1} }}
\newcommand \hlclab [1][\vaemb] {%
  \@ifstar{ c\sb{#1, v} }{ c\sb{#1} }}

\newcommand \hmpm [1][\vaemb] {%
  \@ifstar{ C'\sb{#1, v} }{ C'\sb{#1} }}
\newcommand \hlpm [1][\vaemb] {%
  \@ifstar{ c'\sb{#1, v} }{ c'\sb{#1} }}

\newcommand \vaht  { h_\va }
\newcommand \vacdn { \cdn_\va }
\newcommand \vahtr { h_{0, \va} }

\newcommand*\clab [3][] { [#2, #3]\ssub{#1} }
\newcommand*\multab [1] { [#1] }
\newcommand \rmclab [3] { L\pexp{#1, #2, #3}} % représentation de \clab-

\newcommand \clmap [1][] { \gamma\ssub{#1} }
\newc@star@default \clmapv {\fcti}{m-1} { \clmap[v \slast{#1}] }
\newc@star@default \clmape {\fcti}{m-1} { \clmap[\ex \slast{#1}] }
\newcommand \clmaps { \Gamma }
\newcommand \nclmaps { N }

% projective (and affine) indices and coordinates [[2
%
% helper macros [[
\newc@star@default@i \gp {\ind}{n} {\gp@{#1}{#2}}
\newcommand*\gp@ [2] {%
  #1\ssub{#2}}
% ]]

\newcommand \ind      {k}
\newcommand \indi     {l}
\newcommand \indrange  {\sb{\ind =0}\sp n}
\newcommand \indirange {\sb{\indi=0}\sp n}

% point : x -- coordonnées : \gp x
\newcommand \vp {\gp X}
\newcommand \vpi{\gp Y}
\newcommand \ip {\gp \lambda}
\newcommand \anyvp  {\gp W} % XXX utiliser \vp a priori

% affine variables
\newc@star@default \vaf  {\ind}{} {W\ssub{#1}}
\newc@star@default \vafi {\ind}{} {T\ssub{#1}}

% variety, approximations of which we're studying, or any variety
\newcommand \avar {V}
\newcommand \adim {u}
\newcommand \adeg {d}

\newcommand*\lgr [1] {\abs{#1}}

\newcommand*\ncoef  [1] {\mathcal N(#1)}
\newcommand*\maxbin [1] {m(#1)}

% multiprojective indices and coordinates [[2
%
% helper macros [[
\newc@star@deftwo@i \gmp  {\fct }{\ind} {\gmp@{#1}{#2}{#3}}
\newc@star@deftwo@i \gmpi {\fcti}{\ind} {\gmp@{#1}{#2}{#3}}
\newc@star@deftwo@i \gmpiv{\fcti}{\indiv*}{\gmp@{#1}[v]{#2}{#3}}
\newc@star@deftwo@i \gmpim{\fcti}{\ind} {\gmp@{#1}[\clmap]{#2}{#3}}
% generic multiprojective symbol:
% #1 = factor number, #2 = optional prefix for this, see \gmpiv & \wembclg
% #3 = coordinate in this factor,
% #4 = symbol
\newcommandx*\gmp@ [4][2] {%
  \@ifnotmtarg{#1}{%
    \@ifmtarg{#3}{\boldsymbol}{}{%
      #1}}%
  % cannot say \pexp{\sfirst{#2}#3}[{#4}] cause it checks if #1 is empty
  \@ifmtarg{#2}{\pexp{#3}[{#4}]}{\pexp{#2\slast{#3}}[{#4}]}
}
\newcommand \mexp {\gmp{}} % compat: p\mexp usage is stupid, use \gmp p
% ]]

\newcommand \fct      {i}
\newcommand \fctrange  {\sb{\fct =1}\sp m}

% point : x, x_i, coordonnées : \gmp x
\newcommand \vmp {\gmp X}
\newcommand \imp {\gmp \lambda}

\newcommand*\vlg [1] {\abs{#1}}
\newcommand*\lgt [1] {\lVert#1\rVert}

% height functions [[2
%
\newcommand*\Hautm [1]   {H \ssub{#1}}
\newcommand*\Hautl [1]   {h \ssub{#1}}
\newcommand \Hautn       {\hat h}

\newcommand*\hautm [2]   {\Hautm{#1}(#2)}
\newcommand*\hautl [2]   {\Hautl{#1}(#2)}
\newcommand*\hautn [1]   {\Hautn    (#1)}

\newcommand \hmin {\Hautn_{\mathrm{min}}}

% \nnt + \scalnt available for Néron-Tate norm & scalar product

\newcommand*\htpph {\mathrm{P}}
\newcommand*\htmah {\mathrm{M}}

\newcommand \stoll [1] {\mathrm{St}\sb{#1}}


% Vojta-specific math [[1
% -------------------

% constants in the theorem itself [[2
%
\newcommand \Vbig { \alpha \sb{\mathrm{V}} }
\newcommand \Vfar { \beta  \sb{\mathrm{V}} }
\newcommand \Vcos { \gamma \sb{\mathrm{V}} }

% general situation [[2
%
\newcommand \divi {E} % diviseur linéaire
\newcommand \hs   {F} % hypersurface (coro)

\newcommand \Excep { e }
\newcommand \cex   { \gmp\Excep }
\newcommand \cexi  { \gmpi{\Excep'}} % no space here!
\newcommand \cexa  { \gmp{\tilde\Excep}} % no space here!

\newc@star@default \ex      {\fct }{m  } {\Excep\ssub{#1}}
\newc@star@default \exi     {\fcti}{m-1} {\Excep'\ssub{#1}}

\newc@star@default \wt      {\fct }{m  } {a\ssub{#1}}
\newc@star@default \wts     {\fct }{m  } {a\ssub{#1}\sp2}
\newc@star@default \wti     {\fcti}{m-1} {a\ssub{#1}}
\newc@star@default \wtis    {\fcti}{m-1} {a\ssub{#1}\sp2}
\newc@star@default \wtw     {\fct }{m  } {\eta\ssub{#1}}

\newcommand \prodwt {\wts[1] \dots \wts[m] (m-1)}

\newc@star@deftwo \poldep {\fct}{\indi} {P\pexp{#1}[#2]}
\newc@star@default \pden {\fct}{}       {Q\ssub{#1}}
\newcommand       \anypden {R}

\newcommand \varset {\mathcal V}

% weighted embedding [[2
%
\newc@star@deftwo@i \smpi {\fcti}{\ind} {\gmp@{#1}{#2}{#3}}
\newcommand \mexpi {\smpi{}}

\newcommand \fcti      {j}
\newcommand \fctirange {\sb{\fcti=1}\sp{m-1}}

\newcommand \vmpi {\smpi Y}

\newcommand*\wemb  [1][\wt] {\varphi\ssub{#1}}
\newc@star@default \wemba {\clmap}{} {\psi\ssub{\wt\slast{#1}}}

\newc@star@deftwo@i \wembclg{\fcti}{\ind} {\gmp@{L}[{#1}]{#2}{#3}}
\newcommand*\wembclv {\gmpiv L}
\newcommand*\wembclm {\gmpim L}
\newcommand*\wembclp [2] {\rmclab{\wt[#2]}{\wt**}{#1[#2]}} % pas d'espace

\newcommand \idealim { \ideala{\wemb(\var)} }

% vanishing conditions [[2
%
\newcommand \Stairs { \mathcal E }
\newcommand \Vanish {\@ifstar {\mathfrak{\tilde q}} {\mathfrak q}}

\newcommand \wt@scale [1][\delta\epsi] { \sb{\wt} \sp{#1} }
\newcommand \stairs {\Stairs}
\newcommand \vanish {\@ifstar {\Vanish*\wt@scale} {\Vanish\wt@scale}}

%\newcommand  \wtsum         {\@ifstar{ S\sp\wt\sb0 }{ S\sp\wt }}
\newcommand* \wtsum [1][\wtw\wts] {\@ifstar{ S\ssup{#1}\sb0 }{ S\ssup{#1} }}

\newc@star@default@i \indg {\divi}{\ex} {\Aind\ssup{#1}\ssub{#2}}
\newc@star@default   \inda {\divi}{\ex} {\indg{\wtw\wts}[#1]}

% various (degree) conditions for subsets in lemmas
\newc@ifstar\Dz   { \delta d      }{ \delta d \sb\fct }
\newc@ifstar\Di   { \delta d'     }{ \delta d'\sb\fct }
\newc@ifstar\Dir  { \delta d' + r }{ \delta d'\sb\fct + r\sb\fct }
\newcommand \Ci   { \sb\Di   \sp{C'}   }
\newcommand \Cii  { \sb\Di   \sp{C''}  }
\newcommand \Ciii { \sb\Dir  \sp{C'''} }

% the space were the auxiliary form is to be found
\newcommand \fspace { \mathcal{\tilde F}_{\Dz} }
% the target of \sigma, where the aux form's image is to be null
\newcommand \ftarget { \mathcal{G}_{\Dir} }

% the product sub-variety considered and its attributes [[2
%
\newcommand \Var {Z}
\newc@star@default \var     {\fct}{m} {\Var  \ssub{#1}}
\newc@star@default \vdim    {\fct}{m} { u    \ssub{#1} }
\newc@star@default \vdeg    {\fct}{m} { D    \ssub{#1} }
\newc@star@default \vdegp   {\fct}{m} { D'   \ssub{#1} }
\newc@star@default \varfc   {\fct}{m} {\chow {\var[#1]}}
\newc@star@default \varid   {\fct}{m} {\ideal{\var[#1]}}

\newc@star@default \vadapt  {\fct}{m} {\chi   \ssub{#1}}
\newc@star@default \varfca  {\fct}{m} {\chowa {\var[#1]}}
\newc@star@default \varida  {\fct}{m} {\ideala{\var[#1]}}
\newc@star@default \vringa  {\fct}{m} {\ringa {\var[#1]}}

\newcommand \ideala [1] {\tilde\Ideal \sb{#1}}
\newcommand \ringa  [1] {\tilde\Ring  \sb{#1}}
\newcommand \chowa  [1] {\tilde\Chow  \sb{#1}}

% various "epsilons" [[2
%
% Note: no additional braces, or \expi\sp2 would be typeset incorrectly
\newcommand \epsz   {\eps\sb0}
\newcommand \epsi   {\eps\sb1}

% auxiliary form & co [[2
%
\newc@star@default \faux {\clmap}{\clmap\sb\ex} {
  F\@ifnotmtarg{#1}{'\sb{#1}}
}
\newcommand \fauxv { \faux[v] }

% for extrapolation [[2
%
% local indices
\newc@star@default \indv  {\fct }{m} {\ind \sb{v \slast{#1}}}
\newc@star@default \indt  {\fct }{m} {\ind \sb{{#1}}}
\newc@star@default \indiv {\fcti}{m} {\indi\sb{v \slast{#1}}}
\newc@star@default \indig {\fcti}{m} {\indi\sb{{#1}}}

% rational functions
\newcommand*\ratf      {\xi}
\newcommand*\ratfi     {\zeta}
\newcommand*\ratfv [1] {\alpha\sb{#1, v}}
\newcommand*\ratfh [1] {\hautl{}{\alpha\sb{#1}(\cexa)}}

% misc (ok) [[2
%
\newcommand \rdiv  { \rho\sb{\mathrm{div }} }
\newcommand \relim { \rho\sb{\mathrm{elim}} }
\newcommand \rfull { \rho }

% Parametrisation and adapted embeddings [[2
%
\newcommand \anyvar {V}
\newcommand \anydim {s}
\newcommand \anydeg {\Delta}

\newcommand \psmp   {\gmp t} % paramètre
\newcommand \psp    {\gp  t}
\newcommand \dermp  {\gmp\kappa} % ordre de dérivation
\newcommand \derp   {\gp \kappa}

\newc@ifstar \pmor  {\tau} {\tilde\tau}
\newcommand  \pmnum {\Delta}
\newcommand  \pmden {\Gamma}

% Other specific math [[1
% -------------------

\newcommand \opdefi {\mathcal D}


% [[1
% vim: ft=tex fdm=marker fmr=[[,]] fdl=1 spell spelllang=fr,en
