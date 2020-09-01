\version "2.20.0"
\time 4/4
\header {
  title = "Nettuno"
  composer = "Rondò Veneziano"
}

verseScore = \relative c' {
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
       a g a fis d fis a d a g a fis d fis a d
       cis b cis a e a cis e cis b cis a e a cis e
       e d e c g c e g e d e c g c e g
       d c d b g b d g d c d b g b d g
     }
verseTab = \relative c' {
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
       a\3 g\4 a\3 fis\4 d\5 fis\4 a\3 d\2 a\3 g\4 a\3 fis\4 d\5 fis\4 a\3 d\2
       \set TabStaff.minimumFret = #0
       cis\2 b\3 cis\2 a\3 e\4 a\3 cis\2 e\2 cis\2 b\3 cis\2 a\3 e\4 a\3 cis\2 e\2
       e\2 d\3 e\2 c\3 g\4 c\3 e\2 g\2 e\2 d\3 e\2 c\3 g\4 c\3 e\2 g\2
       d\2 c\3 d\2 b\3 g\4 b\3 d\2 g\1 d\2 c\3 d\2 b\3 g\4 b\3 d\2 g\1
     }

verseVariationAScore = \relative c' {
  f e f d a d f a e d e c a c e a
  b a b gis e b e b gis e gis b gis b e gis
  b a b g d b d g a g a fis d a d fis
  {
    e' d e cis a e a e cis a cis e cis e a cis
    e d e c g e g e c g c e c e g c
  }
  d c d b g d g d bes f bes d bes d f bes
  c bes c a f c f c a e a c a c e a
  b a b gis e b e gis b a b gis e b e gis
  b a b g d b d b g d g b g b d g
}
verseVariationATab = \relative c' {
  f16\2 e\2 f\2 d\3 a\4 d\3 f\2 a\1 e\2 d\3 e\2 c\3 a\4 c\3 e\2 a\1
  \set TabStaff.minimumFret = #3
  \set TabStaff.restrainOpenStrings = ##t
  b\1 a\1 b\1 gis\1 e\2 b\3 e\2 b\3 gis\4 e\5 gis\4 b\3 gis\4 b\3 e\2 gis\1
  b\1 a\1 b\1 g\1 d\2 b\3 d\2 g\1 a\1 g\1 a\1 fis\1 d\2 a\3 d\2 fis\1

  e'\1 d\1 e\1 cis\1 a\2 e\3 a\2 e\3 cis\4 a\5 cis\4 e\3 cis\4 e\3 a\2 cis\1
  e\1 d\1 e\1 c\1   g\2 e\3 g\2 e\3 c\4   g\5 c\4   e\3 c\4   e\3 g\2 c\1

  d\1 c\1  d\1 b\1 g\2 d\3 g\2 d\3 bes\4 f\5 bes\4 d\3 bes\4 d\3 f\2 bes\1
  c\1 bes\1 c\1 a\1 f\2 c\3 f\2 c\3 a\4 e\5 a\4 c\3 a\4 c\3 e\2 a\1
  b\1 a\1 b\1 gis\1 e\2 b\3 e\2 gis\1 b\1 a\1 b\1 gis\1 e\2 b\3 e\2 gis\1
  b\1 a\1 b\1 g\1 d\2 b\3 d\2 b\3 g\4 d\5 g\4 b\3 g\4 b\3 d\2 g\1
}

\score {
  \new StaffGroup <<
    \new Staff {
      \verseScore
      \verseVariationAScore
    }
    \new TabStaff {
      \verseTab
      \verseVariationATab
    }
  >>
  \layout {}
  \midi {}
}