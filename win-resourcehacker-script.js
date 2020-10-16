const resourceHacker = require('node-resourcehacker');

resourceHacker({
    operation: 'addoverwrite',
    input: 'output/HDS-Overlay-win.exe',
    output: 'output/HDS-Overlay-win.exe',
    resource: 'win-icon.ico',
    resourceType: 'ICONGROUP',
    resourceName: 'IDR_MAINFRAME',
}, (err) => {

    if(err) {
        return console.error(err);
    }

    console.log('Done.');

});