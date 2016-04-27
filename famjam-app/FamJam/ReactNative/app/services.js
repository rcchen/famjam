export const BASE_URL = "https://young-eyrie-25027.herokuapp.com/api"

export function fetchTopic(id, token) {
  return fetch(BASE_URL + "/topics/" + id, {
      method: "GET",
      headers: {
        "Authorization": "Bearer " + token
      }
    })
    .then(response => response.json());
}

export function fetchSignedUploadUrl(token) {
  return fetch(BASE_URL + "/get_signed_upload", {
    method: "POST",
    headers: {
      "Authorization": "Bearer " + token,
      "Content-Type": "application/json",
      "x-amz-acl": "public-read"
    },
    body: JSON.stringify({
      file_type: "image/jpeg"
    })
  })
  .then(response => response.text());
}
