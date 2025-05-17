#import "typ-pad.typ": typ-pad
#import "@preview/hyperscript:0.1.0": h

///////////////////////////////////////////////
// Background code to setup interactivity
/////////////////////////////////////////////// 


// The following is code used later to dynamically generate content with Typst.
// The `cetz` specifies the ID of the location where the result will be inserted.
#let typs = (
cetz: ```typ 
#import "@preview/cetz:0.3.2": canvas, draw
#import "@preview/cetz-plot:0.1.1": plot

#let f(x) = calc.sin(mdpad.w1 * x) + calc.sin(mdpad.w2 * x)

#canvas({
  import draw: *

  // Set-up a thin axis style
  set-style(axes: (stroke: .5pt, tick: (stroke: .5pt)),
            legend: (stroke: none, orientation: ttb, item: (spacing: .3), scale: 80%))

  plot.plot(size: (12, 8),
    x-tick-step: calc.pi/2,
    x-format: plot.formats.multiple-of,
    y-tick-step: 2, y-min: -2.5, y-max: 2.5,
    legend: "inner-north",
    {
      let domain = (-1.1 * calc.pi, +1.1 * calc.pi)
      plot.add(f, domain: domain, label: $ sin (#mdpad.w1 x) + sin (#mdpad.w2 x)  $, samples: 500)
    })
})

```)


// This is JavaScript code to update results based on changes to the inputs.
#let js = ```js
function mdpad_update(md) {
  document.getElementById("jsoutput").innerHTML = "With ω₁ = " + mdpad.w1 + " rad/sec and ω₂ = " + mdpad.w2 + " rad/sec, the beat frequency is " + Math.abs(mdpad.w1 - mdpad.w2) + " rad/sec."
}
```


// Load the `typ-pad` template.
// This app uses the Pico CSS framework (https://picocss.com/). It's light weight and concise.
#show: typ-pad.with(
  title: "Typ-pad: summing sinusoids",
  links: (
    (rel: "stylesheet", href: "https://cdn.jsdelivr.net/npm/@picocss/pico@2/css/pico.min.css"),
    (rel: "icon", type: "svg/xml", href: "data:image/svg+xml,<svg viewBox='0 0 256 256' xmlns='http://www.w3.org/2000/svg'><rect fill='none' height='256' width='256'/><path d='M24,128c104-224,104,224,208,0' fill='none' stroke='%23000' stroke-linecap='round' stroke-linejoin='round' stroke-width='19'/></svg>"),
  ),
  typst-online: typs, 
  js: js)


// This defines a little helper to generate form input elements.
#let binput(title: "", mdpad: "", type: "number", step: 1, min: 0, value: 10) = {
    h("label",
      title,
      h("input", (mdpad:mdpad, type:type, step:str(step), min:str(min), value:str(value))))
}

///////////////////////////////////////////////
// Main body of the app
/////////////////////////////////////////////// 

// Wrap everything in a container for just a bit of styling.
#h("main.container")[

= Example online app using `typ-pad`

Here is an example using #link("https://github.com/cetz-package/cetz-plot")[CeTZ-Plot] used to generate a plot. This plot is generated offline, and the SVG generated is part of the static page.

#import "@preview/cetz:0.3.2": canvas, draw
#import "@preview/cetz-plot:0.1.1": plot

#let style = (stroke: black, fill: rgb(0, 0, 200, 75))

#let mdpad = (w1: 8, w2: 9)
#let f(x) = calc.sin(mdpad.w1 * x) + calc.sin(mdpad.w2 * x)

#html.frame(canvas({
  import draw: *

  // Set-up a thin axis style
  set-style(axes: (stroke: .5pt, tick: (stroke: .5pt)),
            legend: (stroke: none, orientation: ttb, item: (spacing: .3), scale: 80%))

  plot.plot(size: (12, 8),
    x-tick-step: calc.pi/2,
    x-format: plot.formats.multiple-of,
    y-tick-step: 2, y-min: -2.5, y-max: 2.5,
    legend: "inner-north",
    {
      let domain = (-1.1 * calc.pi, +1.1 * calc.pi)
      plot.add(f, domain: domain, label: $ sin (#mdpad.w1 x) + sin (#mdpad.w2 x)  $, samples: 500)
    })
}))

\
 
Now, let's generate that dynamically and provide some input elements to control the behavior of the plot.

#h(".grid",
  binput(title:"Angular frequency ω₁", mdpad:"w1", value:21, step: 0.25),
  binput(title:"Angular frequency ω₂", mdpad:"w2", value:23, step: 0.25))
\
 
// Placeholder for the Typst output.
#h("#cetz[style='width: 500px; max-width: 500px']")   

\
We can also use JavaScript to generate output. The following mimics the input.

// Placeholder for the JavaScript output.
#h("#jsoutput")   

]
