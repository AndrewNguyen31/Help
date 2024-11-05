-- Create 3 non-clustered indexes on your tables

-- 1. Non-clustered index on Users table for username
-- This index improves the performance of queries that search or join on the username column.
-- It's particularly useful for operations like user lookups, authentication, and joining with other tables.
CREATE NONCLUSTERED INDEX idx_username ON Users(username)

-- 2. Non-clustered index on Business table for businessType and overallRating
-- This composite index enhances queries that filter or sort businesses by type and rating.
-- It's beneficial for searches like "top-rated restaurants" or "highly-rated entertainment venues".
CREATE NONCLUSTERED INDEX idx_businessType_overallRating ON Business(businessType, overallRating)

-- 3. Non-clustered index on the Review table for username and rating
-- This index improves query performance for searches that filter or sort reviews by username and rating.
-- It's particularly useful for operations like finding all reviews by a specific user or retrieving reviews within a certain rating range.
CREATE NONCLUSTERED INDEX idx_Review_Username_Rating ON Review (username, rating)