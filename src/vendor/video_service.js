import axios from "axios";
import normalizeUrl from "normalize-url";
import env from "~config/environment";

const ENDPOINTS = {
  // eslint-disable-next-line no-undef
  PreviewCourse: courseId => normalizeUrl(`${env.previewVideoServiceEndpoint}/${courseId}`),
  // eslint-disable-next-line no-undef
  Course: courseId => normalizeUrl(`${env.videoServiceEndpoint}/${courseId}`)
};

const response = (courseId, courseType) => ({
  json: () => {
    return new Promise(function(resolve, reject) {
      axios
        .get(ENDPOINTS[courseType || "Course"](courseId))
        .then(({ data }) => resolve(data))
        .catch(error => reject(error));
    });
  }
});

export default function videoService(courseId, courseType) {
  // eslint-disable-next-line no-unused-vars
  return new Promise(function(resolve, _reject) {
    resolve(response(courseId, courseType));
  });
}
