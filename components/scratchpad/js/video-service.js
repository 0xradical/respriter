import course from "./course";

const response = {
  json: () => {
    return new Promise(function(resolve, reject) {
      resolve({
        url: `//youtube.com/embed/${course.video.id}?showinfo=0&rel=0&enablejsapi=1`,
        embed: true
      });
    });
  }
};

export default function videoService(id) {
  return new Promise(function(resolve, reject) {
    resolve(response);
  });
}
