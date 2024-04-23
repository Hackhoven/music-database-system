USE music_db_system;



-- QUERIES


-- Query 1: Retrieve User's Playlist with Song Details

SELECT Playlists.PlaylistName, Songs.SongTitle, Artists.ArtistName, Albums.AlbumName
FROM Playlists
JOIN PlaylistSongs ON Playlists.PlaylistID = PlaylistSongs.PlaylistID
JOIN Songs ON PlaylistSongs.SongID = Songs.SongID
JOIN Artists ON Songs.ArtistID = Artists.ArtistID
JOIN Albums ON Songs.AlbumID = Albums.AlbumID
WHERE Playlists.UserID = 1;


-- Query 2: Find top artists based on play count
SELECT Artists.ArtistName, COUNT(UserActivity.SongID) AS PlayCount
FROM UserActivity
JOIN Songs ON UserActivity.SongID = Songs.SongID
JOIN Artists ON Songs.ArtistID = Artists.ArtistID
WHERE UserActivity.Action = 'play'
GROUP BY Artists.ArtistName
ORDER BY PlayCount DESC
LIMIT 3;


-- Query 3: Retrieve user's payment information
SELECT Users.FirstName, Users.LastName, PaymentInfo.CardNumber, PaymentInfo.ExpiryDate, PaymentInfo.BillingAddress
FROM Users
JOIN PaymentInfo ON Users.UserID = PaymentInfo.UserID
WHERE Users.UserID = 1;

-- Query 4: Retrieve Total Number of Songs in Each Playlist
SELECT Playlists.PlaylistName, COUNT(PlaylistSongs.SongID) AS TotalSongs
FROM Playlists
JOIN PlaylistSongs ON Playlists.PlaylistID = PlaylistSongs.PlaylistID
GROUP BY Playlists.PlaylistName;

-- Query 5: Calculate average song duration by genre
SELECT Artists.Genre, AVG(Songs.Duration) AS AverageDuration
FROM Songs
JOIN Artists ON Songs.ArtistID = Artists.ArtistID
GROUP BY Artists.Genre;







-- FUNCTIONS


-- Function 1: Calculate Average Duration of Songs in Playlist
DELIMITER //
CREATE FUNCTION CalculateAveragePlaylistDuration(playlistId INT) RETURNS DECIMAL(10, 2) DETERMINISTIC
BEGIN
    DECLARE totalDuration INT;
    DECLARE songCount INT;

    -- Calculate total duration and song count
    SELECT SUM(Songs.Duration), COUNT(Songs.SongID)
    INTO totalDuration, songCount
    FROM PlaylistSongs
    JOIN Songs ON PlaylistSongs.SongID = Songs.SongID
    WHERE PlaylistSongs.PlaylistID = playlistId;

    -- Avoid division by zero
    IF songCount > 0 THEN
        RETURN totalDuration / songCount;
    ELSE
        RETURN 0;  -- Default value if no songs in the playlist
    END IF;
END //
DELIMITER ;
-- SELECT CalculateAveragePlaylistDuration(1);




-- Function 2: Calculate Playlist Duration
DELIMITER //
CREATE FUNCTION CalculatePlaylistDuration(playlistId INT) RETURNS INT DETERMINISTIC
BEGIN
    DECLARE totalDuration INT;
    SELECT SUM(Songs.Duration) INTO totalDuration
    FROM PlaylistSongs
    JOIN Songs ON PlaylistSongs.SongID = Songs.SongID
    WHERE PlaylistSongs.PlaylistID = playlistId;
    RETURN totalDuration;
END //
DELIMITER ;
-- SELECT CalculatePlaylistDuration(1);




-- Function 3: Get User's Most Played Genre
DELIMITER //
CREATE FUNCTION GetUserMostPlayedGenre(userId INT) RETURNS VARCHAR(50) DETERMINISTIC
BEGIN
    DECLARE mostPlayedGenre VARCHAR(50);
    SELECT Artists.Genre INTO mostPlayedGenre
    FROM UserActivity
    JOIN Songs ON UserActivity.SongID = Songs.SongID
    JOIN Artists ON Songs.ArtistID = Artists.ArtistID
    WHERE UserActivity.UserID = userId
    GROUP BY Artists.Genre
    ORDER BY COUNT(UserActivity.SongID) DESC
    LIMIT 1;
    RETURN mostPlayedGenre;
END //
DELIMITER ;

-- SELECT GetUserMostPlayedGenre(1);







-- PROCEDURES


-- Procedure 1: Add Song to Playlist
DELIMITER //
CREATE PROCEDURE AddSongToPlaylist(IN playlistId INT, IN songId INT)
BEGIN
    INSERT INTO PlaylistSongs (PlaylistID, SongID) VALUES (playlistId, songId);
END //
DELIMITER ;

-- CALL AddSongToPlaylist(1,6);


-- Procedure 2: Get Total Number of Songs in a Playlist
DELIMITER //
CREATE PROCEDURE GetTotalSongsInPlaylist(IN playlistId INT, OUT totalSongs INT)
BEGIN
    SELECT COUNT(SongID) INTO totalSongs
    FROM PlaylistSongs
    WHERE PlaylistID = playlistId;
END //
DELIMITER ;

-- CALL GetTotalSongsInPlaylist(1, @totalSongs);
-- SELECT @totalSongs;



-- Procedure 3: Update User's Subscription Type
DELIMITER //
CREATE PROCEDURE UpdateUserSubscriptionType(IN userId INT, IN newSubscriptionType VARCHAR(20))
BEGIN
    UPDATE Users SET SubscriptionType = newSubscriptionType WHERE UserID = userId;
END //
DELIMITER ;

-- CALL UpdateUserSubscriptionType(2, 'Premium');


-- Procedure 4: Create Playlist for User
DELIMITER //
CREATE PROCEDURE CreatePlaylistForUser(IN userID INT, IN playlistName VARCHAR(100))
BEGIN
    INSERT INTO Playlists (UserID, PlaylistName) VALUES (userID, playlistName);
END //
DELIMITER ;
-- CALL CreatePlaylistForUser(3, 'new playlist');


-- Procedure 5: Get Playlist Names by User
DELIMITER //
CREATE PROCEDURE GetPlaylistNamesByUser(IN userId INT)
BEGIN
    SELECT PlaylistName
    FROM Playlists
    WHERE UserID = userId;
END //
DELIMITER ;

-- CALL GetPlaylistNamesByUser(3);








-- TRIGGERS


-- Trigger 2: Update UserActivity Timestamp on Song Play
DELIMITER //
CREATE TRIGGER AfterInsertUserActivity
AFTER INSERT ON UserActivity
FOR EACH ROW
IF NEW.Action = 'play' THEN
    UPDATE UserActivity
    SET Timestamp = NOW()
    WHERE ActivityID = NEW.ActivityID;
END IF;
//
DELIMITER ;


-- Trigger 3: Prevent Deletion of Artists with Associated Albums
DELIMITER //
CREATE TRIGGER BeforeDeleteArtists
BEFORE DELETE ON Artists
FOR EACH ROW
BEGIN
    DECLARE albumCount INT;
    SELECT COUNT(*) INTO albumCount
    FROM Albums
    WHERE ArtistID = OLD.ArtistID;

    IF albumCount > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot delete artist with associated albums';
    END IF;
END;
//
DELIMITER ;


-- Trigger 4: Log PaymentInfo Changes
DELIMITER //
CREATE TRIGGER AfterUpdatePaymentInfo
AFTER UPDATE ON PaymentInfo
FOR EACH ROW
BEGIN
    INSERT INTO PaymentInfoLog (PaymentID, UserID, CardNumber, ExpiryDate, BillingAddress, Timestamp)
    VALUES (OLD.PaymentID, OLD.UserID, OLD.CardNumber, OLD.ExpiryDate, OLD.BillingAddress, NOW());
END;
//
DELIMITER ;

-- Trigger 5: Update TotalDuration in Albums After Song Insert
DELIMITER //
CREATE TRIGGER AfterInsertSongs
AFTER INSERT ON Songs
FOR EACH ROW
BEGIN
    UPDATE Albums
    SET TotalDuration = TotalDuration + NEW.Duration
    WHERE AlbumID = NEW.AlbumID;
END;
//
DELIMITER ;
