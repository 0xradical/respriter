CREATE FUNCTION triggers.gen_compound_ext_id() RETURNS trigger AS $$
BEGIN
  NEW.compound_ext_id = concat(NEW.source,'_',NEW.ext_id);
  return NEW;
END
$$ LANGUAGE plpgsql;
