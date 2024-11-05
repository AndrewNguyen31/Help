-- For your project create three views for any 3 tables

-- User Status View [show user username, full name, and status]
CREATE VIEW UserStatusView
AS
    SELECT u.username, u.firstName + ' ' + u.lastName AS fullName, s.description AS statusDescription
    FROM Users u
        JOIN Hold_Status hs ON u.username = hs.username
        JOIN Status s ON hs.statusID = s.statusID;

GO

-- Business Review Summary View [show business name, business type, average rating, and review count]
CREATE VIEW BusinessReviewSummary
AS
    SELECT b.businessID, b.name, b.overallRating, b.reviewCount, b.businessType
    FROM Business b;

GO

-- Detailed Review View [show all review details like reviewer username, business name, description, etc.]
CREATE VIEW DetailedReviewView
AS
    SELECT r.reviewID, r.username, u.firstName + ' ' + u.lastName AS reviewerName, b.name AS businessName, r.rating, r.description
    FROM Review r
        JOIN Users u ON r.username = u.username
        JOIN Business_Review br ON r.reviewID = br.reviewID
        JOIN Business b ON br.businessID = b.businessID;