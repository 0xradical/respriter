import axios from "axios";

const response = courseId => ({
  json: () => {
    return new Promise(function(resolve, reject) {
      axios
        .get(`/videos/${courseId}`)
        .then(({ data }) => resolve(data))
        .catch(error => reject(error));
    });
  }
});

export default function videoService(courseId) {
  return new Promise(function(resolve, reject) {
    resolve(response(courseId));
  });
}
