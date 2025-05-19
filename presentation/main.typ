#import "@preview/polylux:0.4.0": *

#let HANDOUT_MODE = true
#enable-handout-mode(HANDOUT_MODE)

#let SMALL_FONT = 14pt
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

#let animsvg(img, display_callback, ..frames) = {
  let _frame_wrapper(_img, hide: (), display: ()) = {
    setgrp((setgrp(_img, ..hide, display: false)), ..display, display: true)
  }
  if HANDOUT_MODE == true {
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

#let only-last-handout(..blocks, fig: false, fig-num: 1) = {
  if HANDOUT_MODE == true {
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

#let sl(
  body,
  title: none,
  footer: true,
  inset: 0.5cm,
  fill: SECONDARY_COLOR,
) = {
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
      #text(
        fill: PRIMARY_COLOR,
      )[*Fergus Baker* <#link("fergus@cosroe.com")>\ Andy Young]
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
    [#t],
  )
  #v(-5pt)
]

#sl[
  #set text(font: SUBTITLE_FONT, size: 45pt)
  #set par(leading: 20pt)
  All stars are #hl[born].\
  #uncover("2-")[All stars will #hl[die].]
  #v(1cm)
  #uncover("3-")[The death of a star is a spectacle.\ ]
  #uncover("4-")[A star is reborn.]
  #v(1cm)
  #uncover("5-")[The pristine death is the #hl[black hole].]
]

#sl(title: "Astrophysical black holes")[
  #grid(
    columns: (50%, 1fr),
    [
      #set align(center)
      #image(
        "assets/NGC4151_Galaxy_from_the_Mount_Lemmon_SkyCenter_Schulman_Telescope_courtesy_Adam_Block.jpg",
        width: 90%,
      )
      Active Galactic Nuclei (#hl[AGN])
    ],
    [

      #set align(center)
      #image("assets/Gaia_BH1_PanSTARRS.jpg", width: 90%)
      Black hole X-ray binaries (#hl[BHXRB])
    ],
  )

  #place(
    bottom + left,
    text(
      size: SMALL_FONT,
    )[NGC4151 by #link("https://en.wikipedia.org/wiki/NGC_4151#/media/File:NGC4151_Galaxy_from_the_Mount_Lemmon_SkyCenter_Schulman_Telescope_courtesy_Adam_Block.jpg")[Adam Block/Mount Lemmon SkyCenter/\ University of Arizona], CC BY-SA 4.0],
  )
  #place(
    bottom + right,
    text(
      size: SMALL_FONT,
    )[Gaia BH1 by #link("https://en.wikipedia.org/wiki/Gaia_BH1#/media/File:Gaia_BH1_PanSTARRS.jpg")[Meli thev], CC BY-SA 4.0],
  )

  // despite large difference in mass, the physics of the black hole in each is the same
]

#sl(title: "Accreting black holes")[
  #v(0.5cm)
  #image("assets/hercules-a.jpg")

  #place(bottom + right, text(size: SMALL_FONT)[NGC2663, NASA CC])
]

#sl(fill: PRIMARY_COLOR)[
  #v(3cm)
  #set text(size: 70pt, weight: "bold", fill: SECONDARY_COLOR)
  #set align(center)
  #quote[Spacetime is curved around black holes.]

  #set text(size: 60pt, weight: "regular")
  #uncover("2-")[But what _does that even mean_???]
]

#sl[
  #hl[Galileo Galilei] (1632)
  - The laws of physics are the same in all (inertial) frames of reference.

  #align(center, image("assets/ss-great-britain.png", height: 12cm))

  #uncover("2-")[#subtitle("1. Galilean Relativity")]

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
      #uncover("3-")[#subtitle("2. The speed of light is finite.")]
      #v(15pt)

      #uncover("4-")[*Isaac Newton* (1687)]
      #uncover("5-")[
        - Universal theory of gravity.
        - Balance kinetic energy with gravitational potential energy.
      ]
      #v(15pt)
      #uncover("6-")[#subtitle("3. Escape velocity.")]
      #v(15pt)
      #grid(
        columns: (50%, 1fr),
        [
          #uncover("7-")[$
              Delta "KE" &= Delta "PE", \
              (m v^2) / 2 &= (G M m) / r, \
              v_"esc" &= sqrt((2 G M) / r).
            $
          ]
        ],
        [
          #uncover("8-")[For *Earth*: #h(1fr) $v_"esc" = 11.2 "m" \/ "s"$ \
            For the *Moon*: #h(1fr) $v_"esc" = 2.4 "m" \/ "s"$ \
            On *Titan*: #h(1fr) $v_"esc" = 2.6 "m" \/ "s"$ \
          ]
        ],
      )
    ],
    [
      #set align(center)
      #v(1cm)
      #uncover("2-")[#image("assets/romer-speed-of-light.svg", height: 13cm)]
    ],
  )
]

#sl[
  #[
    #set par(spacing: 0pt, justify: true)
    #uncover("3-")[
      #align(
        left,
        text(
          font: SUBTITLE_FONT,
          size: 50pt,
          weight: "black",
        )[A dark star],
      )
    ]
  ]

  Reverend #hl[John Michell] (1783): \

  $
    v_"esc" &=  sqrt((2 G M) / r) #text(fill: PRIMARY_COLOR)[$= c$] #h(3cm) arrow.r.double r &= (2 G M) / c^2.
  $

  #uncover("2-")[#block(
      inset: (left: 1cm, right: 1cm),
      quote[[...] a body falling from an infinite height towards it, would have acquired at its surface a greater velocity than that of light, and consequently supposing light to be attracted by the same force in proportion to its _vis inertiae_ with other bodies, #hl[all light emitted from such a body would be made to return towards it], by its own proper gravity.],
    )
  ]
  #uncover("3-")[
    #v(-0.3cm)
    #align(center, image("assets/black-hole-sim.jpg", height: 8.5cm))
    #place(
      bottom + right,
      block(text(size: SMALL_FONT, [Simulation, NASA CC BY 2.0])),
    )
  ]
]

#sl[
  #hl[James Clerk Maxwell] (1864): light does not obey Galilean relativity

  #uncover("2-")[#subtitle(
      "4. The speed of light is constant in all frames.",
      size: 32pt,
    )]

  #grid(
    columns: (58%, 1fr),
    column-gutter: 0.5cm,
    [
      #uncover("3-")[Light travels in #hl[straight lines].]

      #uncover("4-")[#hl[Albert Einstein] (1905): Special Theory of Relativity
        - Galilean relativity but with #hl[a constant speed of light]
      ]
      // physics at high velocities behaves weirdly
      // concept of The Event
      // that when you move close to the speed of light, time slows down
      // lengths contract

      #v(2cm)
      #uncover("5-")[#subtitle("5. The equivalence principle.")]

      #v(1cm)
      #uncover("9-")[#hl[Acceleration] is the same as #hl[gravity].
        - Fundamentally no way to distinguish the two scenarios.
      ]
    ],
    [
      #set align(center)
      #animsvg(
        read("assets/left-handed-equivalence.svg"),
        (i, im) => only(i)[
          #image.decode(im, height: 16cm)
        ],
        (hide: ("g4", "g9", "g2", "g3")),
        (),
        (),
        (),
        (),
        (display: ("g4",)),
        (display: ("g3",)),
        (display: ("g9",)),
        (display: ("g2",)),
      )
    ],
  )

  // Talk about the fact that you can't tell the difference between accelerating and gravity
  // - then have the example of an elevator
  // - light is always travelling at a constant speed in all frames of reference
  // - therefore light is travelling in straight lines
  // - it must therefore be space that is curved

  #uncover("6-")[#place(
      bottom + left,
      text(size: SMALL_FONT)[LHG person, James Yeo],
    )]
]

#sl[
  #animsvg(
    read("assets/left-handed-throw.svg"),
    (i, im) => only(i)[
      #image.decode(im)
    ],
    (hide: ("g2", "g3", "g4", "g5", "g7")),
    (display: ("g2",)),
    (display: ("g3",)),
    (display: ("g7", "g4")),
    (display: ("g5",)),
    (),
    (display: ("g8",), hide: ("g4", "g7",)),
    (),
    (),
  )

  #place(
    bottom + right,
    block(width: 15cm)[
      #set align(left)
      #uncover("6-")[Now we imagine the ball is a #hl[particle of light].

        #uncover("7-")[
          - Equivalence principle says this is the #hl[same as being in a gravitational field].
          - But light is travelling in straight lines...
        ]
      ]

      #grid(
        columns: (65%, 1fr),
        [
          #set align(top)
          #uncover("8-")[... therefore it must be #hl[space that is curved]!]

          #uncover("9-")[- Light is #hl[deflected by gravity].]
        ],
        [
          #set align(center)
          #uncover("8-")[#image("assets/berty-onestones.jpg", width: 4cm)]
        ],
      )
      #v(1cm)

    ],
  )

  // A is Goram
  // B is Vincent
]

#sl[
  #set align(horizon)
  #set par(spacing: 20pt)
  #hl(text(size: 50pt, "Einstein Ring"))

  #align(
    center,
    image("assets/webb-spies-spiral-through-lens.jpg", height: 80%),
  )
  #align(right, text(size: 12pt)[JWST, ESO CC BY 4.0 2025])

]

#sl[
  #hl[Albert Einstein] (again, now 1915): General Theory of Relativity
  #subtitle("6. Spacetime curvature.")

  #grid(
    columns: (50%, 1fr),
    row-gutter: 0.3cm,
    [
      #set align(center)
      #uncover("2-")[#animsvg(
          read("assets/path-on-sphere.svg"),
          (i, im) => only(i)[
            #image.decode(im, height: 9cm)
          ],
          (),
          (hide: ("g44", "g41", "g42", "g43")),
          (display: ("g41",)),
          (display: ("g42",)),
          (display: ("g43", "g44")),
          (),
          (),
          (),
        )]
      #uncover("6-")[#hl[Curvature] is a property of #hl[space and time] generated by #hl[matter and motion].]
    ],
    [
      #set align(center)
      #uncover("5-")[
        If you believe you are in flat space...
        #image("assets/projected-path.svg", height: 7.0cm)
        ... you might believe in a #hl[force driving you together].
      ]
    ],

    [
      #set align(horizon)
      #uncover("7-")[#align(
          center,
          image("assets/embedding-diagram.svg", height: 4.0cm),
        )]
    ],
    [
      #set align(horizon)
      #uncover("8-")[#move(
          dx: 1.1cm,
          dy: -0.4cm,
          image("assets/curved-space.svg", height: 4.6cm),
        )]
    ],
  )

  // motivating example about paths on a sphere
  // is this useful? YES! Your phones are taking into account relativistic effects to triangulate your position via GPS

  // Global Positioning System
  // - apparent stars
]

#sl(title: "Bridging the gap")[
  #grid(
    columns: (70%, 1fr),
    [
      #hl[Jocelyn Bell Burnell] (1967): discovery of first radio pulsar. \
      #uncover("2-")[ #hl[John Wheeler] (1967): coins the term #hl[Black Hole]]\
      #uncover("3-")[#hl[Tom Bolton] (1972): discovers Cygnus X-1 orbits #hl[an invisible partner].]
      #v(0.5cm)
      #uncover("4-")[#align(
        center,
        text(
          size: 30pt,
          font: SUBTITLE_FONT,
          [Black holes are the extreme of spacetime curvature.],
        ),
      )
    ]
    ],
    [
      #image("assets/jocelyn-bell-burnell.jpg")
    ],
  )

  #uncover("5-")[#align(center, line(length: 90%, stroke: PRIMARY_COLOR + 3pt))]

  #uncover("6-")[The language used to talk about curvature is #hl[Riemannian geometry]
  - Trajectory of all things follow #hl[geodesics]
  - #hl[Curvature] acts to impart a force, which we call #hl[gravity]
  - Curvature is mathematically represented by a #hl[metric]
]
  #v(0.5cm)
  #uncover("7-")[#align(
    center,
    block[
      #text[(*Mass* and *momentum* distribution)] $arrow.r.double g_(mu nu) = f(M(x), arrow(p)(x))$
    ],
  )
]
  #v(0.5cm)
  #uncover("8-")[#hl[Hideously complex] for e.g. a star or a planet, potentially >1000s of parameters...]
]

#sl[
  #v(3cm)
  #text(
    size: 30pt,
    font: SUBTITLE_FONT,
    [The #hl[Kerr family] of black hole solutions:],
  )
  #v(-3cm)
  #text(size: 120pt)[
    $ g_(mu nu) (#hl[$M$], #hl[$a$]) $
  ]
  #v(-3cm)
  #text(
    quote[The black holes of nature are the most #hl[perfect
  macroscopic objects] in the universe [...]. And since the
      general theory of relativity provides only a single unique
      family of solutions [...], they are the #hl[simplest objects] as
      well.],
  )
  #align(right)[
    -- S. Chandrasekhar
    #v(-0.9em)
    #text(size: 12pt)[ prologue to The Mathematical Theory of Black Holes ]
  ]
]

#sl(footer: false, fill: PRIMARY_COLOR)[
  #v(3cm)
  #set text(
    fill: SECONDARY_COLOR,
    size: 80pt,
    weight: "black",
    font: SUBTITLE_FONT,
  )
  #set par(leading: 0pt, spacing: 0pt)
  Visualising
  #v(1.2cm)
  #text(size: 130pt, fill: TEXT_COLOR)[black holes]
]

#sl[
  #set align(center)
  #v(2cm)
  #image("assets/luminet.png", width: 22cm)

  #hl[J-P. Luminet] (1978): Image of a spherical black hole with thin accretion disc
]

#sl(title: "(Relativistic) ray-tracing")[
  #hl[Ray-tracing]: ubiquitous in modern computer graphics
  - Each #hl[pixel is a photon].
  #grid(
    columns: (50%, 1fr),
    column-gutter: 0.8cm,
    [
      #image("assets/utah-teapot.jpg")
      #text(size: SMALL_FONT)[
        Rendering by #link("https://commons.wikimedia.org/w/index.php?curid=4303243")[Dhatfield] - CC BY-SA 3.0,
      ]
    ],
    [
      #v(1cm)
      #uncover("2-")[#image("assets/teapot.png")]
    ],

    [],
    [
      #uncover("2-")[#hl[Relativistic ray-tracing]
      - Exact same idea.
      - Except light now follows curved paths.
    ]
    ],
  )
]

#sl(title: "Tracing geodesics")[
      #v(0.5cm)
      #align(
        center,
        animsvg(
          read("assets/gr-ray-tracing.svg"),
          (i, im) => only(i)[
            #image.decode(im, height: 85%)
          ],
          (hide: ("g301",)),
          (display: ("g301",)),
        ),
      )

      #uncover("2-")[Vertically #hl[stack slices] of different $beta$ to create an image.]
      // be sure to explain the Event Horizon radius here
]

#sl()[
  #v(1cm)
  #set align(center)
  #image("assets/schwarzschild-shadow.png", height: 15cm)
  (if this is about 2.8 meters across, it's 1:1 with the Schwarzschild radius of Jupiter)\
  (if it's closer to 0.8 meters across, it's 1:1 with Schwarzschild radius of Saturn)
]

#sl(title: "Shadow of a black hole")[
  #set align(center)
  #image("assets/shadows.png")

  #hl[The shadow] is a projection of the #hl[event horizon].
]

#sl(title: "Toy accretion disc")[
  #let size = 17cm
  #align(center, image("assets/toy-accretion.svg", width: size))
  #uncover("2-")[#align(
      center,
      image("assets/toy-accretion-projected.svg", width: size),
    )]
  #uncover("3-")[#align(
      center,
      image("assets/toy-accretion-render.png", width: size),
    )]
]

#sl(title: "Redshift")[
  Ratio of #hl[observer energy] to #hl[emitted energy].

  #uncover("2-")[Sources of redshift include: ]

  #v(-0.3cm)

  #grid(
    columns: (50%, 1fr),
    [
        #set align(center)
      #uncover("3-")[- #hl[Doppler shift]
        #image("assets/redshift.flat.png", width: 95%)
      ]

      #uncover("4-")[
        #image("assets/whirly-tube.jpg", height: 4cm)
      ]
    ],
    [
      #uncover("5-")[- #hl[Gravitational redshift]
        #set align(center)
        #image("assets/redshift.schwarzschild.png", width: 95%)
        ]
    ],
  )
  // - accretion disc is rotating at about 10% speed of light
  // - how it's used to make a line profile
]

#sl()[
  #set align(center)
  #v(3cm)
  #image("assets/our-luminet.png", width: 22cm)

  #hl[After J-P. Luminet] (2025): Schwarzschild black hole
]

#sl(title: "Observers")[
  The #hl[inclination] of the observer changes the #hl[redshift profile]:
  #v(1cm)
  #align(center, image("assets/redshift-observer.png", height: 12cm))
]

// #image("assets/building-line-profiles.svg", width: 100%)

// #v(1cm)
// The #hl[line profile] tells us how radiation from the disc #hl[is observed].

#sl(footer: false, fill: PRIMARY_COLOR)[
  #v(3cm)
  #set text(
    fill: SECONDARY_COLOR,
    size: 80pt,
    weight: "black",
  )
  #set par(leading: 0pt, spacing: 0pt)
  _The_ #text(fill: TEXT_COLOR)[black hole]
  #set text(font: SUBTITLE_FONT, size: 180pt)
  corona
]

#sl(footer: false)[
  #v(1cm)
  #image("assets/corona-launching.jpg")

  #place(
    bottom + right,
    text(size: SMALL_FONT)[Artist's rendition, NASA JPL Caltech CC],
  )
]

#sl(title: "The black hole corona")[
  #grid(
    columns: (42%, 1fr),
    column-gutter: 0.5cm,
    [
      Observations have two key components:
      - A black-body component (#hl[disc])
      - A high-energy additional component (#hl[the corona])

      #uncover("2-")[Super-hot cloud of #hl[electrons]
        - Illuminates the accretion disc in #hl[high-energy X-rays]
      ]

      #v(2cm)
      #uncover("3-")[When we observe with our telescopes we see the #hl[ensemble].]
      #v(2cm)
      #uncover("4-")[#cbox[Components can be *modelled independently*.]]
    ],
    [
      #v(1fr)
      #align(right)[The #hl[Lamppost] model]
      #only-last-handout(
        image("assets/literal-lamppost.png", width: 95%),
        image("assets/literal-lamppost.png", width: 95%),
        image("assets/literal-lamppost-magnifying.png", width: 95%),
        image("assets/literal-lamppost-magnifying.png", width: 95%),
      )
    ],
  )
]

#sl(title: "Reverberation lags")[
  #set align(center)
  #align(center)[
    #animsvg(
      read("assets/reverberation-traces.svg"),
      (i, im) => only(i)[
        #image.decode(im, width: 90%)
      ],
      (),
      (hide: ("g75", "g49")),
      (hide: ("g1",)),
      (display: ("g5",)),
      (hide: ("g6", "g2"), display: ("g7",)),
      (display: ("g73", "g72", "g4")),
      (display: ("path63", "g3")),
    )
  ]
]

#sl(title: "Weighing black holes")[
  Use #hl[reverberation lag] to measure mass:
  #grid(
    columns: (50%, 1fr),
    [
      #set align(center)
      #image("assets/o-neill-2025-cyg-x-1-mass.png", height: 9cm)
      #v(-0.5cm)
      #text(size: 15pt)[O'Neill et al., 2025]
      #v(-0.5cm)
    ],
    [
      #set align(center)
      #image(
        "assets/iron-k-vs-black-hole-mass-kara-et-al-2016.png",
        height: 9cm,
      )
      #v(-0.5cm)
      #text(size: 15pt)[Kara et al., 2016]
      #v(-0.5cm)
    ],
  )

  #v(2cm)
  #align(
    center,
    block[
      #hl[Accreting black holes] are highly #hl[variable], and we try to model that variability to #hl[infer parameters] of the black hole.
    ],
  )
]

#if HANDOUT_MODE  == false [
  #sl(footer: false, fill: TEXT_COLOR)[
    #align(center, image("assets/xmm-ngc-4151.png", width: 100%))

    #place(center + horizon)[
      #uncover("2-")[#image("assets/eht-m87-image.jpg")]
    ]
  ]
]

#slide[
  #show link: l => text(fill: blue.lighten(40%), l)
  #set page(fill: PRIMARY_COLOR, footer: none)
  #set text(fill: SECONDARY_COLOR)
  #v(0.5cm)
  #par(spacing: 0pt, text(size: 105pt, weight: "bold")[Summary])

  Spacetime is curved around black holes.
  - Leads to distortion of light

  *Open problems:*
  - What is the *geometry of the corona*?
  - We see AGN and XRB, but Where are the *intermediary mass black holes*?
  - What happens *inside a black hole*?

  #v(0.5cm)


  #set align(right)
  #v(1fr)
  *Slides:*\
  #link("https://github.com/fjebaker/pint-of-sci-25") \
  *Contact:* #link("fergus@cosroe.com") \
  #link("https://github.com/fjebaker") \
  #link("www.cosroe.com") \
  #set text(size: 15pt)
  \
  Figures rendered using Makie.jl and GNUPlot.\
  Fonts: Atkinson Hyperlegible, Adelphe Germinal (OFL).\
  Slides made with Typst.

  #place(bottom+left, image("assets/cat-meme.jpg", height: 10cm))
]

#sl(footer: false)[
  #set align(center)
  #set align(horizon)

  Backup Slides
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

#sl(title: "Measuring parameters")[

  #grid(
    columns: (50%, 1fr),
    [
      #set align(center)
      #image("assets/line-profiles.svg", height: 100%)
    ],
    [
      #hl[Lineprofile] is sensitive to the parameters of the #hl[black hole].
      - Used to measure the #hl[spin] and relative #hl[inclination]

        #v(1cm)
        #align(center, image("assets/young-05.png", width: 100%))
        #align(
          center,
          text(size: SMALL_FONT, [MCG 6-30-15 from Young et al. (2005)]),
        )
    ],
  )
]

#sl(title: "Aside: photon ring")[
  #grid(
    columns: (68%, 1fr),
    column-gutter: 20pt,
    [
      #hl[Winding] of geodesics around the black hole:
      #{
        set text(size: 15pt)
        grid(
          columns: (55%, 1fr),
          [
            #v(1cm)
            #image(
              "./assets/photon-ring-schwarzschild.svg",
              width: 100%,
            )
          ],
          [
            #v(2.0em)
            #image("./assets/eht-m87-image.jpg", width: 90%)
            #text(
              size: 14pt,
            )[M87\*, imaged by the #hl[Event Horizon Telescope] CC BY 4.0]
            #v(1em)
          ],
        )
      }
      Bright central ring in EHT images is the #hl[photon ring].
    ],
    [
      #set text(size: 15pt)
      #set align(center)
      #move(
        dy: -1pt,
        image("./assets/m-von-laue-1921.png", width: 90%),
      )
      #v(-11pt)
      #text(size: 18pt, [M. von Laue, 1921])
      #v(-5pt)
      #move(
        dx: -15pt,
        image("./assets/photon-ring-paths.svg", width: 100%),
      )
      #v(-20pt)
      #text(size: 18pt, [After M. von Laue, 2025])
    ],
  )
]


#sl(title: "Observing lags")[
  // TODO: redo this slide
  Trace #hl[observer to disc] and bin by #hl[redshift] $g$ and #hl[total arrival time]:
  $ t_"tot" = t_("corona" -> "disc") + t_("disc" -> "observer") $

  #v(1cm)
  #grid(
    columns: (33%, 33%, 1fr),
    column-gutter: 0pt,
    [
      #image("./assets/apparent-image.png", width: 100%)
    ],
    [
      #image("./assets/apparent-image-arrival.png", width: 100%)
    ],
    [
      #move(
        dx: -0.5em,
        image("./assets/apparent-image-transfer.png", width: 94%),
      )
    ],
  )
]

#sl(title: "Illuminating the disc")[
  #align(
    center,
    animsvg(
      read("assets/lamp-post-traces.svg"),
      (i, im) => only(i)[
        #image.decode(im, height: 50%)
      ],
      (hide: ("g572", "g570", "g571")),
      (display: ("g570",)),
      (display: ("g571",), hide: ("g570",)),
      (display: ("g572",), hide: ("g571",)),
    ),
  )

  #align(
    center,
    animsvg(
      read("assets/lamp-post-emissivity-travel-time.svg"),
      (i, im) => only(i)[
        #image.decode(im, height: 45%)
      ],
      (hide: ("g389", "g390", "g391")),
      (display: ("g391",)),
      (display: ("g390",)),
      (display: ("g389",)),
    ),
  )
]

#sl(title: "Beyond the lamppost model")[
  #v(1cm)
  #align(center, image("assets/coronal-illustration.svg", width: 22cm))

  // extended coronae is the problem i've been working on for about a year with
  // the software i've been developing over the last 4 years
  // - we can do thick discs fast enough to fit them
  // - we can do radially extended coronae fast enough too
]

