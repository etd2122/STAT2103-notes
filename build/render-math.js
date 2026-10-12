// Reads a JSON array of {tex, display} on stdin, prints a JSON array of MathML strings.
const katex = require('katex');
let buf = '';
process.stdin.on('data', d => buf += d);
process.stdin.on('end', () => {
  const items = JSON.parse(buf);
  const out = items.map(({tex, display}) => {
    try { return katex.renderToString(tex, {displayMode: display, output: 'mathml', throwOnError: true}); }
    catch (e) { process.stderr.write('KaTeX error in: ' + tex + '\n  ' + e.message + '\n'); return '<code>' + tex.replace(/</g,'&lt;') + '</code>'; }
  });
  process.stdout.write(JSON.stringify(out));
});
