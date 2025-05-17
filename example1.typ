#import "typ-pad.typ": typ-pad
#import "@preview/hyperscript:0.1.0": h



///////////////////////////////////////////////
// Code to setup interactivity
/////////////////////////////////////////////// 


// This is JavaScript code to update results based on changes to the inputs.
#let js = ```js
var n = 100;
var x = [], y = [], z = [];
var dt = 0.015;
function mdpad_init(md) {

  for (i = 0; n >= i; i++) {    // need to flip around the `i < n` to avoid using <
    x[i] = Math.random() * 2 - 1;
    y[i] = Math.random() * 2 - 1;
    z[i] = 30 + Math.random() * 10;
  }

  Plotly.newPlot('myDiv', [{
    x: x,
    y: z,
    mode: 'markers'
  }], {
    width: 800,
    xaxis: {range: [-40, 40]},
    yaxis: {range: [0, 60]}
  })

  function compute () {
    var s = mdpad.s, b = mdpad.b, r = mdpad.r;
    var dx, dy, dz;
    var xh, yh, zh;
    for (var i = 0; n >= i; i++) {
      dx = s * (y[i] - x[i]);
      dy = x[i] * (r - z[i]) - y[i];
      dz = x[i] * y[i] - b * z[i];

      xh = x[i] + dx * dt * 0.5;
      yh = y[i] + dy * dt * 0.5;
      zh = z[i] + dz * dt * 0.5;

      dx = s * (yh - xh);
      dy = xh * (r - zh) - yh;
      dz = xh * yh - b * zh;

      x[i] += dx * dt;
      y[i] += dy * dt;
      z[i] += dz * dt;
    }
  }

  function update () {
    compute();

    Plotly.animate('myDiv', {
      data: [{x: x, y: z}]
    }, {
      transition: {
        duration: 0
      },
      frame: {
        duration: 0,
        redraw: false
      }
    });

    requestAnimationFrame(update);
  }

  requestAnimationFrame(update);
}

function mdpad_update() {

}
```

// Load the `typ-pad` template.
// This app uses the Pico CSS framework (https://picocss.com/). It's light weight and concise.
#show: typ-pad.with(
  title: "Typ-pad: animating the Lorenz attractor",
  links: (
    (rel: "stylesheet", href: "https://cdn.jsdelivr.net/npm/@picocss/pico@2/css/pico.min.css"),
    (rel: "icon", type: "svg/xml", href: "data:image/svg+xml,<svg viewBox='0 0 256 256' xmlns='http://www.w3.org/2000/svg'><rect fill='none' height='256' width='256'/><path d='M24,128c104-224,104,224,208,0' fill='none' stroke='%23000' stroke-linecap='round' stroke-linejoin='round' stroke-width='19'/></svg>"),
  ),
  js-includes: ("https://cdn.plot.ly/plotly-3.0.1.min.js",),
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

This is an online app created with #link("https://github.com/tshort/typ-pad/")[typ-pad]. The page is created from a Typst document (#link("https://github.com/tshort/typ-pad/blob/main/example1.typ")[source]).

This example shows an animation of the Lorenz attractor from #link("https://plotly.com/javascript/animations/#animating-many-frames-quickly")[this Plotly example]. The differential equations for the Lorenz attractor are:

#html.frame(
$ 
 diff(x) / diff(t) &= sigma (y - x)  \
 diff(y) / diff(t) &= x (rho - z) - y \
 diff(z) / diff(t) &= x y - beta z 
$)

\

Change these inputs to adjust the parameters of the Lorenz attractors.

#h(".grid",
  binput(title:"σ", mdpad:"s", value:10, step: 1.0),
  binput(title:"ρ", mdpad:"b", value:8/3, step: 0.25),
  binput(title:"β", mdpad:"r", value:28, step: 1.0))
 
// Placeholder for the Plotly output.
#h("#myDiv")   

]
