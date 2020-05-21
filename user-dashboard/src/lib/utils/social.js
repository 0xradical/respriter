import {
  socialPlatformsReducer,
  elearningPlatformsReducer
} from "~validations/social";

/**
 * Mapping of social and elearning platforms to icons
 */

const defaultIconMapper = p => ({ icon: p, color: p });

export const SOCIAL_ICONS = {
  ...socialPlatformsReducer(defaultIconMapper),
  facebook: { icon: "facebook-circle", color: "facebook" },
  github: { icon: "github-circle", color: "github" }
};

export const ELEARNING_ICONS = {
  ...elearningPlatformsReducer(defaultIconMapper),
  linkedin_learning: { icon: "linkedin", color: "linkedin" }
};
