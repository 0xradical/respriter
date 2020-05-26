import axios from "axios";

const URL_ENDPOINTS = {
  PreviewCourse: courseId => `/developers/preview_course_videos/${courseId}`,
  Course: courseId => `/videos/${courseId}`
};

const response = (courseId, courseType) => ({
  json: () => {
    return new Promise(function(resolve, reject) {
      axios
        .get(URL_ENDPOINTS[courseType || "Course"](courseId))
        .then(({ data }) => resolve(data))
        .catch(error => reject(error));
    });
  }
});

export default function videoService(courseId, courseType) {
  return new Promise(function(resolve, reject) {
    resolve(response(courseId, courseType));
  });
}
