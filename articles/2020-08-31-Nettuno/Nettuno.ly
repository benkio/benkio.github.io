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
       f e f d a d f a f e f d a d f a
       e d e c a c e a e d e c a c e a
       a g a f c f a c g f g e c e g c
       d c d b g d g d b g b d b d g b
       a g a f c f a c g f g e c e g c
       d c d bes f d f d bes d bes d, f bes d f
       c bes c a f a c f e d e c a c e a
       g f g e c e g c b d b g d b g b
     }
     \new TabStaff \relative c' {
       e16\2 d\3 e\2 c\3 g\4 c\3 e\2 g\2 e4\2 r4
       e'16\1 d\2 e\1 c\2 g\3 c\2 e\1 g\1 e4\1 r4
       e,16\2 d\3 e\2 c\3 g\4 c\3 e\2 g\2 e\2 d\3 e\2 c\3 g\4 c\3 e\2 g\2
       d\3 c\4 d\3 b\4 g\5 b\4 d\3 g\2 d\3 c\4 d\3 b\4 g\5 b\4 d\3 g\2
       f\3 e\3 f\3 d\4 a\5 d\4 f\3 a\2 f\3 e\3 f\3 d\4 a\5 d\4 f\3 a\2
       e\3 d\3 e\3 c\4 a\4 c\4 e\3 a\2 e\3 d\3 e\3 c\4 a\4 c\4 e\3 a\2
       \set TabStaff.minimumFret = #5
       a\2 g\2 a\2 f\3 c\4 f\3 a\2 c\1 g\2 f\3 g\2 e\3 c\4 e\3 g\2 c\1
       \set TabStaff.minimumFret = #5
       d\1 c\1 d\1 b\1 g\2 d\3 g\2 d\3 b\4 g\5 b\4 d\3 b\4 d\3 g\2 b\1
       \set TabStaff.minimumFret = #5
       a\2 g\2 a\2 f\3 c\4 f\3 a\2 c\1 g\2 f\3 g\2 e\3 c\4 e\3 g\2 c\1
       d\1 c\1 d\1 bes\1 f\2 d\3 f\2 d\3 bes\4 d\3 bes\4 d,\5 f\5 bes\4 d\3 f\2
       c\3 bes\4 c\3 a\4 f\5 a\4 c\3 f\2 e\2 d\3 e\2 c\3 a\4 c\3 e\2 a\1
       \set TabStaff.minimumFret = #6
       g\2 f\3 g\2 e\3 c\4 e\3 g\2 c\1 b\1 d\1 b\1 g\2 d\3 b\4 g\5 b\4 
     }
   >>
  \layout {}
  \midi {}
}