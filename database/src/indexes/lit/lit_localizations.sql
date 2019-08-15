CREATE INDEX index_lit_localizations_on_locale_id
ON lit.lit_localizations
USING btree (locale_id);

CREATE INDEX index_lit_localizations_on_localization_key_id
ON lit.lit_localizations
USING btree (localization_key_id);

CREATE UNIQUE INDEX index_lit_localizations_on_localization_key_id_and_locale_id
ON lit.lit_localizations
USING btree (localization_key_id, locale_id);
