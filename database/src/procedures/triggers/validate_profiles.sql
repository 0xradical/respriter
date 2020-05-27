CREATE OR REPLACE FUNCTION triggers.validate_profiles() RETURNS trigger AS $$
DECLARE
  _platform     text;
  _url          text;
  _host         text;
  _url_path     text;
  _id           text;
  _path_pattern text;
BEGIN
  -- social profiles
  IF (
      NEW.social_profiles IS NOT NULL AND
      NEW.social_profiles <> '{}'
    ) THEN

    FOR _platform, _url IN
       SELECT * FROM jsonb_each_text(NEW.social_profiles)
    LOOP
      WITH parsed AS (
        SELECT alias, token FROM ts_debug(_url)
      )
      SELECT (SELECT token FROM parsed WHERE alias = 'host') AS host,
              (SELECT token FROM parsed WHERE alias = 'url_path') AS url_path
        INTO _host, _url_path;

      IF (_host IS NULL) OR (_url_path IS NULL) THEN
        RAISE EXCEPTION 'social_profiles update failed' USING DETAIL = 'public_profile__invalid_uri', HINT = json_build_object('value', _url);
      END IF;

      CASE _platform
      WHEN 'behance' THEN
        -- /thiagobrandam
        _path_pattern := SUBSTR(_url_path, 1, 1);
        _id := SUBSTR(_url_path, 2);

        IF (_host <> 'behance.net') OR
           (_path_pattern <> '/') OR
           (_id !~ '^(?!.*(?:\/))(?:[A-z\d\-_]){3,20}$') THEN
          RAISE EXCEPTION 'social_profiles update failed' USING DETAIL = 'public_profile__invalid_format', HINT = json_build_object('platform', _platform);
        END IF;
      WHEN 'dribbble' THEN
        -- /thiagobrandam
        _path_pattern := SUBSTR(_url_path, 1, 1);
        _id := SUBSTR(_url_path, 2);

        IF (_host <> 'dribbble.com') OR
           (_path_pattern <> '/') OR
           (_id !~ '^(?!.*(?:\/))(?:[A-z\d\-_]){2,20}$') THEN
          RAISE EXCEPTION 'social_profiles update failed' USING DETAIL = 'public_profile__invalid_format', HINT = json_build_object('platform', _platform);
        END IF;
      WHEN 'facebook' THEN
        -- /thiagobrandam
        _path_pattern := SUBSTR(_url_path, 1, 1);
        _id := SUBSTR(_url_path, 2);

        IF  (_host <> 'facebook.com') OR
            (_path_pattern <> '/') OR
            (_id !~ '^(?!.*(?:\/))(?:(?:(?:[A-z\d])(?:[A-z\d]|[.-](?=[A-z\d])){4,50})|(?:\d{15}))$') THEN
          RAISE EXCEPTION 'social_profiles update failed' USING DETAIL = 'public_profile__invalid_format', HINT = json_build_object('platform', _platform);
        END IF;
      WHEN 'github' THEN
        -- /thiagobrandam
        _path_pattern := SUBSTR(_url_path, 1, 1);
        _id := SUBSTR(_url_path, 2);

        IF  (_host <> 'github.com') OR
            (_path_pattern <> '/') OR
            (_id !~ '^(?!.*(?:\/))[A-z\d](?:[A-z\d]|-(?=[A-z\d])){0,38}$') THEN
          RAISE EXCEPTION 'social_profiles update failed' USING DETAIL = 'public_profile__invalid_format', HINT = json_build_object('platform', _platform);
        END IF;
      WHEN 'instagram' THEN
        -- /thiagobrandam
        _path_pattern := SUBSTR(_url_path, 1, 1);
        _id := SUBSTR(_url_path, 2);

        IF  (_host <> 'instagram.com') OR
            (_path_pattern <> '/') OR
            (_id !~ '^(?!.*(?:\/))([A-z\d._](?:(?:[A-z\d._]|(?:\.(?!\.))){2,28}(?:[A-z\d._]))?)$') THEN
          RAISE EXCEPTION 'social_profiles update failed' USING DETAIL = 'public_profile__invalid_format', HINT = json_build_object('platform', _platform);
        END IF;
      WHEN 'linkedin' THEN
        -- /in/thiagobrandam
        _path_pattern := SUBSTR(_url_path, 1, LENGTH('/in/'));
        _id := SUBSTR(_url_path, LENGTH('/in/') + 1);

        IF  (_host <> 'linkedin.com') OR
            (_path_pattern <> '/in/') OR
            (_id !~ '^(?!.*(?:\/))[A-zÀ-ÿ\d](?:[A-zÀ-ÿ\d]|-(?=[A-zÀ-ÿ\d])){2,99}$') THEN
          RAISE EXCEPTION 'social_profiles update failed' USING DETAIL = 'public_profile__invalid_format', HINT = json_build_object('platform', _platform);
        END IF;
      WHEN 'pinterest' THEN
        -- /thiagobrandam
        _path_pattern := SUBSTR(_url_path, 1, 1);
        _id := SUBSTR(_url_path, 2);

        IF  (_host <> 'pinterest.com') OR
            (_path_pattern <> '/') OR
            (_id !~ '^(?!.*(?:\/))[A-z\d](?:[A-z\d]|_){2,29}$') THEN
          RAISE EXCEPTION 'social_profiles update failed' USING DETAIL = 'public_profile__invalid_format', HINT = json_build_object('platform', _platform);
        END IF;
      WHEN 'reddit' THEN
        -- /user/thiagobrandam
        _path_pattern := SUBSTR(_url_path, 1, LENGTH('/user/'));
        _id := SUBSTR(_url_path, LENGTH('/user/') + 1);

        IF  (_host <> 'reddit.com') OR
            (_path_pattern <> '/user/') OR
            (_id !~ '^(?!.*(?:\/))(?:[A-z\d\-_]){3,20}$') THEN
          RAISE EXCEPTION 'social_profiles update failed' USING DETAIL = 'public_profile__invalid_format', HINT = json_build_object('platform', _platform);
        END IF;
      WHEN 'soundcloud' THEN
        -- /thiagobrandam
        _path_pattern := SUBSTR(_url_path, 1, 1);
        _id := SUBSTR(_url_path, 2);

        IF  (_host <> 'soundcloud.com') OR
            (_path_pattern <> '/') OR
            (_id !~ '^(?!.*(?:\/))(?:[a-z\d](?:[a-z\d]|[-_](?=[a-z\d])){2,24})$') THEN
          RAISE EXCEPTION 'social_profiles update failed' USING DETAIL = 'public_profile__invalid_format', HINT = json_build_object('platform', _platform);
        END IF;
      WHEN 'twitter' THEN
        -- /thiagobrandam
        _path_pattern := SUBSTR(_url_path, 1, 1);
        _id := SUBSTR(_url_path, 2);

        IF  (_host <> 'twitter.com') OR
            (_path_pattern <> '/') OR
            (_id !~ '^(?!.*(?:\/))[A-z\d_]{4,15}$') THEN
          RAISE EXCEPTION 'social_profiles update failed' USING DETAIL = 'public_profile__invalid_format', HINT = json_build_object('platform', _platform);
        END IF;
      WHEN 'youtube' THEN
        -- /channel/UCasdjfsafkjasdkflj
        _path_pattern := SUBSTR(_url_path, 1, LENGTH('/channel/'));
        _id := SUBSTR(_url_path, LENGTH('/channel/') + 1);

        IF  (_host <> 'youtube.com') OR
            (_path_pattern <> '/channel/') OR
            (_id !~ '^(?!.*(?:\/))UC(?:[A-z\d_-]){22}$') THEN
          RAISE EXCEPTION 'social_profiles update failed' USING DETAIL = 'public_profile__invalid_format', HINT = json_build_object('platform', _platform);
        END IF;
      ELSE
        NULL;
      END CASE;
    END LOOP;
  END IF;

  -- elearning profiles
  IF (
      NEW.elearning_profiles IS NOT NULL AND
      NEW.elearning_profiles <> '{}'
    ) THEN

    FOR _platform, _url IN
       SELECT * FROM jsonb_each_text(NEW.elearning_profiles)
    LOOP
      WITH parsed AS (
        SELECT alias, token FROM ts_debug(_url)
      )
      SELECT (SELECT token FROM parsed WHERE alias = 'host') AS host,
              (SELECT token FROM parsed WHERE alias = 'url_path') AS url_path
        INTO _host, _url_path;

      IF (_host IS NULL) OR (_url_path IS NULL) THEN
        RAISE EXCEPTION 'elearning_profiles update failed' USING DETAIL = 'public_profile__invalid_uri', HINT = json_build_object('value', _url);
      END IF;

      CASE _platform
      WHEN 'linkedin_learning' THEN
        -- /learning/instructors/thiagobrandam
        _path_pattern := SUBSTR(_url_path, 1, LENGTH('/learning/instructors/'));
        _id := SUBSTR(_url_path, LENGTH('/learning/instructors/') + 1);

        IF  (_host <> 'linkedin.com') OR
            (_path_pattern <> '/learning/instructors/') OR
            (_id !~ '^(?!.*(?:\/))[a-z\d](?:[a-z\d]|-(?=[a-z\d])){2,}$') THEN
          RAISE EXCEPTION 'elearning_profiles update failed' USING DETAIL = 'public_profile__invalid_format', HINT = json_build_object('platform', _platform);
        END IF;
      WHEN 'masterclass' THEN
        -- /classes/thiagobrandam
        _path_pattern := SUBSTR(_url_path, 1, LENGTH('/classes/'));
        _id := SUBSTR(_url_path, LENGTH('/classes/') + 1);

        IF  (_host <> 'masterclass.com') OR
            (_path_pattern <> '/classes/') OR
            (_id !~ '^(?!.*(?:\/))(?:[a-z\d](?:[a-z\d]|-(?=[a-z\d])){9,})$') THEN
          RAISE EXCEPTION 'elearning_profiles update failed' USING DETAIL = 'public_profile__invalid_format', HINT = json_build_object('platform', _platform);
        END IF;
      WHEN 'pluralsight' THEN
        -- /authors/thiagobrandam
        _path_pattern := SUBSTR(_url_path, 1, LENGTH('/authors/'));
        _id := SUBSTR(_url_path, LENGTH('/authors/') + 1);

        IF  (_host <> 'pluralsight.com') OR
            (_path_pattern <> '/authors/') OR
            (_id !~ '^(?!.*(?:\/))[a-z\d](?:[a-z\d]|-(?=[a-z\d])){4,}$') THEN
          RAISE EXCEPTION 'elearning_profiles update failed' USING DETAIL = 'public_profile__invalid_format', HINT = json_build_object('platform', _platform);
        END IF;
      WHEN 'skillshare' THEN
        -- /user/thiagobrandam
        _path_pattern := SUBSTR(_url_path, 1, LENGTH('/user/'));
        _id := SUBSTR(_url_path, LENGTH('/user/') + 1);

        IF  (_host <> 'skillshare.com') OR
            (_path_pattern <> '/user/') OR
            (_id !~ '^(?!.*(?:\/))(?:[a-z\d\-_]{3,30})$') THEN
          RAISE EXCEPTION 'elearning_profiles update failed' USING DETAIL = 'public_profile__invalid_format', HINT = json_build_object('platform', _platform);
        END IF;
      WHEN 'treehouse' THEN
        -- /thiagobrandam
        _path_pattern := SUBSTR(_url_path, 1, 1);
        _id := SUBSTR(_url_path, 2);

        IF  (_host <> 'teamtreehouse.com') OR
            (_path_pattern <> '/') OR
            (_id !~ '^(?!.*(?:\/))(?:[a-z]{3,30})$') THEN
          RAISE EXCEPTION 'elearning_profiles update failed' USING DETAIL = 'public_profile__invalid_format', HINT = json_build_object('platform', _platform);
        END IF;
      WHEN 'udemy' THEN
        -- /user/thiagobrandam
        _path_pattern := SUBSTR(_url_path, 1, LENGTH('/user/'));
        _id := SUBSTR(_url_path, LENGTH('/user/') + 1);

        IF  (_host <> 'udemy.com') OR
            (_path_pattern <> '/user/') OR
            (_id !~ '^(?!.*(?:\/))[a-z\d\-_]{3,60}$') THEN
          RAISE EXCEPTION 'elearning_profiles update failed' USING DETAIL = 'public_profile__invalid_format', HINT = json_build_object('platform', _platform);
        END IF;
      ELSE
        NULL;
      END CASE;
    END LOOP;
  END IF;

  RETURN NEW;
END;
$$ SECURITY DEFINER STABLE LANGUAGE plpgsql;