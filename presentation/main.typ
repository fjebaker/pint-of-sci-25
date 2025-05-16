#import "@preview/polylux:0.4.0": *

#let HANDOUT_MODE = true
#enable-handout-mode(HANDOUT_MODE)

#let principle_counter = counter("principle")
#principle_counter.update(1)

// colour configurations
#let SECONDARY_COLOR = rgb("#fafafa")
#let PRIMARY_COLOR = rgb("#be2b31")
#let TEXT_COLOR = black.lighten(13%)

#let SUBTITLE_FONT = "Adelphe Germinal"

// document general
#let location = "Pint of Science"
#let date = datetime(year: 2025, month: 5, day: 19)
#let datefmt = "[day] [month repr:long] [year]"

// utility functions
#let black(t, ..args) = text(weight: "black", t, ..args)
#let hl(t, ..args) = black(fill: PRIMARY_COLOR, ..args, t)

#let _setgrp(img, grp, display: true) = {
  let key = "id=\"" + grp + "\""
  let pos1 = img.split(key)
  if display {
    pos1.at(1) = pos1.at(1).replace("display:none", "display:inline", count: 1)
  } else {
    pos1.at(1) = pos1.at(1).replace("display:inline", "display:none", count: 1)
  }
  pos1.join(key)
}

#let cbox(b, width: 100%) = block(
  inset: 15pt,
  radius: 3pt,
  width: width,
  fill: PRIMARY_COLOR,
  text(fill: SECONDARY_COLOR, b),
)

#let setgrp(img, ..grps, display: true) = {
  grps
    .pos()
    .fold(
      img,
      (acc, grp) => {
        _setgrp(acc, grp, display: display)
      },
    )
}

#let animsvg(img, display_callback, ..frames, handout: false) = {
  let _frame_wrapper(_img, hide: (), display: ()) = {
    setgrp((setgrp(_img, ..hide, display: false)), ..display, display: true)
  }
  if handout == true {
    let final_image = frames
      .pos()
      .fold(img, (im, args) => _frame_wrapper(im, ..args))
    display_callback(1, final_image)
  } else {
    let output = ()
    let current_image = img
    for args in frames.pos().enumerate() {
      let (i, frame) = args
      current_image = _frame_wrapper(
        current_image,
        ..frame,
      )
      let this = display_callback(i + 1, current_image)
      output.push(this)
    }
    output.join()
  }
}

#let only-last-handout(..blocks, fig: false, handout: false, fig-num: 1) = {
  if handout == true {
    blocks.at(-1)
  } else {
    let output = ()
    context {
      counter(figure).update(fig-num)
      for blk in blocks.pos().enumerate() {
        let (i, b) = blk
        [
          #only(i + 1, b)
        ]
      }
    }
    output.join()
  }
}

// page configuration
#set par(leading: 8pt)
#set text(size: 20pt, font: "Atkinson Hyperlegible Next", fill: TEXT_COLOR)
#show raw.where(block: true): c => block(
  stroke: 1pt,
  inset: 7pt,
  radius: 1pt,
  fill: white,
  text(size: 12pt, c),
)

#let seperator = [#h(10pt)/#h(10pt)]
#set page(
  paper: "presentation-4-3",
  margin: (top: 0.4cm, left: 0.4cm, right: 0.4cm, bottom: 1.0cm),
  fill: SECONDARY_COLOR.darken(10%),
  footer: text(
    size: 12pt,
    [Fergus Baker #seperator CC BY-NC-SA 4.0 #seperator #location #seperator #date.display(datefmt) #h(1fr) #toolbox.slide-number],
  ),
)

// functions for drawing slides
#let cline(width: 1fr) = box(
  baseline: -12pt,
  height: 7pt,
  width: width,
  fill: PRIMARY_COLOR,
)
#let titlefmt(t) = block(
  inset: 0pt,
  text(
    tracking: -2pt,
    weight: "bold",
    size: 50pt,
    [#cline(width: 1cm) #t #cline()],
  ),
)

#let sl(body, title: none, footer: true, inset: 0.5cm, fill: SECONDARY_COLOR) = {
  let contents = [
    #if title != none [
      #titlefmt(title)
      #v(-inset + 0.2cm)
    ]
    #block(inset: inset, fill: fill, height: 1fr, width: 100%, body)
  ]

  if footer [
    #slide(contents)
  ] else [
    #set page(
      margin: 0.4cm,
      footer: none,
    )
    #slide(contents)
  ]
}

// main body
#let main_title = sl(footer: false, inset: 0.2cm)[
  // Keep the counter at zero for the main title slide
  #counter("logical-slide").update(0)
  #grid(
    columns: (38%, 1fr),
    column-gutter: 0.0cm,
    [
      #block(inset: 0.2cm, width: 100%, height: 100%)[
        #set align(center)
        #v(1fr)
        #block(height: 100%, width: 100%, fill: TEXT_COLOR)
        // #image("assets/key.svg", height: 100%)
      ]
    ],
    block(inset: 0.3cm)[
      #text(tracking: -2pt, size: 30pt)[
        #set par(spacing: 0pt, justify: true)
        #text(size: 73pt, fill: PRIMARY_COLOR, weight: "black")[Light Echoes]\
        #v(20pt)
        #text(
          size: 60pt,
          fill: PRIMARY_COLOR,
          weight: "black",
        )[_from_]\
        #v(20pt)
        #text(
          font: "Adelphe Germinal",
          size: 180pt,
          weight: "black",
        )[Black\ Holes]\
      ]

      #v(1fr)
      #text(fill: PRIMARY_COLOR)[*Fergus Baker* <#link("fergus@cosroe.com")>\ Andy Young]
      #v(-0.2cm)
      #set text(size: 16pt)
      #v(-0.2cm)
      #grid(
        columns: (50%, 1fr),
        [
          #location #h(1fr)\
          #date.display(datefmt)
        ],
        [
          #set align(right)
          #set align(bottom)
          #image("assets/bristol-logo.svg", height: 1.5cm)
        ],
      )
    ],
  )
]

#main_title

#let subtitle(t, size: 40pt) = context [
  #principle_counter.step()
  #set par(spacing: 0pt)
  #text(
    font: SUBTITLE_FONT,
    fill: PRIMARY_COLOR,
    size: size,
    weight: "black",
    [#principle_counter.display("1.") #t],
  )
  #v(-5pt)
]

#sl(title: "Astrophysical Black Holes")[

]

#sl[
  #hl[Galileo Galilei] (1632)
  - The laws of physics are the same in all (inertial) frames of reference.

  #align(center, image("assets/ss-great-britain.png", height: 12cm))

  #subtitle("Galilean Relativity")

  // David Scott on the moon dropping hammer and feather "Well how bout that"
]

#sl(fill: TEXT_COLOR)[

  #set text(fill: SECONDARY_COLOR)

  #v(0.4cm)

  #grid(
    columns: (70%, 1fr),
    [
      #v(1cm)
      *Ole Rømer* (1676)
      - Studying the eclipses of Jupiter's moon Io.
      #subtitle("The speed of light is finite.")
      #v(15pt)

      *Isaac Newton* (1687)
      - Universal theory of gravity.
      - Balance kinetic energy with gravitational potential energy.
      #v(15pt)
      #subtitle("Escape velocity.")
      #v(15pt)
      #grid(
          columns: (50%, 1fr),
          [
      $
        Delta "KE" &= Delta "PE", \
        (m v^2)/2  &= (G M m) / r, \
        v_"esc" &=  sqrt((2 G M) / r).
      $
          ],
          [
            For *Earth*: #h(1fr) $v_"esc" = 11.2 "m" \/ "s"$ \
            For the *Moon*: #h(1fr) $v_"esc" = 2.4 "m" \/ "s"$ \
            On *Titan*: #h(1fr) $v_"esc" = 2.6 "m" \/ "s"$ \
          ]
      )
    ],
    [
      #set align(center)
      #v(1cm)
      #image("assets/romer-speed-of-light.svg", height: 13cm)
    ],
  )
]

#sl[
  #[
    #set par(spacing: 0pt, justify: true)
    #uncover("2-")[
      #align(
        left,
        text(
          font: SUBTITLE_FONT,
          size: 68pt,
          weight: "black",
        )[A dark star],
      )
    ]
  ]

  Reverend #hl[John Michell] (1783): \

  $
    v_"esc" &=  sqrt((2 G M) / r) #text(fill: PRIMARY_COLOR)[$= c$] #h(3cm) arrow.r.double r &= (2 G M) / c^2.
  $

  #block(
    inset: (left: 1cm, right: 1cm),
    quote[[...] a body falling from an infinite height towards it, would have acquired at its surface a greater velocity than that of light, and consequently supposing light to be attracted by the same force in proportion to its _vis inertiae_ with other bodies, #hl[all light emitted from such a body would be made to return towards it], by its own proper gravity.],
  )
  #v(-0.5cm)
  #align(center, image("assets/Cavendish_Experiment.png", height: 8.5cm))
]

#sl[
  #hl[James Clerk Maxwell] (1864): light does not obey Galilean relativity

  #subtitle("The speed of light is constant in all frames.", size: 32pt)

  Then...

  #hl[Albert Einstein] (1905): Special Theory of Relativity
  - Galilean relativity but with #hl[a constant speed of light]
  // physics at high velocities behaves weirdly
  // concept of The Event
  // that when you move close to the speed of light, time slows down
  // lengths contract

  #hl[Albert Einstein] (again, now 1915): General Theory of Relativity

  #subtitle("The equivalence principle.")

  // Talk about the fact that you can't tell the difference between accelerating and gravity
]

#sl[
  #subtitle("Spacetime curvature.")

  // motivating example about paths on a sphere
  // is this useful? YES! Your phones are taking into account relativistic effects to triangulate your position via GPS

]

#sl[
  #hl[Chandrasekhar] Neutron Stars \
  #hl[Jocelyn Bell Burnell] (1967): discovery of first radio pulsar. \
  - Proves neutron stars exist
  #hl[John Wheeler] (1967): coins the term #hl[Black Hole] \
  #hl[Tom Bolton] (1972): discovers Cygnus X-1 orbits #hl[an invisible partner]. \
]

// Plan
//
// 1. Dark stars & Curvature
//    - Measuring finite velocity of light
//    - Newtonian gravity
//    - Escape velocity and the event horizon
//    - Mapping a trajectory of Einstein's ideas
//    - "A man in free-fall does not feel his own weight."
//    - The equivalence principle
//    - Curvature nominally as fictitious forces
//      - Example of trajectories on a sphere
//      - Throwing an apple would lead you to believe a force is acting on the apple
//      - Not so: Einstein's breakthrough was realising when you are accelerating you are still free-falling
//    - How to think about the origins of Gravity
//
// 2. Astrophysical Black Holes
//    - Eclipse of 1919 and deviation
//    - Detection of pulsars confirming Einstein's theories, weird objects predicted by GR maybe real?
//    - Einstein rings
//    - Luminets figure, how we go about calculating models of black holes
//    - Basic accretion model, illustrate why we know the gas will be hot
//    - First X-ray telescopes
//    - Line profiles and the 1989 measurements
//    - Notice these systems are far from stable
//    - End with figure of point source, then switch to 2019
//
// 3. Reverberation
//    - These systems are far from stable
//    - One particular effect
//    - Models of accretion physics
//    - Lamp post model and
