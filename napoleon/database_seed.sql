INSERT INTO app.datasets (
  id,
  name
) VALUES (
  'c1225396-28e1-11ea-9078-0242ac150002',
  'Classpert'
);

INSERT INTO app.users (
  dataset_id,
  email,
  password
) VALUES (
  'c1225396-28e1-11ea-9078-0242ac150002',
  'user@classpert.com',
  'abc123'
);
