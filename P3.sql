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
    reviewCount INT DEFAULT 0,
    statusID INT NOT NULL,
    CONSTRAINT User_FK FOREIGN KEY (statusID) REFERENCES Status(statusID)
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
    businessID INT NOT NULL,
    rating INT CHECK (rating >= 1 AND rating <= 5),
    [description] NVARCHAR(255),
    CONSTRAINT Review_User_FK FOREIGN KEY (username) REFERENCES Users(username),
    CONSTRAINT Review_Business FOREIGN KEY (businessID) REFERENCES Business(businessID)
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
-- Query 1: Find small businesses (less than 100 reviews) (Aggregate)

-- Query 2: Find average ratings for the businesses (Aggregate)

-- Query 3: Find total number of comments for each review (Aggregate)

-- Query 4: Find total number of reviews for each status (Join)

-- Query 5: Find the most common business type (Subquery)

-- Query 6: Find the average number of reviews a user posts (Aggregate)

-- Query 7: Find the number of businesses per state (Aggregate)

-- Query 8: Find the most common reviewer status for each business (Join)

-- Query 9: Find the most common type of business each user reviews (Subquery)

-- Query 10: Find the total number of users with a 'Gold' status type (Aggregate)

-- Query 11: Find the breakdown for status types for all users (Aggregate)