window.MathJax = {
  loader: { load: ['[tex]/boldsymbol', '[tex]/ams'] },
  tex: {
    packages: { '[+]': ['boldsymbol', 'ams'] },
    macros: {
      unit: ["\\mathrm{#1}", 1]
    },
    tags: 'all',        // Enables \label and \ref support
    tagSide: 'right',
    tagIndent: '0em'
  },
  options: {
    ignoreHtmlClass: '.*|',
    processHtmlClass: 'arithmatex'
  }
};
