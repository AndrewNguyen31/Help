-- For any 1 column in your table, implement the column encryption for security purposes

-- Create Master Key
-- This is the top-level encryption key in SQL Server's encryption hierarchy
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'StrongPassword123!';

-- Create Certificate
-- This certificate will be used to protect the symmetric key
CREATE CERTIFICATE EmailCert
WITH SUBJECT = 'Certificate for User Email Encryption';

-- Create Symmetric Key
-- This key will be used for the actual encryption and decryption of data
CREATE SYMMETRIC KEY EmailKey
WITH ALGORITHM = AES_256
ENCRYPTION BY CERTIFICATE EmailCert;

-- Add column for encrypted data
-- This new column will store the encrypted email addresses
ALTER TABLE Users
ADD EncryptedEmail VARBINARY(128);