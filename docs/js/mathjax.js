window.MathJax = {
  tex: {
    inlineMath: [["\\(", "\\)"]],
    displayMath: [["\\[", "\\]"]],
    processEscapes: true,
    processEnvironments: true,
    tags: 'all', // ✅ ativa numeração automática em todas as equações
    tagSide: 'right', // opcional: define o lado do número (pode ser 'left' ou 'right')
    tagIndent: '0.8em' // opcional: espaçamento entre equação e número
  },
  options: {
    ignoreHtmlClass: ".*|",
    processHtmlClass: "arithmatex"
  }
};

document$.subscribe(() => { 
  MathJax.startup.output.clearCache();
  MathJax.typesetClear();
  MathJax.texReset();
  MathJax.typesetPromise();
});
