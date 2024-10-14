-- Create the Hyelp database
CREATE DATABASE Hyelp

-- Create all the tables for the database
CREATE TABLE Status
(
    statusID INT PRIMARY KEY,
    statusName NVARCHAR(30) CHECK (statusName IN ('Bronze', 'Silver', 'Gold')),
    [description] NVARCHAR(255)
)

CREATE TABLE Users
(
    username NVARCHAR(50) PRIMARY KEY,
    firstName NVARCHAR(30) NOT NULL,
    lastName NVARCHAR(30) NOT NULL,
    dateOfBirth DATE,
    dateJoined DATE DEFAULT GETDATE(),
    userType NVARCHAR CHECK (userType IN ('Owner', 'Reviewer')),
    businessCount INT DEFAULT 0,
    reviewCount INT DEFAULT 0
)

CREATE TABLE Business
(
    businessID INT PRIMARY KEY,
    [name] NVARCHAR(255),
    overallRating FLOAT,
    reviewCount INT NOT NULL,
    street NVARCHAR(255),
    city NVARCHAR(100),
    [state] NVARCHAR(100),
    zipCode NVARCHAR(10),
    businessType NVARCHAR(100) CHECK (businessType in ('Restaurant', 'Entertainment', 'Service')),
    cuisineType NVARCHAR(100),
    entertainmentType NVARCHAR(100),
    serviceType NVARCHAR(100)
)

CREATE TABLE User_Email
(
    username NVARCHAR(50),
    email NVARCHAR(100),
    CONSTRAINT User_Email_PK PRIMARY KEY (username, email),
    CONSTRAINT User_Email_FK FOREIGN KEY (username) REFERENCES Users(username)
)

CREATE TABLE Holds
(
    username NVARCHAR(50) PRIMARY KEY,
    statusID INT,
    CONSTRAINT Holds_FK_User FOREIGN KEY (username) REFERENCES Users(username),
    CONSTRAINT HOlds_FK_Status FOREIGN KEY (statusID) REFERENCES [Status](statusID)
)

CREATE TABLE Review
(
    reviewID INT PRIMARY KEY,
    username NVARCHAR(50) NOT NULL,
    rating INT CHECK (rating >= 1 AND rating <= 5),
    [description] NVARCHAR(255),
    CONSTRAINT Review_User_FK FOREIGN KEY (username) REFERENCES Users(username)
)

CREATE TABLE Own
(
    username NVARCHAR(50),
    businessID INT,
    CONSTRAINT Own_PK PRIMARY KEY (username, businessID),
    CONSTRAINT Own_User_FK FOREIGN KEY (username) REFERENCES Users(username),
    CONSTRAINT Own_Business_FK FOREIGN KEY (businessID) REFERENCES Business(businessID)
)

CREATE TABLE Post_Review
(
    username NVARCHAR(50),
    reviewID INT,
    [date] DATE DEFAULT GETDATE(),
    CONSTRAINT Post_Review_PK PRIMARY KEY (username, reviewID),
    CONSTRAINT Post_Review_User_FK FOREIGN KEY (username) REFERENCES Users(username),
    CONSTRAINT Post_Review_Review_FK FOREIGN KEY (reviewID) REFERENCES Review(reviewID)
)

CREATE TABLE Comment
(
    commentID INT PRIMARY KEY,
    username NVARCHAR(50),
    reviewID INT,
    [description] NVARCHAR(255),
    CONSTRAINT Comment_User_FK FOREIGN KEY (username) REFERENCES Users(username),
    CONSTRAINT Comment_Review_FK FOREIGN KEY (reviewID) REFERENCES Review(reviewID)
)

CREATE TABLE Reply
(
    commentID INT,
    reviewID INT,
    [date] DATE DEFAULT GETDATE(),
    CONSTRAINT Reply_PK PRIMARY KEY (commentID, reviewID),
    CONSTRAINT Reply_Comment_FK FOREIGN KEY (commentID) REFERENCES Comment(commentID),
    CONSTRAINT Reply_Review_FK FOREIGN KEY (reviewID) REFERENCES Review(reviewID)
)

CREATE TABLE Post_Comment
(
    commentID INT,
    username NVARCHAR(50),
    [date] DATE DEFAULT GETDATE(),
    PRIMARY KEY (commentID, username),
    CONSTRAINT Post_CommentID_FK FOREIGN KEY (commentID) REFERENCES Comment(commentID),
    CONSTRAINT Post_User_FK FOREIGN KEY (username) REFERENCES Users(username)
)

CREATE TABLE Business_Review
(
    businessID INT,
    reviewID INT,
    PRIMARY KEY (businessID, reviewID),
    CONSTRAINT Business_FK FOREIGN KEY (businessID) REFERENCES Business(businessID),
    CONSTRAINT Review_FK FOREIGN KEY (reviewID) REFERENCES Review(reviewID)
)

-- Insert data into the tables


-- 10 SQL Queries
-- Query 1: Find small businesses (less than 100 reviews)

-- Query 2: Find average ratings for the businesses (Aggregate)
SELECT AVG(overallRating) AS AvgRating
FROM Business

-- Query 3: Find total number of comments for each review

-- Query 4: Find total number of reviews for each status (Aggregate + Join)
SELECT statusName, COUNT(r.reviewID) as ReviewCount
FROM [Status] s JOIN Holds h ON s.statusID = h.statusID JOIN Users u ON u.username = h.username JOIN Review r ON u.username = r.username
GROUP BY s.statusName

-- Query 5: Find the most common business type (Aggregate)
SELECT TOP 1
    businessType, COUNT(*) AS typeCount
FROM Business
GROUP BY businessType
ORDER BY typeCount DESC

-- Query 6: Find the average number of reviews a user posts

-- Query 7: Find the number of businesses per status

-- Query 8: Find the most common reviewer status for each business

-- Query 9: Find the most common type of business each user reviews (Aggregate + Join + Subquery)
WITH
    UserBusinessTypes
    AS
    (
        SELECT
            u.username,
            b.businessType,
            COUNT(*) AS reviewCount
        FROM
            Users u
            JOIN
            Review r ON u.username = r.username
            JOIN
            Business_Review br ON r.reviewID = br.reviewID
            JOIN
            Business b ON br.businessID = b.businessID
        GROUP BY 
        u.username, b.businessType
    ),
    MaxReviewCounts
    AS
    (
        SELECT
            username,
            MAX(reviewCount) AS maxCount
        FROM
            UserBusinessTypes
        GROUP BY 
        username
    )
SELECT
    ubt.username,
    ubt.businessType
FROM
    UserBusinessTypes ubt
    JOIN
    MaxReviewCounts mrc ON ubt.username = mrc.username AND ubt.reviewCount = mrc.maxCount

-- Query 10: Find the breakdown for status types for all users (Aggregate + Join)
SELECT s.statusName, COUNT(*) as UserCount
FROM [Status] s LEFT JOIN Holds h ON s.statusID = h.statusID
GROUP BY s.statusID