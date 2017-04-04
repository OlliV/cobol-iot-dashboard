cobol-iot-dashboard
===================

COBOL CGI program storing and reading Redis + a simple AWS IoT Lambda
function.

https://youtu.be/WTMAnvDh4OY

The Lambda function
-------------------

```
'use strict';

const https = require('https');

exports.handler = (event, context, callback) => {
    console.log('Received event:', event.clickType);

    const options = {
        host: 'cobol-dashboard.now.sh',
        path: '/push',
        port: 443,
        method: 'GET'
    };

    const req = https.request(options, (res) => {
        callback();
    });
    req.end();
};
```

Powered by
----------

* [klange/cgiserver](https://github.com/klange/cgiserver)
* [Cobol on Wheelchair](https://github.com/azac/cobol-on-wheelchair)
