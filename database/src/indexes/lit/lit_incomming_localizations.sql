CREATE INDEX index_lit_incomming_localizations_on_incomming_id
ON lit.lit_incomming_localizations
USING btree (incomming_id);

CREATE INDEX index_lit_incomming_localizations_on_locale_id
ON lit.lit_incomming_localizations
USING btree (locale_id);

CREATE INDEX index_lit_incomming_localizations_on_localization_id
ON lit.lit_incomming_localizations
USING btree (localization_id);

CREATE INDEX index_lit_incomming_localizations_on_localization_key_id
ON lit.lit_incomming_localizations
USING btree (localization_key_id);

CREATE INDEX index_lit_incomming_localizations_on_source_id
ON lit.lit_incomming_localizations
USING btree (source_id);