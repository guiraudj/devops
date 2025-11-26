exports.handler = async (event) => {
    const responseBody = {
        message: "Hello, JSON!",
        timestamp: new Date().toISOString()
    };

    return {
        statusCode: 200,
        body: JSON.stringify(responseBody),
        headers: {
            "Content-Type": "application/json"
        }
    };
};