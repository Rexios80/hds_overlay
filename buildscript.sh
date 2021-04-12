npm install
npm install pkg
function npm-do { (PATH=$(npm bin):$PATH; eval $@;) }
npm-do pkg package.json --out-path output
