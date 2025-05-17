#let as-text(x) = if type(x) == content {x.text} else {x}

#let typ-pad(content,
  title: "",
  js: "",
  js-includes: (),
  heads: (),
  heads-default: true,
  links: (),
  mdpad: true,
  typst-online: (:),
  full-html: true) = {

  let online-typst-js = ```js

      function ready(fn) {
          if (document.readyState != "loading"){
              fn();
          } else {
              document.addEventListener("DOMContentLoaded", fn);
          }
      }

      function setup_listeners() {
          document.addEventListener("keyup", function (event) {
              if (event.target.matches("input, textarea, datalist, button")) 
                if (event.target.getAttribute("mdpad")) 
                  if (event.key == "Enter") {
                      mdpad.api.calculate();
                      makeSvgs();
                  }
              }, false);
          document.addEventListener("change", function (event) {
              if (event.target.matches("select, input, textarea, datalist")) 
                if (event.target.getAttribute("mdpad")) {
                      mdpad.api.calculate();
                      makeSvgs();
                  }
              }, false);
          window.addEventListener('popstate', function(event) {
                      mdpad.api.calculate();
                      makeSvgs();
          }, true);
      }

      function toTypstObject(x) {
        var obj = [];
        for (const k in x) {
          if (k != "api") {
            obj.push(`${k}: ${x[k]}`)
          }
        }
        return `#let mdpad = (${obj.join(", ")})`;
      }
      function makeSvg(id, tcode) {
        const mainContent = toTypstObject(mdpad) + "\n#set page(width: auto, height: auto, margin: 0em)\n" + tcode;
        // console.log(mainContent);
        $typst.svg({ mainContent }).then(svg => {
          const contentDiv = document.getElementById(id);
          contentDiv.innerHTML = svg;
          const svgElem = contentDiv.firstElementChild;
          const width = Number.parseFloat(svgElem.getAttribute('width'));
          const height = Number.parseFloat(svgElem.getAttribute('height'));
          svgElem.removeAttribute('width');
          svgElem.removeAttribute('height');
          // console.log(height);
          // const cw = document.body.clientWidth - 40;
          // svgElem.setAttribute('width', width*2);
          // svgElem.setAttribute('height', height * 2);
        });
      };
      document.getElementById('typst').addEventListener('load', function () {
        $typst.setCompilerInitOptions({
          getModule: () =>
            'https://cdn.jsdelivr.net/npm/@myriaddreamin/typst-ts-web-compiler/pkg/typst_ts_web_compiler_bg.wasm',
        });
        $typst.setRendererInitOptions({
          getModule: () =>
            'https://cdn.jsdelivr.net/npm/@myriaddreamin/typst-ts-renderer/pkg/typst_ts_renderer_bg.wasm',
        });
       })```.text

  let result = ()
  if mdpad {
    result.push(html.elem("script",
      attrs: (src: "https://cdn.jsdelivr.net/npm/mdpad-js@1.0.0/dist/mdpad.min.js")))
  }
  if typst-online.len() > 0 {
    result.push(html.elem("script",
      attrs: (
        id: "typst",
        type: "module",
        src: "https://cdn.jsdelivr.net/npm/@myriaddreamin/typst.ts/dist/esm/contrib/all-in-one-lite.bundle.js")))
    result.push(html.elem("script", online-typst-js + "\nfunction makeSvgs() {\n" + typst-online.pairs().map(((id,tcode)) => "\nmakeSvg('" + id + "', `" + as-text(tcode) + "`)").join("\n") + "\n}\n      setup_listeners()\nready(makeSvgs)"))
  }
  if heads-default {
    heads.insert(0, html.elem("meta", attrs: (name: "viewport", content: "width=device-width, initial-scale=1")))
    heads.insert(0, html.elem("meta", attrs: (charset: "utf-8"))) 
  }
  if title != "" {
    heads.push(html.elem("title", title))
  }
  for a in js-includes {
    if type(x) == dictionary {
      result.push(html.elem("script", a))
    } else {
      result.push(html.elem("script", (src: a)))
    }
  }
  if js != "" {
    result.push(html.elem("script", as-text(js)))
  }
  if full-html {
    let head = html.elem("head", 
      heads.join() + 
      links.map(x => html.elem("link", attrs: x)).join())
    return html.elem("html",
      head + html.elem("body", content + result.join()))
  } else {
    return content + result.join()
  }
}