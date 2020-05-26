export const SOCIAL_PLATFORMS = [
  "behance",
  "dribbble",
  "facebook",
  "github",
  "instagram",
  "linkedin",
  "pinterest",
  "reddit",
  "soundcloud",
  "twitter",
  "youtube"
].sort();

export const ELEARNING_PLATFORMS = [
  "linkedin_learning",
  "masterclass",
  "pluralsight",
  "skillshare",
  "treehouse",
  "udemy"
].sort();

export const platformReducer = function (platforms) {
  return function (reducer) {
    return platforms.reduce(
      (platforms, platform) => ({
        ...platforms,
        [platform]: reducer(platform)
      }),
      {}
    );
  };
};

const requirePlatform = platform => require(`./${platform}`);

export const socialPlatformsReducer = platformReducer(SOCIAL_PLATFORMS);
export const elearningPlatformsReducer = platformReducer(ELEARNING_PLATFORMS);

export const socialPlatformsValidations = socialPlatformsReducer(
  requirePlatform
);
export const elearningPlatformsValidations = elearningPlatformsReducer(
  requirePlatform
);

export default {
  ...socialPlatformsValidations,
  ...elearningPlatformsValidations
};
