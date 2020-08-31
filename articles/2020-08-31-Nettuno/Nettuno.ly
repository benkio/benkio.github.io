\version "2.20.0"
\time 4/4
\score {
  \new StaffGroup <<
     \new Staff \relative c' {
       \time 4/4
       \tempo 4 = 125
       \key c \major
       e16 d e c g c e g e4 r4
       e'16 d e c g c e g e4 r4
       e,16 d e c g c e g e d e c g c e g
       d c d b g b d g d c d b g b d g
     }
     \new TabStaff \relative c' {
       e16\2 d\3 e\2 c\3 g\4 c\3 e\2 g\2 e4\2 r4
       %\set TabStaff.minimumFret = #12
       e'16\1 d\2 e\1 c\2 g\3 c\2 e\1 g\1 e4\1 r4
       % \set TabStaff.minimumFret = #0
       e,16\2 d\3 e\2 c\3 g\4 c\3 e\2 g\2 e\2 d\3 e\2 c\3 g\4 c\3 e\2 g\2
       d\3 c\4 d\3 b\4 g\5 b\4 d\3 g\2 d\3 c\4 d\3 b\4 g\5 b\4 d\3 g\2
     }
   >>
  \layout {}
  \midi {}
}