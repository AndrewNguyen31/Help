async function fetchData(endpoint) {
    const response = await fetch(`/${endpoint}`);
    if (!response.ok) throw new Error(`HTTP error! status: ${response.status}`);
    return await response.json();
}

async function postData(endpoint, data) {
    const response = await fetch(`/${endpoint}`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify(data)
    });
    return await response.json();
}

async function putData(endpoint, id, data) {
    const response = await fetch(`/${endpoint}/${id}`, {
        method: 'PUT',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify(data)
    });
    return await response.json();
}

async function deleteData(endpoint, id) {
    const response = await fetch(`/${endpoint}/${id}`, {
        method: 'DELETE'
    });
    return await response.json();
}