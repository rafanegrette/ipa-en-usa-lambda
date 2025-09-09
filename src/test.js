const handler = require('./index').handler;

const testEvent = {
    text: "Anderson said, “Where's Jimmy, dear? "
};

handler(testEvent).then(response => {
    console.log('Response:', response);
}).catch(error => {
    console.error('Error:', error);
});