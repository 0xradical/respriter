CREATE FUNCTION triggers.user_encrypt_password()
RETURNS trigger AS $$
BEGIN
  IF NEW.password ~* '^\$\d\w\$\d{2}\$[^$]{53}$' THEN
    RETURN NEW;
  END IF;

  IF tg_op = 'INSERT' OR NEW.password != OLD.password THEN
    NEW.password = crypt(NEW.password, gen_salt('bf', 11));
  END IF;

  RETURN NEW;
end
$$ SECURITY DEFINER LANGUAGE plpgsql;
