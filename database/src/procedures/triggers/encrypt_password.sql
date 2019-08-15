CREATE FUNCTION triggers.encrypt_password() RETURNS trigger
AS $$
BEGIN
  IF NEW.encrypted_password ~* '^\$\d\w\$\d{2}\$[^$]{53}$' THEN
    RETURN NEW;
  END IF;

  IF tg_op = 'INSERT' OR NEW.encrypted_password <> OLD.encrypted_password THEN
    NEW.encrypted_password = crypt(NEW.encrypted_password, gen_salt('bf', 11));
  END IF;

  RETURN NEW;
end
$$ LANGUAGE plpgsql;
