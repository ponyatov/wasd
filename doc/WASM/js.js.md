# js.js

```JS
(async () => {
  // import WASM
  const env = {env: {_log: console.log}};
  const {instance} =
      await WebAssembly.instantiateStreaming(fetch('/static/st.wasm'), env);
  console.log(instance);
  console.log(instance.exports);

  // ...
})()
```

## paint

[[wasm.rs#paint]]

```js
  // canvas size
  w = instance.exports.w();
  h = instance.exports.h();
  const canvas = document.getElementById('canvas')
  canvas.width = w;
  canvas.height = h;
  $('#wh').text(`${w}:${h}`);

  // canvas set painting area from WASM memory
  const image = new ImageData(
      new Uint8ClampedArray(
          instance.exports.memory.buffer, instance.exports.CANVAS.value,
          w * h * 4),
      w);

  // paint frame loop
  const ctx = canvas.getContext('2d');
  function paint() {
    instance.exports.paint();
    ctx.putImageData(image, 0, 0);
    window.requestAnimationFrame(paint);
  };
  paint()
```
