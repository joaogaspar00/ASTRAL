window.MathJax = {
  // Load the boldsymbol extension
  loader: { load: ['[tex]/boldsymbol'] },

  tex: {
    packages: { '[+]': ['boldsymbol'] },

    // Define macros
    macros: {
      unit: ["\\mathrm{#1}", 1]
    }
  }
};
