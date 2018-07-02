export default (url, methods = 'get', body = {}) => {
  return request(url, methods, body).then(response => {
    if (!response.ok) {
      throw Error(response.statusText)
    }
    return response.json()
  }).catch(err => {
     throw Error(err) // network error
  })
}

function request (url, methods, body) {
  const token = document.head.children['csrf-token'].content
  switch (methods.toLowerCase()) {
    case 'get':
      return fetch(url, {
        method: 'GET',
        mode: 'cors',
        credentials: 'include',
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'x-csrf-token': token
        }
      })
    case 'post':
      return fetch(url, {
        method: 'POST',
        mode: 'cors',
        credentials: 'include',
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'x-csrf-token': token
        },
        body: JSON.stringify(body)
      })
    case 'put':
      return fetch(url, {
        method: 'PUT',
        mode: 'cors',
        credentials: 'include',
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'x-csrf-token': token
        },
        body: JSON.stringify(body)
      })
    case 'delete':
      return fetch(url, {
        method: 'DELETE',
        mode: 'cors',
        credentials: 'include',
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'x-csrf-token': token
        }
      })
  }
}
