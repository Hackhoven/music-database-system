CREATE DATABASE music_db_system;

USE music_db_system;


-- Table 1: Users
CREATE TABLE Users (
    UserID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    DateOfBirth DATE,
    Email VARCHAR(100),
    SubscriptionType VARCHAR(20)
);

INSERT INTO Users 
VALUES
    (1, 'Elmir', 'Hajizada', '1990-05-15', 'elmir@email.com', 'Premium'),
    (2, 'Suleyman', 'Mammadzada', '1985-08-20', 'suleyman@email.com', 'Free'),
    (3, 'Aflan', 'Badalov', '1993-02-10', 'aflan@email.com', 'Premium'),
    (4, 'Jon', 'Jones', '1988-11-30', 'jon@email.com', 'Free');



-- Table 2: Artists
CREATE TABLE Artists (
    ArtistID INT PRIMARY KEY,
    ArtistName VARCHAR(100),
    Genre VARCHAR(50)
);

-- Insert sample data for Artists
INSERT INTO Artists 
VALUES
    (1, 'Sezen Aksu', 'Pop'),
    (2, 'Ceza', 'Rap'),
    (3, 'Lana Del Rey', 'Pop'),
    (4, 'Sagopa K', 'Rap'),
    (5, 'Mavi Gri', 'Rock');




-- Table 3: Albums
CREATE TABLE Albums (
    AlbumID INT PRIMARY KEY,
    ArtistID INT,
    AlbumName VARCHAR(100),
    ReleaseDate DATE,
    FOREIGN KEY (ArtistID) REFERENCES Artists(ArtistID)
);

-- Insert sample data for Albums
INSERT INTO Albums 
VALUES
    (1, 1, 'Gulumse', '2001-05-15'),
    (2, 2, 'Rapstar', '2004-09-27'),
    (3, 3, 'Born to Die', '2012-01-27'),
    (4, 4, 'Romantizma', '2005-12-12'),
    (5, 5, 'Mavi Gri', '2018-03-02');




-- Table 4: Songs
CREATE TABLE Songs (
    SongID INT PRIMARY KEY,
    ArtistID INT,
    AlbumID INT,
    SongTitle VARCHAR(100),
    Duration INT,  -- Assuming duration in seconds
    FOREIGN KEY (ArtistID) REFERENCES Artists(ArtistID),
    FOREIGN KEY (AlbumID) REFERENCES Albums(AlbumID)
); 


-- Insert sample data for Songs
INSERT INTO Songs 
VALUES
    (1, 1, 1, 'Gel Gor Beni Ashk Neyledi', 240),
    (2, 2, 2, 'Holocaust', 210),
    (3, 3, 3, 'Video Games', 280),
    (4, 4, 4, 'Bir Pesimistin Gozyashlari', 180),
    (5, 5, 5, 'Olumluler', 220),
    (6, 1, 1, 'Beni Unutma', 210),
    (7, 2, 2, 'Araturka Ceşmesi', 190),
    (8, 3, 3, 'Summertime Sadness', 260),
    (9, 4, 4, 'Bir Dizi Ichin Muzik', 200),
    (10, 5, 5, 'Belki Bir Gun Ozlersin', 180);



-- Table 5: Playlists
CREATE TABLE Playlists (
    PlaylistID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT,
    PlaylistName VARCHAR(100),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- Insert sample data for Playlists
INSERT INTO Playlists 
VALUES
    (1, 1, 'Favorites'),
    (2, 2, 'Chill Vibes'),
    (3, 3, 'Workout Mix'),
    (4, 4, 'Road Trip Jams');


-- Table 6: PlaylistSongs   AUTO_INCREMENT MESELESI
CREATE TABLE PlaylistSongs (
    PlaylistSongID INT AUTO_INCREMENT PRIMARY KEY,
    PlaylistID INT,
    SongID INT,
    FOREIGN KEY (PlaylistID) REFERENCES Playlists(PlaylistID),
    FOREIGN KEY (SongID) REFERENCES Songs(SongID)
);

-- Insert sample data for PlaylistSongs
INSERT INTO PlaylistSongs 
VALUES
    (1, 1, 1),
    (2, 1, 2),
    (3, 2, 3),
    (4, 3, 4),
    (5, 4, 5),
    (6, 2, 6),
    (7, 3, 7),
    (8, 4, 8),
    (9, 1, 9),
    (10, 2, 10);



-- Table 7: UserActivity
CREATE TABLE UserActivity (
    ActivityID INT PRIMARY KEY,
    UserID INT,
    SongID INT,
    Timestamp DATETIME,
    Action VARCHAR(10),
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (SongID) REFERENCES Songs(SongID)
);

-- Insert sample data for UserActivity
INSERT INTO UserActivity VALUES
    (1, 1, 1, '2023-01-15 12:30:00', 'play'),
    (2, 1, 2, '2023-01-15 13:15:00', 'skip'),
    (3, 2, 3, '2023-01-15 14:00:00', 'like'),
    (4, 3, 4, '2023-01-15 15:00:00', 'play'),
    (5, 4, 5, '2023-01-15 16:30:00', 'skip'),
    (6, 1, 6, '2023-01-16 10:00:00', 'play'),
    (7, 2, 7, '2023-01-16 11:45:00', 'play'),
    (8, 3, 8, '2023-01-16 13:20:00', 'like'),
    (9, 4, 9, '2023-01-16 14:30:00', 'play'),
    (10, 1, 10, '2023-01-16 16:00:00', 'skip');



-- Table 8: PaymentInfo
CREATE TABLE PaymentInfo (
    PaymentID INT PRIMARY KEY,
    UserID INT,
    CardNumber VARCHAR(16),
    ExpiryDate DATE,
    BillingAddress VARCHAR(255),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- Insert sample data for PaymentInfo
INSERT INTO PaymentInfo 
VALUES
    (1, 1, '1234567890123456', '2025-12-31', '123 Nizami St'),
    (2, 2, '9876543210987654', '2024-08-31', '456 Zerdabi St'),
    (3, 3, '4567890123456789', '2026-05-31', '789 Fuzuli St'),
    (4, 4, '5678901234567890', '2023-10-31', '101 Elm St');





