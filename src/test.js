const handler = require('./index').handler;

const testEvent = {
    text: "Hello this is a beautiful days"
};

handler(testEvent).then(response => {
    console.log('Response:', response);
}).catch(error => {
    console.error('Error:', error);
});