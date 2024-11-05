-- For your project create three stored procedures and emphasize how or why they would be used

-- Procedure 1: AddNewReview: It will be used whenever a user wants to write a review for a business. 
-- This will be a procedure since nothing needs to be returned, but it is something expected to be queried often. 
-- It will insert a new review, update the user’s review count, and update the business rating.
CREATE PROCEDURE AddNewReview
    @username NVARCHAR(50),
    @businessID INT,
    @rating INT,
    @description NVARCHAR(255)
AS
BEGIN
    DECLARE @reviewID NVARCHAR(50) = NEWID();
    -- Insert into Review table
    INSERT INTO Review
        (reviewID, username, rating, description)
    VALUES
        (@reviewID, @username, @rating, @description);
    -- Insert into Business_Review table
    INSERT INTO Business_Review
        (businessID, reviewID)
    VALUES
        (@businessID, @reviewID);
    -- Update User reviewCount
    UPDATE Users
SET reviewCount = reviewCount + 1
WHERE username = @username;
    -- Update Business reviewCount and overallRating
    UPDATE Business
SET reviewCount = reviewCount + 1,
overallRating = (overallRating * (reviewCount - 1) + @rating) / reviewCount
WHERE businessID = @businessID;
END;

GO

-- Procedure 2: UpdateUserStatus: It will be used whenever a user ranks up in their status. 
-- Since there’s no calculations involved, this can be a procedure. 
-- This procedure updates a user’s status based on the number of reviews posted.
CREATE PROCEDURE UpdateUserStatus
    @username NVARCHAR(50)
AS
BEGIN
    DECLARE @reviewCount INT;
    SELECT @reviewCount = reviewCount
    FROM Users
    WHERE username = @username;

    DECLARE @statusID INT;
    SET @statusID = CASE
WHEN @reviewCount >= 1000 THEN 30
WHEN @reviewCount >= 850 THEN 29
WHEN @reviewCount >= 750 THEN 28
WHEN @reviewCount >= 600 THEN 27
WHEN @reviewCount >= 500 THEN 26 
WHEN @reviewCount >= 450 THEN 25
WHEN @reviewCount >= 400 THEN 24
WHEN @reviewCount >= 350 THEN 23
WHEN @reviewCount >= 300 THEN 22
WHEN @reviewCount >= 250 THEN 21
WHEN @reviewCount >= 200 THEN 20
WHEN @reviewCount >= 175 THEN 19
WHEN @reviewCount >= 150 THEN 18
WHEN @reviewCount >= 125 THEN 17
WHEN @reviewCount >= 100 THEN 16
WHEN @reviewCount >= 90 THEN 15
WHEN @reviewCount >= 80 THEN 14
WHEN @reviewCount >= 70 THEN 13
WHEN @reviewCount >= 60 THEN 12
WHEN @reviewCount >= 50 THEN 11
WHEN @reviewCount >= 35 THEN 10
WHEN @reviewCount >= 25 THEN 9
WHEN @reviewCount >= 20 THEN 8
WHEN @reviewCount >=  15 THEN 7
WHEN @reviewCount >= 10 THEN 6
WHEN @reviewCount >= 8 THEN 5
WHEN @reviewCount >= 5 THEN 4
WHEN @reviewCount >= 2 THEN 3
WHEN @reviewCount >= 1 THEN 2
ELSE 1 -- Iron 1 as default
END;

    -- Update Hold_Status
    UPDATE Hold_Status
SET statusID = @statusID
WHERE username = @username;
END;

GO

-- Procedure 3: GetBusinessReviews: Retrieves all reviews for a specific business. 
-- It will automatically sort it by date. 
-- This would be used when a user wants to look into what others think about the business.
CREATE PROCEDURE GetBusinessReviews
    @businessID INT
AS
BEGIN
    SELECT r.reviewID, r.username, r.rating, r.description, pr.date
    FROM Review r
        JOIN Business_Review br ON r.reviewID = br.reviewID
        JOIN Post_Review pr ON r.reviewID = pr.reviewID
    WHERE br.businessID = @businessID
    ORDER BY pr.date DESC;
END;