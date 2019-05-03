class HandleLaguagesProperly < ActiveRecord::Migration[5.2]
  def up
    execute up_sql_code
  end

  def down
    execute down_sql_code
  end

  protected
  def down_sql_code
    %{
      DROP FUNCTION IF EXISTS normalize_languages(languages text[]);
      DROP FUNCTION IF EXISTS course_normalize_languages_trigger();
      DROP TRIGGER  IF EXISTS course_normalize_languages ON courses;
    }
  end

  def up_sql_code
    File.read(__FILE__).match(/^__END__$/).post_match
  end
end

__END__

CREATE OR REPLACE FUNCTION
  normalize_languages(languages text[])
  RETURNS text[]
AS $$
DECLARE
  upcased_languages text[];
BEGIN
  WITH
  subtitles AS (
    SELECT DISTINCT unnest(languages) AS subtitle
  ),
  subtitle_arrays AS (
    SELECT regexp_split_to_array(subtitle, '-') AS subtitle_array
    FROM subtitles
  )
  SELECT DISTINCT
    ARRAY_AGG(
      CASE WHEN array_length(subtitle_array, 1) = 2
      THEN subtitle_array[1] || '-' || upper(subtitle_array[2])
      ELSE subtitle_array[1]
      END
    )
  FROM subtitle_arrays
  INTO upcased_languages;

  RETURN upcased_languages;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION
  course_normalize_languages_trigger()
  RETURNS trigger
AS $$
BEGIN
  NEW.audio     = normalize_languages(NEW.audio);
  NEW.subtitles = normalize_languages(NEW.subtitles);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER course_normalize_languages
  BEFORE INSERT OR UPDATE ON courses
  FOR EACH ROW
  EXECUTE PROCEDURE
    course_normalize_languages_trigger();

UPDATE courses SET
audio     = normalize_languages(audio),
subtitles = normalize_languages(subtitles);
