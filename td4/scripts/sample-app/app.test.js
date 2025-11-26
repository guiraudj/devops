//app.test.js
const request = require('supertest');
const app = require('./app');

describe('Test the root path', () => {
    test('It should respond to the GET method', async () => {
        const response = await request(app).get('/');
        expect(response.statusCode).toBe(200);
        expect(response.text).toBe('Hello, World!');
    });
});

describe('Test the /name/:name path', () => {
    test('It should respond with a personalized greeting', async () => {
        const name = 'Alice';
        const response = await request(app).get(`/name/${name}`);
        expect(response.statusCode).toBe(200);
        expect(response.text).toBe(`Hello, ${name}!`);
    });
});

describe('Test the /add/:a/:b path', () => {
    test('It should return the correct sum for two numbers', async () => {
        const a = 5;
        const b = 10;
        const response = await request(app).get(`/add/${a}/${b}`);
        
        expect(response.statusCode).toBe(200);
        expect(response.body).toEqual({ sum: '15' });
    });

    test('It should return 400 for non-numeric inputs', async () => {
        const a = 5;
        const b = 'not-a-number';
        const response = await request(app).get(`/add/${a}/${b}`);
        
        expect(response.statusCode).toBe(400);
        expect(response.text).toBe("Error: the two parameters must be valid numbers.");
    });

    test('It should handle floating point numbers', async () => {
        const a = 1.5;
        const b = 2.5;
        const response = await request(app).get(`/add/${a}/${b}`);
        
        expect(response.statusCode).toBe(200);
        expect(response.body).toEqual({ sum: '4' });
    });
});

// NOUVEAU TEST TDD POUR LA SOUSTRACTION
describe('Test the /subtract/:a/:b path', () => {
    // Cas de succès (TDD Green - Ex 13)
    test('It should return the difference of two numbers', async () => {
        const a = 10;
        const b = 4;
        const response = await request(app).get(`/subtract/${a}/${b}`);
        
        expect(response.statusCode).toBe(200);
        expect(response.body).toEqual({ result: 6 });
    });

    // NOUVEAU TEST (Code Coverage - Ex 14)
    // Vérifie que l'erreur est renvoyée si les paramètres ne sont pas des nombres
    test('It should return 400 for non-numeric inputs', async () => {
        const a = 10;
        const b = 'invalid';
        const response = await request(app).get(`/subtract/${a}/${b}`);
        
        expect(response.statusCode).toBe(400);
        expect(response.text).toBe("Error: parameters must be numbers.");
    });
});