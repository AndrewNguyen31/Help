-- For your project create one Trigger associated with any type of action between the referenced tables(primary-foreign key relationship tables)

-- Create a trigger that updates the Business table's reviewCount and overallRating whenever a new review is added to the Business_Review table
-- This trigger automatically updates the Business table whenever a new review is added.
-- It increments the reviewCount and recalculates the overallRating.
-- This ensures that the Business table always has up-to-date statistics without manual intervention.
CREATE TRIGGER trg_UpdateBusinessStats
ON Business_Review
AFTER INSERT
AS
BEGIN
    -- Declare variables to store the businessID, new rating, and review count
    DECLARE @BusinessID NVARCHAR(50)
    DECLARE @NewRating FLOAT
    DECLARE @ReviewCount INT

    -- Get the businessID from the inserted row
    SELECT @BusinessID = businessID
    FROM inserted

    -- Get the new rating from the Review table
    SELECT @NewRating = r.rating
    FROM inserted i
        JOIN Review r ON i.reviewID = r.reviewID

    -- Get the current review count for the business
    SELECT @ReviewCount = reviewCount
    FROM Business
    WHERE businessID = @BusinessID

    -- Update the Business table
    UPDATE Business
    SET 
        reviewCount = reviewCount + 1,
        overallRating = ((overallRating * @ReviewCount) + @NewRating) / (@ReviewCount + 1)
    WHERE businessID = @BusinessID
END