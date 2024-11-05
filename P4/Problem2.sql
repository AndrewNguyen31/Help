-- For your project create three functions and emphasize how or why they would be used

-- 1. Calculate User Engagement Score
-- This function calculates a user's engagement score based on their review count, comment count, and the duration of their membership.
-- It's useful for identifying active and valuable users on the platform.
CREATE FUNCTION CalculateUserEngagementScore
(
    @Username NVARCHAR(50)
)
RETURNS FLOAT
AS
BEGIN
    DECLARE @EngagementScore FLOAT
    DECLARE @CommentCount INT
    DECLARE @ReviewCount INT
    DECLARE @DaysSinceJoin INT

    SELECT @ReviewCount = reviewCount,
        @DaysSinceJoin = DATEDIFF(DAY, dateJoined, GETDATE())
    FROM Users
    WHERE username = @Username

    SELECT @CommentCount = COUNT(*)
    FROM Comment
    WHERE username = @Username

    SET @EngagementScore = (@ReviewCount * 2 + @CommentCount) / (CAST(@DaysSinceJoin AS FLOAT) / 30)

    RETURN @EngagementScore
END

GO

-- 2. Get Business Rating Distribution
-- This function returns the distribution of ratings for a specific business.
-- It's useful for understanding the spread of ratings and identifying potential biases.
CREATE FUNCTION GetBusinessRatingDistribution
(
    @BusinessID NVARCHAR(50)
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        rating,
        COUNT(*) AS count,
        CAST(COUNT(*) AS FLOAT) / 
            (SELECT COUNT(*) FROM Business_Review WHERE businessID = @BusinessID) AS percentage
    FROM 
        Business_Review br
    JOIN 
        Review r ON br.reviewID = r.reviewID
    WHERE 
        br.businessID = @BusinessID
    GROUP BY 
        rating
)

GO

-- 3. Calculate Review Helpfulness
-- This function calculates the helpfulness of a review based on the number of comments it receives relative to the total number of reviews in the system.
-- It's useful for identifying particularly insightful or controversial reviews.
CREATE FUNCTION CalculateReviewHelpfulness
(
    @ReviewID NVARCHAR(50)
)
RETURNS FLOAT
AS
BEGIN
    DECLARE @CommentCount INT
    DECLARE @TotalReviews INT
    DECLARE @Helpfulness FLOAT

    SELECT @CommentCount = COUNT(*)
    FROM Comment
    WHERE reviewID = @ReviewID

    SELECT @TotalReviews = COUNT(*)
    FROM Review

    SET @Helpfulness = (CAST(@CommentCount AS FLOAT) / @TotalReviews) * 100

    RETURN @Helpfulness
END