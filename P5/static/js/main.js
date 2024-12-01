async function fetchData(endpoint) {
    try {
        const response = await fetch(`/${endpoint}`);
        const data = await response.json();
        return data;
    } catch (error) {
        console.error('Error fetching data:', error);
        return null;
    }
}

async function postData(endpoint, data) {
    try {
        const response = await fetch(`/${endpoint}`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(data),
        });
        return await response.json();
    } catch (error) {
        console.error('Error posting data:', error);
        return null;
    }
}