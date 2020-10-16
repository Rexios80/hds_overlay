const resourceHacker = require('@lorki97/node-resourcehacker');
 
resourceHacker({
    operation: 'modify',
    input: 'output/HDS-Overlay-win.exe',
    output: 'output/HDS-Overlay-win.exe',
    resource: 'win-icon.ico',
    resourceType: 'ICONGROUP',
    resourceName: '1'
}, (err) => {
 
    if(err) {
        return console.error(err);
    }
 
    console.log('Done.');
 
});