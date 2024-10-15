-- Create the Hyelp database
CREATE DATABASE Hyelp

-- Create all the tables for the database
CREATE TABLE Status
(
    statusID INT PRIMARY KEY,
    statusName NVARCHAR(30) CHECK (
        statusName LIKE 'Iron %' OR
        statusName LIKE 'Bronze %' OR
        statusName LIKE 'Silver %' OR
        statusName LIKE 'Gold %' OR
        statusName LIKE 'Platinum %' OR
        statusName LIKE 'Diamond %'
    ),
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
-- Manual Insert 1: Status
INSERT INTO Status (statusID, statusName, [description]) VALUES 
(1, 'Iron 1', 'Basic entry-level status for beginners. General access and iron badge for profile unlocked'),
(2, 'Iron 2', 'Earn after posting first review'),
(3, 'Iron 3', 'Earn if in Iron 2 and post a review with written description'),
(4, 'Iron 4', 'Earn if in Iron 3 and post 5 reviews'),
(5, 'Iron 5', 'Earn if in Iron 4 and finish customizing profile'),
(6, 'Bronze 1', 'Earn if in Iron 5 and post 10 reviews. Bronze badge for profile unlocked'),
(7, 'Bronze 2', 'Earn if in Bronze 1 and post review with pictures. '),
(8, 'Bronze 3', 'Earn if in Bronze 2 and comment on another review '),
(9, 'Bronze 4', 'Earn if in Bronze 3 and post 15 reviews'),
(10, 'Bronze 5', 'Earn if in Bronze 4 and post 20 reviews'),
(11, 'Silver 1', 'Earn if in Bronze 5 and post 100 reviews Silver badge for profile unlocked'),
(12, 'Silver 2', 'Earn if in Silver 1 and '),
(13, 'Silver 3', 'Earn if in Silver 2 and '),
(14, 'Silver 4', 'Earn if in Silver 3 and '),
(15, 'Silver 5', 'Earn if in Silver 4 and '),
(16, 'Gold 1', 'Earn if in Silver 5 and post 100 reviews Gold badge for profile unlocked'),
(17, 'Gold 2', 'Earn if in Gold 1 and '),
(18, 'Gold 3', 'Earn if in Gold 2 and '),
(19, 'Gold 4', 'Earn if in Gold 3 and '),
(20, 'Gold 5', 'Earn if in Gold 4 and '),
(21, 'Platinum 1', 'Earn if in Gold 5 and post 250 reviews Platinum badge for profile unlocked'),
(22, 'Platinum 2', 'Earn if in Platinum 1 and'),
(23, 'Platinum 3', 'Earn if in Platinum 2 and'),
(24, 'Platinum 4', 'Earn if in Platinum 3 and'),
(25, 'Platinum 5', 'Earn if in Platinum 4 and'),
(26, 'Diamond 1', 'Earn if in Platinum 5 and post 500 reviews Diamond badge for profile unlocked'),
(27, 'Diamond 2', 'Earn if in Diamond 1'),
(28, 'Diamond 3', 'Earn if in Diamond 2 and'),
(29, 'Diamond 4', 'Earn if in Diamond 3 and'),
(30, 'Diamond 5', 'Earn if in Diamond 4 and post 1000 reviews. Get 10% off selected partnered stores.')

-- Manual Insert 2: Comment
INSERT INTO Comment (commentID, username, reviewID, [description]) VALUES 
(1, 'qVc8ODYU5SZjKXVBgXdI7w', 'saUsX_uimxRlCVr67Z4Jig', 'Great review! I had a similar experience at this place.'),
(2, 'AUi8MPWJ0mLkMfwbui27lg', 'AqPFMleE6RsU23_auESxiA', 'Thanks for the detailed review! It really helped me make a decision.'),
(3, 'QF1Kuhs8iwLWANNZxebTow', 'L0jv8c2FbpWSlfNC6bbUEA', 'I disagree with your rating, but your review is well-written.'),
(4, 'FT9CFS39sjZxVjCTrDHmdg', 'qGQvUHmC02PAZW3H1WTIfw', 'This review perfectly captures my thoughts on this restaurant.'),
(5, 'v7DwnrjzuTk7pXmuBPZnsg', '67cGcRrS0jTvB8p7rpaPew', 'Your review was really helpful. Thanks for sharing!'),
(6, '4ZaqBJqt7laPPs8xfWvr6A', 'fGYcFOHfQL4stYPdD3J47g', 'I appreciate the detailed breakdown. I''ll check this place out.'),
(7, '65uUyG9yuF0rdMh0z7ajaA', 'Ad91EzbAGRCR1SwkPfZJKg', 'I think your rating is too harsh, but I get your point.'),
(8, 'HoiOETUtwO4CL0PhjDCnSw', 'aAcQibR3zWOvk4atbCM3SA', 'Thanks for sharing your thoughts!'),
(9, 'KYBEVBAP7QUlt1LjmatTJg', 'zRIH5eDA2GbynjZPrk8dDg', 'This is a very well-thought-out review. Thanks for posting!'),
(10, 'AkBtT43dYcttxQ3qOzPBAg', 'JzBhoRVecH9pO0BBiJNQqw', 'I had the exact opposite experience here. Interesting read though!'),
(11, 'RDTVzWPoCeGaUujrHIWRBQ', 'meGaFP7yxQdjyABrYDVeoQ', 'Great review. Keep up the good work!'),
(12, '4ZaqBJqt7laPPs8xfWvr6A', 'gmVABJ9ctuispKPC7S1AeQ', 'I found this review very informative. Thanks!'),
(13, 'wrNOKq0hOlz8q1N_YCNXCA', 'fC415u9adP0Xtamme7hcCw', 'This place was a nightmare, but your review is spot on.'),
(14, 'kggqL33iZjeHmUn1Rtdjzg', 'gImS1dtA_TixEouDfp2o4g', 'I disagree, but your review gives a balanced perspective.'),
(15, 'OlJ9vcVFB1iEKcZO-MS3cQ', '8GZbCEMxrbqmRinDbfHWVQ', 'Interesting take on this restaurant, I''ll have to visit again.'),
(16, 'zjPbmmvO4QzE_nE9uErLTg', 'zJQ6jw7cuC5CJFonEhGncQ', 'Thanks for the review! Very helpful.'),
(17, 'NIhcRW6DWvk1JQhDhXwgOQ', 'bQt8QqosIDjDa3h14zTiZg', 'This review convinced me to visit this place. Thanks!'),
(18, '1L3O2CUTk27SnmqyPBWQdQ', '25o4ksHw1akeAAFwbIjLzA', 'Not sure I agree with your rating, but your points are valid.'),
(19, 'QF1Kuhs8iwLWANNZxebTow', 'AMUQ3ldi6ZxYWBWSQVf9iw', 'Excellent review, very detailed!'),
(20, 'SgiBkhXeqIKl1PlFpZOycQ', 'mqNAs4k835HzybNbNF5YVQ', 'This was very helpful! Thank you!'),
(21, '1McG5Rn_UDkmlkZOrsdptg', 'PLFXSReyR5ziN14TWXGqaw', 'Your review gave me a lot to think about.'),
(22, 'E9kcWJdJUHuTKfQurPljwA', 'F4b9qgpIyDvlag1kAvKVKA', 'Well-written review, I appreciate your thoughts.'),
(23, 'cxuxXkcihfCbqt5Byrup8Q', 'zM33UxkpJozHWhffyZQmAw', 'Thanks for sharing this. Very helpful!'),
(24, 'SZDeASXq7o05mMNLshsdIA', 'tLGZKv2A08KCRnfJivkHMw', 'I had a totally different experience here, but nice review.'),
(25, '2WnXYQFK0hXEoTxPtV2zvg', 'CLaaBwE5ZNKuvklE75wzlw', 'This was really helpful! Thanks for the thorough review.'),
(26, 'hA5lMy-EnncsH4JoR-hFGQ', 'A8bFrG4JnYVxYr63MFxhzw', 'Good review. I''ll consider this place for my next outing.'),
(27, '_crIokUeTCHVK_JVOy-0qQ', 'iRBGazfUjzqTE7jZVjRG8A', 'Thanks for the honest feedback!'),
(28, 'x7YtLnBW2dUnrrpwaofVQQ', 'SjIdGf61SUA8NdIONqTlXg', 'I appreciate your detailed review. Very informative.'),
(29, '1L3O2CUTk27SnmqyPBWQdQ', 'VMKbDvrXWBVJC913E34dfw', 'Good points made in this review!'),
(30, 'MGPQVLsODMm9ZtYQW-g_OA', 'G4nnwYJaTC6olpT0BSTtew', 'I enjoyed reading this review. Thank you for posting!');


-- Manual Insert 3: Post_Comment
INSERT INTO Post_Comment (commentID, username, [date]) VALUES 
(1, 'qVc8ODYU5SZjKXVBgXdI7w', '2024-10-01'),
(2, 'AUi8MPWJ0mLkMfwbui27lg', '2024-10-02'),
(3, 'QF1Kuhs8iwLWANNZxebTow', '2024-10-03'),
(4, 'FT9CFS39sjZxVjCTrDHmdg', '2024-10-03'),
(5, 'v7DwnrjzuTk7pXmuBPZnsg', '2024-10-04'),
(6, '4ZaqBJqt7laPPs8xfWvr6A', '2024-10-04'),
(7, '65uUyG9yuF0rdMh0z7ajaA', '2024-10-05'),
(8, 'HoiOETUtwO4CL0PhjDCnSw', '2024-10-06'),
(9, 'KYBEVBAP7QUlt1LjmatTJg', '2024-10-06'),
(10, 'AkBtT43dYcttxQ3qOzPBAg', '2024-10-07'),
(11, 'RDTVzWPoCeGaUujrHIWRBQ', '2024-10-08'),
(12, '4ZaqBJqt7laPPs8xfWvr6A', '2024-10-08'),
(13, 'wrNOKq0hOlz8q1N_YCNXCA', '2024-10-09'),
(14, 'kggqL33iZjeHmUn1Rtdjzg', '2024-10-10'),
(15, 'OlJ9vcVFB1iEKcZO-MS3cQ', '2024-10-10'),
(16, 'zjPbmmvO4QzE_nE9uErLTg', '2024-10-11'),
(17, 'NIhcRW6DWvk1JQhDhXwgOQ', '2024-10-11'),
(18, '1L3O2CUTk27SnmqyPBWQdQ', '2024-10-12'),
(19, 'QF1Kuhs8iwLWANNZxebTow', '2024-10-12'),
(20, 'SgiBkhXeqIKl1PlFpZOycQ', '2024-10-13'),
(21, '1McG5Rn_UDkmlkZOrsdptg', '2024-10-13'),
(22, 'E9kcWJdJUHuTKfQurPljwA', '2024-10-14'),
(23, 'cxuxXkcihfCbqt5Byrup8Q', '2024-10-14'),
(24, 'SZDeASXq7o05mMNLshsdIA', '2024-10-15'),
(25, '2WnXYQFK0hXEoTxPtV2zvg', '2024-10-15'),
(26, 'hA5lMy-EnncsH4JoR-hFGQ', '2024-10-16'),
(27, '_crIokUeTCHVK_JVOy-0qQ', '2024-10-16'),
(28, 'x7YtLnBW2dUnrrpwaofVQQ', '2024-10-16'),
(29, '1L3O2CUTk27SnmqyPBWQdQ', '2024-10-16'),
(30, 'MGPQVLsODMm9ZtYQW-g_OA', '2024-10-16')


-- 10 SQL Queries
-- Query 1: Find businesses with 0 reviews
SELECT COUNT(businessID) AS businessWithNoReviews
FROM Business WHERE reviewCount = 0

-- Query 2: Find average ratings for the businesses (Aggregate)
SELECT AVG(overallRating) AS AvgRating
FROM Business

-- Query 3: Find total number of comments for each review
SELECT reviewID, COUNT(commentID) AS totalComments
FROM Comment
GROUP BY reviewID

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
SELECT username, AVG(review_count) OVER() AS average_review FROM (SELECT username, COUNT(*) AS review_count FROM Review GROUP BY username) AS user_review_counts;
    
-- Query 7: Find the number of businesses per status
SELECT [state], COUNT(*) AS NumberOfBusinesses FROM Business GROUP BY [state];

-- Query 8: Find the most common reviewer status for each business
SELECT B.businessID, B.[name], S.statusName, COUNT(*) AS totalReviewers
FROM Business B
JOIN Business_Review BR ON B.businessID = BR.businessID
JOIN Review R ON BR.reviewID = R.reviewID
JOIN Users U ON R.username = U.username
JOIN Holds H ON U.username = H.username
JOIN Status S ON H.statusID = S.statusID
GROUP BY B.businessID, B.[name], S.statusName
ORDER BY totalReviewers DESC

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
