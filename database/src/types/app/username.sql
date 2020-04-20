CREATE DOMAIN app.username AS CITEXT;

ALTER DOMAIN app.username ADD CONSTRAINT username_format CHECK (NOT(value ~* '[^0-9a-zA-Z\.\-\_]'));
ALTER DOMAIN app.username ADD CONSTRAINT username_consecutive_dash CHECK (NOT(value ~* '--'));
ALTER DOMAIN app.username ADD CONSTRAINT username_consecutive_underline CHECK (NOT(value ~* '__'));
ALTER DOMAIN app.username ADD CONSTRAINT username_boundary_dash CHECK (NOT(value ~* '^-' OR value ~* '-$'));
ALTER DOMAIN app.username ADD CONSTRAINT username_boundary_underline CHECK (NOT(value ~* '^_' OR value ~* '_$'));
ALTER DOMAIN app.username ADD CONSTRAINT username_length_upper CHECK (LENGTH(value) <= 15);
ALTER DOMAIN app.username ADD CONSTRAINT username_length_lower CHECK (LENGTH(value) >= 5);
ALTER DOMAIN app.username ADD CONSTRAINT username_lowercased CHECK (value = LOWER(value));
