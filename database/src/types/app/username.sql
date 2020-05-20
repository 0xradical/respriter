CREATE DOMAIN app.username AS CITEXT;

ALTER DOMAIN app.username ADD CONSTRAINT username__format CHECK (NOT(value ~* '[^0-9a-zA-Z\.\-\_]'));
ALTER DOMAIN app.username ADD CONSTRAINT username__consecutive_dash CHECK (NOT(value ~* '--'));
ALTER DOMAIN app.username ADD CONSTRAINT username__consecutive_underline CHECK (NOT(value ~* '__'));
ALTER DOMAIN app.username ADD CONSTRAINT username__boundary_dash CHECK (NOT(value ~* '^-' OR value ~* '-$'));
ALTER DOMAIN app.username ADD CONSTRAINT username__boundary_underline CHECK (NOT(value ~* '^_' OR value ~* '_$'));
ALTER DOMAIN app.username ADD CONSTRAINT username__length_upper CHECK (LENGTH(value) <= 15);
ALTER DOMAIN app.username ADD CONSTRAINT username__length_lower CHECK (LENGTH(value) >= 5);
ALTER DOMAIN app.username ADD CONSTRAINT username__lowercased CHECK (value = LOWER(value));
