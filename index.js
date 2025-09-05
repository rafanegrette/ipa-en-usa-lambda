const fs = require('fs');
const path = require('path');

// Global dictionary variable
let dictionary = {};

// Initialize and load dictionary upon Lambda cold start
const loadDictionary = () => {
    const filePath = path.resolve(__dirname, 'en_US.txt'); // Path to the dictionary file
    const fileContent = fs.readFileSync(filePath, 'utf8'); // Read the content of the file

    // Parse the dictionary into a key-value format
    const lines = fileContent.split('\n'); // Split lines
    lines.forEach(line => {
        const [key, value] = line.split(/\s+/); // Split on spaces or tabs
        if (key && value) {
            dictionary[key.trim()] = value.trim(); // Populate dictionary
        }
    });
};

// Lambda handler
exports.handler = async (event) => {
    // Load the dictionary on the first invocation (cold start)
    if (Object.keys(dictionary).length === 0) {
        loadDictionary();
    }

    // Parse the input text from the event
    const inputText = event?.text || ''; // Input provided in event object
    if (!inputText) {
        return { error: 'No input text provided' };
    }

    // Tokenize the input text into words and transform them using the dictionary
    const transformedText = inputText
        .split(/\s+/) // Split text into words based on spaces
        .map(word => {
            const pronunciation = dictionary[word.toLowerCase()];
            if (pronunciation) {
                // Remove forward slashes from IPA pronunciation and take only the first pronunciation
                const cleanPronunciation = pronunciation.replace(/\//g, '');
                return cleanPronunciation.split(',')[0].trim();
            }
            return word;
        }) // Replace word if found in dictionary, removing slashes
        .join(' '); // Join the words back into a single string

    // Return the transformed text
    return {
        original: inputText,
        transformed: transformedText
    };
};